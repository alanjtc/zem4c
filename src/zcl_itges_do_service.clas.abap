class ZCL_ITGES_DO_SERVICE definition
  public
  inheriting from /EM4C/CL_BASE_SERVICE
  final
  create public .

public section.

  methods GET_STATUS
    importing
      !IO_LOGGER type ref to /EM4C/CFEL_LOGGER
    changing
      !CT_DATA type /EM4C/TTFEL_SERVICE_DATA
    raising
      /EM4C/CS_ERROR
      CX_AI_SYSTEM_FAULT .

  methods DOWNLOAD
    redefinition .
  methods SYNC
    redefinition .
protected section.

  methods APPEND_DATA
    redefinition .
private section.

  methods SAVE_LOGS
    importing
      !IV_TEXTO type STRING
      !IO_LOGGER type ref to /EM4C/CFEL_LOGGER
      !IV_TITULO type STRING optional .
  methods GET_QR
    importing
      value(IV_XML) type STRING optional
    returning
      value(RV_QR) type STRING .
ENDCLASS.



CLASS ZCL_ITGES_DO_SERVICE IMPLEMENTATION.


  method APPEND_DATA.
CALL METHOD SUPER->APPEND_DATA
  EXPORTING
    IV_FIELD = IV_FIELD
    IV_VALUE = IV_VALUE
  CHANGING
    CT_DATA  = CT_DATA
    .
  endmethod.


  method DOWNLOAD.
  endmethod.


  method GET_QR.


  DATA: lt_xml_table TYPE TABLE OF smum_xmltb,
        lt_return    TYPE TABLE OF      bapiret2.

  DATA: lv_xml_string  TYPE string,
        lv_xml_xstring TYPE xstring,
        lv_xml_base64  TYPE string.

  DATA: lv_cod_seg(6) type c.


    data:
      lo_par type ref to /em4c/cl_par_dao.

*-  Obtenemos la url
    lo_par ?= /em4c/cl_factory_dao=>get_instance( 'PAR' ).
    data(lv_url) = lo_par->get_constant( iv_id = 'DGII' iv_name = 'URLQR' ).

  call function 'SCMS_BASE64_DECODE_STR'
    exporting
      input         = iv_xml
     UNESCAPE       = 'X'
   IMPORTING
     OUTPUT         = lv_xml_xstring
   EXCEPTIONS
     FAILED         = 1
     OTHERS         = 2
            .
  if sy-subrc <> 0.
* Implement suitable error handling here
  endif.



  CALL FUNCTION 'SMUM_XML_PARSE'
    EXPORTING
      xml_input = lv_xml_xstring
    TABLES
      xml_table = lt_xml_table
      return    = lt_return.


  READ TABLE lt_xml_table INTO DATA(ls_xml) WITH KEY hier = 4 cname = 'RNCEmisor'.
  IF sy-subrc = 0.
    data(lv_rnc_emisor) = ls_xml-cvalue.
  ENDIF.

  READ TABLE lt_xml_table INTO ls_xml WITH KEY hier = 4 cname = 'eNCF'.
  IF sy-subrc = 0.
    data(lv_encf) = ls_xml-cvalue.
  ENDIF.

  READ TABLE lt_xml_table INTO ls_xml WITH KEY hier = 4 cname = 'MontoTotal'.
  IF sy-subrc = 0.
    data(lv_monto_total) = ls_xml-cvalue.
  ENDIF.

  READ TABLE lt_xml_table INTO ls_xml WITH KEY hier = 3 TYPE = '+' cname = 'SignatureValue'.
  IF sy-subrc = 0.
    lv_cod_seg = ls_xml-cvalue(6).
  ENDIF.

  rv_qr = |{ lv_url }?RncEmisor={ lv_rnc_emisor }&encf={ lv_encf }&montototal={ lv_monto_total }&codigoseguridad={ lv_cod_seg }|.




  endmethod.


  method get_status.

    data:
      lo_par type ref to /em4c/cl_par_dao.
    data:
      ls_input  type zem4c_electronic_invoices_requ,
      lv_estado type c length 1.


