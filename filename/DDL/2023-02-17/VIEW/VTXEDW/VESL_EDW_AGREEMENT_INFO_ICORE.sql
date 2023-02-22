CREATE OR REPLACE VIEW P1VTXEDW.VESL_EDW_AGREEMENT_INFO_ICORE (
  AS_OF_DT,
  ACCOUNT_NUM,
  ACCOUNT_MODIFIER_NUM,
  AGMT_CTL_ID,
  BASE_ACCOUNT_NUM,
  AGMT_LEVEL_CD,
  TR_ACCT_GROUP_ID,
  BANK_CODE,
  ACCOUNT_IND,
  DEAL_IND,
  COMMITMENT_IND,
  ACCT_CURRENT_STATUS_TYPE_CD,
  ACTIVE_IND,
  ACCT_STATUS_REASON_CD,
  ACCOUNT_OPEN_DT,
  ACCOUNT_CLOSE_DT,
  ACCOUNT_PROCESSING_DT,
  ACCOUNT_SIGNED_DT,
  CONTRACT_NAME,
  THAI_CONTRACT_NAME,
  CONTRACT_EXPIRATION_DT,
  ASSET_LIABILITY_CD,
  BALANCE_SHEET_CD,
  STATEMENT_CYCLE_CD,
  CONTRACT_START_DT,
  ACCOUNT_CURRENCY_CD,
  ACCT_PRODUCT_ID,
  ACCT_PRODUCT_2_ID,
  TR_ASSOC_PROD_GRP_ID,
  RC_CODE,
  OC_CODE,
  BRANCH_CODE,
  COMPANY_CD,
  PRIM_CUST_ID,
  PRIM_CUST_ROLE_CD,
  PRIM_PARTY_TYPE_CD,
  JOINT_IND,
  BUSINESS_TYPE_CD,
  SOURCE_BUSINESS_TYPE_CD,
  CUST_TYPE_CD,
  TR_INT_DISC_FLAG,
  TR_CUST_TYPE_CD,
  AGMT_LOCATION_ID,
  BILL_CODE,
  MATURITY_TERM_NUM,
  MATURITY_TIME_PERIOD_CD,
  LAST_ACCT_ACT_DT,
  LAST_CUST_ACT_DT,
  FUND_IND,
  ACCT_SUBTYPE_CD,
  CREDIT_PURPOSE_CD,
  CHARGE_OFF_CD,
  PROJECT_CODE,
  CYCLE_START_DT,
  NEXT_REPRICE_DT,
  CONTRACT_EXTENDED_IND,
  FIRST_PRIN_PAID_DT,
  FIRST_INTEREST_PAID_DT,
  FIRST_PRIN_WITHDRAW_DT,
  ACCOUNT_NUM_DD,
  VIP_IND,
  ORIGINAL_PRIM_CUST_ID,
  FIRST_OC_CODE)
COMMENT ' ############################################################
 MODELER NAME: NATTHARUT S.
 DEVELOP BY: KARITTHA S.
 VERSION MAPPING: EDW_AGREEMENT_INFO_ESL_SPEC_V9.9.ods
 CREATE DATE: 2021-12-15
 DESCRIPTION :  SR-1266 Dbank Project MVP1 interface with EDW
 ############################################################
 

   
'
AS SELECT  
 TO_DATE(LNA_LOAN.BUSINESSDATE ,'yyyy-MM-dd') AS AS_OF_DT
 ,CAST(LNA_LOAN.LOAN_NO AS VARCHAR(100)) AS ACCOUNT_NUM
/*  ,CAST('IC' || Substr(LNA_LOAN.ORG_ID,3,2) AS VARCHAR(20)) AS ACCOUNT_MODIFIER_NUM << mig orig*/
  ,CAST('IC' || SUBSTR(LNA_LOAN.ORG_ID,3,2) AS VARCHAR(20)) AS ACCOUNT_MODIFIER_NUM
 ,CAST(LNA_LOAN.CTL_ID AS CHAR(10)) AS AGMT_CTL_ID
 ,CAST(LNA_LOAN.LIMIT_CODE AS VARCHAR(100)) AS BASE_ACCOUNT_NUM
 ,CAST(6 AS SMALLINT) AS AGMT_LEVEL_CD /*-6 Deal/Bill*/ ---6 Deal/Bill
/*  ,CAST(NULL AS INTEGER) AS TR_ACCT_GROUP_ID << mig orig*/
  ,CAST(NULL AS INT) AS TR_ACCT_GROUP_ID
 ,CAST(SUBSTR(LNA_LOAN.CUST_NO,3,2) AS CHAR(2)) AS BANK_CODE
 ,CAST('YES' AS CHAR(3))  AS ACCOUNT_IND
 ,CAST('YES' AS CHAR(3))  AS DEAL_IND
 ,CAST('YES' AS CHAR(3))  AS COMMITMENT_IND
 ,M00750.EDW_CODE AS ACCT_CURRENT_STATUS_TYPE_CD
 ,REF_M00750.SHORT_DESCRIPTION AS ACTIVE_IND
 ,CAST(M00700.EDW_CODE AS SMALLINT) AS ACCT_STATUS_REASON_CD
 ,TO_DATE(LNA_LOAN.LOAN_CREATION_DATE ,'yyyy-MM-dd') AS ACCOUNT_OPEN_DT
 ,TO_DATE(LNA_LOAN.CLOSE_ACCT_DATE    ,'yyyy-MM-dd') AS ACCOUNT_CLOSE_DT
 ,TO_DATE(LNA_LOAN.LOAN_CREATION_DATE ,'yyyy-MM-dd') AS ACCOUNT_PROCESSING_DT
 ,TO_DATE(LNA_LOAN.LOAN_CREATION_DATE ,'yyyy-MM-dd') AS ACCOUNT_SIGNED_DT
 ,CAST(PERSON_BASE.CUST_NAME  AS VARCHAR(120)) AS CONTRACT_NAME
 ,CAST(PERSON_BASE.CUST_FOREIGN_NAME AS VARCHAR(120)) AS THAI_CONTRACT_NAME
 ,TO_DATE(LNA_LOAN.MATURITY_DATE ,'yyyy-MM-dd') AS CONTRACT_EXPIRATION_DT
 ,CAST(1 AS SMALLINT)  AS ASSET_LIABILITY_CD    /*-1 Asset*/ ---1 Asset
 ,CAST(NULL AS SMALLINT) AS BALANCE_SHEET_CD
 ,CAST(NULL AS SMALLINT)  AS STATEMENT_CYCLE_CD
 ,TO_DATE(LNA_LOAN.LOAN_CREATION_DATE ,'yyyy-MM-dd' )AS CONTRACT_START_DT  
 ,M09700.EDW_CODE AS ACCOUNT_CURRENCY_CD
 ,BK_PRODUCT.EDW_KEY AS ACCT_PRODUCT_ID
