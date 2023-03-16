CREATE OR REPLACE VIEW P1VSGMF.GN_MTLOG_1_0 (
  EDW_RECORD_NO,
  GN_REC_SYS_DATE,
  GN_REC_SYS_TIME,
  GN_REC_TASKNO,
  GN_CHANNEL_CODE,
  GN_REC_RECTYPE,
  GN_TS_EXT_TRAN_CODE,
  GN_TRAN_TYPE,
  GN_REC_STATUS,
  GN_ATM_CARDNUMBER,
  GN_TERMINAL_ID,
  GN_TERMINAL_RECNO,
  GN_TS_TELLER_ID,
  GN_TS_TRAN_SERNO,
  GN_TS_PROC_DATE,
  GN_EIB_TRANID,
  GN_EIB_TERMID,
  MIT_MQ_RQUID,
  MIT_ACCT1_ACCTNUM,
  MIT_ACCT2_ACCTNUM,
  MIT_DRCR_IND,
  MIT_FINANCIAL_TYPE,
  MIT_CHEQUE_NUMBER,
  MIT_CHEQUE_CLRG_TYPE,
  MIT_DR_TRAN_AMOUNT,
  MIT_DR_TRAN_CCY,
  MIT_CR_TRAN_AMOUNT,
  MIT_CR_TRAN_CCY,
  MIT_FEE_PROCESS_IND,
  MIT_FEE_TYPE_01,
  MIT_FEE_AMOUNT_01,
  MIT_FEE_TYPE_02,
  MIT_FEE_AMOUNT_02,
  MIT_FEE_TYPE_03,
  MIT_FEE_AMOUNT_03,
  MIT_FEE_TYPE_04,
  MIT_FEE_AMOUNT_04,
  MIT_FEE_TYPE_05,
  MIT_FEE_AMOUNT_05,
  MIT_FEE_TYPE_06,
  MIT_FEE_AMOUNT_06,
  MIT_FEE_TYPE_07,
  MIT_FEE_AMOUNT_07,
  MIT_FEE_TYPE_08,
  MIT_FEE_AMOUNT_08,
  MIT_FEE_TYPE_09,
  MIT_FEE_AMOUNT_09,
  MIT_FEE_TYPE_10,
  MIT_FEE_AMOUNT_10,
  START_DT,
  END_DT,
  RECORD_DELETED_FLAG,
  CTL_ID,
  INS_PROC_NAME,
  INS_TXF_BATCHID,
  UPD_PROC_NAME,
  UPD_TXF_BATCHID)
