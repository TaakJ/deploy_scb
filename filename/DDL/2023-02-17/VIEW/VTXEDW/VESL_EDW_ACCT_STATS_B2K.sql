CREATE OR REPLACE VIEW P1VTXEDW.VESL_EDW_ACCT_STATS_B2K (
  As_Of_Dt,
  Account_Num,
  Account_Modifier_Num,
  Agmt_Ctl_Id,
  Acct_Product_Id,
  Base_Account_Num,
  Days_Num,
  MINF_BANK_BALANCE_AMT_DD,
  MAXF_BANK_BALANCE_AMT_DD,
  SUMF_BANK_BALANCE_AMT_DD,
  AVGF_BANK_BALANCE_AMT_DD,
  MINF_BANK_BALANCE_AMT_BAHT_DD,
  MAXF_BANK_BALANCE_AMT_BAHT_DD,
  SUMF_BANK_BALANCE_AMT_BAHT_DD,
  AVGF_BANK_BALANCE_AMT_BAHT_DD,
  MINN_BANK_BALANCE_AMT_DD,
  MAXN_BANK_BALANCE_AMT_DD,
  SUMN_BANK_BALANCE_AMT_DD,
  AVGN_BANK_BALANCE_AMT_DD,
  MINN_BANK_BALANCE_AMT_BAHT_DD,
  MAXN_BANK_BALANCE_AMT_BAHT_DD,
  SUMN_BANK_BALANCE_AMT_BAHT_DD,
  AVGN_BANK_BALANCE_AMT_BAHT_DD,
  MIND_BANK_BALANCE_AMT_DD,
  MAXD_BANK_BALANCE_AMT_DD,
  SUMD_BANK_BALANCE_AMT_DD,
  AVGD_BANK_BALANCE_AMT_DD,
  MIND_BANK_BALANCE_AMT_BAHT_DD,
  MAXD_BANK_BALANCE_AMT_BAHT_DD,
  SUMD_BANK_BALANCE_AMT_BAHT_DD,
  AVGD_BANK_BALANCE_AMT_BAHT_DD)