/*  ,CAST(NULL AS INTEGER) AS ACCT_PRODUCT_2_ID << mig orig*/
  ,CAST(NULL AS INT) AS ACCT_PRODUCT_2_ID
/*  ,CAST(NULL AS INTEGER) AS TR_ASSOC_PROD_GRP_ID << mig orig*/
  ,CAST(NULL AS INT) AS TR_ASSOC_PROD_GRP_ID
 ,CAST('' AS CHAR(10)) AS RC_CODE
 ,CAST(PERSON_BASE.OC_CODE AS CHAR(10)) AS OC_CODE  
 ,CAST(NULL AS CHAR(10)) AS BRANCH_CODE
 ,CAST(SUBSTR(LNA_LOAN.CUST_NO,3,2) AS SMALLINT) AS COMPANY_CD
 ,ACCPAR1.PARTY_ID AS PRIM_CUST_ID
    ,ACCPAR1.ACCOUNT_PARTY_ROLE_CD AS PRIM_CUST_ROLE_CD
 ,M24700.EDW_CODE AS PRIM_PARTY_TYPE_CD
 ,'N' AS JOINT_IND
 ,CAST(NULL AS SMALLINT)  AS BUSINESS_TYPE_CD
 ,CAST(NULL AS VARCHAR(50))  AS SOURCE_BUSINESS_TYPE_CD
 ,CAST(NULL AS SMALLINT) AS CUST_TYPE_CD  
 ,CAST(NULL AS SMALLINT) AS TR_INT_DISC_FLAG
 ,CAST(NULL AS SMALLINT) AS TR_CUST_TYPE_CD
 ,NULL as AGMT_LOCATION_ID
 ,CAST(NULL AS VARCHAR(250)) AS BILL_CODE
/*  ,Substr(Trim(LNA_LOAN.LOAN_TENOR), 1, Length(Trim(LNA_LOAN.LOAN_TENOR))-1)  << mig orig*/
  ,SUBSTR(Trim(LNA_LOAN.LOAN_TENOR), 1, Length(Trim(LNA_LOAN.LOAN_TENOR))-1) AS MATURITY_TERM_NUM
 ,M33700.EDW_CODE AS MATURITY_TIME_PERIOD_CD 
 ,CASE WHEN GRP_LAST_TRAN.LAST_TRXN_DATE IS NOT NULL
   THEN GRP_LAST_TRAN.LAST_TRXN_DATE
   ELSE PREV_ESL_AGMT.LAST_ACCT_ACT_DT END AS LAST_ACCT_ACT_DT
 ,TO_DATE(NULL ,'yyyy-MM-dd') AS LAST_CUST_ACT_DT
 ,'F' AS FUND_IND
 ,CAST(NULL AS SMALLINT)  AS ACCT_SUBTYPE_CD 
    ,CAST(NULL AS SMALLINT)  as CREDIT_PURPOSE_CD
 ,CAST(NULL AS SMALLINT) AS CHARGE_OFF_CD 
 ,CAST(NULL AS SMALLINT)  as PROJECT_CODE
 ,TO_DATE(NULL ,'yyyy-MM-dd') AS CYCLE_START_DT 
 ,TO_DATE(NULL ,'yyyy-MM-dd')  AS NEXT_REPRICE_DT
 ,CAST(CASE WHEN LNA_MATURITY.LOAN_EXTEND_IND = 'Y'   /*Yes*/ --Yes
  THEN 1 ELSE 0
  END AS SMALLINT) AS CONTRACT_EXTENDED_IND
 ,TO_DATE(LNA_SCHEDULE.DUE_DATE ,'yyyy-MM-dd' )AS FIRST_PRIN_PAID_DT 
 ,TO_DATE(LNA_SCHEDULE.DUE_DATE ,'yyyy-MM-dd') AS FIRST_INTEREST_PAID_DT 
 ,TO_DATE(LNA_LOAN.LOAN_CREATION_DATE ,'yyyy-MM-dd')AS FIRST_PRIN_WITHDRAW_DT 
 ,CAST(NULL AS VARCHAR(100))  as ACCOUNT_NUM_DD
 --,CAST(NULL AS CHAR(1))  as VIP_IND
/*,CAST(NULL AS CHAR(1))  as VIP_IND*/
 ,CASE WHEN PARPARGRP.PARTY_GROUP_ID IN (1,2,3,4,5,6,7,8,9)
   THEN 'Y' ELSE 'N' END AS VIP_IND
