CREATE OR REPLACE VIEW P1VEUOBM.VOBM_08_LIMIT_INFO_HS (
  AS_OF_DT,
  APPL_CODE,
  SAGMNT_ID,
  LIMIT_NO,
  LIMIT_CURR_CODE,
  LIMIT_SEQ,
  LIMIT_AMT,
  STATUS,
  OPEN_DT,
  MATURITY_DT,
  CLOSE_DT,
  SHARE_ACCT,
  INT_METHOD,
  INT_RATE_TYPE,
  INT_RATE,
  SPREAD_RATE,
  INT_DISC,
  REL_SAGMNT_ID,
  ROOT_SAGMNT,
  FLAG_REVL)
COMMENT ' ############################################################
   DSF SYSTEM: (OBM)
   Modeler name: Tippawan
   Develop BY: xxx
   Version mapping: V 1-1.1
   CREATE DATE: 10/05/2008
   UPDATE history: 26/06/2008 : MODIFY BY : Chaiya
    1.)  Change field LIMIT_NO (TR) constant ""05""  FOR M19950
   UPDATE history: 30/06/2008 : MODIFY BY : Chaiya
    1.)  DON""T SEND TR80,TR81
   UPDATE history: 03/07/2008 : MODIFY BY : Chaiya
    1.)  Change condition field STATUS JOIN WITH REFERENCE_DESCRIPTION
     Change  Get DATA FROM NEW TABLE ( use FOR OBM ONLY ---------------------------------
           AGREEMENT --> AGREEMENT_HS 
              ACCOUNT_INTEREST_FEATURE  --> ACCOUNT_INTEREST_FEATURE_HS 
              AGMT_AGMT_CLASS_ASSOC  ---> AGMT_AGMT_CLASS_ASSOC_HS
       UPDATE history: 01/04/2009 : MODIFY BY : Chaiya
   1.) Change field FROM FEATURE.Feature_Desc TO FEATURE.Feature_Name
   UPDATE HISTORY: 09/04/2009 : MODIFY BY : Chaiya
   1.) Change TABLE ACCOUNT_PRODUCT_HISTORY_HS 
   UPDATE HISTORY: 2010-01-26: MODIFY BY : S40530(TONG)
   1.) FOR UR52060036
   UPDATE HISTORY: 2010-02-08: MODIFY BY : S40530(TONG)
   1.) FOR UR52060036 ADD AGMT_AGMT_CLASS_ASSOC.AGREEMENT_CLASS_VALUE_CD = 4
   ############################################################
 
  
  
 UNION ALL
   
   ------------------------------------------------------------------
   -- TR80  or  TR81 
   ------------------------------------------------------------------
   
   SELECT
   (VOBM_BUSINESSDATE.BUSINESSDATE(FORMAT ""YYYY-MM-DD"") (CHAR(10)))   AS AS_OF_DT,  --CHANGE DATE TYPE
   CASE 
   WHEN ACC_ACC_GRO.ACCT_TO_ACCT_GROUP_RELAT_CD = ""1"" THEN CAST(""TR80"" AS CHAR(4))
   WHEN ACC_ACC_GRO.ACCT_TO_ACCT_GROUP_RELAT_CD = ""2"" THEN CAST(""TR81"" AS CHAR(4))
   END AS APPL_CODE,
   CAST(AGREEMENT.BASE_ACCOUNT_NUM AS CHAR(26)) AS SAGMNT_ID,
   --CAST(SUBSTR(M19950.SOURCE_KEY,6,20) AS CHAR(20)) AS LIMIT_NO,
   CAST(""05"" AS CHAR(20)) AS LIMIT_NO,
   ---CASE  
   --WHEN   M19950.SOURCE_KEY LIKE ""%20_%""  THEN ""20""
   --WHEN   M19950.SOURCE_KEY LIKE ""%13_B%""  THEN ""13""
   ---WHEN   M19950.SOURCE_KEY LIKE ""%8_%""  THEN ""8""
   ----WHEN   M19950.SOURCE_KEY LIKE ""%1_%""  THEN ""1""
   -----END  AS LIMIT_NO, 
   ------REF_CS009700
   ---CAST(M09700.SOURCE_KEY AS CHAR(3)) AS LIMIT_CURR_CODE,
   CAST(REF_CS009700.SHORT_DESCRIPTION  AS CHAR(3)) AS LIMIT_CURR_CODE,
   --CAST(""1"" AS DEC(9,0)) AS LIMIT_SEQ,
   (CASE 
    WHEN CAST(1 AS DECIMAL(9,0)) = 1
                THEN CAST(CAST(1 AS DECIMAL(9,0) FORMAT ""--ZZZZZZ9"") AS VARCHAR(9))
                ELSE TRIM(TRAILING ""0"" FROM CAST(CAST(1 AS DECIMAL(9,0) FORMAT ""--ZZZZZZ9"") AS VARCHAR(9)))
   END) AS LIMIT_SEQ,
   --CAST(ACC_CRE_SUB_LIM.Credit_Sub_Limit_Amt AS DECIMAL(18,2)) AS LIMIT_AMT,
   (CASE 
    WHEN CAST(ACC_CRE_SUB_LIM.Credit_Sub_Limit_Amt AS DECIMAL(18,2)) = ACC_CRE_SUB_LIM.Credit_Sub_Limit_Amt
                THEN CAST(CAST(ACC_CRE_SUB_LIM.Credit_Sub_Limit_Amt AS DECIMAL(18,2) FORMAT ""--ZZZZZZZZZZZZZZZ9.99"") AS VARCHAR(21))
                ELSE TRIM(TRAILING ""0"" FROM CAST(CAST(ACC_CRE_SUB_LIM.Credit_Sub_Limit_Amt AS DECIMAL(18,2) FORMAT ""--ZZZZZZZZZZZZZZZ9.99"") AS VARCHAR(21)))
   END) AS LIMIT_AMT,
   CAST(  CASE   AGREEMENT.Acct_Current_Status_Type_Cd
    WHEN  4 THEN ""02""
    ELSE ""01""
    END AS CHAR(2)) AS STATUS,
   (ACC_CRE_LIM.Credit_Limit_Start_Dttm (FORMAT ""YYYY-MM-DD"") (CHAR(10)))  AS OPEN_DT,   --CHANGE DATE TYPE
   (ACC_CRE_LIM.Credit_Limit_End_Dttm (FORMAT ""YYYY-MM-DD"") (CHAR(10)))  AS MATURITY_DT,  --CHANGE DATE TYPE
   (AGREEMENT.Account_Close_Dt (FORMAT ""YYYY-MM-DD"") (CHAR(10)))  AS CLOSE_DT,  --CHANGE DATE TYPE
   CAST("" "" AS CHAR(26)) AS SHARE_ACCT,
   CAST("" "" AS CHAR(3))  AS INT_METHOD,
   --1 CAST(0 AS CHAR(9)) AS INT_RATE_TYPE,
   ---2 CAST("" "" AS CHAR(9)) AS INT_RATE_TYPE,
   (CASE WHEN CAST(0 AS DECIMAL(12,7)) = 0
                THEN CAST(CAST(0 AS DECIMAL(12,7) FORMAT ""--ZZZZZZZZZ9.9999999"") AS VARCHAR(20))
                ELSE TRIM(TRAILING ""0"" FROM CAST(CAST(0 AS DECIMAL(12,7) FORMAT ""--ZZZZZZZZZ9.9999999"") AS VARCHAR(20)))
   END) AS INT_RATE_TYPE,
   --CAST(0 AS DECIMAL(12,7)) AS INT_RATE,
   (CASE WHEN CAST(0 AS DECIMAL(12,7)) = 0
                THEN CAST(CAST(0 AS DECIMAL(12,7) FORMAT ""--ZZZZZZZZZ9.9999999"") AS VARCHAR(20))
                ELSE TRIM(TRAILING ""0"" FROM CAST(CAST(0 AS DECIMAL(12,7) FORMAT ""--ZZZZZZZZZ9.9999999"") AS VARCHAR(20)))
   END) AS INT_RATE,
   --CAST(0 AS DECIMAL(12,7)) AS SPREAD_RATE,
   (CASE WHEN CAST(0 AS DECIMAL(12,7)) = 0
                THEN CAST(CAST(0 AS DECIMAL(12,7) FORMAT ""--ZZZZZZZZZ9.9999999"") AS VARCHAR(20))
                ELSE TRIM(TRAILING ""0"" FROM CAST(CAST(0 AS DECIMAL(12,7) FORMAT ""--ZZZZZZZZZ9.9999999"") AS VARCHAR(20)))
   END) AS SPREAD_RATE,
   --CAST("" "" AS DECIMAL(12,7)) AS INT_DISC,
   (CASE WHEN CAST(0 AS DECIMAL(12,7)) = 0
                THEN CAST(CAST(0 AS DECIMAL(12,7) FORMAT ""--ZZZZZZZZZ9.9999999"") AS VARCHAR(20))
                ELSE TRIM(TRAILING ""0"" FROM CAST(CAST(0 AS DECIMAL(12,7) FORMAT ""--ZZZZZZZZZ9.9999999"") AS VARCHAR(20)))
   END) AS INT_DISC,
   CAST("" "" AS CHAR(26)) AS REL_SAGMNT_ID,
   CAST("" "" AS CHAR(26)) AS ROOT_SAGMNT
   
   --SELECT COUNT(*)
   --select AGREEMENT.ACCOUNT_MODIFIER_NUM,count(*) from P1VTTEDW.AGREEMENT AGREEMENT group by 1
   FROM P1VTTEDW.AGREEMENT AGREEMENT
   INNER JOIN P1VTPOBM.VOBM_BUSINESSDATE_D VOBM_BUSINESSDATE
   ON VOBM_BUSINESSDATE.BUSINESSDATE 
    BETWEEN AGREEMENT.START_DT AND AGREEMENT.END_DT
   AND  AGREEMENT.RECORD_DELETED_FLAG = 0
   AND AGREEMENT.CTL_ID =""017""
   ----AND AGREEMENT.ACCOUNT_MODIFIER_NUM = ""TR""
    -->FILTER CLOSING DATE<--
    AND (AGREEMENT.Acct_Current_Status_Type_Cd NOT IN (4,122,123) 
     OR (AGREEMENT.Acct_Current_Status_Type_Cd  IN (4,122,123) 
              AND AGREEMENT.ACCOUNT_CLOSE_DT = VOBM_BUSINESSDATE.BUSINESSDATE))
   
   --15,297
   
   INNER JOIN
   (
   --SELECT * FROM
   P1VTTEDW.AGREEMENT AGR 
   INNER JOIN P1VTTEDW.ACCOUNT_ACCOUNT_GROUP ACC_ACC_GRO
   ON AGR.ACCOUNT_NUM = ACC_ACC_GRO. ACCOUNT_NUM
   AND AGR.ACCOUNT_MODIFIER_NUM = ACC_ACC_GRO. ACCOUNT_MODIFIER_NUM
   AND ACC_ACC_GRO.ACCT_TO_ACCT_GROUP_RELAT_CD IN (1,2)
   )
   ON AGREEMENT.ACCOUNT_NUM = AGR.BASE_ACCOUNT_NUM
   AND VOBM_BUSINESSDATE.BUSINESSDATE  BETWEEN AGR.START_DT AND AGR.END_DT
   AND  AGR.RECORD_DELETED_FLAG = 0
   
   INNER JOIN 
   (
   --SELECT COUNT(*) FROM  -- 0 row
   P1VTTEDW.ACCOUNT_CREDIT_LIMIT38  ACC_CRE_LIM 
   INNER JOIN P1VTTEDW.ACCOUNT_CREDIT_SUB_LIMIT ACC_CRE_SUB_LIM
   ON ACC_CRE_LIM.ACCOUNT_NUM = ACC_CRE_SUB_LIM. ACCOUNT_NUM
   AND ACC_CRE_LIM.ACCOUNT_MODIFIER_NUM = ACC_CRE_SUB_LIM. ACCOUNT_MODIFIER_NUM
   --AND ACC_CRE_LIM.ACCOUNT_MODIFIER_NUM = ""TR""
   --AND ACC_CRE_SUB_LIM.ACCOUNT_MODIFIER_NUM = ""TR80""
   --- ADD
   AND ACC_CRE_LIM.CTL_ID=""017"" AND ACC_CRE_SUB_LIM.CTL_ID =""017""
   AND ACC_CRE_LIM.LIMIT_TYPE_CD = ACC_CRE_SUB_LIM.LIMIT_TYPE_CD
   AND ACC_CRE_LIM.LIMIT_TYPE_CD IN (""14"",""15"",""16"",""17"",""18"")
   AND ACC_CRE_SUB_LIM.LIMIT_TYPE_CD IN (""14"",""15"",""16"",""17"",""18"")
   
   )
   ON AGREEMENT.ACCOUNT_NUM = ACC_CRE_LIM. ACCOUNT_NUM
   AND AGREEMENT.ACCOUNT_MODIFIER_NUM = ACC_CRE_LIM. ACCOUNT_MODIFIER_NUM
   AND VOBM_BUSINESSDATE.BUSINESSDATE 
    BETWEEN ACC_CRE_LIM.START_DT AND ACC_CRE_LIM.END_DT
   AND  ACC_CRE_LIM.RECORD_DELETED_FLAG = 0
   
   -----LEFT OUTER JOIN P1VUTEDW.M09700_CRNCY  M09700
   ------ON M09700.EDW_CODE = ACC_CRE_SUB_LIM.Sub_Limit_Currency_Cd
   ----AND ACC_CRE_SUB_LIM.CTL_ID = ""017""
   -----AND M09700.SRC_CTL_ID = ACC_CRE_SUB_LIM.CTL_ID
   ------AND M09700.SOURCE_ID = 1
   
   --LEFT OUTER JOIN P1VUTEDW.M19950_LMT_TYPE  M19950
   --ON M19950.EDW_CODE = ACC_CRE_SUB_LIM.Limit_Type_Cd
   --AND ACC_CRE_SUB_LIM.CTL_ID = ""017""
   --AND M19950.SRC_CTL_ID = ACC_CRE_SUB_LIM.CTL_ID
   --AND M19950.SOURCE_ID = 1
   
    LEFT OUTER JOIN P1VUTEDW.REFERENCE_DESCRIPTION AS REF_CS009700
   ON ACC_CRE_SUB_LIM.SUB_LIMIT_Currency_Cd = REF_CS009700.EDW_CODE
   AND  REF_CS009700.CODE_ID = 55
   AND REF_CS009700.CODE_SET_ID = ""CS009700""
   AND  REF_CS009700.LANGUAGE_ID = 1
   
   GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19
 