*-  Obtenemos el Track Id
    ls_input-track_id = ct_data[ field = zem4c_c_fields-hdr-id_xml_doc ]-value.

*-  Enviamos los datos

    try.

        data(lo_api) = new zem4c_co_electronic_invoices_p( ).
        lo_api->process_electronic_invoice(
          exporting
            input  = ls_input
          importing
            output = data(ls_output)
        ).

      catch cx_ai_system_fault. " Communication Error

        raise exception type /em4c/cs_error
          exporting
            textid = /em4c/cs_error=>/em4c/cs_error
            msgv1  = conv msgv1( text-e03 ).


    endtry.
*-  Procesamos la respuesta


*-  Cargamos los datos

    me->append_data(
         exporting iv_field = zem4c_c_fields-hdr-id_xml_doc
                     iv_value = ls_output-track_id
            changing ct_data  = ct_data[] ).

* - BEGIN OF Harold JTC 16.04.2025 15:24:24 [Reparaciones monitor]

    case  ls_output-estado.
      when 'Rechazado'.
        lv_estado = '2'.
      when 'Aceptado'.
        lv_estado = '1'.
      when others.
        lv_estado = '10'.
    endcase.

    read table ct_data assigning field-symbol(<fs_data>) with key field = zem4c_c_fields-hdr-estado.
    if sy-subrc = 0.
      <fs_data>-value = lv_estado.
    endif.

* - END OF Harold JTC 16.04.2025 15:24:24

*- guardamos en el log

    data(lv_msgty) = cond #( when ls_output-estado = 'Rechazado' then  if_s95_constants=>c_message_error
                             else if_s95_constants=>c_message_info    ) .

    io_logger->add( value #( msgty = lv_msgty
                             msgno = '001'
                             msgv1 = '---------------'
                             msgv2 = 'Inicio Mensajes DGII'
                             msgv3 = '-------------->' )  ).

    io_logger->add( value #( msgty = lv_msgty
                             msgno = '001'
                             msgv1 = 'Track id: '
                             msgv2 = ls_output-track_id )  ).

    io_logger->add( value #( msgty = lv_msgty
                                 msgno = '001'
                                 msgv1 = 'Estado: '
                                 msgv2 = ls_output-estado )  ).


    io_logger->add( value #( msgty = lv_msgty
                         msgno = '001'
                         msgv1 = 'Mensajes:' )  ).
    .

    data: lv_msg_cod type string.
    concatenate 'Codigo:' ls_output-mensajes-codigo into lv_msg_cod separated by space.


    io_logger->add( value #( msgty = lv_msgty
                             msgno = '001'
                             msgv1 = lv_msg_cod )  ).

*    io_logger->add( value #( msgty = lv_msgty
*                             msgno = '001'
*                             msgv1 = ls_output-mensajes-valor )  ).

    me->save_logs(
      exporting
        iv_texto  = ls_output-mensajes-valor
        io_logger = io_logger
    ).

    io_logger->add( value #( msgty = lv_msgty
                         msgno = '001'
                         msgv1 = '<---------------'
                         msgv2 = 'Fin mensajes DGII'
                         msgv3 = '---------------' )  ).

    data: lv_msg_final type string.
    concatenate ls_output-estado ':' ls_output-mensajes-valor into lv_msg_final.
    message lv_msg_final type 'I'.

    free:
      lo_api,
      lo_par.
    clear:
      ls_output,
      ls_input.


  endmethod.


  method save_logs.

    data: ls_log    type /em4c/sfel_message,
          lv_part1  type string,
          lv_part2  type string,
          lv_part3  type string,
          lv_part4  type string,
          lv_string type string,
          lv_length type i.

    data: lt_mensajes type table of swastrtab.

    call function 'SWA_STRING_SPLIT'
      exporting
        input_string         = iv_texto
        max_component_length = 50
      tables
        string_components    = lt_mensajes.

    loop at lt_mensajes into data(ls_mensaje).
      ls_log-msgty = 'W'.
      ls_log-msgno = '105'.
      ls_log-msgv1 = ls_mensaje-str.

      io_logger->add( is_msg = ls_log ).

    endloop.

  endmethod.


  method sync.

    data:
      lo_par type ref to /em4c/cl_par_dao.
    data:
      ls_input  type zcl_electronic_invoices_reques,
      lv_estado type c length 2.