/*  ,CAST(NULL AS INTEGER) AS ORIGINAL_PRIM_CUST_ID << mig orig*/
  ,CAST(NULL AS INT) AS ORIGINAL_PRIM_CUST_ID
 ,CAST(FIRST_OC.OC_CODE AS CHAR(10))  as FIRST_OC_CODE
          
FROM  
( SELECT
 LNA_LOAN.LOAN_NO
 ,LNA_LOAN.ORG_ID
 ,LNA_LOAN.CTL_ID
 ,LNA_LOAN.LIMIT_CODE
 ,LNA_LOAN.CUST_NO
 ,LNA_LOAN.LOAN_CREATION_DATE
 ,LNA_LOAN.CLOSE_ACCT_DATE 
 ,LNA_LOAN.MATURITY_DATE 
 ,LNA_LOAN.START_INST_DATE
 ,LNA_LOAN.LOAN_STATUS
 ,LNA_LOAN.CCY_CODE
 ,LNA_LOAN.PROD_ID
 ,'IC' || SUBSTR(LNA_LOAN.ORG_ID,3,2) AS ACCT_MODIFIER_NUM
 ,BD.BUSINESSDATE
 ,LNA_LOAN.LOAN_TENOR
 FROM P1VTTEDW.AGMT_ICORE_LNA_LOAN AS LNA_LOAN

INNER JOIN P1VTPEDW.VESL_BUSINESSDATE_D AS BD
ON BD.BUSINESSDATE BETWEEN LNA_LOAN.START_DT AND LNA_LOAN.END_DT
AND LNA_LOAN.RECORD_DELETED_FLAG = 0
AND LNA_LOAN.CTL_ID = '134'  /*-ICORE    */ ---ICORE    

) AS LNA_LOAN


LEFT JOIN 
(
 SELECT LNA_BASIC.ORG_ID,
 LNA_BASIC.LOAN_NO,
 LNA_BASIC.LOAN_PURPOSE
 FROM P1VTTEDW.AGMT_ICORE_LNA_BASIC AS LNA_BASIC
 INNER JOIN P1VTPEDW.VESL_BUSINESSDATE_D AS BD
 ON BD.BUSINESSDATE BETWEEN LNA_BASIC.START_DT AND LNA_BASIC.END_DT
 AND LNA_BASIC.RECORD_DELETED_FLAG = 0 
 AND LNA_BASIC.CTL_ID = '134'  /*-ICORE */ ---ICORE 
) AS LNA_BASIC
ON LNA_BASIC.ORG_ID = LNA_LOAN.ORG_ID
AND LNA_BASIC.LOAN_NO = LNA_LOAN.LOAN_NO

LEFT JOIN P1VUTEDW.M00700_ACCT_STS_REASN AS M00700
ON M00700.SOURCE_KEY = LNA_BASIC.LOAN_PURPOSE
AND M00700.SRC_CTL_ID = '134'  /*--ICORE*/ ----ICORE
AND M00700.SOURCE_ID = 1

LEFT JOIN 
(
 SELECT ORG_ID,
LOAN_NO,
DUE_DATE
 FROM (
    SELECT  LNA_SCHEDULE.ORG_ID,
    LNA_SCHEDULE.LOAN_NO,
    LNA_SCHEDULE.DUE_DATE
     
    ,Rank() Over (PARTITION BY LNA_SCHEDULE.ORG_ID, LNA_SCHEDULE.LOAN_NO ORDER BY  LNA_SCHEDULE.DUE_DATE ASC)  AS R 
    FROM P1VTTEDW.AGMT_ICORE_LNA_REPAY_SCHEDULE AS  LNA_SCHEDULE
    INNER JOIN P1VTPEDW.VESL_BUSINESSDATE_D AS BD
    ON LNA_SCHEDULE.CTL_ID ='134'  /*-ICORE*/ ---ICORE
    AND BD.BUSINESSDATE BETWEEN LNA_SCHEDULE.START_DT AND LNA_SCHEDULE.END_DT AND LNA_SCHEDULE.RECORD_DELETED_FLAG = 0
    AND LNA_SCHEDULE.PERIOD_NO = '1'    /*FIRST DUE*/ --FIRST DUE
 ) AS SRC
    WHERE SRC.R = 1 
    
 
) AS LNA_SCHEDULE
ON LNA_SCHEDULE.ORG_ID = LNA_LOAN.ORG_ID
AND LNA_SCHEDULE.LOAN_NO = LNA_LOAN.LOAN_NO

LEFT JOIN 
(
 SELECT PERSON_BASE.ORG_ID,
 PERSON_BASE.CUST_NO,
 PERSON_BASE.CUST_NAME,
 PERSON_BASE.CUST_FOREIGN_NAME,
 PERSON_BASE.OC_CODE,
/*  Substr(Trim(PERSON_BASE.CUST_NO),1,4) ||'R'|| Substr(Trim(PERSON_BASE.CUST_NO),21,10) AS PERS_KEY, << mig orig*/
  SUBSTR(Trim(PERSON_BASE.CUST_NO),1,4) ||'R'|| SUBSTR(Trim(PERSON_BASE.CUST_NO),21,10) AS PERS_KEY,
 PERSON_BASE.CUST_TYPE_CODE
 FROM P1VTTEDW.PARTY_ICORE_CFB_PERSON_BASE AS  PERSON_BASE
 
 INNER JOIN P1VTPEDW.VESL_BUSINESSDATE_D AS BD
 ON PERSON_BASE.CTL_ID ='134'  /*-ICORE*/ ---ICORE
 AND BD.BUSINESSDATE BETWEEN PERSON_BASE.START_DT AND PERSON_BASE.END_DT
 AND PERSON_BASE.RECORD_DELETED_FLAG = 0 
) AS PERSON_BASE
ON PERSON_BASE.ORG_ID = LNA_LOAN.ORG_ID
AND PERSON_BASE.CUST_NO = LNA_LOAN.CUST_NO

