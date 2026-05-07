type-pool zem4c .


*----------------------------------------------------------------------*
*  TYPES
*----------------------------------------------------------------------*
*  Definicion de Types
*----------------------------------------------------------------------*

*----------------------------------------------------------------------*
*  Types para las tablas de datos
*----------------------------------------------------------------------*
types:
  zem4c_tt_hdr type standard table of /em4c/tfel_hdr with default key,
  zem4c_tt_rep type standard table of /em4c/tfel_rep with default key.

types:
  zem4c_tt_stat  type standard table of /em4c/tfel_statu  with default key,
  zem4c_tt_conv  type standard table of /em4c/tfel_conv   with default key,
  zem4c_tt_const type standard table of /em4c/tfel_const  with default key,
  zem4c_tt_res   type standard table of /em4c/tfel_res    with default key,
  zem4c_tt_param type standard table of /em4c/tfel_param  with default key,
  zem4c_tt_matnr type standard table of /em4c/vfel_matnr  with default key.

types:
  begin of zem4c_ts_par_bukrs.
    include type /em4c/vfel_bukrs.
types:
    butxt type t001-butxt,
  end   of zem4c_ts_par_bukrs,
  zem4c_tt_par_bukrs type standard table of zem4c_ts_par_bukrs with default key.


*----------------------------------------------------------------------*
*  Types para el binario
*----------------------------------------------------------------------*
types:
  begin of zem4c_ts_bin,
    line(255) type x,
  end   of zem4c_ts_bin,
  zem4c_tt_bin type standard table of zem4c_ts_bin
                    with default key.

*----------------------------------------------------------------------*
*  Types para rangos
*----------------------------------------------------------------------*
types:
  zem4c_tr_bukrs type range of bukrs,
  zem4c_tr_datum type range of sydats,
  zem4c_tr_xblnr type range of xblnr,
  zem4c_tr_docls type range of /em4c/de_fel_docfte,
  zem4c_tr_stat  type range of /em4c/de_fel_estado_fact_elect,
  zem4c_tr_belnr type range of belnr_d,
  zem4c_tr_bstkd type range of bstkd,
  zem4c_tr_vbeln type range of vbeln,
  zem4c_tr_uuid  type range of /em4c/de_fel_uuid,
  zem4c_tr_fkart type range of fkart,
  zem4c_tr_file  type range of /em4c/de_file_type.


*----------------------------------------------------------------------*
*  CONSTANTS
*----------------------------------------------------------------------*
*  Definicion de Constants
*----------------------------------------------------------------------*

*----------------------------------------------------------------------*
*  Constants para los campos
*----------------------------------------------------------------------*
constants:
  begin of zem4c_c_fields,
    begin of hdr,
      uuid               type string value 'UUID',
      bukrs              type string value 'BUKRS',
      belnr              type string value 'BELNR',
      gjahr              type string value 'GJAHR',
      clase_doc_fte      type string value 'CLASE_DOC_FTE',
      buzei              type string value 'BUZEI',  "Modificado
      kunrg              type string value 'KUNRG',
      name1              type string value 'NAME1',
      vbeln              type string value 'VBELN',
      land1              type string value 'LAND1',
      xblnr              type string value 'XBLNR',
      xref2              type string value 'XREF2',
      coaut              type string value 'COAUT',
      femis              type string value 'FEMIS',
      hemis              type string value 'HEMIS',
      serie              type string value 'SERIE',
      estado             type string value 'ESTADO',
      fecha_estado       type string value 'FECHA_ESTADO',
      hora_estado        type string value 'HORA_ESTADO',
      id_xml_doc         type string value 'ID_XML_DOC',
      country_doc        type string value 'COUNTRY_DOC',
      type_xml_doc       type string value 'TYPE_XML_DOC',
      create_user        type string value 'CREATE_USER',
      create_date        type string value 'CREATE_DATE',
      create_time        type string value 'CREATE_TIME',
      qrcode             type string value 'QRCODE',
      num_entrega        type string value 'NUM_ENTREGA',
      num_pedido         type string value 'NUM_PEDIDO',
      moti_pedid         type string value 'MOTI_PEDID',
      blart              type string value 'BLART',
      transaction_id     type string value 'TRANSACTION_ID',
      fkart              type string value 'FKARD',
      bstkd              type string value 'BSTKD',
      global_document_id type string value 'GLOBAL_DOCUMENT_ID',
      amount_total       type string value 'AMOUNT_TOTAL',
      waers              type string value 'WAERS',
      attach             type string value 'ATTACH',
    end   of hdr,
    begin of tmp,
      xref2 type string value 'XREF2',
      proc  type string value 'PROCESS',
      prov  type string value 'PROVIDER',
      xml   type string value 'XML',
    end   of tmp,
  end   of zem4c_c_fields.


