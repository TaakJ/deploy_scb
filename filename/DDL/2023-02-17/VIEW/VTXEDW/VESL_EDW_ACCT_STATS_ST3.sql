CREATE OR REPLACE VIEW P1VTXEDW.VESL_EDW_ACCT_STATS_ST3 (
  As_Of_Dt,
  Account_Num,
  Account_Modifier_Num,
  Acct_Product_Id,
  Agmt_Ctl_Id,
  Base_Account_Num,
  Min_Deposit_Bal_Amt,
  Min_Deposit_Bal_THB_Amt,
  Max_Deposit_Bal_Amt,
  Max_Deposit_Bal_THB_Amt,
  Min_Funding_Bal_Amt,
  Min_Funding_Bal_THB_Amt,
  Max_Funding_Bal_Amt,
  Max_Funding_Bal_THB_Amt,
  Min_Non_Funding_Bal_Amt,
  Min_Non_Funding_Bal_THB_Amt,
  Max_Non_Funding_Bal_Amt,
  Max_Non_Funding_Bal_THB_Amt,
  MTD_Deposit_Cnt,
  MTD_Deposit_Amt,
  MTD_Deposit_THB_Amt,
  MTD_Withdrawal_Cnt,
  MTD_Withdrawal_Amt,
  MTD_Withdrawal_THB_Amt,
  YTD_Deposit_Amt,
  YTD_Deposit_THB_Amt,
  YTD_Withdrawal_Amt,
  YTD_Withdrawal_THB_Amt,
  MTD_Deposit_Avg_Bal_Amt,
  MTD_Deposit_Avg_Bal_THB_Amt,
  MTD_Funding_Avg_Bal_Amt,
  MTD_Funding_Avg_Bal_THB_Amt,
  MTD_Non_Funding_Avg_Bal_Amt,
  MTD_Non_Fund_Avg_Bal_THB_Amt,
  MTD_Int_Payable_Avg_Amt,
  MTD_Int_Payable_Avg_THB_Amt)
