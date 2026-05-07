class ZCL_EM4C_WF_BUS2037 definition
  public
  final
  create public .

public section.

  interfaces BI_OBJECT .
  interfaces BI_PERSISTENT .
  interfaces IF_WORKFLOW .

  class-methods RUN
    importing
      !IV_VBELN type VBELN_VF
    raising
      /EM4C/CS_ERROR .
protected section.
private section.

  class-data __MO_LOGGER type ref to /EM4C/CFEL_LOGGER .

  class-methods __GET_DATA
    importing
      !IV_VBELN type VBELN_VF
    returning
      value(RS_DATA) type /EM4C/TFEL_HDR
    raising
      /EM4C/CS_ERROR .
  class-methods __PROCESS_ERROR
    importing
      !IV_TEXT type TEXT200
    raising
      /EM4C/CS_ERROR .
  class-methods __PROCESS_SERVICE
    importing
      !IS_HDR type /EM4C/TFEL_HDR
    exporting
      value(RS_HDR) type /EM4C/TFEL_HDR
    changing
      value(CT_DATA) type /EM4C/TTFEL_SERVICE_DATA
    raising
      /EM4C/CS_ERROR .
  class-methods __RUN_BUS2037
    importing
      !IV_VBELN type VBELN_VF
    raising
      /EM4C/CS_ERROR .
  class-methods __UPDATE_DATA
    importing
      !IS_HDR type /EM4C/TFEL_HDR
      !IS_DATA type /EM4C/TTFEL_SERVICE_DATA
    raising
      /EM4C/CS_ERROR .
  class-methods __GET_STATUS
    importing
      !IO_LOGGER type ref to /EM4C/CFEL_LOGGER
    changing
      !CT_DATA type /EM4C/TTFEL_SERVICE_DATA
    raising
      /EM4C/CS_ERROR .
ENDCLASS.



CLASS ZCL_EM4C_WF_BUS2037 IMPLEMENTATION.


  method BI_OBJECT~DEFAULT_ATTRIBUTE_VALUE.
  endmethod.


  method BI_OBJECT~EXECUTE_DEFAULT_METHOD.
  endmethod.


  method BI_OBJECT~RELEASE.
  endmethod.


  method BI_PERSISTENT~FIND_BY_LPOR.
  endmethod.


  method BI_PERSISTENT~LPOR.
  endmethod.


  method BI_PERSISTENT~REFRESH.
  endmethod.


  method run.

    __mo_logger = new /em4c/cfel_logger( ).

    try.

*-      Lanzamos la aplicacion
        __run_bus2037( iv_vbeln ).

      catch /em4c/cs_error into data(lo_error).

*-      Procesamos el error
        __process_error( conv text200( lo_error->get_text( ) ) ).
        free lo_error.

    endtry.

*-  Grabamos el historial
    __mo_logger->save( ).
    __mo_logger->delete( ).

    free:
      __mo_logger.

  endmethod.


  method __get_data.

    data:
      lr_bukrs type zem4c_tr_bukrs,
      lr_datum type zem4c_tr_datum,
      lr_xblnr type zem4c_tr_xblnr,
      lr_docls type zem4c_tr_docls,
      lr_stat  type zem4c_tr_stat,
      lr_belnr type zem4c_tr_belnr,
      lr_bstkd type zem4c_tr_bstkd,
      lr_vbeln type zem4c_tr_vbeln,
      lr_fkart type zem4c_tr_fkart,
      lt_data  type zem4c_tt_hdr.

    append value #( low    = iv_vbeln
                    sign   = if_s95_constants=>c_sign_inclusive
                    option = if_s95_constants=>c_option_equals )
              to lr_vbeln.

*-  Obtenemos los datos
    cast /em4c/cl_hdr_dao( /em4c/cl_factory_dao=>get_instance( 'HDR' )
       )->get_data_by_ranges(
                    exporting ir_bukrs = lr_bukrs[]
                              ir_datum = lr_datum[]
                              ir_xblnr = lr_xblnr[]
                              ir_docls = lr_docls[]
                              ir_stat  = lr_stat[]
                              ir_belnr = lr_belnr[]
                              ir_bstkd = lr_bstkd[]
                              ir_vbeln = lr_vbeln[]
                              ir_fkart = lr_fkart[]
                     changing ct_data  = lt_data[] ).

