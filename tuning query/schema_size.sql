select sum(bytes)/(1024*1024*1024) from dba_segments aa  where   
owner= :owner
and segment_name not in (
'T_ACCOUNTTYPEITEM',
'T_DOCUMENTITEM',
'T_DOCUMENT',
'T_INTERBRANCHDOCUMENT',
'T_INTERBRANCHDOCUMENTITEM',
'T_LASTACCOUNTTYPEITEM',
'T_SUMMARYACCOUNTTYPEITEM',
'T_TRANSFERMONEYBILL',
'T_DEPOSITITEM',
'T_AUTHORITYLOG',
'T_AUTHORTIYOPERATIONLOG',
'T_TRANSFERMONEYLOG',
'T_TRANSFERMONEYLOGITEM',
'T_DOCUMENTSMSINFO',
'T_TEMPORARYDOCUMENTSMSINFO',
'T_DOCUMENTEXTRAINFO',
'T_DOCUMENTITEMEXTRAINFO',
'PK_T_DOCUMENT',
'DOC_RLBRDATISURSTS_GHPI',
'DOCUMNT_DOCNUMBER_UGHPI',
'DOCUMNET_RLTBRNCH5COL_LPIX',
'DOCUMENT_TRANSACTION_GPHIX',
'DOCUMENT_DATEBRANCHID_LPIX',
'PK_TLASTACCOUNTTYPEITEM',
'LSTACTYPITM_PFCURATY_LPIX',
'LSTACTYPITM_ISSUANCEID_UGRPIX',
'LSTACTYPITM_EFDATEATY_GHPI',
'LSTACTYPITM_ATYPF_GHPI',
'LASTACC_PFATY#CUR_LPIX',
'PK_AUTHORITYLOG_NEW',
'ACTYPITM_ACPF_GHPI',
'PK_ACCOUNTTYPEITEM',
'ACTYPITM_PFACID_LPIX',
'ACTYPITM_PFACCUR#_LPIX',
'ACTYPITM_ISSUANCEID_UGPIX',
'ACTYPITM_ATYPF_GHPI',
'ACTYPITM_ATYPFCUR#_LPIX',
'ACTYPITM_ACPFCURID_LPIX',
'ACTYPITM_ACCUR#AMNTPF_LPIX',
'DOCITM_ISSUANCEID_UGPIX',
'DCTM_DOC_LPIX',
'DCTM_DOCACC_LPIX',
'PK_TDOCUMENTITEM_GHPI',
'PK_DOCEXTRAINFO_ID',
'PK_DIEXTRAINFO_ID',
'SYS_C0015610',
'T_TRANSFERMONEYBILL_UK1',
'PK_T_TRANSFERMONEYBILL',
'PK_T_INTERBRANCHDOCUMENT',
'DPITEM_DNUMBER',
'PK_T_INTERBRANCHDOCUMENTITEM',
'PK_T_TRANSFERMONEYLOG',
'PK_T_TRANSFERMONEYLOGITEM',
'DOCEXTRAINFO_DI_IDX',
'DOCEXTRAINFO_CE_INFOTYPE_IDX',
'DIEXTRAINFO_DI_IDX',
'DIEXTRAINFO_CE_INFOTYPE_IDX',
'SYS_C0016223',
'TRANSFERMONEYBILL_ORGANIZA',
'TRANSFERMONEYBILL_CIX1',
'T_DEPOSITITEM_INDEX1',
'T_DEPOSITITEM_INDEX2',
'INTERBRANCHDOCUMENTITEM_RE',
'INTERBRANCHDOCUMENTITEM_CIX1',
'TRANSFERMONEYLOG_CURRENCY',
'TRANSFERMONEYLOG_TRANSACTI',
'NFK_TRAN_LOG6',
'TRANSFERMONEYLOGITEM_LOG',
'TRANSFERMONEYLOGITEM_OBJ_0',
'TRANSFERMONEYLOGITEM_OBJEC',
'TRANSFERMONEYLOGITEM_OPERA')


 