LEFT JOIN P1VUTEDW.BKEY_PARTY AS BK_PARTY 
ON BK_PARTY.SOURCE_KEY = PERSON_BASE.PERS_KEY

LEFT JOIN P1VUTEDW.M24700_PARTY_TYPE AS M24700
ON M24700.SOURCE_KEY = PERSON_BASE.CUST_TYPE_CODE
AND M24700.SRC_CTL_ID = '134'  /*--ICORE*/ ----ICORE
AND M24700.SOURCE_ID = 1

LEFT  JOIN 
(
 SELECT LNA_MATURITY.ORG_ID,
 LNA_MATURITY.LOAN_NO,
 LNA_MATURITY.LOAN_EXTEND_IND 
 FROM P1VTTEDW.AGMT_ICORE_LNA_MATURITY AS LNA_MATURITY
 INNER JOIN P1VTPEDW.VESL_BUSINESSDATE_D AS BD
 ON LNA_MATURITY.CTL_ID ='134'  /*-ICORE*/ ---ICORE
 AND BD.BUSINESSDATE BETWEEN LNA_MATURITY.START_DT AND LNA_MATURITY.END_DT
 AND LNA_MATURITY.RECORD_DELETED_FLAG = 0 
) AS LNA_MATURITY
ON LNA_MATURITY.ORG_ID = LNA_LOAN.ORG_ID
AND LNA_MATURITY.LOAN_NO = LNA_LOAN.LOAN_NO

LEFT JOIN P1VUTEDW.M00750_ACCT_STS_TYPE  AS M00750
ON M00750.SOURCE_KEY = LNA_LOAN.LOAN_STATUS
AND M00750.SRC_CTL_ID = '134'  /*--ICORE*/ ----ICORE
AND M00750.SOURCE_ID = 1

LEFT JOIN P1VUTEDW.REFERENCE_DESCRIPTION AS REF_M00750
ON REF_M00750.EDW_CODE = M00750.EDW_CODE
AND REF_M00750.CODE_SET_ID = 'CS000750'
AND REF_M00750.CODE_ID = 7
AND REF_M00750.LANGUAGE_ID = 3

LEFT JOIN P1VUTEDW.M09700_CRNCY AS M09700
ON M09700.SOURCE_KEY = LNA_LOAN.CCY_CODE
AND M09700.SRC_CTL_ID = '134'  /*--ICORE*/ ----ICORE
AND M09700.SOURCE_ID = 1

LEFT JOIN P1VUTEDW.BKEY_PRODUCT  AS BK_PRODUCT  
ON BK_PRODUCT.SOURCE_KEY = LNA_LOAN.PROD_ID