'
AS SELECT  
   /*
  ------------------------------------------------------------------
     IM80  or  IM81 
  ------------------------------------------------------------------
  */
  ( CAST(DATE_FORMAT(VOBM_BUSINESSDATE.BUSINESSDATE  , 'yyyy-MM-dd') AS CHAR(10)))   AS AS_OF_DT,  /* CHANGE DATE TYPE */ --CHANGE DATE TYPE
  CAST(AGREEMENT.ACCOUNT_MODIFIER_NUM AS CHAR(4)) AS APPL_CODE,
  CAST(AGREEMENT.BASE_ACCOUNT_NUM AS CHAR(26)) AS SAGMNT_ID,
  CAST('13' AS CHAR(20)) AS LIMIT_NO,
/* --CAST(M09700.SOURCE_KEY AS CHAR(3)) AS LIMIT_CURR_CODE, 
*/
  CAST(REF_CS009700.SHORT_DESCRIPTION  AS CHAR(3)) AS LIMIT_CURR_CODE,
/* CAST(1 AS DEC(9,0)) AS LIMIT_SEQ, 
*/
  (CASE 
   WHEN CAST(1 AS DECIMAL(9,0)) = 1
               THEN CAST(CAST(1 AS DECIMAL(9,0)) AS VARCHAR(9))
               ELSE TRIM(TRAILING '0' FROM CAST(CAST(1 AS DECIMAL(9,0)) AS VARCHAR(9)))
  END) AS LIMIT_SEQ,
  
