CREATE OR REPLACE VIEW P1VEULQ.VLQ_08_GL_BAL_SUM_OC_D (
  SET_OF_BOOKS_ID,
  OC_CODE,
  PROD_CODE,
  AC_CODE,
  COMPANY_CODE,
  CREATED_DT,
  NATURE_NOW,
  NOW_BALANCE_BEQ)
AS SELECT CAST(coab.SET_OF_Books_CD AS DECIMAL(15))        SET_OF_BOOKS_ID                             
,RTRIM(CAST(coa.OC_Val  AS CHAR(4)))            OC_CODE                                           
,RTRIM(CAST(coa.Product_Val AS CHAR(4)))           PROD_CODE                                       
,RTRIM(CAST(coa.ACCOUNT_Val AS CHAR (5)))          AC_CODE                                           
,RTRIM(CAST(coa.Company_Val AS CHAR (2)))          COMPANY_CODE                                
,( DATE_FORMAT(cb.businessdate , 'yyyy-MM-dd'))        CREATED_DT                                     
,CASE 
 WHEN coa.chart_of_account_desc IN ('L','O','R') 
  THEN CAST( 'CR' AS CHAR(2))                             
   ELSE CAST('DR' AS CHAR(2))                                      
 END  NATURE_NOW                           
,SUM(CASE 
 WHEN coa.chart_of_account_desc IN ('L','O','R') 
  THEN CAST(coab.COA_Bal_Global_Crncy_End_Amt AS DECIMAL (18,2))
   ELSE CAST(coab.COA_Bal_Global_Crncy_End_Amt AS DECIMAL (18,2)) 
 END) NOW_BALANCE_BEQ      



 -- /*
FROM P1VTTEDW.CHART_OF_ACCOUNT_BALANCE COAB
INNER JOIN P1VTPLQ.VLQ_BUSINESSDATE_D AS CB
ON COAB.SET_OF_BOOKS_CD = 1
AND COAB.COA_BAL_TYPE_CD = 1
AND COAB.CURRENCY_CD = 155
AND COAB.RECORD_DELETED_FLAG = 0
AND CB.BUSINESSDATE BETWEEN COAB.START_DT AND COAB.END_DT


 -- /*INNER JOIN P1VTTEDW.CHART_OF_ACCOUNT COA
  --back up 2010-11-22
  


 --change 2010-11-22
 -- /*INNER JOIN
  
 INNER JOIN P1VTTEDW.CHART_OF_ACCOUNT COA
ON COAB.COA_BAL_ID = COA.CHART_OF_ACCOUNT_ID
AND COA.COMPANY_VAL ='01'
AND COA.CHART_OF_ACCOUNT_DESC IN ('A','L')
AND COA.RECORD_DELETED_FLAG = 0
AND CB.BUSINESSDATE BETWEEN COA.START_DT AND COA.END_DT
  
  
INNER JOIN P1VTTEDW.CUSTOM_CALENDAR_MONTH CCM                               -- add by k .chatchai 14 july 2008
ON CB.businessdate BETWEEN CCM.Custom_Calendar_Month_Start_Dt AND CCM.Custom_Calendar_Month_End_Dt
  --back up 2010-11-22
  --AND SUBSTR(Custom_Calendar_Month_Desc ,1,3) <> 'Adj'
  --change 2010-11-22
  AND CCM.Custom_Calendar_Month_Desc  NOT LIKE 'Adj%' 
  AND coab.coa_bal_period_start_dttm = CCM.Custom_Calendar_Month_Start_Dt
    --2019-11-21 add filter active record
  AND CB.BUSINESSDATE BETWEEN CCM.START_DT AND CCM.END_DT
  AND CCM.RECORD_DELETED_FLAG = 0


GROUP BY 1,2,3,4,5,6 ,7