*----------------------------------------------------------------------*
*  Constants para las sociedades
*----------------------------------------------------------------------*
constants:
  begin of zem4c_c_bukrs,
    all type string value '0000',
  end   of zem4c_c_bukrs.

*----------------------------------------------------------------------*
*  Constants para los prefijos
*----------------------------------------------------------------------*
constants:
  begin of zem4c_c_prefix,
    file type string value 'FILE-',
  end   of zem4c_c_prefix.

*----------------------------------------------------------------------*
*  Constants para los archivos
*----------------------------------------------------------------------*
constants:
  begin of zem4c_c_file,
    pdf type string value '00',
    xml type string value '01',
  end   of zem4c_c_file .

*----------------------------------------------------------------------*
*  Constants para los estados
*----------------------------------------------------------------------*
constants:
  begin of zem4c_c_status,
    pending type /em4c/tfel_hdr-estado value 'PE',
    begin of ok,
      signature type /em4c/tfel_hdr-estado value '10',
      dian      type /em4c/tfel_hdr-estado value '4',
    end   of ok,
    begin of rejected,
      dian  type /em4c/tfel_hdr-estado value '6',
      proxy type /em4c/tfel_hdr-estado value 'ER',
    end   of rejected,
  end   of zem4c_c_status.

*----------------------------------------------------------------------*
*  Constants para los usuarios
*----------------------------------------------------------------------*
constants:
  begin of zem4c_c_usr,
    begin of auth,
      viewer(2) type c value '03',
      admin(2)  type c value '70',
    end   of auth,
  end   of zem4c_c_usr.

*----------------------------------------------------------------------*
*  DEFINE
*----------------------------------------------------------------------*
*  Definicion de Macros
*----------------------------------------------------------------------*

*----------------------------------------------------------------------*
*  DEFINE zem4c_m_progress_indicator
*----------------------------------------------------------------------*
*  Macro para el Indicador de progreso
*----------------------------------------------------------------------*
*  &1  Porcentage
*  &2  Texto
*----------------------------------------------------------------------*
define zem4c_m_progress_indicator.

*- Llamamos a la funcion
  call function 'SAPGUI_PROGRESS_INDICATOR'
    exporting
      percentage = &1
      text       = &2.

end-of-definition.

*----------------------------------------------------------------------*
*  DEFINE zem4c_m_append_message
*----------------------------------------------------------------------*
*  Macro para la carga de campo
*----------------------------------------------------------------------*
*  &1  Tabla de Mensaje
*  &2  Tipo
*  &3  Numero
*  &4  Valor 1
*  &5  Valor 2
*  &6  Valor 3
*  &7  Valor 4
*----------------------------------------------------------------------*
define zem4c_m_append_message.

  append value /em4c/sfel_message( msgty = &2
                               msgno = &3
                               msgv1 = &4
                               msgv2 = &5
                               msgv3 = &6
                               msgv4 = &7 )
            to &1.

end-of-definition.


*----------------------------------------------------------------------*
* Support Document types
*----------------------------------------------------------------------*

types:
  zem4c_dsa_tt_hdr type standard table of /em4c/dsa_t_hdr with default key,
  zem4c_dsa_tt_rep type standard table of /em4c/dsa_t_rep with default key.



