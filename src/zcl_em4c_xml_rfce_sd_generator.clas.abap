class ZCL_EM4C_XML_RFCE_SD_GENERATOR definition
  public
  inheriting from /EM4C/CL_BASE_GENERATOR
  create public .

public section.

  types:
    begin of ts_data,
        name      type /em4c/de_docfte,
        hdr       type /em4c/tfel_hdr,
        reference type ts_reference,
        receptor  type ts_receptor,
        sender    type ts_sender,
        parameter type ts_parameter,
        account   type ts_account,
        invoice   type ts_invoice,
        condition type ts_condition,
      end   of ts_data .
protected section.

*  methods map_cae
*    importing
*      !is_data       type ts_data
*    returning
*      value(rs_data) type zsem4c_xml_service_cae
*    raising
*      /em4c/cs_error .
  methods MAP_CUSTOM
    importing
      !IS_DATA type TS_DATA
    changing
      !CS_DATA type /EM4C/SFEL_XML_SERVICE
    raising
      /EM4C/CS_ERROR .
  methods MAP_CUSTOM_AMOUNT
    importing
      !IS_DATA type TS_DATA
    changing
      !CS_DATA type /EM4C/SFEL_XML_SERVICE
    raising
      /EM4C/CS_ERROR .
  methods MAP_CUSTOM_CONST
    importing
      !IS_DATA type TS_DATA
    changing
      !CS_DATA type /EM4C/SFEL_XML_SERVICE
    raising
      /EM4C/CS_ERROR .
  methods MAP_CUSTOM_PRINT
    importing
      !IS_DATA type TS_DATA
    changing
      !CS_DATA type /EM4C/SFEL_XML_SERVICE
    raising
      /EM4C/CS_ERROR .
  methods MAP_CUSTOM_VALUE
    importing
      !IS_DATA type TS_DATA
    changing
      !CS_DATA type /EM4C/SFEL_XML_SERVICE
    raising
      /EM4C/CS_ERROR .
  methods MAP_DATA
    importing
      !IS_DATA type TS_DATA
    returning
      value(RS_DATA) type /EM4C/SFEL_XML_SERVICE
    raising
      /EM4C/CS_ERROR .
  methods MAP_DETAIL
    importing
      !IS_DATA type TS_DATA
    returning
      value(RT_DATA) type ZTTEM4C_XML_SERVICE_ITEM
    raising
      /EM4C/CS_ERROR .
  methods MAP_DETAIL_TAX
    importing
      !IS_VBRP type VBRP
      !IS_DATA type TS_DATA
    changing
      !CS_DATA type ZSEM4C_XML_SERVICE_ITEM .
  methods MAP_DISC_REC
    importing
      !IS_DATA type TS_DATA
    returning
      value(RT_DATA) type ZTTEM4C_XML_SERVICE_DISC_REC
    raising
      /EM4C/CS_ERROR .
  methods MAP_XML_VERSION
    returning
      value(RV_DATA) type /EM4C/DE_XML_VALUE .
  methods MAP_IDDOC
    importing
      !IS_DATA type TS_DATA
    returning
      value(RS_DATA) type ZSEM4C_XML_SERVICE_ID_DOC
    raising
      /EM4C/CS_ERROR .
  methods MAP_RECEIVER
    importing
      !IS_DATA type TS_DATA
    returning
      value(RS_DATA) type ZSEM4C_XML_SERVICE_BUYER
    raising
      /EM4C/CS_ERROR .
  methods MAP_SENDER
    importing
      !IS_DATA type TS_DATA
    returning
      value(RS_DATA) type ZSEM4C_XML_SERVICE_SENDER
    raising
      /EM4C/CS_ERROR .