/* CAST(ACC_INT_FEA.Acct_Interest_Feat_To_Amt AS DECIMAL(18,2)) AS LIMIT_AMT, 
*/
  (CASE 
   WHEN CAST(ACC_INT_FEA.Acct_Interest_Feat_To_Amt AS DECIMAL(18,2)) = ACC_INT_FEA.Acct_Interest_Feat_To_Amt
               THEN CAST(CAST(ACC_INT_FEA.Acct_Interest_Feat_To_Amt AS DECIMAL(18,2)) AS VARCHAR(21))
               ELSE TRIM(TRAILING '0' FROM CAST(CAST(ACC_INT_FEA.Acct_Interest_Feat_To_Amt AS DECIMAL(18,2)) AS VARCHAR(21)))
  END) AS LIMIT_AMT,
/* Next line needs to be changed!!! 
CAST(AGREEMENT.Acct_Current_Status_Type_Cd AS CHAR(2)) AS STATUS, 
*/
  CAST(REF_CS000750.SHORT_DESCRIPTION AS CHAR(2)) AS STATUS,
  ( CAST(DATE_FORMAT(ACC_INT_FEA.Acct_Interest_Feat_Start_Dt , 'yyyy-MM-dd') AS CHAR(10)))   AS OPEN_DT,   /* CHANGE DATE TYPE */ --CHANGE DATE TYPE
  ( CAST(DATE_FORMAT(ACC_INT_FEA.Acct_Interest_Feat_End_Dt , 'yyyy-MM-dd') AS CHAR(10)))  AS MATURITY_DT,  /* CHANGE DATE TYPE */ --CHANGE DATE TYPE
  ( CAST(DATE_FORMAT(AGREEMENT.Account_Close_Dt , 'yyyy-MM-dd') AS CHAR(10)))   AS CLOSE_DT,  /* CHANGE DATE TYPE */ --CHANGE DATE TYPE
  CAST(' ' AS CHAR(26)) AS SHARE_ACCT,
  CAST(  CASE ACC_INT_FEA.Fixed_Variable_Ind 
   WHEN  'FIX'  THEN '000'
   ELSE   '050'
   END AS CHAR(3))  AS INT_METHOD,
  CAST( 
  CASE ACC_INT_FEA.Interest_Index_Cd 
  WHEN  102  THEN 'B10'
  WHEN 165 THEN 'B60'
  WHEN 120 THEN 'B30'
  WHEN 101  THEN 'B00'
  WHEN 114 THEN 'B20'
  WHEN 146  THEN          
   CASE 
   WHEN  AGMT_AGMT_CLASS_ASSOC.Agreement_Classification_Cd = 4
    AND AGMT_AGMT_CLASS_ASSOC.Agreement_Class_Value_Cd = 1 
   THEN  'B43'          
   ELSE  'B42'         
   END
  END AS CHAR(9)) AS INT_RATE_TYPE,
/* CAST(ACC_INT_FEA.Acct_Interest_Feat_Rate AS DECIMAL(12,7)) AS INT_RATE, 
*/
  (CASE 
   WHEN CAST(ACC_INT_FEA.Acct_Interest_Feat_Rate AS DECIMAL(12,7)) = ACC_INT_FEA.Acct_Interest_Feat_Rate
               THEN CAST(format_number(CAST(ACC_INT_FEA.Acct_Interest_Feat_Rate AS DECIMAL(12,7)), "0.0000000") AS VARCHAR(20))
               ELSE TRIM(TRAILING '0' FROM CAST(format_number(CAST(ACC_INT_FEA.Acct_Interest_Feat_Rate AS DECIMAL(12,7)), "0.0000000") AS VARCHAR(20)))
  END) AS INT_RATE,
  
/* CAST(ACC_INT_FEA.Acct_Interest_Spread_Rate AS DECIMAL(12,7)) AS SPREAD_RATE, 
*/
  (CASE 
   WHEN CAST(ACC_INT_FEA.Acct_Interest_Spread_Rate AS DECIMAL(12,7)) = ACC_INT_FEA.Acct_Interest_Spread_Rate
               THEN CAST(format_number(CAST(ACC_INT_FEA.Acct_Interest_Spread_Rate AS DECIMAL(12,7)), "0.0000000") AS VARCHAR(20))
               ELSE TRIM(TRAILING '0' FROM CAST(format_number(CAST(ACC_INT_FEA.Acct_Interest_Spread_Rate AS DECIMAL(12,7)), "0.0000000") AS VARCHAR(20)))
  END) AS SPREAD_RATE,
  