types:
  zem4c_dsa_tt_stat  type standard table of /em4c/tfel_statu  with default key,
  zem4c_dsa_tt_conv  type standard table of /em4c/tfel_conv   with default key,
  zem4c_dsa_tt_const type standard table of /em4c/tfel_const  with default key,
  zem4c_dsa_tt_res   type standard table of /em4c/tfel_res    with default key,
  zem4c_dsa_tt_param type standard table of /em4c/tfel_param  with default key,
  zem4c_dsa_tt_matnr type standard table of /em4c/vfel_matnr  with default key.

types:
  begin of zem4c_dsa_ts_par_bukrs.
    include type /em4c/vfel_bukrs.
types:
    butxt type t001-butxt,
  end   of zem4c_dsa_ts_par_bukrs,
  zem4c_dsa_tt_par_bukrs type standard table of zem4c_dsa_ts_par_bukrs with default key.


*----------------------------------------------------------------------*
*  Types para el binario
*----------------------------------------------------------------------*
types:
  begin of zem4c_dsa_ts_bin,
    line(255) type x,
  end   of zem4c_dsa_ts_bin,
  zem4c_dsa_tt_bin type standard table of zem4c_dsa_ts_bin
                    with default key.

*----------------------------------------------------------------------*
*  Types para rangos
*----------------------------------------------------------------------*
types:
  zem4c_dsa_tr_bukrs type range of bukrs,
  zem4c_dsa_tr_datum type range of sydats,
  zem4c_dsa_tr_xblnr type range of xblnr,
  zem4c_dsa_tr_docls type range of /em4c/dsa_de_docfte,
  zem4c_dsa_tr_stat  type range of /em4c/dsa_de_estado_fact_elect,
  zem4c_dsa_tr_belnr type range of belnr_d,
  zem4c_dsa_tr_bstkd type range of bstkd,
  zem4c_dsa_tr_vbeln type range of vbeln,
  zem4c_dsa_tr_uuid  type range of /em4c/dsa_de_uuid,
  zem4c_dsa_tr_fkart type range of fkart,
  zem4c_dsa_tr_file  type range of /em4c/dsa_de_file_type.


*----------------------------------------------------------------------*
*  CONSTANTS
*----------------------------------------------------------------------*
*  Definicion de Constants
*----------------------------------------------------------------------*

*----------------------------------------------------------------------*
*  Constants para los campos
*----------------------------------------------------------------------*
constants:
  begin of zem4c_dsa_c_fields,
    begin of hdr,
      uuid               type string value 'UUID',
      bukrs              type string value 'BUKRS',
      belnr              type string value 'BELNR',
      gjahr              type string value 'GJAHR',
      clase_doc_fte      type string value 'CLASE_DOC_FTE',
      buzei              type string value 'BUZEI',  "Modificado
      kunrg              type string value 'KUNRG',
      name1              type string value 'NAME1',
      vbeln              type string value 'VBELN',
      land1              type string value 'LAND1',
      xref2              type string value 'XREF2',
      xblnr              type string value 'XBLNR',
      coaut              type string value 'COAUT',
      femis              type string value 'FEMIS',
      hemis              type string value 'HEMIS',
      serie              type string value 'SERIE',
      estado             type string value 'ESTADO',
      fecha_estado       type string value 'FECHA_ESTADO',
      hora_estado        type string value 'HORA_ESTADO',
      id_xml_doc         type string value 'ID_XML_DOC',
      country_doc        type string value 'COUNTRY_DOC',
      type_xml_doc       type string value 'TYPE_XML_DOC',
      create_user        type string value 'CREATE_USER',
      create_date        type string value 'CREATE_DATE',
      create_time        type string value 'CREATE_TIME',
      qrcode             type string value 'QRCODE',
      num_entrega        type string value 'NUM_ENTREGA',
      num_pedido         type string value 'NUM_PEDIDO',
      moti_pedid         type string value 'MOTI_PEDID',
      blart              type string value 'BLART',
      transaction_id     type string value 'TRANSACTION_ID',
      fkart              type string value 'FKARD',
      bstkd              type string value 'BSTKD',
      global_document_id type string value 'GLOBAL_DOCUMENT_ID',
      amount_total       type string value 'AMOUNT_TOTAL',
      waers              type string value 'WAERS',
      attach             type string value 'ATTACH',
      usnam              type string value 'USNAM',
      doc_ref            type string value 'DOC_REF',
    end   of hdr,
    begin of tmp,
      xref2 type string value 'XREF2',
      proc  type string value 'PROCESS',
      prov  type string value 'PROVIDER',
      xml   type string value 'XML',
    end   of tmp,
  end   of zem4c_dsa_c_fields.