AS SELECT 
  As_Of_Dt                      
  ,Account_Num                   
  ,Account_Modifier_Num          
  ,Agmt_Ctl_Id                   
  ,Acct_Product_Id               
  ,Base_Account_Num              
  ,Days_Num                      
  ,MINF_BANK_BALANCE_AMT_DD      
  ,MAXF_BANK_BALANCE_AMT_DD      
  ,SUMF_BANK_BALANCE_AMT_DD      
  , CASE WHEN SUMF_BANK_BALANCE_AMT_DD > 0 
    THEN SUMF_BANK_BALANCE_AMT_DD / Days_Num
     ELSE 0 END 
     AS AVGF_BANK_BALANCE_AMT_DD 
  ,MINF_BANK_BALANCE_AMT_BAHT_DD 
  ,MAXF_BANK_BALANCE_AMT_BAHT_DD 
  ,SUMF_BANK_BALANCE_AMT_BAHT_DD 
  ,CASE WHEN SUMF_BANK_BALANCE_AMT_BAHT_DD > 0 
    THEN SUMF_BANK_BALANCE_AMT_BAHT_DD / Days_Num
    ELSE 0 END 
    AS AVGF_BANK_BALANCE_AMT_BAHT_DD
  ,MINN_BANK_BALANCE_AMT_DD      
  ,MAXN_BANK_BALANCE_AMT_DD      
  ,SUMN_BANK_BALANCE_AMT_DD      
  ,AVGN_BANK_BALANCE_AMT_DD 
  ,MINN_BANK_BALANCE_AMT_BAHT_DD 
  ,MAXN_BANK_BALANCE_AMT_BAHT_DD 
  ,SUMN_BANK_BALANCE_AMT_BAHT_DD 
  ,AVGN_BANK_BALANCE_AMT_BAHT_DD
  ,MIND_BANK_BALANCE_AMT_DD      
  ,MAXD_BANK_BALANCE_AMT_DD      
  ,SUMD_BANK_BALANCE_AMT_DD      
  ,AVGD_BANK_BALANCE_AMT_DD 
  ,MIND_BANK_BALANCE_AMT_BAHT_DD 
  ,MAXD_BANK_BALANCE_AMT_BAHT_DD 
  ,SUMD_BANK_BALANCE_AMT_BAHT_DD 
  ,AVGD_BANK_BALANCE_AMT_BAHT_DD
    FROM 
   (
       SELECT         BD.BusinessDate AS As_Of_Dt 
       ,BAL.ACCOUNT_NUM 
       ,BAL.ACCOUNT_MODIFIER_NUM
       ,rtrim(BAL.AGMT_CTL_ID) AS AGMT_CTL_ID
       ,BAL.Acct_Product_Id 
       ,BAL.Base_Account_Num
       ,BD.Days_Num
        ,MIN(CASE WHEN  BAL.FUND_IND = 'F' 
                     THEN (CASE WHEN COALESCE(BAL.BANK_BALANCE_AMT_DD, 0 ) < 0 
                                              THEN 0 
                                              ELSE  COALESCE(BAL.BANK_BALANCE_AMT_DD, 0 ) END)
                      ELSE 0  END)
                  AS MINF_BANK_BALANCE_AMT_DD
         ,MAX( CASE WHEN  BAL.FUND_IND = 'F' 
                     THEN (CASE WHEN COALESCE(BAL.BANK_BALANCE_AMT_DD, 0 ) < 0 
                                              THEN 0 
                                              ELSE  COALESCE(BAL.BANK_BALANCE_AMT_DD, 0 ) END)
            ELSE 0 END)
           AS MAXF_BANK_BALANCE_AMT_DD
         ,SUM(CASE WHEN  BAL.FUND_IND = 'F' 
                     THEN (CASE WHEN COALESCE(BAL.BANK_BALANCE_AMT_DD, 0 ) < 0 
                                              THEN 0 
                                              ELSE  COALESCE(BAL.BANK_BALANCE_AMT_DD, 0 ) END)
           ELSE 0 END)
          AS SUMF_BANK_BALANCE_AMT_DD
        ,MIN(CASE WHEN  BAL.FUND_IND = 'F' 
                     THEN (CASE WHEN COALESCE(BAL.BANK_BALANCE_AMT_BAHT_DD, 0 ) < 0 
                                              THEN 0 
                                              ELSE  COALESCE(BAL.BANK_BALANCE_AMT_BAHT_DD, 0 ) END)
                       ELSE 0 END)
         AS MINF_BANK_BALANCE_AMT_BAHT_DD
        ,MAX(CASE WHEN  BAL.FUND_IND = 'F' 
                     THEN (CASE WHEN COALESCE(BAL.BANK_BALANCE_AMT_BAHT_DD, 0 ) < 0 
                                              THEN 0 
                                              ELSE  COALESCE(BAL.BANK_BALANCE_AMT_BAHT_DD, 0 ) END)
                       ELSE 0 END)
          AS MAXF_BANK_BALANCE_AMT_BAHT_DD
        ,SUM     (CASE WHEN  BAL.FUND_IND = 'F' 
                     THEN (CASE WHEN COALESCE(BAL.BANK_BALANCE_AMT_BAHT_DD, 0 ) < 0 
                                              THEN 0 
                                              ELSE  COALESCE(BAL.BANK_BALANCE_AMT_BAHT_DD, 0 ) END)
                            ELSE 0 END) 
         AS SUMF_BANK_BALANCE_AMT_BAHT_DD
        ,MAX(0) AS MINN_BANK_BALANCE_AMT_DD
        ,MAX(0) AS MAXN_BANK_BALANCE_AMT_DD
        ,MAX(0)  AS SUMN_BANK_BALANCE_AMT_DD
        ,MAX(0)  AS AVGN_BANK_BALANCE_AMT_DD 
        ,MAX(0)  AS MINN_BANK_BALANCE_AMT_BAHT_DD
        ,MAX(0)  AS MAXN_BANK_BALANCE_AMT_BAHT_DD
        ,MAX(0)  AS SUMN_BANK_BALANCE_AMT_BAHT_DD
        ,MAX(0)  AS AVGN_BANK_BALANCE_AMT_BAHT_DD
        ,MAX(0) AS MIND_BANK_BALANCE_AMT_DD
        ,MAX(0) AS MAXD_BANK_BALANCE_AMT_DD
        ,MAX(0)  AS SUMD_BANK_BALANCE_AMT_DD
        ,MAX(0)  AS AVGD_BANK_BALANCE_AMT_DD 
        ,MAX(0)  AS MIND_BANK_BALANCE_AMT_BAHT_DD
        ,MAX(0)  AS MAXD_BANK_BALANCE_AMT_BAHT_DD
        ,MAX(0)  AS SUMD_BANK_BALANCE_AMT_BAHT_DD
        ,MAX(0)  AS AVGD_BANK_BALANCE_AMT_BAHT_DD
   
      FROM P1VTTEDW.EDW_ACCOUNT_BALANCE AS BAL
      CROSS JOIN P1DTPEDW.VESL_BUSINESSDATE_W AS BD
      WHERE  BAL.AS_OF_DT = BD.First_BusinessDate 
      AND  Bal.SUM_AMT_IND = 'No' 
      AND BAL.Agmt_CTL_ID = '005' 
      GROUP BY 
        BD.BusinessDate  
       ,BAL.ACCOUNT_NUM 
       ,BAL.ACCOUNT_MODIFIER_NUM
       ,rtrim(BAL.AGMT_CTL_ID)
       ,BAL.Acct_Product_Id 
       ,BAL.Base_Account_Num
       ,BD.Days_Num
   ) A