AS SELECT
STGMERGE.EDW_RECORD_NO
,COALESCE(CC.DEFAULT_DATE,to_date('10000103', 'yyyyMMdd')) /*AS D1*/ AS GN_REC_SYS_DATE
,STGMERGE.GN_REC_SYS_TIME
,STGMERGE.GN_REC_TASKNO
,STGMERGE.GN_CHANNEL_CODE
,STGMERGE.GN_REC_RECTYPE
,STGMERGE.GN_TS_EXT_TRAN_CODE
,STGMERGE.GN_TRAN_TYPE
,STGMERGE.GN_REC_STATUS
,STGMERGE.GN_ATM_CARDNUMBER
,STGMERGE.GN_TERMINAL_ID
,STGMERGE.GN_TERMINAL_RECNO
,STGMERGE.GN_TS_TELLER_ID
,STGMERGE.GN_TS_TRAN_SERNO
,STGMERGE.D2 AS GN_TS_PROC_DATE
,STGMERGE.GN_EIB_TRANID
,STGMERGE.GN_EIB_TERMID
,STGMERGE.MIT_MQ_RQUID
,STGMERGE.MIT_ACCT1_ACCTNUM
,STGMERGE.MIT_ACCT2_ACCTNUM
,STGMERGE.MIT_DRCR_IND
,STGMERGE.MIT_FINANCIAL_TYPE
,STGMERGE.MIT_CHEQUE_NUMBER
,STGMERGE.MIT_CHEQUE_CLRG_TYPE
,STGMERGE.MIT_DR_TRAN_AMOUNT 
,STGMERGE.MIT_DR_TRAN_CCY
,STGMERGE.MIT_CR_TRAN_AMOUNT
,STGMERGE.MIT_CR_TRAN_CCY
,STGMERGE.MIT_FEE_PROCESS_IND
,STGMERGE.MIT_FEE_TYPE_01
,STGMERGE.MIT_FEE_AMOUNT_01
,STGMERGE.MIT_FEE_TYPE_02
,STGMERGE.MIT_FEE_AMOUNT_02
,STGMERGE.MIT_FEE_TYPE_03
,STGMERGE.MIT_FEE_AMOUNT_03
,STGMERGE.MIT_FEE_TYPE_04
,STGMERGE.MIT_FEE_AMOUNT_04
,STGMERGE.MIT_FEE_TYPE_05
,STGMERGE.MIT_FEE_AMOUNT_05
,STGMERGE.MIT_FEE_TYPE_06
,STGMERGE.MIT_FEE_AMOUNT_06
,STGMERGE.MIT_FEE_TYPE_07
,STGMERGE.MIT_FEE_AMOUNT_07
,STGMERGE.MIT_FEE_TYPE_08
,STGMERGE.MIT_FEE_AMOUNT_08
,STGMERGE.MIT_FEE_TYPE_09
,STGMERGE.MIT_FEE_AMOUNT_09
,STGMERGE.MIT_FEE_TYPE_10
,STGMERGE.MIT_FEE_AMOUNT_10
,STGMERGE.START_DT
,STGMERGE.END_DT
,STGMERGE.RECORD_DELETED_FLAG
,STGMERGE.CTL_ID
,STGMERGE.INS_PROC_NAME
,STGMERGE.INS_TXF_BATCHID
,STGMERGE.UPD_PROC_NAME
,STGMERGE.UPD_TXF_BATCHID
FROM P1DUTEDW.CHAR_CALENDAR CC
RIGHT OUTER JOIN
(
  SELECT EDW_RECORD_NO
  ,GN_REC_SYS_DATE
  ,GN_REC_SYS_TIME
  ,GN_REC_TASKNO
  ,GN_CHANNEL_CODE
  ,GN_REC_RECTYPE
  ,GN_TS_EXT_TRAN_CODE
  ,GN_TRAN_TYPE
  ,GN_REC_STATUS
  ,GN_ATM_CARDNUMBER
  ,GN_TERMINAL_ID
  ,GN_TERMINAL_RECNO
  ,GN_TS_TELLER_ID
  ,GN_TS_TRAN_SERNO
  ,COALESCE(CDT2.DEFAULT_DATE, to_date('10000103', 'yyyyMMdd')) AS D2
  ,GN_EIB_TRANID
  ,GN_EIB_TERMID
  ,MIT_MQ_RQUID
  ,MIT_ACCT1_ACCTNUM
  ,MIT_ACCT2_ACCTNUM
  ,MIT_DRCR_IND
  ,MIT_FINANCIAL_TYPE
  ,MIT_CHEQUE_NUMBER
  ,MIT_CHEQUE_CLRG_TYPE
  ,MIT_DR_TRAN_AMOUNT
  ,MIT_DR_TRAN_CCY
  ,MIT_CR_TRAN_AMOUNT
  ,MIT_CR_TRAN_CCY
  ,MIT_FEE_PROCESS_IND
  ,MIT_FEE_TYPE_01
  ,MIT_FEE_AMOUNT_01
  ,MIT_FEE_TYPE_02
  ,MIT_FEE_AMOUNT_02
  ,MIT_FEE_TYPE_03
  ,MIT_FEE_AMOUNT_03
  ,MIT_FEE_TYPE_04
  ,MIT_FEE_AMOUNT_04
  ,MIT_FEE_TYPE_05
  ,MIT_FEE_AMOUNT_05
  ,MIT_FEE_TYPE_06
  ,MIT_FEE_AMOUNT_06
  ,MIT_FEE_TYPE_07
  ,MIT_FEE_AMOUNT_07
  ,MIT_FEE_TYPE_08
  ,MIT_FEE_AMOUNT_08
  ,MIT_FEE_TYPE_09
  ,MIT_FEE_AMOUNT_09
  ,MIT_FEE_TYPE_10
  ,MIT_FEE_AMOUNT_10
  ,START_DT
  ,END_DT
  ,RECORD_DELETED_FLAG
  ,CTL_ID
  ,INS_PROC_NAME
  ,INS_TXF_BATCHID
  ,UPD_PROC_NAME
  ,UPD_TXF_BATCHID
  FROM	P1DSGEDW.GN_MTLOG_1_0_T1 AS T1
  LEFT OUTER JOIN P1DUTEDW.CHAR_CALENDAR AS CDT2
  ON     COALESCE(T1.GN_TS_PROC_DATE,'NA') = CDT2.CDT_YYYYMMDD
) STGMERGE
ON COALESCE(STGMERGE.GN_REC_SYS_DATE,'NA') = CC.CDT_YYYYMMDD