LEFT JOIN (
 SELECT GRP_EVENT.ORG_ID
 ,GRP_EVENT.LOAN_NO
 ,MAX(GRP_EVENT.TRXN_DATE) AS LAST_TRXN_DATE
 
 FROM (

 SELECT rtrim(LNS_ACCRUAL.ORG_ID) AS ORG_ID
    ,LNS_ACCRUAL.LOAN_NO
    ,LNS_ACCRUAL.START_DT AS TRXN_DATE 
 FROM  P1VTTEDW.EVENT_ICORE_LNS_ACCRUAL   AS LNS_ACCRUAL
 INNER JOIN P1VTPEDW.VESL_BUSINESSDATE_D AS BD
 ON LNS_ACCRUAL.START_DT <= BD.BUSINESSDATE
  -- /* UNION ALL 
 
/*  UNION ALL 
  SELECT LNS_BAL_CH.ORG_ID
     ,LNS_BAL_CH.LOAN_NO
     ,LNS_BAL_CH.TRXN_DATE 
  FROM P1VTTEDW.EVENT_ICORE_LNS_BALANCE_CHANGE AS LNS_BAL_CH
  
 */
  UNION ALL 
 SELECT rtrim(LNH_ACCRU_BAK.ORG_ID) AS ORG_ID
    ,LNH_ACCRU_BAK.LOAN_NO
    ,LNH_ACCRU_BAK.START_DT AS TRXN_DATE 
 FROM  P1VTTEDW.EVENT_ICORE_LNH_ACCRUAL_BAK   AS LNH_ACCRU_BAK
 INNER JOIN P1VTPEDW.VESL_BUSINESSDATE_D AS BD
 ON LNH_ACCRU_BAK.START_DT <= BD.BUSINESSDATE

 UNION ALL 
 SELECT rtrim(LNH_ACCRUAL.ORG_ID) AS ORG_ID
    ,LNH_ACCRUAL.LOAN_NO
    ,LNH_ACCRUAL.START_DT AS TRXN_DATE 
 FROM  P1VTTEDW.EVENT_ICORE_LNH_ACCRUAL  AS LNH_ACCRUAL
 INNER JOIN P1VTPEDW.VESL_BUSINESSDATE_D AS BD
 ON LNH_ACCRUAL.START_DT <= BD.BUSINESSDATE

  -- /*UNION ALL 
 
/* UNION ALL 
  SELECT LNB_DRAWDOWN.ORG_ID
     ,LNB_DRAWDOWN.LOAN_NO
     ,LNB_DRAWDOWN.TRXN_DATE 
  FROM  P1VTTEDW.EVENT_ICORE_LNB_DRAWDOWN AS LNB_DRAWDOWN
 
  UNION ALL 
  SELECT LNB_REPAYMENT.ORG_ID
     ,LNB_REPAYMENT.LOAN_NO
     ,LNB_REPAYMENT.TRXN_DATE 
  FROM  P1VTTEDW.EVENT_ICORE_LNB_REPAYMENT AS LNB_REPAYMENT
  
  UNION ALL 
  SELECT LNB_RENEW.ORG_ID
     ,LNB_RENEW.LOAN_NO
     ,LNB_RENEW.TRXN_DATE 
  FROM  P1VTTEDW.EVENT_ICORE_LNB_RENEW AS LNB_RENEW
  
 */
  UNION ALL 
 SELECT rtrim(LNB_TRANSFER.ORG_ID) AS ORG_ID
    ,LNB_TRANSFER.LOAN_NO
    ,TO_DATE(LNB_TRANSFER.TRXN_DATE  ,'yyyy-MM-dd' )
 FROM  P1VTTEDW.EVENT_ICORE_LNB_TRANSFER AS LNB_TRANSFER
 INNER JOIN P1VTPEDW.VESL_BUSINESSDATE_D AS BD
 ON LNB_TRANSFER.START_DT <= BD.BUSINESSDATE
 
  -- /*UNION ALL 
 
/* UNION ALL 
  SELECT LNB_WROFF.ORG_ID
     ,LNB_WROFF.LOAN_NO
     ,TO_DATE(LNB_WROFF.TRXN_DATE ,'yyyy-MM-dd' ) 
  FROM  P1VTTEDW.EVENT_ICORE_LNB_WRITE_OFF AS LNB_WROFF
 
  UNION ALL 
  SELECT LNB_WROFF_REPAY.ORG_ID
     ,LNB_WROFF_REPAY.LOAN_NO
     ,LNB_WROFF_REPAY.TRXN_DATE 
  FROM  P1VTTEDW.EVENT_ICORE_LNB_WRITEOFF_REPAYMENT AS LNB_WROFF_REPAY
  
 */
  UNION ALL 
 SELECT rtrim(LNB_ACCRUAL.ORG_ID) AS ORG_ID
    ,LNB_ACCRUAL.LOAN_NO
    ,LNB_ACCRUAL.TRXN_DATE 
 FROM  P1VTTEDW.EVENT_ICORE_LNB_ACCRUAL AS LNB_ACCRUAL
 INNER JOIN P1VTPEDW.VESL_BUSINESSDATE_D AS BD
 ON LNB_ACCRUAL.START_DT <= BD.BUSINESSDATE
 
  -- /* UNION ALL 
 
/*  UNION ALL 
  SELECT LNB_PROVISION.ORG_ID
     ,LNB_PROVISION.LOAN_NO
     ,LNB_PROVISION.PROVISION_GL_DATE AS TRXN_DATE
  FROM  P1VTTEDW.EVENT_ICORE_LNB_PROVISION AS LNB_PROVISION
  UNION ALL 
  SELECT LNB_INTS_ADJUST.ORG_ID
     ,LNB_INTS_ADJUST.LOAN_NO
     ,LNB_INTS_ADJUST.TRXN_DATE 
  FROM  P1VTTEDW.EVENT_ICORE_LNB_INTEREST_ADJUST AS LNB_INTS_ADJUST
  
 */
  UNION ALL 
 SELECT rtrim(LNB_BAL.ORG_ID) AS ORG_ID
    ,LNB_BAL.LOAN_NO
    ,LNB_BAL.TRXN_DATE 
 FROM  P1VTTEDW.EVENT_ICORE_LNB_BALANCE AS LNB_BAL
 INNER JOIN P1VTPEDW.VESL_BUSINESSDATE_D AS BD
 ON LNB_BAL.START_DT <= BD.BUSINESSDATE

 ) AS GRP_EVENT
 GROUP BY 1,2 
) AS GRP_LAST_TRAN
ON  GRP_LAST_TRAN.ORG_ID = LNA_LOAN.ORG_ID
AND GRP_LAST_TRAN.LOAN_NO =  LNA_LOAN.LOAN_NO


LEFT JOIN (
 SELECT PREV_ESL_AGMT.ACCOUNT_NUM
  ,PREV_ESL_AGMT.ACCOUNT_MODIFIER_NUM
  ,PREV_ESL_AGMT.LAST_ACCT_ACT_DT
 FROM P1VTTEDW.EDW_AGREEMENT_INFO  AS PREV_ESL_AGMT
 INNER JOIN P1VTPEDW.VESL_BUSINESSDATE_D AS BD
 ON PREV_ESL_AGMT.CTL_ID ='134'  /*-ICORE*/ ---ICORE
 AND PREV_ESL_AGMT.AS_OF_DT = BD.BUSINESSDATE - 1
 AND PREV_ESL_AGMT.AGMT_LEVEL_CD = 6
) AS PREV_ESL_AGMT
ON PREV_ESL_AGMT.ACCOUNT_NUM = LNA_LOAN.LOAN_NO
AND PREV_ESL_AGMT.ACCOUNT_MODIFIER_NUM = LNA_LOAN.ACCT_MODIFIER_NUM


LEFT OUTER JOIN (
        SELECT AP.*
        FROM    P1VTTEDW.ACCOUNT_PARTY AS AP
        INNER JOIN P1VTPEDW.VESL_BUSINESSDATE_D AS BD
        ON  BD.BUSINESSDATE BETWEEN AP.START_DT AND AP.END_DT
        AND       AP.RECORD_DELETED_FLAG = 0
        AND       AP.CTL_ID = '001'
        
        INNER JOIN P1VTTEDW.PARAM_ACCOUNT_PARTY_ROLE AS PARMPARTYROLE
        ON  AP.ACCOUNT_PARTY_ROLE_CD = PARMPARTYROLE.ACCOUNT_PARTY_ROLE_CD
        AND       PARMPARTYROLE.ACCOUNT_PARTY_GROUP_CD = 1
        AND       BD.BUSINESSDATE BETWEEN PARMPARTYROLE.START_DT AND PARMPARTYROLE.END_DT
        AND       PARMPARTYROLE.RECORD_DELETED_FLAG = 0
) AS ACCPAR1
ON LNA_LOAN.LIMIT_CODE = ACCPAR1.ACCOUNT_NUM
/* AND 'IC' || Substr(Trim(LNA_LOAN.ORG_ID),3,2) = ACCPAR1.ACCOUNT_MODIFIER_NUM << mig orig*/
 AND 'IC' || SUBSTR(Trim(LNA_LOAN.ORG_ID),3,2) = ACCPAR1.ACCOUNT_MODIFIER_NUM

