class ZEM4C_CO_ELECTRONIC_INVOICES_P definition
  public
  inheriting from CL_PROXY_CLIENT
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !DESTINATION type ref to IF_PROXY_DESTINATION optional
      !LOGICAL_PORT_NAME type PRX_LOGICAL_PORT_NAME optional
    preferred parameter LOGICAL_PORT_NAME
    raising
      CX_AI_SYSTEM_FAULT .
  methods PROCESS_ELECTRONIC_INVOICE
    importing
      !INPUT type ZEM4C_ELECTRONIC_INVOICES_REQU
    exporting
      !OUTPUT type ZEM4C_ELECTRONIC_INVOICES_RES1
    raising
      CX_AI_SYSTEM_FAULT .
protected section.
private section.
ENDCLASS.



CLASS ZEM4C_CO_ELECTRONIC_INVOICES_P IMPLEMENTATION.


  method CONSTRUCTOR.

  super->constructor(
    class_name          = 'ZEM4C_CO_ELECTRONIC_INVOICES_P'
    logical_port_name   = logical_port_name
    destination         = destination
  ).

  endmethod.


  method PROCESS_ELECTRONIC_INVOICE.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'PROCESS_ELECTRONIC_INVOICE'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.
ENDCLASS.
