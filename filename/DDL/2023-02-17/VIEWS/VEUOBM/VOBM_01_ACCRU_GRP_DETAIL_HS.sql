CREATE OR REPLACE VIEW P1VEUOBM.VOBM_01_ACCRU_GRP_DETAIL_HS (
  AS_OF_DT,
  SAGMNT_ID,
  ITEM_NO,
  ACCRU_TYPE_CD,
  AC_BAL_BEG_RNGE,
  AC_BAL_END_RNGE,
  AC_NEXT_DT,
  AC_RATE)
COMMENT '------------------------------------------------------------------------------

 ############################################################
  DSF SYSTEM: (OBM)
  Modeler name: Tippawan
  Develop BY: xxxx
  Version mapping: V 1-1.1
  CREATE DATE: 10/05/2008
  UPDATE history: 05/06/2008 : MODIFY BY : Ake
   1.) Solve DECIMAL SHOW  .00 
   2.) Modifiy DATE TO ""9999-12-31"" WHEN value IS NULL
  UPDATE history: 06/06/2008 : MODIFY BY : Chaiya
   1.) Change condition AC_NEXT_DT 
   UPDATE history: 12/06/2008 : MODIFY BY : Chaiya
   1.) Change condition field ITEM_NO (ALS)
   2.)  ADD condition FILTER CLOSING DATE ALL SYSTEM  
   UPDATE history: 16/06/2008 : MODIFY BY : Chaiya
   1.) Change condition field AC_NEXT_DT cann""t send space
   UPDATE history: 23/06/2008 : MODIFY BY : Chaiya
   1.) Change condition field AC_NEXT_DT = 365 use NULL
   2.) ADD condition JOIN WITH AGMT_AGMT_CLASS_ASSOC2
       Change  Get DATA FROM NEW TABLE ( use FOR OBM ONLY ---------------------------------
        AGREEMENT --> AGREEMENT_HS 
        ACCOUNT_INTEREST_FEATURE  --> ACCOUNT_INTEREST_FEATURE_HS 
        AGMT_AGMT_CLASS_ASSOC  ---> AGMT_AGMT_CLASS_ASSOC_HS
          
    UPDATE history: 01/04/2009 : MODIFY BY : Chaiya
   1.) Change field FROM FEATURE.Feature_Desc TO FEATURE.Feature_Name
      ############################################################
 
  
'
AS SELECT
  ( CAST(DATE_FORMAT(VOBM_BUSINESSDATE.BUSINESSDATE  , 'yyyy-MM-dd') AS CHAR(10)))  AS AS_OF_DT,
  CAST(AGREEMENT.Base_Account_Num AS CHAR(26)) AS SAGMNT_ID,
 CAST(CASE 
   WHEN  SUBSTR(AGREEMENT.ACCOUNT_MODIFIER_NUM,1,2)  = 'AM' AND       SUBSTR(AGREEMENT.Account_Num,27,1)  = '0'
    THEN     '00' || SUBSTR(AGREEMENT.Account_Num,1,2) || '0' || SUBSTR(AGREEMENT.Account_Num,3,3) ||  SUBSTR(AGREEMENT.Account_Num,9,4) || '0034000000000' ||  SUBSTR(AGREEMENT.Account_Num,13,20)
 
   WHEN  SUBSTR(AGREEMENT.ACCOUNT_MODIFIER_NUM,1,2)  = 'AM' AND       SUBSTR(AGREEMENT.Account_Num,27,1)  = ''
    THEN     SUBSTR(AGREEMENT.Account_Num,1,5) || 
          (CASE  
          /* LQD */
          WHEN SUBSTR(AGREEMENT.Account_Num,6,3) = '470' THEN SUBSTR(AGREEMENT.Account_Num,10,3) || '0099' 
          /* Speedy Loan */
          WHEN SUBSTR(AGREEMENT.Account_Num,6,3) = '473' THEN SUBSTR(AGREEMENT.Account_Num,10,3) ||'0035'
          /* Consumer Loan */
          WHEN SUBSTR(AGREEMENT.Account_Num,6,3) = '478' THEN SUBSTR(AGREEMENT.Account_Num,10,3) ||'0031'
          /* Trade Past Due */
          WHEN SUBSTR(AGREEMENT.Account_Num,6,3) = '479' THEN SUBSTR(AGREEMENT.Account_Num,10,3) ||'0479'
          /* Commercial Loan */
          WHEN SUBSTR(AGREEMENT.Account_Num,6,3) = '496' THEN SUBSTR(AGREEMENT.Account_Num,10,3) ||'0030'
          /* Hire Purchase (SCB) */
          WHEN SUBSTR(AGREEMENT.Account_Num,6,3) = '497' THEN SUBSTR(AGREEMENT.Account_Num,10,3) ||'0497'
          /* Hire Purchase (SCBL) */
          WHEN SUBSTR(AGREEMENT.Account_Num,6,3) = '498' THEN SUBSTR(AGREEMENT.Account_Num,10,3) ||'0498'
          /* P/N product */
          WHEN SUBSTR(AGREEMENT.Account_Num,6,3) = '485' THEN SUBSTR(AGREEMENT.Account_Num,10,3) ||'0032'
          /* CBD product */
          WHEN SUBSTR(AGREEMENT.Account_Num,6,3) = '487' THEN SUBSTR(AGREEMENT.Account_Num,10,3) ||'0034'
          /* Factoring product */
          WHEN SUBSTR(AGREEMENT.Account_Num,6,3) = '489' THEN SUBSTR(AGREEMENT.Account_Num,10,3) ||'0036'
          /* Import Product */
          WHEN SUBSTR(AGREEMENT.Account_Num,6,3) = '491' THEN SUBSTR(AGREEMENT.Account_Num,10,3) ||'0063'
          /* Export product */
          WHEN SUBSTR(AGREEMENT.Account_Num,6,3) = '493' THEN SUBSTR(AGREEMENT.Account_Num,10,3) ||'0064'
          /* L/G product */
          WHEN SUBSTR(AGREEMENT.Account_Num,6,3) = '475' THEN SUBSTR(AGREEMENT.Account_Num,10,3) ||'0060'
          /* AVAL product */
          WHEN SUBSTR(AGREEMENT.Account_Num,6,3) = '481' THEN SUBSTR(AGREEMENT.Account_Num,10,3) ||'0061'
          /* ACCEPT product */
          WHEN SUBSTR(AGREEMENT.Account_Num,6,3) = '483' THEN SUBSTR(AGREEMENT.Account_Num,10,3) ||'0062'
          /* Multi-Product */
          WHEN SUBSTR(AGREEMENT.Account_Num,6,3) = '495' THEN SUBSTR(AGREEMENT.Account_Num,10,3) ||'0088'                  
          ELSE  SUBSTR(AGREEMENT.Account_Num,6,7)   
      END)
    || SUBSTR(AGREEMENT.Account_Num,13,14)
 
   ELSE     AGREEMENT.ACCOUNT_NUM
 END AS CHAR(45))  AS ITEM_NO,