*  methods map_taxes
*    importing
*      !is_data       type ts_data
*    returning
*      value(rt_data) type zttem4c_xml_service_taxes
*    raising
*      /em4c/cs_error .
  methods MAP_TOTALS
    importing
      !IS_DATA type TS_DATA
    returning
      value(RS_DATA) type ZSEM4C_XML_SERVICE_TOTALS
    raising
      /EM4C/CS_ERROR .
  methods MAP_FECHAHORAFIRMA
    returning
      value(RV_DATA) type /EM4C/DE_XML_VALUE .
  methods RELOAD_DATA
    importing
      !IS_DATA type TS_DATA
    changing
      !CT_DATA type /EM4C/TTFEL_SERVICE_DATA .
  methods REQUEST_HDR
    importing
      !IO_LOGGER type ref to /EM4C/CFEL_LOGGER
    changing
      !CS_DATA type TS_DATA
    raising
      /EM4C/CS_ERROR .
  methods REQUEST_PAR
    importing
      !IO_LOGGER type ref to /EM4C/CFEL_LOGGER
    changing
      !CS_DATA type TS_DATA
    raising
      /EM4C/CS_ERROR .
  methods REQUEST_XML
    importing
      !IO_LOGGER type ref to /EM4C/CFEL_LOGGER
    changing
      !CS_DATA type TS_DATA
    raising
      /EM4C/CS_ERROR .

  methods PROCESS_DATA
    redefinition .
private section.

  data GV_TIPOECF type /EM4C/DE_XML_VALUE .
ENDCLASS.



CLASS ZCL_EM4C_XML_RFCE_SD_GENERATOR IMPLEMENTATION.


  method MAP_CUSTOM.

*-  Constantes
    me->map_custom_const(
                exporting is_data = is_data
                 changing cs_data = cs_data ).

*-  Valores
    me->map_custom_value(
                exporting is_data = is_data
                 changing cs_data = cs_data ).

    if is_data-invoice-s_vbrk-waerk = mc_waers.

      return.

    endif.

*-  Montos
    me->map_custom_amount(
                 exporting is_data = is_data
                  changing cs_data = cs_data ).

*-  Detalle de Impresion
    me->map_custom_print(
                 exporting is_data = is_data
                  changing cs_data = cs_data ).

  endmethod.


  method MAP_CUSTOM_AMOUNT.

*    field-symbols:
*      <ls_fields> type zsem4c_xml_service_fields.
*
*    data(lv_fct_conv) = cs_data-dte-documento-encabezado-totales-fct_conv.
*
*    if lv_fct_conv is initial.
*
*      lv_fct_conv = 1.
*
*    endif.
*
**-  Montos
*    append initial line to cs_data-dte-personalizados-fields assigning <ls_fields>.
*    <ls_fields>-field = 'MONEDA'.
*    <ls_fields>-value = is_data-invoice-s_vbrk-waerk.
*
*    append initial line to cs_data-dte-personalizados-fields2 assigning <ls_fields>.
*    <ls_fields>-field = 'SubTotalCop'.
*    <ls_fields>-value = me->format_not_rounded( conv string( cs_data-dte-documento-encabezado-totales-subtotal / lv_fct_conv ) ).
*
*    append initial line to cs_data-dte-personalizados-fields2 assigning <ls_fields>.
*    <ls_fields>-field = 'TotIvaCop'.
*    <ls_fields>-value = me->format_not_rounded( conv string( cs_data-dte-documento-encabezado-totales-mnt_imp / lv_fct_conv ) ).
*
*    append initial line to cs_data-dte-personalizados-fields2 assigning <ls_fields>.
*    <ls_fields>-field = 'VlrPagarCop'.
*    <ls_fields>-value = me->format_not_rounded( conv string( cs_data-dte-documento-encabezado-totales-vlr_pagar / lv_fct_conv ) ).
*
*    unassign:
*      <ls_fields>.
*
*    clear:
*      lv_fct_conv.

  endmethod.


  method MAP_CUSTOM_CONST.
  endmethod.


  method MAP_CUSTOM_PRINT.
  endmethod.


  method MAP_CUSTOM_VALUE.
  endmethod.


  method MAP_DATA.

*-  Cabecera

* - BEGIN OF Harold JTC 15.04.2025 09:04:33 [Insumos facturación electrónica DGII]
    rs_data-ecf-encabezado-xml_version = me->map_xml_version( ).