AS SELECT 
    ST_AGGR.As_Of_Dt AS As_Of_Dt
    ,ST_AGGR.Account_Num AS Account_Num
    ,ST_AGGR.Account_Modifier_Num AS Account_Modifier_Num
    ,ST_AGGR.Acct_Product_Id AS Acct_Product_Id
    ,ST_AGGR.Agmt_Ctl_Id AS Agmt_Ctl_Id
    ,ST_AGGR.Base_Account_Num AS Base_Account_Num
    ,ST_AGGR.MIND_BANK_BALANCE_AMT_DD AS Min_Deposit_Bal_Amt
    ,ST_AGGR.MIND_BANK_BALANCE_AMT_BAHT_DD AS Min_Deposit_Bal_THB_Amt
    ,ST_AGGR.MAXD_BANK_BALANCE_AMT_DD AS Max_Deposit_Bal_Amt
    ,ST_AGGR.MAXD_BANK_BALANCE_AMT_BAHT_DD AS Max_Deposit_Bal_THB_Amt
    ,ST_AGGR.MINF_BANK_BALANCE_AMT_DD AS Min_Funding_Bal_Amt
    ,ST_AGGR.MINF_BANK_BALANCE_AMT_BAHT_DD AS Min_Funding_Bal_THB_Amt
    ,ST_AGGR.MAXF_BANK_BALANCE_AMT_DD AS Max_Funding_Bal_Amt
    ,ST_AGGR.MAXF_BANK_BALANCE_AMT_BAHT_DD AS Max_Funding_Bal_THB_Amt
    ,ST_AGGR.MINN_BANK_BALANCE_AMT_DD AS Min_Non_Funding_Bal_Amt
    ,ST_AGGR.MINN_BANK_BALANCE_AMT_BAHT_DD AS Min_Non_Funding_Bal_THB_Amt
    ,ST_AGGR.MAXN_BANK_BALANCE_AMT_DD AS Max_Non_Funding_Bal_Amt
    ,ST_AGGR.MAXN_BANK_BALANCE_AMT_BAHT_DD AS Max_Non_Funding_Bal_THB_Amt
    ,ACC_SUM_DD.MTD_Deposit_Cnt AS MTD_Deposit_Cnt
    ,ACC_SUM_DD.MTD_Deposit_Amt AS MTD_Deposit_Amt
    ,CAST(COALESCE((CASE
     WHEN ST_AGGR.Account_Currency_Cd = 155 
       THEN ACC_SUM_DD.MTD_Deposit_Amt 
       ELSE COALESCE(ACC_SUM_DD.MTD_Deposit_Amt * ST_AGGR.Curr_Translation_Rate, 0)
     END), 0 , 0) AS DECIMAL(18,2)) AS MTD_Deposit_THB_Amt
    ,ACC_SUM_DD.MTD_Withdrawal_Cnt AS MTD_Withdrawal_Cnt
    ,ACC_SUM_DD.MTD_Withdrawal_Amt AS MTD_Withdrawal_Amt
    ,CAST(COALESCE((CASE
     WHEN ST_AGGR.Account_Currency_Cd = 155 
       THEN ACC_SUM_DD.MTD_Withdrawal_Amt 
       ELSE COALESCE(ACC_SUM_DD.MTD_Withdrawal_Amt * ST_AGGR.Curr_Translation_Rate, 0)
     END), 0 , 0) AS DECIMAL(18,2)) AS MTD_Withdrawal_THB_Amt
    ,ACC_SUM_DD.YTD_Deposit_Amt AS YTD_Deposit_Amt
    ,CAST(COALESCE((CASE
     WHEN ST_AGGR.Account_Currency_Cd = 155 
       THEN ACC_SUM_DD.YTD_Deposit_Amt 
       ELSE COALESCE(ACC_SUM_DD.YTD_Deposit_Amt * ST_AGGR.Curr_Translation_Rate, 0)
     END), 0 , 0) AS DECIMAL(18,2)) AS YTD_Deposit_THB_Amt
    ,ACC_SUM_DD.YTD_Withdrawal_Amt AS YTD_Withdrawal_Amt
    ,CAST(COALESCE((CASE
     WHEN ST_AGGR.Account_Currency_Cd = 155 
       THEN ACC_SUM_DD.YTD_Withdrawal_Amt 
       ELSE COALESCE(ACC_SUM_DD.YTD_Withdrawal_Amt * ST_AGGR.Curr_Translation_Rate, 0)
     END), 0 , 0) AS DECIMAL(18,2)) AS YTD_Withdrawal_THB_Amt
    ,ST_AGGR.AVGD_BANK_BALANCE_AMT_DD AS MTD_Deposit_Avg_Bal_Amt
    ,ST_AGGR.AVGD_BANK_BALANCE_AMT_BAHT_DD AS MTD_Deposit_Avg_Bal_THB_Amt
    ,ST_AGGR.AVGF_BANK_BALANCE_AMT_DD AS MTD_Funding_Avg_Bal_Amt
    ,ST_AGGR.AVGF_BANK_BALANCE_AMT_BAHT_DD AS MTD_Funding_Avg_Bal_THB_Amt
    ,ST_AGGR.AVGN_BANK_BALANCE_AMT_DD AS MTD_Non_Funding_Avg_Bal_Amt
    ,ST_AGGR.AVGN_BANK_BALANCE_AMT_BAHT_DD AS MTD_Non_Fund_Avg_Bal_THB_Amt
    ,ST_AGGR.MTD_Int_Payable_Avg_Amt AS MTD_Int_Payable_Avg_Amt
    ,ST_AGGR.MTD_Int_Payable_Avg_THB_Amt AS MTD_Int_Payable_Avg_THB_Amt
    
FROM P1DTPEDW.TP_EDW_ACCT_STAT_AVG_ST3 AS ST_AGGR

LEFT OUTER JOIN 
 ( SELECT 
  ACC_SUM.Account_Num AS Account_Num 
  , ACC_SUM.Account_Modifier_Num AS Account_Modifier_Num
  , ACC_SUM.MTD_Deposit_Cnt AS MTD_Deposit_Cnt
  , ACC_SUM.MTD_Deposit_Amt AS MTD_Deposit_Amt
  ,ACC_SUM.MTD_WITHDRAWAL_CNT AS MTD_Withdrawal_Cnt
  ,ACC_SUM.MTD_WITHDRAWAL_AMT AS MTD_WITHDRAWAL_Amt
  ,ACC_SUM.YTD_DEPOSIT_AMT AS YTD_Deposit_AMT
  ,ACC_SUM.YTD_Withdrawal_Amt AS YTD_Withdrawal_Amt
 FROM  P1VTTEDW.ACCOUNT_SUMMARY_DD AS ACC_SUM
 CROSS JOIN (SELECT BUSINESSDATE FROM P1DTPEDW.VESL_BUSINESSDATE_W GROUP BY 1)AS BD 
 WHERE  BD.BUSINESSDATE BETWEEN ACC_SUM.Start_Dt AND ACC_SUM.End_Dt
        AND ACC_SUM.Record_Deleted_Flag = 0 
        AND ACC_SUM.CTL_ID = '002'
    )    AS ACC_SUM_DD
 ON ST_AGGR.ACCOUNT_NUM = ACC_SUM_DD.ACCOUNT_NUM
 AND rtrim(ST_AGGR.ACCOUNT_MODIFIER_NUM) = rtrim(ACC_SUM_DD.ACCOUNT_MODIFIER_NUM)