LEFT JOIN P1VUTEDW.M33700_TIME_PERD AS M33700
/* ON M33700.SOURCE_KEY = Substr(Trim(LNA_LOAN.LOAN_TENOR), Length(Trim(LNA_LOAN.LOAN_TENOR)))  << mig orig*/
 ON M33700.SOURCE_KEY = SUBSTR(Trim(LNA_LOAN.LOAN_TENOR), Length(Trim(LNA_LOAN.LOAN_TENOR))) 
AND M33700.SRC_CTL_ID = '134'  /*--ICORE*/ ----ICORE
AND M33700.SOURCE_ID = 1


LEFT JOIN (
 SELECT PARTY_GROUP_ID,PARTY_ID 
 FROM P1VTTEDW.PARTY_PARTY_GROUP AS  PARPARGRP
 INNER JOIN P1VTPEDW.VESL_BUSINESSDATE_D AS BD
 ON  BD.BUSINESSDATE BETWEEN PARPARGRP.START_DT AND PARPARGRP.END_DT
 AND PARPARGRP.RECORD_DELETED_FLAG = 0
 AND PARPARGRP.CTL_ID = '001'  /*-RM*/ ---RM
) AS PARPARGRP
ON PARPARGRP.Party_Id = ACCPAR1.Party_Id


LEFT JOIN (
 SELECT OC_CODE,
ORG_ID,
CUST_NO
 FROM (
    SELECT OC_CODE,rtrim(ORG_ID) AS ORG_ID,CUST_NO                       
  
    ,Rank() Over (PARTITION BY rtrim(ORG_ID), CUST_NO ORDER BY  START_DT ASC)  AS R 
    FROM P1VTTEDW.PARTY_ICORE_CFB_PERSON_BASE  AS FIRST_OC
 WHERE  COALESCE(OC_CODE,'') <> ''
 AND FIRST_OC.RECORD_DELETED_FLAG = 0
 AND FIRST_OC.CTL_ID = '134'  /*-ICORE*/ ---ICORE
 ) AS SRC
    WHERE SRC.R = 1 
    
) AS FIRST_OC
ON FIRST_OC.CUST_NO =LNA_LOAN.CUST_NO
AND FIRST_OC.ORG_ID = LNA_LOAN.ORG_ID

 -------------------------------------------------------------------------------------------------------Deal Level--------------------------------------------------------------------------------
/*-----------------------------------------------------------------------------------------------------Deal Level--------------------------------------------------------------------------------*/
UNION ALL

SELECT  
 TO_DATE(BD.BUSINESSDATE ,'yyyy-MM-dd') AS AS_OF_DT
 ,CAST(CLA_ACCT.LIMIT_CODE AS VARCHAR(100)) AS ACCOUNT_NUM
 ,CAST('IC' || SUBSTR(CLA_ACCT.ORG_ID,3,2)  AS VARCHAR(20)) AS ACCOUNT_MODIFIER_NUM
 ,CAST(CLA_ACCT.CTL_ID AS CHAR(10)) AS AGMT_CTL_ID
 ,CAST(CLA_ACCT.LIMIT_CODE AS VARCHAR(100)) AS BASE_ACCOUNT_NUM
 ,CAST(2 AS SMALLINT) AS AGMT_LEVEL_CD /*- 2 Ac with Bill*/ --- 2 Ac with Bill
/*  ,CAST(NULL AS INTEGER) AS TR_ACCT_GROUP_ID << mig orig*/
  ,CAST(NULL AS INT) AS TR_ACCT_GROUP_ID
 ,CAST(SUBSTR(CLA_ACCT.CUST_NO,3,2) AS CHAR(2))AS BANK_CODE
 ,CAST('YES' AS CHAR(3))  AS ACCOUNT_IND
 ,CAST('YES' AS CHAR(3))  AS DEAL_IND
 ,CAST('YES' AS CHAR(3))  AS COMMITMENT_IND
 ,M00750.EDW_CODE AS ACCT_CURRENT_STATUS_TYPE_CD
 ,REF_M00750.SHORT_DESCRIPTION AS ACTIVE_IND
 ,CAST(NULL AS SMALLINT) AS ACCT_STATUS_REASON_CD
 ,TO_DATE(CLA_ACCT.OPEN_DATE ,'yyyy-MM-dd') AS ACCOUNT_OPEN_DT
 ,TO_DATE(CLA_ACCT.CLOSE_DATE ,'yyyy-MM-dd') AS ACCOUNT_CLOSE_DT
 ,TO_DATE(CLA_ACCT.EFFECT_DATE ,'yyyy-MM-dd') AS ACCOUNT_PROCESSING_DT
 ,TO_DATE(CLA_ACCT.EFFECT_DATE ,'yyyy-MM-dd') AS ACCOUNT_SIGNED_DT
 ,CAST(PERSON_BASE.CUST_NAME         AS VARCHAR(120))  AS CONTRACT_NAME
 ,CAST(PERSON_BASE.CUST_FOREIGN_NAME    AS VARCHAR(120)) AS THAI_CONTRACT_NAME
 ,TO_DATE(CLA_ACCT.EXPIRY_DATE ,'yyyy-MM-dd') AS CONTRACT_EXPIRATION_DT
 ,CAST(1 AS SMALLINT)  AS ASSET_LIABILITY_CD   /*-1 Asset*/ ---1 Asset
 ,CAST(NULL AS SMALLINT) AS BALANCE_SHEET_CD
 ,CAST(NULL AS SMALLINT)  AS STATEMENT_CYCLE_CD
 ,TO_DATE(CLA_ACCT.EFFECT_DATE ,'yyyy-MM-dd') AS CONTRACT_START_DT 
 ,M09700.EDW_CODE AS ACCOUNT_CURRENCY_CD
 ,BK_PRODUCT.EDW_KEY AS ACCT_PRODUCT_ID