* - END OF Harold JTC 15.04.2025 09:04:33

    rs_data-ecf-encabezado-version   = |1.0|.
    rs_data-ecf-encabezado-id_doc    = me->map_iddoc( is_data ).
    rs_data-ecf-encabezado-emisor    = me->map_sender( is_data ).
    rs_data-ecf-encabezado-comprador = me->map_receiver( is_data ).
    rs_data-ecf-encabezado-totales   = me->map_totals( is_data ).


*-  Documento
    rs_data-ecf-detallesitems       = me->map_detail( is_data ).
    rs_data-ecf-descuentosorecargos = me->map_disc_rec( is_data ).

* - BEGIN OF Harold JTC 15.04.2025 13:49:25 [Insumos facturación electrónica DGII
    rs_data-ecf-fechahorafirma = me->map_fechahorafirma( ).
* - END OF Harold JTC 15.04.2025 13:49:25


*-  Personalizados
    me->map_custom(
          exporting is_data = is_data
           changing cs_data = rs_data ).

  endmethod.


  method MAP_DETAIL.
    data:
      lv_contador type i value 0,
      ls_item     type zsem4c_xml_service_item,
      lo_par      type ref to /em4c/cl_par_dao.

*-  Obtenemos la instancia
    lo_par       ?= /em4c/cl_factory_dao=>get_instance( 'PAR' ).

    loop at is_data-invoice-t_vbrp into data(ls_vbrp).

      add 1 to lv_contador.

      ls_item-indicadorfacturacion = get_conv( it_data = is_data-parameter-t_conv iv_param = 'INDICADOR_FACTURACIO' iv_from  = ls_vbrp-taxm1 ).

*      ls_item-numerolinea          = ls_vbrp-posnr.
      ls_item-numerolinea          = lv_contador.
      condense ls_item-numerolinea no-gaps.

      ls_item-nombreitem           = ls_vbrp-arktx.

* - BEGIN OF Harold JTC 15.04.2025 11:38:25 [Insumos facturación electrónica DGII]
      ls_item-indicadorbienoservicio  = lo_par->get_constant( iv_id   = 'FEL_DGII'
                                                              iv_name = 'INDBIENOSERVICIO' ).


*      ls_item-cantidaditem         = ls_vbrp-fkimg.
      ls_item-cantidaditem         = |{ ls_vbrp-fkimg decimals = 2 }|.

      ls_item-unidadmedida         = ls_vbrp-vrkme.

      ls_item-preciounitarioitem   = ls_vbrp-kzwi1.
*      ls_item-preciounitarioitem   = reduce #( init lv_sum type kbetr
*                                        for ls_konv in is_data-invoice-t_konv
*                                      where ( kschl in get_range( it_data = is_data-parameter-t_rng iv_param = 'PRECIOS' ) )
*                                       next lv_sum = abs( ls_konv-kbetr ) ).

      condense ls_item-preciounitarioitem no-gaps.

      ls_item-montoitem = reduce #( init lv_sum1 type kwert
                                        for ls_konv in is_data-invoice-t_konv
                                      where ( kschl in get_range( it_data = is_data-parameter-t_rng iv_param = 'PRECIOS' ) and
                                      ( kposn = ls_vbrp-posnr ) )
                                       next lv_sum1 = abs( ls_konv-kwert ) ).

      condense ls_item-montoitem no-gaps.

