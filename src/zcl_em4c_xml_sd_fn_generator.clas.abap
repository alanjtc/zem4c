class ZCL_EM4C_XML_SD_FN_GENERATOR definition
  public
  inheriting from ZCL_EM4C_XML_BASE_SD_GENERATOR
  create public .

public section.

  methods RUN
    redefinition .
protected section.

  methods PROCESS_DATA
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_EM4C_XML_SD_FN_GENERATOR IMPLEMENTATION.


  method process_data.

    append value #( field = zem4c_c_fields-hdr-clase_doc_fte value = 'SD_FN' ) to ct_data.

    super->process_data(
      exporting
        io_logger = io_logger
      changing
        ct_data   = ct_data
        cs_data   = cs_data ).

  endmethod.


  method run.
    data:
          ls_data type ts_xml.

    read table ct_data into data(ls_vbeln) with key field = 'VBELN'.

    select single kunrg
      from vbrk
      into @data(lv_kunrg)
      where vbeln = @ls_vbeln-value.

    if sy-subrc = 0.

      select single kvgr1
        from knvv
        into @data(lv_kvgr1)
        where kunnr = @lv_kunrg.

    endif.

    if lv_kvgr1 is initial.

      me->process_data( exporting io_logger =  io_logger
                         changing ct_data   = ct_data[]
                                  cs_data   = ls_data
          ).

    else.

      select single field_to
        from /em4c/tfel_conv
        into @data(lv_tipoecf)
        where wricef_id = 'FEL_DGII'
        and param_id = 'TIPO_ECF'
        and field_from = @lv_kvgr1.

      if sy-subrc <> 0.

        raise exception type /em4c/cs_error
          exporting
            textid = /em4c/cs_error=>/em4c/cs_error
            msgv1  = 'Documento XML no configurado'
            msgv2  = conv symsgv( lv_tipoecf ).

      endif.

*-   Procesamos el XML
      try.


          /em4c/cl_factory_generator=>get_instance( |XML_SD_FN{ lv_tipoecf }|
                                   )->run(
                                 exporting io_logger = io_logger
                                  changing ct_data   = ct_data[] ).

        catch /em4c/cs_error into data(lx_err).

          me->process_data( exporting io_logger =  io_logger
                             changing ct_data   = ct_data[]
                                      cs_data   = ls_data
          ).

*-        Obtenemos el XML (B64)
          me->append_data(
                 exporting iv_field = zem4c_c_prefix-file && zem4c_c_file-xml
                           iv_value = me->format_b64( me->generate_xml( is_data = ls_data-src
                                                                        iv_name = ls_data-name ) )
                  changing ct_data  = ct_data[] ).

      endtry.

    endif.

  endmethod.
ENDCLASS.