/* CAST(AGREEMENT.Account_Num AS CHAR(45)) AS ITEM_NO, 
*/
  CAST(SUBSTR(ACCOUNT_INTEREST_FEATURE.Tier_Num,1,5) AS CHAR(5)) AS ACCRU_TYPE_CD, /*OBM_BR0000108*/
  CAST(CAST(COALESCE(ACCOUNT_INTEREST_FEATURE.Acct_Interest_Feat_From_Amt, 0) AS DEC(18,2)) AS VARCHAR(20)) AS AC_BAL_BEG_RNGE, -->wrong data type should decimal (15,2)<--
  CAST(CAST(COALESCE(ACCOUNT_INTEREST_FEATURE.Acct_Interest_Feat_To_Amt, 0) AS DEC(18,2)) AS VARCHAR(20)) AS AC_BAL_END_RNGE, -->wrong data type should decimal (15,2)<--
  (CASE
   WHEN TRIM(ACCOUNT_INTEREST_FEATURE.Acct_Interest_Feat_Txt) = '00000000' THEN NULL
    WHEN TRIM(ACCOUNT_INTEREST_FEATURE.Acct_Interest_Feat_Txt) = '365' THEN NULL
    WHEN TRIM(ACCOUNT_INTEREST_FEATURE.Acct_Interest_Feat_Txt) = 'ACT/365' THEN NULL
   ELSE   ( CAST(DATE_FORMAT(TO_DATE(ACCOUNT_INTEREST_FEATURE.Acct_Interest_Feat_Txt ,'yyyyMMdd') , 'yyyy-MM-dd') AS CHAR(10)))
  END) AS AC_NEXT_DT,   /*  check data type with modeler */ 
  CAST(format_number(CAST(COALESCE(ACCOUNT_INTEREST_FEATURE.Acct_Interest_Feat_Final_Rate, 0) AS DEC(12,7)), "#0.0000000") AS VARCHAR(20)) AS AC_RATE
 
 FROM  
  P1VTTEDW.AGREEMENT_HS AS AGREEMENT
 
 INNER JOIN 
  P1VTPOBM.VOBM_BUSINESSDATE_D AS VOBM_BUSINESSDATE
  ON  
  VOBM_BUSINESSDATE.BUSINESSDATE BETWEEN AGREEMENT.START_DT 
  AND  AGREEMENT.END_DT
  AND  AGREEMENT.RECORD_DELETED_FLAG = 0
  AND AGREEMENT.Account_Modifier_Num IN ('AM80','AM81')