* - END OF Harold JTC 15.04.2025 11:38:25

      append ls_item to rt_data.
      clear:
      ls_item.

    endloop.


  endmethod.


  method MAP_DETAIL_TAX.
  endmethod.


  method MAP_DISC_REC.
    data:
          ls_item type zsem4c_xml_service_disc_rec.

    data(lr_kschl) = get_range( it_data = is_data-parameter-t_rng iv_param = 'COND_DESC_RECARG' ).

    select kschl, vtext
      from t685t
      where kschl in @lr_kschl
        and kappl = 'V'
      into table @data(lt_text).

    loop at is_data-invoice-t_konv into data(ls_konv) where kschl in lr_kschl.

      read table lt_text into data(ls_text) with key kschl = ls_konv-kschl.

      ls_item-descrvalordescuentoorecargoipc = ls_text-vtext.

      ls_item-tipovalor                      = get_conv( it_data  = is_data-parameter-t_conv iv_param = 'TIPO_VALOR' iv_from  = ls_konv-krech ).

      ls_item-valordescuentoorecargo         = ls_konv-kbetr.

      ls_item-numerolinea                    = ls_konv-kposn.

      append ls_item to rt_data.
      clear:
      ls_item.

    endloop.


  endmethod.


  method MAP_FECHAHORAFIRMA.

    data:
      lv_data  type string,
      lv_fecha type string,
      lv_hora  type string.

    concatenate sy-datum+6(2) '-' sy-datum+4(2) '-' sy-datum+0(4) into lv_fecha.
    concatenate sy-uzeit+0(2) ':' sy-uzeit+2(2) ':' sy-uzeit+4(2) into lv_hora.
    concatenate lv_fecha lv_hora into lv_data separated by space.

    rv_data = lv_data.

  endmethod.


  method MAP_IDDOC.

* - BEGIN OF Harold JTC 15.04.2025 09:44:26 [Insumos facturación electrónica DGII]
    data:
        lo_par type ref to /em4c/cl_par_dao.

*-  Obtenemos la instancia
    lo_par       ?= /em4c/cl_factory_dao=>get_instance( 'PAR' ).

    data(lv_montogravado) = lo_par->get_constant( iv_id   = 'FEL_DGII'
                                                  iv_name = 'INDMONTOGRAVADO' ).

    data(lv_tipoingresos) = lo_par->get_constant( iv_id   = 'FEL_DGII'
                                                  iv_name = 'TIPOINGRESOS' ).

    data(lv_tipopago) = lo_par->get_constant( iv_id   = 'FEL_DGII'
                                              iv_name = 'TIPOPAGO' ).
* - END OF Harold JTC 15.04.2025 09:44:26

*-  Pincipal

    select single z~kvgr1, z~fecha_fin
      from knvv as kn
      inner join zsd_t_ncf_conf as z
      on kn~kvgr1 = z~kvgr1
      where kn~kunnr = @is_data-invoice-s_vbrk-kunag
      into @data(ls_ncf_conf).

    select single vtweg, kvgr1
        from knvv
        into @data(ls_knvv)
        where kunnr = @is_data-invoice-s_vbrk-kunag
        and vtweg = @is_data-invoice-s_vbrk-vtweg.

    data(lv_vbtyp) = is_data-invoice-s_vbrk-vbtyp.

    rs_data-tipoecf                   = get_conv( it_data  = is_data-parameter-t_conv iv_param = 'TIPO_ECF' iv_from  = lv_vbtyp ).
    if rs_data-tipoecf is initial.
      rs_data-tipoecf                   = get_conv( it_data  = is_data-parameter-t_conv iv_param = 'TIPO_ECF' iv_from  = ls_knvv-kvgr1 ).
    endif.

    gv_tipoecf = rs_data-tipoecf.

    rs_data-encf                      = is_data-invoice-s_vbrk-xblnr.

    rs_data-fechavencimientosecuencia = |{ ls_ncf_conf-fecha_fin+6(2) && '-' &&
                                           ls_ncf_conf-fecha_fin+4(2) && '-' &&
                                           ls_ncf_conf-fecha_fin(4)  }|.

* - BEGIN OF Harold JTC 15.04.2025 09:24:28 [Insumos facturación electrónica DGII]
    rs_data-indicadormontogravado = lv_montogravado.
    rs_data-tipoingresos = lv_tipoingresos.
    rs_data-tipopago = lv_tipopago.
* - END OF Harold JTC 15.04.2025 09:24:28

  endmethod.


  method MAP_RECEIVER.

    data:
    lv_razonsocialcomprador type string value ''.

    rs_data-rnccomprador            = is_data-receptor-s_kna1-stcd1.

    rs_data-identificadorextranjero = is_data-receptor-s_kna1-kunnr.

    rs_data-identificadorextranjero = |{ is_data-receptor-s_kna1-name1 } { is_data-receptor-s_kna1-name2 }|.

    rs_data-provinciacomprador      = is_data-receptor-s_kna1-land1.