*-  Obtenemos la intancia
    lo_par ?= /em4c/cl_factory_dao=>get_instance( 'PAR' ).
*-  Pasamos los datos
    data(lv_bukrs) = ct_data[ field = zem4c_c_fields-hdr-bukrs ]-value.
    ls_input-company_id = lo_par->get_constant( iv_id = lv_bukrs iv_name = 'CONEX_IDCOMPANY'   ).
    ls_input-xml_base64 = ct_data[ field = zem4c_c_prefix-file && zem4c_c_file-xml ]-value.

    replace all occurrences of '77u/' in ls_input-xml_base64 with space.
    condense ls_input-xml_base64 no-gaps.

*-  Enviamos los datos

    try.

        data(lo_api) = new zcl_co_electronic_invoices_ser( ).
        lo_api->electronic_invoices(
          exporting
            input  = ls_input
          importing
            output = data(ls_output)
        ).

      catch cx_ai_system_fault. " Communication Error

        raise exception type /em4c/cs_error
          exporting
            textid = /em4c/cs_error=>/em4c/cs_error
            msgv1  = conv msgv1( text-e03 ).


    endtry.
*-  Procesamos la respuesta


*-  Cargamos los datos

    me->append_data(
         exporting iv_field = zem4c_c_fields-hdr-id_xml_doc
                     iv_value = ls_output-track_id
            changing ct_data  = ct_data[] ).



    me->append_data(
         exporting iv_field = zem4c_c_fields-hdr-qrcode
                   iv_value = me->get_qr( iv_xml = ls_output-signed_xml  )
          changing ct_data  = ct_data[] ).

* - BEGIN OF Harold JTC 16.04.2025 15:24:24 [Reparaciones monitor]

    case  ls_output-estado.
      when 'Rechazado'.
        lv_estado = '2'.
      when 'Aceptado'.
        lv_estado = '1'.
      when others.
        lv_estado = '10'.
    endcase.

    read table ct_data assigning field-symbol(<fs_data>) with key field = zem4c_c_fields-hdr-estado.
    if sy-subrc = 0.
      <fs_data>-value = lv_estado.
    endif.

* - END OF Harold JTC 16.04.2025 15:24:24

*- guardamos en el log

    data(lv_msgty) = cond #( when ls_output-estado = 'Rechazado' then  if_s95_constants=>c_message_error
                             else if_s95_constants=>c_message_info    ) .

    io_logger->add( value #( msgty = lv_msgty
                             msgno = '001'
                             msgv1 = '---------------'
                             msgv2 = 'Inicio Mensajes DGII'
                             msgv3 = '-------------->' )  ).

    io_logger->add( value #( msgty = lv_msgty
                             msgno = '001'
                             msgv1 = 'Track id: '
                             msgv2 = ls_output-track_id )  ).

    io_logger->add( value #( msgty = lv_msgty
                                 msgno = '001'
                                 msgv1 = 'Estado: '
                                 msgv2 = ls_output-estado )  ).


    io_logger->add( value #( msgty = lv_msgty
                         msgno = '001'
                         msgv1 = 'Mensajes:' )  ).

    loop at ls_output-mensajes into data(ls_mensajes).
* - BEGIN OF Harold JTC 25.04.2025 11:59:53 [Logs Monitor]

*      io_logger->add( value #( msgty = lv_msgty
*                               msgno = '001'
*                               msgv1 = ls_mensajes-valor )  ).
      me->save_logs(
        exporting
          iv_texto  = ls_mensajes-valor
          io_logger = io_logger ).

* - END OF Harold JTC 25.04.2025 11:59:53
    endloop.



    io_logger->add( value #( msgty = lv_msgty
                         msgno = '001'
                         msgv1 = '<---------------'
                         msgv2 = 'Fin mensajes DGII'
                         msgv3 = '---------------' )  ).



    free:
      lo_api,
      lo_par.
    clear:
      ls_output,
      ls_input.

  endmethod.
ENDCLASS.