/* -->FILTER CLOSING DATE<-- 
*/
  AND (AGREEMENT.Acct_Current_Status_Type_Cd NOT IN (4,122,123) 
   OR (AGREEMENT.Acct_Current_Status_Type_Cd  IN (4,122,123) AND AGREEMENT.ACCOUNT_CLOSE_DT = VOBM_BUSINESSDATE.BUSINESSDATE))
  
 
 INNER JOIN 
  P1VTTEDW.AGMT_AGMT_CLASS_ASSOC_HS AS AGMT_AGMT_CLASS_ASSOC
  ON 
  AGREEMENT.Account_Num = AGMT_AGMT_CLASS_ASSOC.Account_Num
  AND AGREEMENT.Account_Modifier_Num = AGMT_AGMT_CLASS_ASSOC.Account_Modifier_Num
  AND AGMT_AGMT_CLASS_ASSOC.Agreement_Classification_Cd = 16
/* AND AGMT_AGMT_CLASS_ASSOC.Agreement_Class_Value_Cd IN (1,5,6) 
*/
  AND AGMT_AGMT_CLASS_ASSOC.Agreement_Class_Value_Cd IN (1,2,5,6)
  AND VOBM_BUSINESSDATE.BUSINESSDATE BETWEEN AGMT_AGMT_CLASS_ASSOC.START_DT 
  AND AGMT_AGMT_CLASS_ASSOC.END_DT
  AND AGMT_AGMT_CLASS_ASSOC.RECORD_DELETED_FLAG = 0
  AND AGMT_AGMT_CLASS_ASSOC.ACCOUNT_MODIFIER_NUM IN ('AM80','AM81')
  
/* -->Start add condition 20080623 by Chaiya<-- 
*/
   LEFT OUTER JOIN P1VTTEDW.AGMT_AGMT_CLASS_ASSOC_HS AS AGMT_AGMT_CLASS_ASSOC2
   ON AGREEMENT.ACCOUNT_NUM = AGMT_AGMT_CLASS_ASSOC2. ACCOUNT_NUM
   AND AGREEMENT.ACCOUNT_MODIFIER_NUM = AGMT_AGMT_CLASS_ASSOC2. ACCOUNT_MODIFIER_NUM
   AND AGMT_AGMT_CLASS_ASSOC2.Agreement_Classification_Cd = 11
   AND AGMT_AGMT_CLASS_ASSOC2.Agreement_Class_Value_Cd IN (153,192)
   AND AGMT_AGMT_CLASS_ASSOC2.ACCOUNT_MODIFIER_NUM IN ('AM80', 'AM81')
   AND VOBM_BUSINESSDATE.BUSINESSDATE BETWEEN AGMT_AGMT_CLASS_ASSOC2.START_DT 
  AND AGMT_AGMT_CLASS_ASSOC2.END_DT
   AND  AGMT_AGMT_CLASS_ASSOC2.RECORD_DELETED_FLAG = 0 
 
/* -->End condition<--  
  
*/
 INNER JOIN 
  P1VTTEDW.ACCOUNT_INTEREST_FEATURE_HS AS ACCOUNT_INTEREST_FEATURE
  ON 
  AGREEMENT.Account_Num = ACCOUNT_INTEREST_FEATURE.Account_Num
  AND AGREEMENT.Account_Modifier_Num = ACCOUNT_INTEREST_FEATURE.Account_Modifier_Num
  AND VOBM_BUSINESSDATE.BUSINESSDATE BETWEEN ACCOUNT_INTEREST_FEATURE.START_DT 
  AND ACCOUNT_INTEREST_FEATURE.END_DT
  AND ACCOUNT_INTEREST_FEATURE.RECORD_DELETED_FLAG = 0
  AND ACCOUNT_INTEREST_FEATURE.ACCOUNT_MODIFIER_NUM IN ('AM80','AM81')
 
 INNER JOIN 
  P1VTTEDW.FEATURE AS FEATURE
  ON ACCOUNT_INTEREST_FEATURE.Feature_Id = FEATURE.Feature_Id
 
/* AND FEATURE.Feature_Desc = 'Tier Interest Rate'
  -->20090401 change filed from feature_Desc to Feature_Name<--
  
   AND FEATURE.Feature_Desc IN (CASE
           WHEN AGMT_AGMT_CLASS_ASSOC.Agreement_Class_Value_Cd IN (1,5,6) THEN 'Tier Interest Rate'
           WHEN AGMT_AGMT_CLASS_ASSOC.Agreement_Class_Value_Cd = 2 THEN 'Accural basis type'
           END)
  
  
*/
   AND FEATURE.Feature_Name IN (CASE
          WHEN AGMT_AGMT_CLASS_ASSOC.Agreement_Class_Value_Cd IN (1,5,6) THEN 'Tier Interest Rate_'
          WHEN AGMT_AGMT_CLASS_ASSOC.Agreement_Class_Value_Cd = 2 THEN 'Accrual Basis_'
          END)

  AND VOBM_BUSINESSDATE.BUSINESSDATE BETWEEN FEATURE.START_DT 
  AND FEATURE.END_DT
  AND FEATURE.RECORD_DELETED_FLAG = 0