* - BEGIN OF Harold JTC 15.04.2025 09:52:25 [Insumos facturación electrónica DGII]
    select single name1, name2
      from kna1
      into @data(ls_kna1)
      where kunnr = @is_data-invoice-s_vbak-kunnr.

    if sy-subrc = 0.
      concatenate ls_kna1-name1 ls_kna1-name2 into lv_razonsocialcomprador separated by space.
    endif.

    rs_data-razonsocialcomprador = lv_razonsocialcomprador.
* - END OF Harold JTC 15.04.2025 09:52:25

  endmethod.


  method MAP_SENDER.

    data(ls_emisor) = is_data-sender-t_adrc[ 1 ].

    rs_data-rncemisor         = ls_emisor-sort1.

    rs_data-razonsocialemisor = |{ ls_emisor-name1 } { ls_emisor-name2 }|.

    rs_data-nombrecomercial   = |{ ls_emisor-name1 } { ls_emisor-name2 }|.

    rs_data-direccionemisor   = ls_emisor-street.

*    rs_data-municipio         = ls_emisor-region.

    rs_data-provincia         = ls_emisor-city1.


*    rs_data-fechaemision      = |{ is_data-invoice-s_vbak-erdat+6(2) && '-' &&
*                                   is_data-invoice-s_vbak-erdat+4(2) && '-' &&
*                                   is_data-invoice-s_vbak-erdat(4) }|.

    rs_data-fechaemision      = |{ is_data-invoice-s_vbrk-erdat+6(2) && '-' &&
                                   is_data-invoice-s_vbrk-erdat+4(2) && '-' &&
                                   is_data-invoice-s_vbrk-erdat(4) }|.

  endmethod.


  method MAP_TOTALS.
    constants:
    lc_cero type string value '0.00'.

