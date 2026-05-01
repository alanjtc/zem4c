class ZCL_EM4C_XML_SD_NC_GENERATOR definition
  public
  inheriting from ZCL_EM4C_XML_BASE_SD_GENERATOR
  final
  create public .

public section.
protected section.

  methods MAP_INFORMACIONREFERENCIA
    importing
      !IS_DATA type TS_DATA
    returning
      value(RS_DATA) type ZSEM4C_XML_SERVICE_INFO_REF .

  methods MAP_DATA
    redefinition .
  methods PROCESS_DATA
    redefinition .
  methods MAP_IDDOC
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_EM4C_XML_SD_NC_GENERATOR IMPLEMENTATION.


  method map_data.

    call method super->map_data
      exporting
        is_data = is_data
      receiving
        rs_data = rs_data.

    rs_data-ecf-informacionreferencia = me->map_informacionreferencia( is_data = is_data ).

    if rs_data-ecf-informacionreferencia-codigomodificacion = '2'.
      rs_data-ecf-encabezado-totales-montototal = '0.00'.
      condense rs_data-ecf-encabezado-totales-montototal no-gaps.
    endif.

  endmethod.


  method map_iddoc.

    call method super->map_iddoc
      exporting
        is_data = is_data
      receiving
        rs_data = rs_data.

    rs_data-indicadornotacredito = '0'.

  endmethod.


  method map_informacionreferencia.

    data:
      lo_par   type ref to /em4c/cl_par_dao.

*-  Obtenemos la instancia
    lo_par       ?= /em4c/cl_factory_dao=>get_instance( 'PAR' ).
    data(lv_cod_mod) = lo_par->get_constant( iv_id   = 'FEL_DGII'
                                             iv_name = 'CODIGOMODIFICACION' ).

    select single vbelv
      from vbfa
      into @data(lv_vbelv)
      where vbeln = @is_data-invoice-s_vbrk-vbeln
      and vbtyp_v = 'M'.

    select single xblnr, fkdat
      from vbrk
      into @data(ls_vbrk_ncf)
      where vbeln = @lv_vbelv.

*    rs_data-ncfmodificado = is_data-invoice-s_vbrk-xblnr.
    rs_data-ncfmodificado = ls_vbrk_ncf-xblnr.
    condense rs_data-ncfmodificado no-gaps.

*    concatenate is_data-invoice-s_vbrk-fkdat+6(2) '-' is_data-invoice-s_vbrk-fkdat+4(2) '-' is_data-invoice-s_vbrk-fkdat+0(4) into rs_data-fechancfmodificado.
    concatenate ls_vbrk_ncf-fkdat+6(2) '-' ls_vbrk_ncf-fkdat+4(2) '-' ls_vbrk_ncf-fkdat+0(4) into rs_data-fechancfmodificado.
    condense rs_data-fechancfmodificado no-gaps.

    "Codigo de modificacion
    select *
      from /em4c/tfel_conv
      into table @data(lt_cod_augru)
      where wricef_id = 'FEL_DGII'
      and param_id = 'COD_MOD_AUGRU'.

    read table lt_cod_augru into data(ls_cod) with key field_from = is_data-invoice-s_vbak-augru.

    if sy-subrc = 0.

      rs_data-codigomodificacion = ls_cod-field_to.
      condense rs_data-codigomodificacion no-gaps.

    else.

      select single value
        from /em4c/tfel_const
        into @data(lv_cod)
        where idfrice = 'FEL_DGII'
        and param_id = 'CODIGOMODIFICACION'.

      rs_data-codigomodificacion = lv_cod.
      condense rs_data-codigomodificacion no-gaps.

    endif.

  endmethod.


  method PROCESS_DATA.

    append value #( field = zem4c_c_fields-hdr-clase_doc_fte value = 'SD_NC' ) to ct_data.

    super->process_data(
      exporting
        io_logger = io_logger
      changing
        ct_data   = ct_data
        cs_data   = cs_data ).

  endmethod.
ENDCLASS.