*-  Devolvemos los datos recibidos
    rs_data = lt_data[ 1 ].

    clear:
      lr_vbeln[],
      lt_data[].

  endmethod.


  method __get_status.

    try.

        data(lo_service) = new zcl_itges_do_service( ).

        lo_service->get_status( exporting io_logger = __mo_logger     " eM4C - Historial de Ejecucion
                                 changing ct_data   =   ct_data[] ).  " eM4C - Datos de Sincronizacion

      catch /em4c/cs_error into data(lo_error).     " eM4C - Manejador de Errores

        data(ls_error) = lo_error->get_message( ).

        read table ct_data assigning field-symbol(<lfs_status>) with key field = 'ESTADO'.

        if sy-subrc = 0.

          <lfs_status>-value = zem4c_c_status-rejected-dian.

        endif.

      catch cx_ai_system_fault into data(lo_fault).

        data(lv_fault) = conv char200( lo_fault->if_message~get_text( ) ).
        __mo_logger->add( value #( msgty = if_s95_constants=>c_message_error
                                 msgno = '001'
                                 msgv1 = lv_fault+0(50)
                                 msgv2 = lv_fault+50(50)
                                 msgv3 = lv_fault+100(50)
                                 msgv4 = lv_fault+150(50) ) ).

        read table ct_data assigning field-symbol(<lfs_em4c_stat>) with key field = 'ESTADO'.

        if sy-subrc = 0.

          <lfs_em4c_stat>-value = zem4c_c_status-rejected-proxy.

        endif.

    endtry.

  endmethod.


  method __PROCESS_ERROR.
  endmethod.


  method __process_service.

    data:
      lt_data type /em4c/ttfel_service_data.

*-  obtenemos el proveedor
    data(lv_provider) = cast /em4c/cl_par_dao( /em4c/cl_factory_dao=>get_instance( 'PAR' )
                           )->get_constant(
                                  exporting iv_id   = is_hdr-bukrs
                                            iv_name = 'PROVIDER' ).
*-  Pasamos los datos
    append value #( field = zem4c_c_fields-hdr-vbeln   value = is_hdr-vbeln )  to ct_data.
    append value #( field = zem4c_c_fields-hdr-bukrs   value = is_hdr-bukrs )  to ct_data.
    append value #( field = zem4c_c_fields-hdr-gjahr   value = is_hdr-gjahr )  to ct_data.
    append value #( field = zem4c_c_fields-hdr-belnr   value = is_hdr-belnr )  to ct_data.
    append value #( field = zem4c_c_fields-hdr-estado  value = is_hdr-estado ) to ct_data.

*-  Procesamos el XML
    /em4c/cl_factory_generator=>get_instance( |XML_{ is_hdr-clase_doc_fte }|
                             )->run(
                           exporting io_logger = __mo_logger
                            changing ct_data   = ct_data[] ).

*- Transmitimos el documento al proveedor
    /em4c/cl_factory_service=>get_instance( |{ lv_provider }|
                           )->sync(
                          exporting io_logger = __mo_logger
                           changing ct_data   = ct_data[] ).