* - BEGIN OF Harold JTC 15.04.2025 10:37:39 [Insumos facturación electrónica DGII]

    rs_data-montogravadoi1 = reduce #( init lv_sum2 type kawrt
                                        for ls_konv in is_data-invoice-t_konv
                                      where ( kschl in get_range( it_data = is_data-parameter-t_rng iv_param = 'IMPUESTOS' ) and
                                              mwsk1 in get_range( it_data = is_data-parameter-t_rng iv_param = 'IND_GRAVADO' ) )
                                       next lv_sum2 = lv_sum2 + abs( ls_konv-kawrt ) ).
    rs_data-montogravadototal = rs_data-montogravadoi1.
    condense rs_data-montogravadototal no-gaps.
    condense rs_data-montogravadoi1 no-gaps.

    rs_data-montogravadoi3 = reduce #( init lv_sum2 type kawrt
                                        for ls_konv in is_data-invoice-t_konv
                                      where ( kschl in get_range( it_data = is_data-parameter-t_rng iv_param = 'IMPUESTOS' ) and
                                              mwsk1 in get_range( it_data = is_data-parameter-t_rng iv_param = 'IND_EXENTO' ) )
                                       next lv_sum2 = lv_sum2 + abs( ls_konv-kawrt ) ).

    rs_data-montoexento = reduce #( init lv_sum2 type kawrt
                                        for ls_konv in is_data-invoice-t_konv
                                      where ( kschl in get_range( it_data = is_data-parameter-t_rng iv_param = 'IMPUESTOS' ) and
                                              mwsk1 in get_range( it_data = is_data-parameter-t_rng iv_param = 'IND_EXENTO' ) )
                                       next lv_sum2 = lv_sum2 + abs( ls_konv-kawrt ) ).

    condense rs_data-montogravadoi1 no-gaps.
    condense rs_data-montogravadoi3 no-gaps.
    condense rs_data-montoexento no-gaps.

    if rs_data-montogravadoi1 = lc_cero.
      rs_data-montogravadoi1 = ''.
      condense rs_data-montogravadoi1 no-gaps.
    endif.

    if rs_data-montogravadoi3 = lc_cero.
      rs_data-montogravadoi3 = ''.
      condense rs_data-montogravadoi3 no-gaps.
    endif.

    if rs_data-montoexento = lc_cero.
      rs_data-montoexento = ''.
      condense rs_data-montoexento no-gaps.
    endif.

    rs_data-itbis1         = |{ reduce #( init lv_sum type kwert
                                        for ls_konv in is_data-invoice-t_konv
                                      where ( kschl in get_range( it_data = is_data-parameter-t_rng iv_param = 'IMPUESTOS' ) and
                                              mwsk1 in get_range( it_data = is_data-parameter-t_rng iv_param = 'IND_GRAVADO' ) )
                                       next lv_sum = lv_sum + abs( ls_konv-kbetr ) ) decimals = 0 }|.

    rs_data-itbis3         = |{ reduce #( init lv_sum type kwert
                                        for ls_konv in is_data-invoice-t_konv
                                      where ( kschl in get_range( it_data = is_data-parameter-t_rng iv_param = 'IMPUESTOS' ) and
                                              mwsk1 in get_range( it_data = is_data-parameter-t_rng iv_param = 'IND_EXENTO' ) )
                                       next lv_sum = lv_sum + abs( ls_konv-kbetr ) ) decimals = 0 }|.

    condense rs_data-itbis1 no-gaps.
    condense rs_data-itbis3 no-gaps.

    if rs_data-itbis1 = lc_cero.
      rs_data-itbis1 = ''.
      condense rs_data-itbis1 no-gaps.
    endif.

    if rs_data-itbis3 = lc_cero.
      rs_data-itbis3 = ''.
      condense rs_data-itbis3 no-gaps.
    endif.

    rs_data-totalitbis     = reduce #( init lv_sum type kwert
                                        for ls_konv in is_data-invoice-t_konv
                                      where ( kschl in get_range( it_data = is_data-parameter-t_rng iv_param = 'IMPUESTOS' ) and
                                              mwsk1 in get_range( it_data = is_data-parameter-t_rng iv_param = 'IND_GRAVADO' ) )
                                       next lv_sum = lv_sum + abs( ls_konv-kwert ) ).
    rs_data-totalitbis3     = reduce #( init lv_sum type kwert
                                        for ls_konv in is_data-invoice-t_konv
                                      where ( kschl in get_range( it_data = is_data-parameter-t_rng iv_param = 'IMPUESTOS' ) and
                                              mwsk1 in get_range( it_data = is_data-parameter-t_rng iv_param = 'IND_EXENTO' ) )
                                       next lv_sum = lv_sum + abs( ls_konv-kbetr ) ).

    condense rs_data-totalitbis no-gaps.
    condense rs_data-totalitbis3 no-gaps.

    rs_data-totalitbis1     = reduce #( init lv_sum type kwert
                                        for ls_konv in is_data-invoice-t_konv
                                        where ( kschl in get_range( it_data = is_data-parameter-t_rng iv_param = 'IMPUESTOS' ) )
                                       next lv_sum = lv_sum + abs( ls_konv-kwert ) ).

    condense rs_data-totalitbis1 no-gaps.

*    rs_data-montototal    = is_data-invoice-s_vbrk-netwr.
    rs_data-montototal    = |{ rs_data-montogravadoi1 + rs_data-montogravadoi3 + rs_data-totalitbis decimals = 2 }|.

    rs_data-montonofacturable = reduce #( init lv_sum2 type kawrt
                                        for ls_konv in is_data-invoice-t_konv
                                        where ( kschl in get_range( it_data = is_data-parameter-t_rng iv_param = 'IMPUESTOS' ) and
                                        mwsk1 = 'A0' )
                                       next lv_sum2 = lv_sum2 + abs( ls_konv-kawrt ) ).

    condense rs_data-montonofacturable no-gaps.

    if rs_data-montonofacturable = lc_cero.
      rs_data-montonofacturable = ''.
      condense rs_data-montonofacturable no-gaps.
    endif.

* - END OF Harold JTC 15.04.2025 10:37:39

  endmethod.


  method MAP_XML_VERSION.

    data:
      lo_par type ref to /em4c/cl_par_dao.