/*  ,CAST(NULL AS INTEGER) AS ACCT_PRODUCT_2_ID << mig orig*/
  ,CAST(NULL AS INT) AS ACCT_PRODUCT_2_ID
/*  ,CAST(NULL AS INTEGER) AS TR_ASSOC_PROD_GRP_ID << mig orig*/
  ,CAST(NULL AS INT) AS TR_ASSOC_PROD_GRP_ID
 ,CAST(CLA_ACCT.RC_CODE AS CHAR(10)) AS RC_CODE  
 ,CAST(PERSON_BASE.OC_CODE AS CHAR(10)) AS OC_CODE 
 ,CAST(NULL AS CHAR(10)) AS BRANCH_CODE
 ,CAST(SUBSTR(CLA_ACCT.CUST_NO,3,2) AS SMALLINT) AS COMPANY_CD
    ,ACCPAR1.PARTY_ID AS PRIM_CUST_ID
    ,ACCPAR1.ACCOUNT_PARTY_ROLE_CD AS PRIM_CUST_ROLE_CD
 ,M24700.EDW_CODE AS PRIM_PARTY_TYPE_CD
 ,'N' AS JOINT_IND
 ,CAST(NULL AS SMALLINT)  AS BUSINESS_TYPE_CD
 ,CAST(NULL AS VARCHAR(50))  AS SOURCE_BUSINESS_TYPE_CD
 ,CAST(NULL AS SMALLINT) AS CUST_TYPE_CD 
 ,CAST(NULL AS SMALLINT) AS TR_INT_DISC_FLAG
 ,CAST(NULL AS SMALLINT) AS TR_CUST_TYPE_CD
 ,NULL as AGMT_LOCATION_ID
 ,CAST(NULL AS VARCHAR(250)) AS BILL_CODE
 ,CAST(NULL AS VARCHAR(10)) AS MATURITY_TERM_NUM
 ,CAST(NULL AS SMALLINT) AS MATURITY_TIME_PERIOD_CD 
 ,TO_DATE(NULL ,'yyyy-MM-dd') AS LAST_ACCT_ACT_DT
 ,TO_DATE(NULL ,'yyyy-MM-dd')AS LAST_CUST_ACT_DT
 ,'F' AS FUND_IND
 ,CAST(NULL AS SMALLINT)  AS ACCT_SUBTYPE_CD 
 ,CAST(NULL AS SMALLINT)  AS CREDIT_PURPOSE_CD
 ,CAST(NULL AS SMALLINT) AS CHARGE_OFF_CD 
 ,CAST(NULL AS SMALLINT)  as PROJECT_CODE
 ,TO_DATE( NULL ,'yyyy-MM-dd') AS CYCLE_START_DT
 ,TO_DATE( NULL ,'yyyy-MM-dd') AS NEXT_REPRICE_DT 
 ,CAST( NULL AS SMALLINT)AS CONTRACT_EXTENDED_IND
 ,TO_DATE( NULL ,'yyyy-MM-dd')   AS FIRST_PRIN_PAID_DT 
 ,TO_DATE( NULL ,'yyyy-MM-dd')   AS FIRST_INTEREST_PAID_DT 
 ,TO_DATE( NULL ,'yyyy-MM-dd')   AS FIRST_PRIN_WITHDRAW_DT 
 ,CAST(NULL AS VARCHAR(100))  AS ACCOUNT_NUM_DD
 --,CAST(NULL AS CHAR(1))  as VIP_IND
/*,CAST(NULL AS CHAR(1))  as VIP_IND*/
 ,CASE WHEN PARPARGRP.PARTY_GROUP_ID IN (1,2,3,4,5,6,7,8,9)
 THEN 'Y' ELSE 'N' END AS VIP_IND
/*  ,CAST(NULL AS INTEGER) AS ORIGINAL_PRIM_CUST_ID << mig orig*/
  ,CAST(NULL AS INT) AS ORIGINAL_PRIM_CUST_ID
 ,CAST(FIRST_OC.OC_CODE AS CHAR(10))  as FIRST_OC_CODE
          
FROM  P1VTTEDW.AGMT_ICORE_CLA_ACCOUNT AS CLA_ACCT

INNER JOIN P1VTPEDW.VESL_BUSINESSDATE_D AS BD
ON BD.BUSINESSDATE BETWEEN CLA_ACCT.START_DT AND CLA_ACCT.END_DT
AND CLA_ACCT.RECORD_DELETED_FLAG = 0
AND CLA_ACCT.CTL_ID = '134'  /*-ICORE    */ ---ICORE    


LEFT JOIN P1VUTEDW.M00750_ACCT_STS_TYPE  AS M00750
ON M00750.SOURCE_KEY = CLA_ACCT.LIMIT_STATUS
AND M00750.SRC_CTL_ID = '134'  /*--ICORE*/ ----ICORE
AND M00750.SOURCE_ID = 1

LEFT JOIN P1VUTEDW.REFERENCE_DESCRIPTION AS REF_M00750
ON REF_M00750.EDW_CODE = M00750.EDW_CODE
AND REF_M00750.CODE_SET_ID = 'CS000750'
AND REF_M00750.CODE_ID = 7
AND REF_M00750.LANGUAGE_ID = 3