*- Mapeamos la información
    rs_hdr-id_xml_doc   = ct_data[ field = zem4c_c_fields-hdr-id_xml_doc ]-value.
    rs_hdr-qrcode       = ct_data[ field = zem4c_c_fields-hdr-qrcode     ]-value.
    rs_hdr-belnr        = ct_data[ field = zem4c_c_fields-hdr-belnr      ]-value.
    rs_hdr-xblnr        = ct_data[ field = zem4c_c_fields-hdr-xblnr      ]-value.
    rs_hdr-estado       = ct_data[ field = zem4c_c_fields-hdr-estado      ]-value.
    rs_hdr-type_xml_doc = ct_data[ field = zem4c_c_fields-hdr-type_xml_doc ]-value.
    rs_hdr-gjahr        = ct_data[ field = zem4c_c_fields-hdr-gjahr        ]-value.
    rs_hdr-name1        = ct_data[ field = zem4c_c_fields-hdr-name1        ]-value.
    rs_hdr-kunrg        = ct_data[ field = zem4c_c_fields-hdr-kunrg        ]-value.
    rs_hdr-bukrs        = ct_data[ field = zem4c_c_fields-hdr-bukrs        ]-value.
    rs_hdr-belnr        = ct_data[ field = zem4c_c_fields-hdr-belnr        ]-value.
    rs_hdr-clase_doc_fte = ct_data[ field = zem4c_c_fields-hdr-clase_doc_fte ]-value.
    rs_hdr-blart        = ct_data[ field = zem4c_c_fields-hdr-blart          ]-value.
    rs_hdr-land1        = ct_data[ field = zem4c_c_fields-hdr-land1          ]-value.
    rs_hdr-uuid         = ct_data[ field = zem4c_c_fields-hdr-uuid          ]-value.
    rs_hdr-femis        = sy-datum.
    rs_hdr-hemis        = sy-uzeit.
    rs_hdr-vbeln        = is_hdr-vbeln.
    rs_hdr-num_pedido   = is_hdr-num_pedido.
    rs_hdr-fecha_estado = is_hdr-fecha_estado.
    rs_hdr-hora_estado  = is_hdr-hora_estado.

  endmethod.


  method __run_bus2037.

    data: lt_data    type /em4c/ttfel_service_data,
          ls_upd_hdr type /em4c/tfel_hdr.

    try.
*-      Obtenemos los datos
        data(ls_hdr) = __get_data( iv_vbeln ).

      catch /em4c/cs_error.

        return.

    endtry.

*-  Creamos el Historial
    __mo_logger->create(
               exporting iv_subobject = 'GLOBAL'
                         iv_extnumber = ls_hdr-uuid ).

*-  Procesamos los datos
    __process_service( exporting is_hdr  = ls_hdr        " eM4C - Cabecera
                       importing rs_hdr  = ls_upd_hdr    " eM4C - Cabecera
                        changing ct_data = lt_data  ).   " eM4C - Datos de Sincronizacion

*- Consultamos el estado
    __get_status( exporting io_logger = __mo_logger  " eM4C - Historial de Ejecucion
                   changing ct_data   =  lt_data ).  " eM4C - Datos de Sincronizacion

*- Actualizamos el estado
    read table lt_data into data(ls_data) with key field = 'ESTADO'.

    if sy-subrc = 0.

      ls_upd_hdr-estado = ls_data-value.

    endif.

*- Actualizamos los datos
    __update_data( exporting is_hdr  = ls_upd_hdr
                             is_data = lt_data ).
    clear:
      ls_hdr.

  endmethod.


  method __UPDATE_DATA.

    data: lt_rep type table of /em4c/tfel_rep,
          lv_xml type string.

    lv_xml = is_data[ field = zem4c_c_prefix-file && zem4c_c_file-xml ]-value.

    append value #( uuid = is_hdr-uuid file_type = '01' data = lv_xml ) to lt_rep.

*- Actualizar datos monitor
    cast /em4c/cl_hdr_dao( /em4c/cl_factory_dao=>get_instance( 'HDR' )
       )->update(
        exporting io_logger = __mo_logger
                  iv_commit = abap_off
                  is_data   = is_hdr ).

*- Actualizar Repositorio
    cast /em4c/cl_rep_dao( /em4c/cl_factory_dao=>get_instance( 'REP' )
        )->create( exporting iv_commit = abap_off         " Variable booleana (X=verdadero, -=falso, space=descon.)
                             it_data   = lt_rep[]
                             io_logger = __mo_logger   ).    " eM4C - Historial de Ejecucion

    clear: lt_rep[].

  endmethod.
ENDCLASS.