/* CAST(ACC_INT_FEA.Acct_Interest_Feat_Final_Rate AS DECIMAL(12,7)) AS INT_DISC,
   
*/
  (CASE
   WHEN ACC_INT_FEA.Interest_Index_Cd IN (102, 165,120,114)
   THEN CASE 
    WHEN  AGMT_AGMT_CLASS_ASSOC.Agreement_Classification_Cd = 4 
     AND  AGMT_AGMT_CLASS_ASSOC.Agreement_Class_Value_Cd = 1
     AND ACC_RAT_180.Account_Rate > ACC_RAT_179.Account_Rate
     AND ACC_INT_FEA.Acct_Interest_Feat_Final_Rate > ACC_RAT_180.Account_Rate
    THEN /* ACC_RAT_180.Account_Rate */ 
    CASE 
     WHEN CAST(ACC_RAT_180.Account_Rate AS DECIMAL(12,7)) = ACC_RAT_180.Account_Rate
                 THEN CAST(format_number(CAST(ACC_RAT_180.Account_Rate AS DECIMAL(12,7)), "0.0000000") AS VARCHAR(20))
                 ELSE TRIM(TRAILING '0' FROM CAST(format_number(CAST(ACC_RAT_180.Account_Rate AS DECIMAL(12,7)), "0.0000000") AS VARCHAR(20)))
    END  
    WHEN  AGMT_AGMT_CLASS_ASSOC.Agreement_Classification_Cd = 4 
     AND  AGMT_AGMT_CLASS_ASSOC.Agreement_Class_Value_Cd = 1
     AND ACC_RAT_180.Account_Rate <= ACC_RAT_179.Account_Rate
     AND ACC_INT_FEA.Acct_Interest_Feat_Final_Rate > ACC_RAT_179.Account_Rate
    THEN /* ACC_RAT_179.Account_Rate */ 
    CASE 
     WHEN CAST(ACC_RAT_179.Account_Rate AS DECIMAL(12,7)) = ACC_RAT_179.Account_Rate
                 THEN CAST(format_number(CAST(ACC_RAT_179.Account_Rate AS DECIMAL(12,7)), "#.0000000") AS VARCHAR(20))
                 ELSE TRIM(TRAILING '0' FROM CAST(format_number(CAST(ACC_RAT_179.Account_Rate AS DECIMAL(12,7)), "#.0000000") AS VARCHAR(20)))
    END  
    END
   WHEN ACC_INT_FEA.Interest_Index_Cd IN (101, 146)
   THEN CASE 
    WHEN  AGMT_AGMT_CLASS_ASSOC.Agreement_Classification_Cd = 4 
     AND  AGMT_AGMT_CLASS_ASSOC.Agreement_Class_Value_Cd = 1
     AND ACC_INT_FEA.Acct_Interest_Feat_Final_Rate > ACC_RAT_180.Account_Rate
    THEN /* ACC_RAT_180.Account_Rate */ 
    CASE 
     WHEN CAST(ACC_RAT_180.Account_Rate AS DECIMAL(12,7)) = ACC_RAT_180.Account_Rate
                 THEN CAST(format_number(CAST(ACC_RAT_180.Account_Rate AS DECIMAL(12,7)), "0.0000000") AS VARCHAR(20))
                 ELSE TRIM(TRAILING '0' FROM CAST(format_number(CAST(ACC_RAT_180.Account_Rate AS DECIMAL(12,7)), "0.0000000") AS VARCHAR(20)))
    END  
    ELSE  CASE
     WHEN  ACC_INT_FEA.Acct_Interest_Feat_Final_Rate > ACC_RAT_178.Account_Rate
     THEN /* ACC_RAT_178.Account_Rate */ 
    CASE 
     WHEN CAST(ACC_RAT_178.Account_Rate AS DECIMAL(12,7)) = ACC_RAT_178.Account_Rate
                 THEN CAST(format_number(CAST(ACC_RAT_178.Account_Rate AS DECIMAL(12,7)), "0.0000000") AS VARCHAR(20))
                 ELSE TRIM(TRAILING '0' FROM CAST(format_number(CAST(ACC_RAT_178.Account_Rate AS DECIMAL(12,7)), "0.0000000") AS VARCHAR(20)))
    END   
     END
    END
  END) AS INT_DISC,
/*  
   1. Find MAX rate FOR compare WITH INT_DISC
   MAX-RATE1 = (SELECT ACCOUNT RATE.ACCOUNT Rate WHERE ACCOUNT RATE.Rate TYPE  CD =  178  AND ACCOUNT RATE.Balance Category TYPE CD = '159')
   MAX-RATE2 = (SELECT ACCOUNT RATE.ACCOUNT Rate WHERE ACCOUNT RATE.Rate TYPE  CD =  179  AND ACCOUNT RATE.Balance Category TYPE CD = '159')
   MAX-RATE3 = (SELECT ACCOUNT RATE.ACCOUNT Rate WHERE ACCOUNT RATE.Rate TYPE  CD =  180  AND ACCOUNT RATE.Balance Category TYPE CD = '159')
   IF ACCOUNT INTEREST FEATURE.Interest INDEX CD IN ('102', '165','120','114') THEN
       IF  AGMT AGMT CLASS ASSOC.Agreement Classification CD = '4' AND AGMT AGMT CLASS ASSOC.Agreement CLASS Value CD = '1' 
       AND MAX-RATE3 > MAX-RATE2 THEN
            MAX-RATE-COMP = MAX-RATE3
       ELSE
             MAX-RATE-COMP = MAX-RATE2
       END IF
   ELSE IF ACCOUNT INTEREST FEATURE.Interest INDEX CD IN ('101','146') THEN
       IF  AGMT AGMT CLASS ASSOC.Agreement Classification CD = '4' AND AGMT AGMT CLASS ASSOC.Agreement CLASS Value CD = '1' 
                     MAX-RATE-COMP = MAX-RATE3
               ELSE
                     MAX-RATE-COMP = MAX-RATE1
               END IF
   END IF
   
   2. Compare INT_DISC WITH MAX rate FROM 1
   INT_DISC = ACCOUNT INTEREST FEATURE.Acct Interest Feat FINAL Rate
   IF INT_DISC > MAX-RATE-COMP THEN
        INT_DISC = MAX-RATE-COMP
   END IF
   
*/
  CAST( ' ' AS CHAR(26)) AS REL_SAGMNT_ID, 
  CAST( ' ' AS CHAR(26)) AS ROOT_SAGMNT,
  CAST(NULL AS CHAR(1))AS FLAG_REVL
  
  FROM P1VTTEDW.AGREEMENT_HS AGREEMENT
  INNER JOIN P1VTPOBM.VOBM_BUSINESSDATE_D VOBM_BUSINESSDATE
  ON VOBM_BUSINESSDATE.BUSINESSDATE 
   BETWEEN AGREEMENT.START_DT AND AGREEMENT.END_DT
  AND  AGREEMENT.RECORD_DELETED_FLAG = 0
  AND AGREEMENT.ACCOUNT_MODIFIER_NUM IN ('IM80', 'IM81')
/* >FILTER CLOSING DATE<-- 
*/
   AND (AGREEMENT.Acct_Current_Status_Type_Cd NOT IN (4,122,123) 
    OR (AGREEMENT.Acct_Current_Status_Type_Cd  IN (4,122,123) AND AGREEMENT.ACCOUNT_CLOSE_DT = VOBM_BUSINESSDATE.BUSINESSDATE))
  
/* 87 
*/
  INNER JOIN P1VTTEDW.AGMT_AGMT_CLASS_ASSOC_HS AGMT_AGMT_CLASS_ASSOC
  ON AGREEMENT.ACCOUNT_NUM = AGMT_AGMT_CLASS_ASSOC. ACCOUNT_NUM
  AND AGREEMENT.ACCOUNT_MODIFIER_NUM = AGMT_AGMT_CLASS_ASSOC. ACCOUNT_MODIFIER_NUM
  AND AGMT_AGMT_CLASS_ASSOC.ACCOUNT_MODIFIER_NUM IN ('IM80', 'IM81')
  AND AGMT_AGMT_CLASS_ASSOC.Agreement_Classification_Cd = '16'
  AND AGMT_AGMT_CLASS_ASSOC.Agreement_Class_Value_Cd = '1'
  AND VOBM_BUSINESSDATE.BUSINESSDATE 
   BETWEEN AGMT_AGMT_CLASS_ASSOC.START_DT AND AGMT_AGMT_CLASS_ASSOC.END_DT
  AND  AGMT_AGMT_CLASS_ASSOC.RECORD_DELETED_FLAG = 0
