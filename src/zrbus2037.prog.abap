INCLUDE <OBJECT>.
BEGIN_DATA OBJECT. " Do not change.. DATA is generated
* only private members may be inserted into structure private
DATA:
" begin of private,
"   to declare private attributes remove comments and
"   insert private attributes here ...
" end of private,
  BEGIN OF KEY,
      BILLINGDOCUMENT LIKE VBRK-VBELN,
  END OF KEY,
      _VBRK LIKE VBRK.
END_DATA OBJECT. " Do not change.. DATA is generated

TABLES VBRK.
*
GET_TABLE_PROPERTY VBRK.
DATA SUBRC LIKE SY-SUBRC.
* Fill TABLES VBRK to enable Object Manager Access to Table Properties
  PERFORM SELECT_TABLE_VBRK USING SUBRC.
  IF SUBRC NE 0.
    EXIT_OBJECT_NOT_FOUND.
  ENDIF.
END_PROPERTY.
*
* Use Form also for other(virtual) Properties to fill TABLES VBRK
FORM SELECT_TABLE_VBRK USING SUBRC LIKE SY-SUBRC.
* Select single * from VBRK, if OBJECT-_VBRK is initial
  IF OBJECT-_VBRK-MANDT IS INITIAL
  AND OBJECT-_VBRK-VBELN IS INITIAL.
    SELECT SINGLE * FROM VBRK CLIENT SPECIFIED
        WHERE MANDT = SY-MANDT
        AND VBELN = OBJECT-KEY-BILLINGDOCUMENT.
    SUBRC = SY-SUBRC.
    IF SUBRC NE 0. EXIT. ENDIF.
    OBJECT-_VBRK = VBRK.
  ELSE.
    SUBRC = 0.
    VBRK = OBJECT-_VBRK.
  ENDIF.
ENDFORM.
