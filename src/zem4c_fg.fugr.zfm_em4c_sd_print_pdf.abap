FUNCTION ZFM_EM4C_SD_PRINT_PDF.
*"----------------------------------------------------------------------
*"*"Interfase local
*"  IMPORTING
*"     REFERENCE(I_VBELN) TYPE  VBELN
*"     REFERENCE(I_DOC_FTE) TYPE  /EM4C/DE_FEL_DOCFTE
*"----------------------------------------------------------------------

   DATA: LV_RONAM TYPE NA_RONAM,
         LV_PGM  TYPE NA_PGNAM.


   LV_RONAM = 'ENTRY'.

   LV_PGM = COND #( WHEN I_DOC_FTE = 'SD_FN' THEN 'ZSD_REP_INVOICE_PDF'
                    WHEN I_DOC_FTE = 'SD_NC' THEN 'ZSD_REP_CREDITNOTE_PDF'
                    WHEN I_DOC_FTE = 'SD_ND' THEN 'ZSD_REP_DEBITNOTE_PDF' ).

   INCLUDE RVADTABL.

   NAST-OBJKY = I_VBELN.

   perform (LV_RONAM) in program (LV_PGM) using 999
                                                    'x'
                                               if found.



ENDFUNCTION.
