CREATE OR REPLACE VIEW P1VSGMF.B2K_BCFDTLRU_1_0 (
  EDW_RECORD_NO,
  FT_TRAN_CODE_SUB,
  FT_CORP_NO,
  FT_ACCT_NO,
  FT_DRAFT_ACNO_EXTENSION,
  FT_REASON_CODE,
  FT_MICRO_REF_NUM,
  FT_PURCHASE_DT,
  FT_ENTRY_AMOUNT,
  FT_ORIG_TRANS_AMT,
  FT_ORIG_CURR_CODE,
  FT_ORIG_CURR_EXP,
  FT_MERCH_NAME,
  FT_MERCH_CITY,
  FT_MERCH_STATE,
  FT_MERCH_CLASS,
  FT_MERCH_COUNTRY,
  FT_AUTH_NO,
  FT_MC_JULIAN_DATE,
  FT_CARD_CODE,
  FT_TERMINAL_ID,
  FT_MAIL_PHONE_IND,
  FT_MERCHANT_CORP,
  FT_MERCHANT_NO,
  START_DT,
  END_DT,
  RECORD_DELETED_FLAG,
  CTL_ID,
  INS_PROC_NAME,
  INS_TXF_BATCHID,
  UPD_PROC_NAME,
  UPD_TXF_BATCHID,
  CREDIT_FLAG,
  INTER_FLAG,
  BIN_12_DIGIT,
  BIN_8_DIGIT,
  TRANSACTION_DATE)
AS select 
STGMERGE.EDW_RECORD_NO,
STGMERGE.FT_TRAN_CODE_SUB,
STGMERGE.FT_CORP_NO,
STGMERGE.FT_ACCT_NO,
STGMERGE.FT_DRAFT_ACNO_EXTENSION,
STGMERGE.FT_REASON_CODE,
STGMERGE.FT_MICRO_REF_NUM,
STGMERGE.FT_PURCHASE_DT,
STGMERGE.FT_ENTRY_AMOUNT,
STGMERGE.FT_ORIG_TRANS_AMT,
STGMERGE.FT_ORIG_CURR_CODE,
STGMERGE.FT_ORIG_CURR_EXP,
STGMERGE.FT_MERCH_NAME,
STGMERGE.FT_MERCH_CITY,
STGMERGE.FT_MERCH_STATE,
STGMERGE.FT_MERCH_CLASS,
STGMERGE.FT_MERCH_COUNTRY,
STGMERGE.FT_AUTH_NO,
STGMERGE.FT_MC_JULIAN_DATE,
STGMERGE.FT_CARD_CODE,
STGMERGE.FT_TERMINAL_ID,
STGMERGE.FT_MAIL_PHONE_IND,
STGMERGE.FT_MERCHANT_CORP,
STGMERGE.FT_MERCHANT_NO,
STGMERGE.START_DT,
STGMERGE.END_DT,
STGMERGE.RECORD_DELETED_FLAG,
STGMERGE.CTL_ID,
STGMERGE.INS_PROC_NAME,
STGMERGE.INS_TXF_BATCHID,
STGMERGE.UPD_PROC_NAME,
STGMERGE.UPD_TXF_BATCHID
/* CODE ADDED FOR DMS CUS PHASE 2 - START */
,STGMERGE.CREDIT_FLAG
,STGMERGE.INTER_FLAG
/* CODE ADDED FOR DMS CUS PHASE 2 - END   */
,STGMERGE.BIN_12_DIGIT
,STGMERGE.BIN_8_DIGIT
,COALESCE(DEFAULT_DATE,to_date('1000-01-02', 'yyy-MM-dd')) as TRANSACTION_DATE
FROM  p1dutedw.CHAR_CALENDAR CC
RIGHT OUTER JOIN
(
  SELECT
  EDW_RECORD_NO,
  FT_TRAN_CODE_SUB,
  FT_CORP_NO,
  FT_ACCT_NO,
  FT_DRAFT_ACNO_EXTENSION,
  FT_REASON_CODE,
  FT_MICRO_REF_NUM,
  FT_PURCHASE_DT,
  FT_ENTRY_AMOUNT,
  FT_ORIG_TRANS_AMT,
  FT_ORIG_CURR_CODE,
  FT_ORIG_CURR_EXP,
  FT_MERCH_NAME,
  FT_MERCH_CITY,
  FT_MERCH_STATE,
  FT_MERCH_CLASS,
  FT_MERCH_COUNTRY,
  FT_AUTH_NO,
  FT_MC_JULIAN_DATE,
  FT_CARD_CODE,
  FT_TERMINAL_ID,
  FT_MAIL_PHONE_IND,
  FT_MERCHANT_CORP,
  FT_MERCHANT_NO,
  START_DT,
  END_DT,
  RECORD_DELETED_FLAG,
  CTL_ID,
  INS_PROC_NAME,
  INS_TXF_BATCHID,
  UPD_PROC_NAME,
  UPD_TXF_BATCHID
  /* CODE ADDED FOR DMS CUS PHASE 2 - START */
  ,CREDIT_FLAG
  ,INTER_FLAG
  /* CODE ADDED FOR DMS CUS PHASE 2 - END   */
  ,BIN_12_DIGIT
  ,BIN_8_DIGIT
  FROM p1dsgedw.B2K_BCFDTLRU_1_0_T1
) STGMERGE

ON COALESCE(SUBSTR(STGMERGE.FT_PURCHASE_DT,2),'NA') = CC.CDT_YYYYMMDD