*----------------------------------------------------------------------*
*  Constants para las sociedades
*----------------------------------------------------------------------*
constants:
  begin of zem4c_dsa_c_bukrs,
    all type string value '0000',
  end   of zem4c_dsa_c_bukrs.

*----------------------------------------------------------------------*
*  Constants para los prefijos
*----------------------------------------------------------------------*
constants:
  begin of zem4c_dsa_c_prefix,
    file type string value 'FILE-',
  end   of zem4c_dsa_c_prefix.

*----------------------------------------------------------------------*
*  Constants para los archivos
*----------------------------------------------------------------------*
constants:
  begin of zem4c_dsa_c_file,
    pdf type string value '00',
    xml type string value '01',
  end   of zem4c_dsa_c_file .

*----------------------------------------------------------------------*
*  Constants para los estados
*----------------------------------------------------------------------*
constants:
  begin of zem4c_dsa_c_status,
    pending type /em4c/tfel_hdr-estado value 'PE',
    begin of ok,
      signature type /em4c/tfel_hdr-estado value '10',
      dian      type /em4c/tfel_hdr-estado value '4',
    end   of ok,
    begin of rejected,
      dian  type /em4c/tfel_hdr-estado value '6',
      proxy type /em4c/tfel_hdr-estado value 'ER',
    end   of rejected,
  end   of zem4c_dsa_c_status.


constants:
  begin of zem4c_dsa_c_clase_doc,
    mm_cq type /em4c/dsa_t_hdr-clase_doc_fte value 'MM_CQ',
  end of zem4c_dsa_c_clase_doc.
*----------------------------------------------------------------------*
*  Constants para los usuarios
*----------------------------------------------------------------------*
constants:
  begin of zem4c_dsa_c_usr,
    begin of auth,
      viewer(2) type c value '03',
      admin(2)  type c value '70',
    end   of auth,
  end   of zem4c_dsa_c_usr.

*----------------------------------------------------------------------*
*  DEFINE
*----------------------------------------------------------------------*
*  Definicion de Macros
*----------------------------------------------------------------------*

*----------------------------------------------------------------------*
*  DEFINE zem4c_m_progress_indicator
*----------------------------------------------------------------------*
*  Macro para el Indicador de progreso
*----------------------------------------------------------------------*
*  &1  Porcentage
*  &2  Texto
*----------------------------------------------------------------------*
define zem4c_dsa_m_progress_indicator.

*- Llamamos a la funcion
  call function 'SAPGUI_PROGRESS_INDICATOR'
    exporting
      percentage = &1
      text       = &2.

end-of-definition.

*----------------------------------------------------------------------*
*  DEFINE zem4c_m_append_message
*----------------------------------------------------------------------*
*  Macro para la carga de campo
*----------------------------------------------------------------------*
*  &1  Tabla de Mensaje
*  &2  Tipo
*  &3  Numero
*  &4  Valor 1
*  &5  Valor 2
*  &6  Valor 3
*  &7  Valor 4
*----------------------------------------------------------------------*
define zem4c_dsa_m_append_message.

  append value /em4c/dsa_s_message( msgty = &2
                               msgno = &3
                               msgv1 = &4
                               msgv2 = &5
                               msgv3 = &6
                               msgv4 = &7 )
            to &1.

end-of-definition.
