function zfm_em4c_sd_validarfactura.
*"----------------------------------------------------------------------
*"*"Interfase local
*"  EXPORTING
*"     REFERENCE(EV_RESULT) TYPE  SYST_SUBRC
*"  TABLES
*"      IT_VBRK STRUCTURE  VBRK
*"----------------------------------------------------------------------
  constants:
    lc_fel_dgii           type string value 'FEL_DGII',
    lc_resp_pago_admitido type string value 'RESP_NO_ADMITIDOS',
    lc_e                  type c length 1 value 'E'.

  data:
    lr_kunrg  type range of vbrk-kunrg,
    lwa_kunrg like line of lr_kunrg,
    lv_msg    type string.

  "Obtenemos los valores de la factura
  read table it_vbrk into data(ls_vbrk) index 1.

  "Inicializamos el resultado
  ev_result = 0.

  "Obtenemos el rango de pagadores de la CUST
  select zlow
    from /em4c/tfel_param
    into table @data(lt_param)
    where idfrice = @lc_fel_dgii
    and param_id = @lc_resp_pago_admitido.

  "Obtenemos las clases de factura de la CUST
  select bukrs, docfte, fkart
    from /em4c/t_bldobk
    into table @data(lt_docfte)
    where bukrs = @ls_vbrk-bukrs.

  "Comprobamos clase de factura
  read table lt_docfte transporting no fields with key fkart = ls_vbrk-fkart.
  if sy-subrc <> 0.
    ev_result = sy-subrc.
    concatenate 'La clase de factura no se encuenta configurada en la CUST: ' ls_vbrk-fkart into lv_msg.
    message lv_msg type lc_e.
    return.
  endif.

  "Comprobamos el pagador
  read table lt_param transporting no fields with key zlow = ls_vbrk-kunrg.
  if sy-subrc = 0.
    ev_result = 4.
    concatenate 'La pagador no se encuenta admitido. Revisar la CUST: ' ls_vbrk-kunrg into lv_msg.
    message lv_msg type lc_e.
    return.
  endif.

endfunction.
