class ZCL_EM4C_XML_SD_FN32_GENERATOR definition
  public
  inheriting from ZCL_EM4C_XML_BASE_SD_GENERATOR
  final
  create public .

public section.
protected section.

  methods PROCESS_DATA
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_EM4C_XML_SD_FN32_GENERATOR IMPLEMENTATION.


  method process_data.

    append value #( field = zem4c_c_fields-hdr-clase_doc_fte value = 'SD_FN32' ) to ct_data.

    super->process_data(
      exporting
        io_logger = io_logger
      changing
        ct_data   = ct_data
        cs_data   = cs_data ).

  endmethod.
ENDCLASS.