*-  Obtenemos la instancia
    lo_par       ?= /em4c/cl_factory_dao=>get_instance( 'PAR' ).
    data(lv_data) = lo_par->get_constant( iv_id   = 'FEL_DGII'
                                          iv_name = 'XML_VERSION' ).

    rv_data = lv_data.

  endmethod.


  method PROCESS_DATA.

    data:
      ls_data type ts_data.

    ls_data-hdr-vbeln = ct_data[ field = zem4c_c_fields-hdr-vbeln         ]-value.
    ls_data-name      = ct_data[ field = zem4c_c_fields-hdr-clase_doc_fte ]-value.

*-  Obtenemos los datos
    me->request_hdr( exporting io_logger = io_logger changing cs_data = ls_data ).
    me->request_xml( exporting io_logger = io_logger changing cs_data = ls_data ).
    me->request_par( exporting io_logger = io_logger changing cs_data = ls_data ).

*-  Recargamos los datos
    me->reload_data(
           exporting is_data = ls_data
            changing ct_data = ct_data[] ).

*-  Mapeamos los datos
    cs_data-src  = me->map_data( ls_data ).
    cs_data-name = ls_data-name.

    clear:
      ls_data.

*    .
  endmethod.


  method RELOAD_DATA.

    append value #( field = zem4c_c_fields-hdr-uuid value = is_data-hdr-uuid ) to ct_data.

*-  Documento Contable
    data(lv_xblnr) = is_data-account-s_bkpf-xblnr. condense lv_xblnr.
    append value #( field = zem4c_c_fields-hdr-xblnr value = lv_xblnr                     ) to ct_data.
    append value #( field = zem4c_c_fields-hdr-belnr value = is_data-account-s_bkpf-belnr ) to ct_data.
    append value #( field = zem4c_c_fields-hdr-bukrs value = is_data-account-s_bkpf-bukrs ) to ct_data.
    append value #( field = zem4c_c_fields-hdr-gjahr value = is_data-account-s_bkpf-gjahr ) to ct_data.
    append value #( field = zem4c_c_fields-hdr-blart value = is_data-account-s_bkpf-blart ) to ct_data.

*-  Cliente
    append value #( field = zem4c_c_fields-hdr-kunrg value = is_data-receptor-s_kna1-kunnr ) to ct_data.
    append value #( field = zem4c_c_fields-hdr-name1 value = is_data-receptor-s_kna1-name1 ) to ct_data.
    append value #( field = zem4c_c_fields-hdr-land1 value = is_data-receptor-s_kna1-land1 ) to ct_data.

*-  Documento Fuente
    append value #( field = zem4c_c_fields-hdr-clase_doc_fte value = is_data-parameter-s_doc-docfte   ) to ct_data.
    append value #( field = zem4c_c_fields-hdr-type_xml_doc  value = is_data-parameter-s_doc-funcname ) to ct_data.
    append value #( field = zem4c_c_fields-hdr-serie         value = is_data-parameter-s_res-prefix   ) to ct_data.



  endmethod.


  method REQUEST_HDR.

    data:
      lo_hdr type ref to /em4c/cl_hdr_dao.

*-  Obtenemos la instancia
    lo_hdr     ?= /em4c/cl_factory_dao=>get_instance( 'HDR' ).
    cs_data-hdr = lo_hdr->get_data_initial_sd( cs_data-hdr-vbeln ).

    free:
      lo_hdr.

  endmethod.


  method REQUEST_PAR.

    data:
      lo_par type ref to /em4c/cl_par_dao.

*-  Obtenemos la instancia
    lo_par ?= /em4c/cl_factory_dao=>get_instance( 'PAR' ).

*-  Obtenemos la resolucion
    cs_data-parameter-s_doc = lo_par->get_docbuk( io_logger = io_logger iv_bukrs = cs_data-hdr-bukrs iv_docfte = cs_data-name ).
    cs_data-parameter-s_res = lo_par->get_fe_res( io_logger = io_logger iv_bukrs = cs_data-hdr-bukrs iv_type   = cs_data-name ).