/* 87 
*/
  INNER JOIN 
  (
/* select distinct ACCOUNT_MODIFIER_NUM from
P1VTTEDW.ACCOUNT_INTEREST_FEATURE38  ACC_INT_FEA 
*/
   P1VTTEDW.ACCOUNT_INTEREST_FEATURE_HS  ACC_INT_FEA
   INNER JOIN P1VTPOBM.VOBM_BUSINESSDATE_D SUB_BD
  ON SUB_BD.BUSINESSDATE  BETWEEN ACC_INT_FEA.START_DT AND ACC_INT_FEA.END_DT
  AND  ACC_INT_FEA.RECORD_DELETED_FLAG = 0
  AND ACC_INT_FEA.ACCOUNT_MODIFIER_NUM IN ('IM80', 'IM81')
  AND  COALESCE(ACC_INT_FEA.Tier_Type_Cd,'') <> ''
  
   INNER JOIN P1VTTEDW.FEATURE FEATURE
   ON ACC_INT_FEA.FEATURE_ID = FEATURE. FEATURE_ID
/* >20090401 change filed from feature_Desc to Feature_Name<--
AND FEATURE.Feature_Desc = 'Tier Interest Rate' 
*/
   AND FEATURE.Feature_Name = 'Tier Interest Rate_'
   AND SUB_BD.BUSINESSDATE  BETWEEN FEATURE.START_DT AND FEATURE.END_DT
   AND  FEATURE.RECORD_DELETED_FLAG = 0
  
    LEFT OUTER JOIN P1VTTEDW.AGMT_AGMT_CLASS_ASSOC_HS AGMT_AGMT_CLASS_ASSOC_2
    ON ACC_INT_FEA.ACCOUNT_NUM = AGMT_AGMT_CLASS_ASSOC_2. ACCOUNT_NUM
    AND ACC_INT_FEA.ACCOUNT_MODIFIER_NUM = AGMT_AGMT_CLASS_ASSOC_2. ACCOUNT_MODIFIER_NUM
    AND AGMT_AGMT_CLASS_ASSOC_2.Agreement_Classification_Cd = 4
    AND AGMT_AGMT_CLASS_ASSOC_2.Agreement_Class_Value_Cd = 1
    AND AGMT_AGMT_CLASS_ASSOC_2.ACCOUNT_MODIFIER_NUM IN ('IM80', 'IM81')
    AND SUB_BD.BUSINESSDATE BETWEEN AGMT_AGMT_CLASS_ASSOC_2.START_DT 
   AND AGMT_AGMT_CLASS_ASSOC_2.END_DT
    AND  AGMT_AGMT_CLASS_ASSOC_2.RECORD_DELETED_FLAG = 0
  )
  ON AGREEMENT.ACCOUNT_NUM = ACC_INT_FEA. ACCOUNT_NUM
  AND AGREEMENT.ACCOUNT_MODIFIER_NUM = ACC_INT_FEA. ACCOUNT_MODIFIER_NUM
  
  LEFT OUTER JOIN P1VTTEDW.ACCOUNT_CURRENCY ACCOUNT_CURRENCY
  ON AGREEMENT.ACCOUNT_NUM = ACCOUNT_CURRENCY. ACCOUNT_NUM
  AND AGREEMENT.ACCOUNT_MODIFIER_NUM = ACCOUNT_CURRENCY. ACCOUNT_MODIFIER_NUM
  AND ACCOUNT_CURRENCY.ACCOUNT_MODIFIER_NUM IN ('IM80', 'IM81')
  AND VOBM_BUSINESSDATE.BUSINESSDATE 
   BETWEEN ACCOUNT_CURRENCY.START_DT AND ACCOUNT_CURRENCY.END_DT
  AND  ACCOUNT_CURRENCY.RECORD_DELETED_FLAG = 0
  
/*  
   MAX-RATE1 = (SELECT ACCOUNT RATE.ACCOUNT Rate WHERE ACCOUNT RATE.Rate TYPE  CD =  178  AND ACCOUNT RATE.Balance Category TYPE CD = '159')
   MAX-RATE2 = (SELECT ACCOUNT RATE.ACCOUNT Rate WHERE ACCOUNT RATE.Rate TYPE  CD =  179  AND ACCOUNT RATE.Balance Category TYPE CD = '159')
   MAX-RATE3 = (SELECT ACCOUNT RATE.ACCOUNT Rate WHERE ACCOUNT RATE.Rate TYPE  CD =  180  AND ACCOUNT RATE.Balance Category TYPE CD = '159')
   
 
    
*/
  LEFT OUTER JOIN
  (
  SELECT  ACCOUNT_RATE. ACCOUNT_NUM,
   ACCOUNT_RATE. ACCOUNT_MODIFIER_NUM,
   ACCOUNT_RATE.ACCOUNT_RATE,
   ACCOUNT_RATE.START_DT,
   ACCOUNT_RATE.END_DT
  FROM P1VTTEDW.ACCOUNT_RATE  ACCOUNT_RATE
  
  WHERE  ACCOUNT_RATE.Rate_Type_Cd = 178 
  AND  ACCOUNT_RATE.Balance_Category_Type_Cd = 159
  AND   ACCOUNT_RATE.RECORD_DELETED_FLAG = 0
  AND ACCOUNT_RATE.ACCOUNT_MODIFIER_NUM IN ('IM80', 'IM81')
  ) ACC_RAT_178
  ON AGREEMENT.ACCOUNT_NUM = ACC_RAT_178. ACCOUNT_NUM
  AND AGREEMENT.ACCOUNT_MODIFIER_NUM = ACC_RAT_178. ACCOUNT_MODIFIER_NUM
  AND VOBM_BUSINESSDATE.BUSINESSDATE 
   BETWEEN ACC_RAT_178.START_DT AND ACC_RAT_178.END_DT
  
  LEFT OUTER JOIN
  (
  SELECT  ACCOUNT_RATE. ACCOUNT_NUM,
   ACCOUNT_RATE. ACCOUNT_MODIFIER_NUM,
   ACCOUNT_RATE.ACCOUNT_RATE,
   ACCOUNT_RATE.START_DT,
   ACCOUNT_RATE.END_DT
  FROM P1VTTEDW.ACCOUNT_RATE  ACCOUNT_RATE
  WHERE  ACCOUNT_RATE.Rate_Type_Cd = 179
  AND  ACCOUNT_RATE.Balance_Category_Type_Cd = 159
  AND   ACCOUNT_RATE.RECORD_DELETED_FLAG = 0
  ) ACC_RAT_179
  ON AGREEMENT.ACCOUNT_NUM = ACC_RAT_179. ACCOUNT_NUM
  AND AGREEMENT.ACCOUNT_MODIFIER_NUM = ACC_RAT_179. ACCOUNT_MODIFIER_NUM
  AND VOBM_BUSINESSDATE.BUSINESSDATE 
   BETWEEN ACC_RAT_179.START_DT AND ACC_RAT_179.END_DT
  
  LEFT OUTER JOIN
  (
  SELECT  ACCOUNT_RATE. ACCOUNT_NUM,
   ACCOUNT_RATE. ACCOUNT_MODIFIER_NUM,
   ACCOUNT_RATE.ACCOUNT_RATE,
   ACCOUNT_RATE.START_DT,
   ACCOUNT_RATE.END_DT
  FROM P1VTTEDW.ACCOUNT_RATE  ACCOUNT_RATE
  WHERE  ACCOUNT_RATE.Rate_Type_Cd = 180
  AND  ACCOUNT_RATE.Balance_Category_Type_Cd = 159
  AND   ACCOUNT_RATE.RECORD_DELETED_FLAG = 0
  ) ACC_RAT_180
  ON AGREEMENT.ACCOUNT_NUM = ACC_RAT_180. ACCOUNT_NUM
  AND AGREEMENT.ACCOUNT_MODIFIER_NUM = ACC_RAT_180. ACCOUNT_MODIFIER_NUM
  AND VOBM_BUSINESSDATE.BUSINESSDATE 
   BETWEEN ACC_RAT_180.START_DT AND ACC_RAT_180.END_DT
  