LEFT JOIN P1VUTEDW.M09700_CRNCY AS M09700
ON M09700.SOURCE_KEY = CLA_ACCT.CCY_CODE
AND M09700.SRC_CTL_ID = '134'  /*--ICORE*/ ----ICORE
AND M09700.SOURCE_ID = 1

LEFT JOIN P1VUTEDW.BKEY_PRODUCT  AS BK_PRODUCT  
ON BK_PRODUCT.SOURCE_KEY = CLA_ACCT.PROD_ID

LEFT JOIN 
(
 SELECT PERSON_BASE.ORG_ID,
 PERSON_BASE.CUST_NO,
 PERSON_BASE.CUST_NAME,
 PERSON_BASE.CUST_FOREIGN_NAME,
 PERSON_BASE.OC_CODE,
/*  Substr(Trim(PERSON_BASE.CUST_NO),1,4) ||'R'|| Substr(Trim(PERSON_BASE.CUST_NO),21,10) AS PERS_KEY, << mig orig*/
  SUBSTR(Trim(PERSON_BASE.CUST_NO),1,4) ||'R'|| SUBSTR(Trim(PERSON_BASE.CUST_NO),21,10) AS PERS_KEY,
 PERSON_BASE.CUST_TYPE_CODE
 FROM P1VTTEDW.PARTY_ICORE_CFB_PERSON_BASE AS  PERSON_BASE
 
 INNER JOIN P1VTPEDW.VESL_BUSINESSDATE_D AS BD
 ON PERSON_BASE.CTL_ID ='134'  /*-ICORE*/ ---ICORE
 AND BD.BUSINESSDATE BETWEEN PERSON_BASE.START_DT AND PERSON_BASE.END_DT
 AND PERSON_BASE.RECORD_DELETED_FLAG = 0 
) AS PERSON_BASE
ON PERSON_BASE.ORG_ID = CLA_ACCT.ORG_ID
AND PERSON_BASE.CUST_NO = CLA_ACCT.CUST_NO

LEFT JOIN P1VUTEDW.BKEY_PARTY AS BK_PARTY 
ON BK_PARTY.SOURCE_KEY = PERSON_BASE.PERS_KEY

LEFT JOIN P1VUTEDW.M24700_PARTY_TYPE AS M24700
ON M24700.SOURCE_KEY = PERSON_BASE.CUST_TYPE_CODE
AND M24700.SRC_CTL_ID = '134'  /*--ICORE*/ ----ICORE
AND M24700.SOURCE_ID = 1

LEFT OUTER JOIN (
        SELECT AP.*
        FROM    P1VTTEDW.ACCOUNT_PARTY AS AP
        INNER JOIN P1VTPEDW.VESL_BUSINESSDATE_D AS BD
        ON  BD.BUSINESSDATE BETWEEN AP.START_DT AND AP.END_DT
        AND       AP.RECORD_DELETED_FLAG = 0
        AND       AP.CTL_ID = '001'
        
        INNER JOIN P1VTTEDW.PARAM_ACCOUNT_PARTY_ROLE AS PARMPARTYROLE
        ON  AP.ACCOUNT_PARTY_ROLE_CD = PARMPARTYROLE.ACCOUNT_PARTY_ROLE_CD
        AND       PARMPARTYROLE.ACCOUNT_PARTY_GROUP_CD = 1
        AND       BD.BUSINESSDATE BETWEEN PARMPARTYROLE.START_DT AND PARMPARTYROLE.END_DT
        AND       PARMPARTYROLE.RECORD_DELETED_FLAG = 0
) AS ACCPAR1
ON CLA_ACCT.LIMIT_CODE = ACCPAR1.ACCOUNT_NUM
/* AND 'IC' || Substr(Trim(CLA_ACCT.ORG_ID),3,2) = ACCPAR1.ACCOUNT_MODIFIER_NUM << mig orig*/
 AND 'IC' || SUBSTR(Trim(CLA_ACCT.ORG_ID),3,2) = ACCPAR1.ACCOUNT_MODIFIER_NUM


LEFT JOIN (
 SELECT PARTY_GROUP_ID,PARTY_ID 
 FROM P1VTTEDW.PARTY_PARTY_GROUP AS  PARPARGRP
 INNER JOIN P1VTPEDW.VESL_BUSINESSDATE_D AS BD
 ON  BD.BUSINESSDATE BETWEEN PARPARGRP.START_DT AND PARPARGRP.END_DT
 AND PARPARGRP.RECORD_DELETED_FLAG = 0
 AND PARPARGRP.CTL_ID = '001'  /*-RM*/ ---RM
) AS PARPARGRP
ON PARPARGRP.Party_Id = ACCPAR1.Party_Id

LEFT JOIN (
 SELECT OC_CODE,
ORG_ID,
CUST_NO
 FROM (
    SELECT OC_CODE,rtrim(ORG_ID) AS ORG_ID,CUST_NO                       
  
    ,Rank() Over (PARTITION BY rtrim(ORG_ID), CUST_NO ORDER BY  START_DT ASC)  AS R 
    FROM P1VTTEDW.PARTY_ICORE_CFB_PERSON_BASE  AS FIRST_OC
 WHERE  COALESCE(OC_CODE,'') <> ''
 AND FIRST_OC.RECORD_DELETED_FLAG = 0
 AND FIRST_OC.CTL_ID = '134'  /*-ICORE*/ ---ICORE
 ) AS SRC
    WHERE SRC.R = 1 
    
) AS FIRST_OC
ON FIRST_OC.CUST_NO =CLA_ACCT.CUST_NO
AND FIRST_OC.ORG_ID = CLA_ACCT.ORG_ID