*-  Obtenemos las conversiones
    lo_par->get_conversions(
                   exporting iv_wricef = 'FEL_DGII'
                             io_logger = io_logger
                    changing ct_data   = cs_data-parameter-t_conv[] ).

*-  Obtenemos las constantes
    lo_par->get_constants(
                 exporting iv_id     = cs_data-hdr-bukrs
                           io_logger = io_logger
                  changing ct_data   = cs_data-parameter-t_cons[] ).

    lo_par->get_constants(
                 exporting iv_id     = 'FEL_DGII'
                           io_logger = io_logger
                  changing ct_data   = cs_data-parameter-t_cons[] ).

*-  Obtenemos los rangos
    lo_par->get_ranges(
              exporting iv_id     = 'FEL_DGII'
                        io_logger = io_logger
               changing ct_data   = cs_data-parameter-t_rng[] ).

    free:
      lo_par.


  endmethod.


  method REQUEST_XML.

    data:
      lo_xml type ref to /em4c/cl_xml_dao.

*-  Obtenemos la instancia
    lo_xml ?= /em4c/cl_factory_dao=>get_instance( 'XML' ).

*-  Obtenemos las facturas
    cs_data-invoice-s_vbrk = lo_xml->get_vbrk2( cs_data-hdr-vbeln ).

    lo_xml->get_vbrp(
            exporting iv_vbeln = cs_data-hdr-vbeln
             changing ct_data  = cs_data-invoice-t_vbrp ).

    lo_xml->get_konv(
            exporting iv_knumv = cs_data-invoice-s_vbrk-knumv
             changing ct_data  = cs_data-invoice-t_konv ).

    cs_data-invoice-s_vbak = lo_xml->get_vbak( cs_data-invoice-t_vbrp[ 1 ]-aubel ).

*-  Obtenemos los datos contables
    cs_data-account-s_bkpf = lo_xml->get_bkpf2( iv_vbeln = cs_data-invoice-s_vbrk-vbeln io_logger = io_logger ).

*-  Obtenemos el proveedor
    cs_data-receptor-s_kna1 = lo_xml->get_kna1( cs_data-hdr-kunrg ).
    cs_data-receptor-s_adr6 = lo_xml->get_adr6( iv_adrnr = cs_data-receptor-s_kna1-adrnr io_logger = io_logger ).

*-  Obtenemos las sap-condiciones
    cs_data-condition-s_t052  = lo_xml->get_t052(  iv_zterm = cs_data-invoice-s_vbrk-zterm io_logger = io_logger ).
    cs_data-condition-s_t052u = lo_xml->get_t052u( iv_zterm = cs_data-invoice-s_vbrk-zterm io_logger = io_logger ).

*-  Obtenemos los datos principales
    cs_data-sender-s_t001 = lo_xml->get_t001( cs_data-hdr-bukrs ).
    lo_xml->get_adrc(
            exporting iv_adrnr  = cs_data-sender-s_t001-adrnr
                      io_logger = io_logger
             changing ct_data   = cs_data-sender-t_adrc ).

    if cs_data-sender-t_adrc[] is not initial.

      cs_data-sender-s_adrcity = lo_xml->get_adrcity( iv_city = cs_data-sender-t_adrc[ 1 ]-city1 io_logger = io_logger ).

    endif.

*-  Obtenemos el proveedor
    lo_xml->get_adrc(
            exporting iv_adrnr  = cs_data-receptor-s_kna1-adrnr
                      io_logger = io_logger
             changing ct_data   = cs_data-receptor-t_adrc ).

    if cs_data-receptor-t_adrc[] is not initial.

      cs_data-receptor-s_adrcity = lo_xml->get_adrcity( iv_city = cs_data-receptor-t_adrc[ 1 ]-city1 io_logger = io_logger ).

    endif.

*-  Obtenemos los datos parametrizados
    lo_xml->get_t001z(
             exporting iv_bukrs  = cs_data-hdr-bukrs
                       io_logger = io_logger
              changing ct_data   = cs_data-invoice-t_t001z ).

    free:
      lo_xml.

  endmethod.
ENDCLASS.