/* -LEFT OUTER JOIN P1VUTEDW.M09700_CRNCY  M09700
-ON M09700.EDW_CODE = ACCOUNT_CURRENCY.Account_Currency_Cd
   
*/
  LEFT OUTER JOIN P1VUTEDW.REFERENCE_DESCRIPTION AS REF_CS009700
  ON ACCOUNT_CURRENCY.Account_Currency_Cd = REF_CS009700.EDW_CODE
  AND  REF_CS009700.CODE_ID = 55
  AND REF_CS009700.CODE_SET_ID = 'CS009700'
  AND  REF_CS009700.LANGUAGE_ID = 1
  
  LEFT OUTER JOIN P1VUTEDW.REFERENCE_DESCRIPTION REF_CS000750
  ON REF_CS000750.EDW_CODE = AGREEMENT.Acct_Current_Status_Type_Cd
  AND REF_CS000750.CODE_ID = 7
  AND REF_CS000750.CODE_SET_ID = 'CS000750'
  AND REF_CS000750.LANGUAGE_ID = 3
  
  
  UNION ALL
  
  
/* ----------------------------------------------------------------
    AM80  or  AM81 
   ----------------------------------------------------------------
   
*/
  SELECT 
  ( CAST(DATE_FORMAT(VOBM_BUSINESSDATE.BUSINESSDATE , 'yyyy-MM-dd') AS CHAR(10)))  AS AS_OF_DT,  /* CHANGE DATE TYPE */ --CHANGE DATE TYPE
  CASE
  WHEN AGREEMENT.ACCOUNT_MODIFIER_NUM = 'AM80' THEN CAST('AL80' AS CHAR(4))
  WHEN AGREEMENT.ACCOUNT_MODIFIER_NUM = 'AM81' THEN CAST('AL81' AS CHAR(4))
  END  AS APPL_CODE,
  CAST(AGREEMENT.BASE_ACCOUNT_NUM AS CHAR(26)) AS SAGMNT_ID,
/* back up 2010-01-26
  CAST(
   CASE SUBSTR(PD.L2_HOST_PRODUCT_GROUP_VAL,1,CHARACTER_LENGTH(PD.L2_HOST_PRODUCT_GROUP_VAL)-3)
   WHEN  'LN30'  THEN  '05'
   WHEN  'LN31'  THEN  '05'
   WHEN  'PN32'  THEN  '06'
   WHEN  'CD34'  THEN  '07'
   WHEN  'LG60'  THEN  '08'
   WHEN  'AV61'  THEN  '09'
   WHEN  'AC62'  THEN  '10'
   WHEN  'DLC'  THEN  '11'
   WHEN 'LQD' THEN  '14'
   WHEN 'FA36' THEN  '20'
   WHEN 'LN35' THEN  '32'
   WHEN 'HP98' THEN  '61'
   WHEN 'LS97' THEN  '62'
   ELSE '99'
   END  AS CHAR(20))  AS LIMIT_NO,
 
back up 2010-01-26
change 2010-01-26 
*/
  CAST( 
   CASE 
    WHEN LIMTNO.LIMIT_NO IS NULL THEN '99'
     ELSE LIMTNO.LIMIT_NO
    END 
   AS CHAR(20)) AS LIMIT_NO,
/* change 2010-01-26

CAST(M09700.SOURCE_KEY AS CHAR(3)) AS LIMIT_CURR_CODE,
- 
*/
  CAST(REF_CS009700.SHORT_DESCRIPTION  AS CHAR(3)) AS LIMIT_CURR_CODE,
/* CAST(1 AS DEC(9,0)) AS LIMIT_SEQ, 
*/
  (CASE 
   WHEN CAST(1 AS DECIMAL(9,0)) = 1
               THEN CAST(CAST(1 AS DECIMAL(9,0)) AS VARCHAR(9))
               ELSE TRIM(TRAILING '0' FROM CAST(CAST(1 AS DECIMAL(9,0)) AS VARCHAR(9)))
  END) AS LIMIT_SEQ,
/* CAST(ACC_CRE_LIM.Acct_Crncy_Credit_Limit_Amt AS DECIMAL(18,2)) AS LIMIT_AMT, 
*/
  (CASE WHEN CAST(ACC_CRE_LIM.Acct_Crncy_Credit_Limit_Amt AS DECIMAL(18,2)) = ACC_CRE_LIM.Acct_Crncy_Credit_Limit_Amt
               THEN CAST(CAST(ACC_CRE_LIM.Acct_Crncy_Credit_Limit_Amt AS DECIMAL(18,2)) AS VARCHAR(21))
               ELSE TRIM(TRAILING '0' FROM CAST(CAST(ACC_CRE_LIM.Acct_Crncy_Credit_Limit_Amt AS DECIMAL(18,2)) AS VARCHAR(21)))
  END) AS LIMIT_AMT,
  CAST(  CASE   AGREEMENT.Acct_Current_Status_Type_Cd
   WHEN  4 THEN '02'
   ELSE '01'
   END AS CHAR(2)) AS STATUS,
  ( CAST(DATE_FORMAT(ACC_CRE_LIM.Credit_Limit_Start_Dttm , 'yyyy-MM-dd') AS CHAR(10)))  AS OPEN_DT,   /* CHANGE DATE TYPE */ 
  ( CAST(DATE_FORMAT(ACC_CRE_LIM.Credit_Limit_End_Dttm , 'yyyy-MM-dd') AS CHAR(10)))  AS MATURITY_DT,  /* CHANGE DATE TYPE */ 
/* --(AGEEMENT.Account_Close_Dt (FORMAT 'YYYY-MM-DD') (CHAR(10)))   AS CLOSE_DT,   --CHANGE DATE TYPE 
*/
  (CASE
   WHEN AGREEMENT.Account_Close_Dt  IS NULL THEN  CAST('9999-12-31' AS CHAR(10))
   ELSE ( CAST(DATE_FORMAT(AGREEMENT.Account_Close_Dt  , 'yyyy-MM-dd') AS CHAR(10)))  
  END) AS CLOSE_DT,
/* back up 2010-01-26
CAST(AGREEMENT.BASE_ACCOUNT_NUM AS CHAR(26)) AS SHARE_ACCT,
change 2010-01-26 
*/
  CAST(AGREEMENT_1.SHARE_ACCT AS CHAR(26)) AS SHARE_ACCT,
  CAST(' ' AS CHAR(3))  AS INT_METHOD,
/* CAST(0 AS CHAR(9)) AS INT_RATE_TYPE,
*/
  (CASE WHEN CAST(0 AS DECIMAL(12,7)) = 0
               THEN CAST(format_number(CAST(0 AS DECIMAL(12,7)), "0.0000000") AS VARCHAR(20))
               ELSE TRIM(TRAILING '0' FROM CAST(format_number(CAST(0 AS DECIMAL(12,7)), "0.0000000") AS VARCHAR(20)))
  END) AS INT_RATE_TYPE,
/* CAST(0 AS DECIMAL(12,7)) AS INT_RATE, 
*/
  (CASE WHEN CAST(0 AS DECIMAL(12,7)) = 0
               THEN CAST(format_number(CAST(0 AS DECIMAL(12,7)), "0.0000000") AS VARCHAR(20))
               ELSE TRIM(TRAILING '0' FROM CAST(format_number(CAST(0 AS DECIMAL(12,7)), "0.0000000") AS VARCHAR(20)))
  END) AS INT_RATE,
/* CAST(0 AS DECIMAL(12,7)) AS SPREAD_RATE, 
*/
  (CASE WHEN CAST(0 AS DECIMAL(12,7)) = 0
               THEN CAST(format_number(CAST(0 AS DECIMAL(12,7)), "0.0000000") AS VARCHAR(20))
               ELSE TRIM(TRAILING '0' FROM CAST(format_number(CAST(0 AS DECIMAL(12,7)), "0.0000000") AS VARCHAR(20)))
  END) AS SPREAD_RATE,
