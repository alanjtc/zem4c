class ZCL_CO_ELECTRONIC_INVOICES_SER definition
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
  methods ELECTRONIC_INVOICES
    importing
      !INPUT type ZCL_ELECTRONIC_INVOICES_REQUES
    exporting
      !OUTPUT type ZCL_ELECTRONIC_INVOICES_RESPO1
    raising
      CX_AI_SYSTEM_FAULT .
protected section.
private section.
ENDCLASS.



CLASS ZCL_CO_ELECTRONIC_INVOICES_SER IMPLEMENTATION.


  method CONSTRUCTOR.

  super->constructor(
    class_name          = 'ZCL_CO_ELECTRONIC_INVOICES_SER'
    logical_port_name   = logical_port_name
    destination         = destination
  ).

  endmethod.


  method ELECTRONIC_INVOICES.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'ELECTRONIC_INVOICES'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.
ENDCLASS.