/* CAST(0 AS DECIMAL(12,7)) AS INT_DISC, 
*/
  (CASE WHEN CAST(0 AS DECIMAL(12,7)) = 0
               THEN CAST(format_number(CAST(0 AS DECIMAL(12,7)), "0.0000000") AS VARCHAR(20))
               ELSE TRIM(TRAILING '0' FROM CAST(format_number(CAST(0 AS DECIMAL(12,7)), "0.0000000") AS VARCHAR(20)))
  END) AS INT_DISC,
/* back up 2010-01-26
CAST(AGREEMENT_1.REL_SAGMNT_ID AS CHAR(26)) AS REL_SAGMNT_ID,
change 2010-01-26 
*/
  CAST(ACC_DEMO_117.Acct_Demographic_Val AS CHAR(26)) AS REL_SAGMNT_ID,
  CAST(AGREEMENT_1.ROOT_SAGMNT AS CHAR(26)) AS ROOT_SAGMNT,
/* add 2010-01-26 
*/
  CAST(
   CASE 
    WHEN  CREAGM.Revolving_Credit_Agmt_Ind = 'Yes' THEN 'Y'
    WHEN CREAGM.Revolving_Credit_Agmt_Ind = 'No' THEN 'N'
    ELSE NULL
   END
   AS CHAR(1)) AS FLAG_REVL
/* add 2010-01-26
  
SELECT COUNT(*)
   
*/
  FROM P1VTTEDW.AGREEMENT_HS AGREEMENT
  INNER JOIN P1VTPOBM.VOBM_BUSINESSDATE_D VOBM_BUSINESSDATE
  ON VOBM_BUSINESSDATE.BUSINESSDATE 
   BETWEEN AGREEMENT.START_DT AND AGREEMENT.END_DT
  AND  AGREEMENT.RECORD_DELETED_FLAG = 0
  AND AGREEMENT.ACCOUNT_MODIFIER_NUM IN ('AM80', 'AM81')
/* >FILTER CLOSING DATE<-- 
*/
   AND (AGREEMENT.Acct_Current_Status_Type_Cd NOT IN (4,122,123) 
    OR (AGREEMENT.Acct_Current_Status_Type_Cd  IN (4,122,123) AND AGREEMENT.ACCOUNT_CLOSE_DT = VOBM_BUSINESSDATE.BUSINESSDATE))
  
  INNER JOIN P1VTTEDW.AGMT_AGMT_CLASS_ASSOC_HS AGMT_AGMT_CLASS_ASSOC
  ON AGREEMENT.ACCOUNT_NUM = AGMT_AGMT_CLASS_ASSOC. ACCOUNT_NUM
  AND AGREEMENT.ACCOUNT_MODIFIER_NUM = AGMT_AGMT_CLASS_ASSOC. ACCOUNT_MODIFIER_NUM
  AND AGMT_AGMT_CLASS_ASSOC.ACCOUNT_MODIFIER_NUM IN ('AM80', 'AM81')
  AND AGMT_AGMT_CLASS_ASSOC.Agreement_Classification_Cd = '16'
/* back up 2010-01-26
AND AGMT_AGMT_CLASS_ASSOC.Agreement_Class_Value_Cd IN ('1','2','3')
change 2010-01-26
back up 2010-02-08
AND AGMT_AGMT_CLASS_ASSOC.Agreement_Class_Value_Cd IN ('1','2','3','7','8','9','10','11')
change 2010-02-08 
*/
  AND AGMT_AGMT_CLASS_ASSOC.Agreement_Class_Value_Cd IN ('1','2','3','4','7','8','9','10','11')
  AND VOBM_BUSINESSDATE.BUSINESSDATE 
   BETWEEN AGMT_AGMT_CLASS_ASSOC.START_DT AND AGMT_AGMT_CLASS_ASSOC.END_DT
  AND  AGMT_AGMT_CLASS_ASSOC.RECORD_DELETED_FLAG = 0
  
  LEFT OUTER JOIN P1VTTEDW.ACCOUNT_CURRENCY ACCOUNT_CURRENCY
  ON AGREEMENT.ACCOUNT_NUM = ACCOUNT_CURRENCY. ACCOUNT_NUM
  AND AGREEMENT.ACCOUNT_MODIFIER_NUM = ACCOUNT_CURRENCY. ACCOUNT_MODIFIER_NUM
  AND ACCOUNT_CURRENCY.ACCOUNT_MODIFIER_NUM IN ('AM80', 'AM81')
  AND VOBM_BUSINESSDATE.BUSINESSDATE 
   BETWEEN ACCOUNT_CURRENCY.START_DT AND ACCOUNT_CURRENCY.END_DT
  AND  ACCOUNT_CURRENCY.RECORD_DELETED_FLAG = 0
  AND ACCOUNT_CURRENCY.CTL_ID = '004'
  
  INNER JOIN P1VTTEDW.ACCOUNT_CREDIT_LIMIT ACC_CRE_LIM 
  ON AGREEMENT.ACCOUNT_NUM = ACC_CRE_LIM. ACCOUNT_NUM
  AND AGREEMENT.ACCOUNT_MODIFIER_NUM = ACC_CRE_LIM. ACCOUNT_MODIFIER_NUM
  AND ACC_CRE_LIM.ACCOUNT_MODIFIER_NUM IN ('AM80', 'AM81')
  AND ACC_CRE_LIM.LIMIT_TYPE_CD = '2'
  AND VOBM_BUSINESSDATE.BUSINESSDATE 
   BETWEEN ACC_CRE_LIM.START_DT AND ACC_CRE_LIM.END_DT
  AND  ACC_CRE_LIM.RECORD_DELETED_FLAG = 0
  
  LEFT OUTER JOIN 
  (
  SELECT 
  ACCT_REL.RELATED_ACCOUNT_NUM,
  ACCT_REL.RELATED_ACCOUNT_MODIFIER_NUM,
/* back up 2010-01-26
  MAX(CASE
    WHEN ACCT_REL.ACCT_RELATIONSHIP_TYPE_CD = 25 THEN AGR.BASE_ACCOUNT_NUM
   END) AS REL_SAGMNT_ID,
 
back up 2010-01-26
change 2010-01-26 
*/
  MAX(CASE
   WHEN ACCT_REL.ACCT_RELATIONSHIP_TYPE_CD = 25 THEN AGR.BASE_ACCOUNT_NUM
  END) AS SHARE_ACCT,
/* change 2010-01-26 
*/
  MAX(CASE
   WHEN ACCT_REL.ACCT_RELATIONSHIP_TYPE_CD = 11 THEN AGR.BASE_ACCOUNT_NUM
  END) AS ROOT_SAGMNT
  
  FROM P1VTTEDW.ACCT_ACCT_RELATIONSHIP AS ACCT_REL
  INNER JOIN P1VTPOBM.VOBM_BUSINESSDATE_D AS CB
  ON ACCT_REL.ACCT_RELATIONSHIP_TYPE_CD IN(11,25)
  AND CB.BUSINESSDATE  BETWEEN ACCT_REL.START_DT AND ACCT_REL.END_DT
  AND  ACCT_REL.RECORD_DELETED_FLAG = 0
  AND ACCT_REL.ACCOUNT_MODIFIER_NUM IN ('AM80', 'AM81')
  
  INNER JOIN P1VTTEDW.ACCOUNT_DEMOGRAPHIC AS ACC_DEMO
  ON ACCT_REL.ACCOUNT_NUM = ACC_DEMO.ACCOUNT_NUM
   AND ACCT_REL.ACCOUNT_MODIFIER_NUM = ACC_DEMO.ACCOUNT_MODIFIER_NUM
   AND ACC_DEMO.DATA_SOURCE_CD = 1357
   AND ACC_DEMO.DEMOG_CD = 121 
   AND ACC_DEMO.ACCT_DEMOGRAPHIC_VAL = 495
   AND CB.BUSINESSDATE  BETWEEN ACC_DEMO.START_DT AND ACC_DEMO.END_DT
   AND  ACC_DEMO.RECORD_DELETED_FLAG = 0
   AND ACC_DEMO.ACCOUNT_MODIFIER_NUM IN ('AM80', 'AM81')
   
  LEFT OUTER JOIN P1VTTEDW.AGREEMENT_HS AS AGR
  ON ACC_DEMO.ACCOUNT_NUM = AGR.ACCOUNT_NUM
   AND ACC_DEMO.ACCOUNT_MODIFIER_NUM = AGR.ACCOUNT_MODIFIER_NUM
   AND CB.BUSINESSDATE  BETWEEN AGR.START_DT AND AGR.END_DT
   AND  AGR.RECORD_DELETED_FLAG = 0
   AND AGR.ACCOUNT_MODIFIER_NUM IN ('AM80', 'AM81')
  GROUP BY 1,2
  ) AS AGREEMENT_1
  ON AGREEMENT.ACCOUNT_NUM = AGREEMENT_1.RELATED_ACCOUNT_NUM
   AND AGREEMENT.ACCOUNT_MODIFIER_NUM = AGREEMENT_1.RELATED_ACCOUNT_MODIFIER_NUM
  
  LEFT OUTER JOIN 
  (
  P1VTTEDW.ACCOUNT_PRODUCT_HISTORY_HS AS APH
  LEFT JOIN ( 
        SELECT 
        PGA.PRODUCT_ID       AS PRODUCT_ID
        ,L4.PRODUCT_GROUP_ID    AS L4_PRODUCT_GROUP_ID
        ,L3.PRODUCT_GROUP_ID   AS L3_PRODUCT_GROUP_ID
        ,L2.PRODUCT_GROUP_ID   AS L2_PRODUCT_GROUP_ID
        ,L2.HOST_PRODUCT_GROUP_VAL  AS L2_HOST_PRODUCT_GROUP_VAL
        FROM  
        P1VTTEDW.PROD_GROUP_ASSOCIATION AS PGA
        CROSS JOIN  P1VTPOBM.VOBM_BUSINESSDATE_D AS CB
        INNER JOIN P1VTTEDW.PRODUCT_GROUP  L4
        ON PGA.PRODUCT_GROUP_ID = L4.PRODUCT_GROUP_ID
        INNER JOIN P1VTTEDW.PRODUCT_GROUP  L3
        ON L4.PARENT_PROD_GROUP_ID = L3.PRODUCT_GROUP_ID
        INNER JOIN P1VTTEDW.PRODUCT_GROUP  L2
        ON L3.PARENT_PROD_GROUP_ID = L2.PRODUCT_GROUP_ID
        WHERE L4.PRODUCT_GROUP_LEVEL_NUM = 4
        AND L3.PRODUCT_GROUP_LEVEL_NUM = 3
        AND L2.PRODUCT_GROUP_LEVEL_NUM = 2
        
        AND cb.businessdate BETWEEN pga.start_dt AND pga.end_dt
        AND cb.businessdate BETWEEN l4.start_dt AND l4.end_dt
        AND cb.businessdate BETWEEN l4.start_dt AND l3.end_dt
        AND cb.businessdate BETWEEN l4.start_dt AND l2.end_dt
        AND pga.record_deleted_flag = 0
        AND l4.record_deleted_flag = 0
        AND l3.record_deleted_flag = 0
        AND l2.record_deleted_flag = 0
       ) AS PD
   ON APH.PRODUCT_ID  = PD.PRODUCT_ID
  )
  ON  AGREEMENT.ACCOUNT_NUM = APH.ACCOUNT_NUM
  AND  AGREEMENT.ACCOUNT_MODIFIER_NUM = APH.ACCOUNT_MODIFIER_NUM
  AND APH.ACCOUNT_MODIFIER_NUM IN ('AM80', 'AM81')
  AND VOBM_BUSINESSDATE.BUSINESSDATE 
   BETWEEN APH.START_DT AND APH.END_DT
  AND  APH.RECORD_DELETED_FLAG = 0
  
/* add 2010-01-26 
*/
  LEFT OUTER JOIN P1VTTEDW.ACCOUNT_DEMOGRAPHIC AS ACC_DEMO_117
  ON AGREEMENT.ACCOUNT_NUM = ACC_DEMO_117. ACCOUNT_NUM
  AND AGREEMENT.ACCOUNT_MODIFIER_NUM = ACC_DEMO_117. ACCOUNT_MODIFIER_NUM
  AND ACC_DEMO_117.DATA_SOURCE_CD = 1357 /* AM */ 
  AND ACC_DEMO_117.DEMOG_CD = 117/* ALS - Document number */ 
  AND VOBM_BUSINESSDATE.BUSINESSDATE   BETWEEN ACC_DEMO_117.START_DT  AND ACC_DEMO_117.END_DT
  AND  ACC_DEMO_117.RECORD_DELETED_FLAG = 0
  AND ACC_DEMO_117.ACCOUNT_MODIFIER_NUM IN ('AM80', 'AM81')
  AND SUBSTR( ACC_DEMO_117.ACCOUNT_NUM,6,3) = '495'
  
  LEFT OUTER JOIN P1VTTEDW.CREDIT_AGREEMENT AS CREAGM
  ON AGREEMENT.ACCOUNT_NUM = CREAGM.ACCOUNT_NUM
  AND AGREEMENT.ACCOUNT_MODIFIER_NUM = CREAGM.ACCOUNT_MODIFIER_NUM
  AND CREAGM.CTL_ID = '004'
  AND VOBM_BUSINESSDATE.BUSINESSDATE BETWEEN CREAGM.START_DT AND CREAGM.END_DT
  AND CREAGM.RECORD_DELETED_FLAG = 0  
  
  LEFT OUTER JOIN P1VTTEDW.PRODUCT AS PROD
  ON PROD.PRODUCT_ID = APH.PRODUCT_ID 
  AND  VOBM_BUSINESSDATE.BUSINESSDATE BETWEEN PROD.START_DT AND PROD.END_DT
  AND  PROD.RECORD_DELETED_FLAG = 0
  AND PROD.CTL_ID = '004'
  
  LEFT OUTER JOIN P1DPYOBM.OBM_LIMIT_NO AS LIMTNO
  ON LIMTNO.SOURCE_KEY = PROD.HOST_PROD_ID 
  AND VOBM_BUSINESSDATE.BUSINESSDATE BETWEEN LIMTNO.START_DT AND LIMTNO.END_DT
  AND  LIMTNO.RECORD_DELETED_FLAG = 0
/* add 2010-01-26
  
  LEFT OUTER JOIN P1VUTEDW.M09700_CRNCY  M09700
  ON M09700.EDW_CODE = ACCOUNT_CURRENCY.Account_Currency_Cd
   AND M09700.SRC_CTL_ID = ACCOUNT_CURRENCY.CTL_ID
   AND M09700.SOURCE_ID = 1
   
*/
  LEFT OUTER JOIN P1VUTEDW.REFERENCE_DESCRIPTION AS REF_CS009700
  ON ACCOUNT_CURRENCY.Account_Currency_Cd = REF_CS009700.EDW_CODE
  AND  REF_CS009700.CODE_ID = 55
  AND REF_CS009700.CODE_SET_ID = 'CS009700'
  AND  REF_CS009700.LANGUAGE_ID = 1
