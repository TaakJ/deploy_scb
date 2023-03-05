CREATE OR REPLACE VIEW P1VTXEDW.VESL_T3_PARTY_TELEPHONE (
  Party_Id,
  Party_Ctl_Id,
  Home_1_Num_DD,
  Home_To_1_Num,
  Home_Extension_1_Num,
  Home_2_Num_DD,
  Home_To_2_Num,
  Home_Extension_2_Num,
  Home_3_Num_DD,
  Home_To_3_Num,
  Home_Extension_3_Num,
  Office_1_Num_DD,
  Office_To_1_Num,
  Office_Extension_1_Num,
  Office_2_Num_DD,
  Office_To_2_Num,
  Office_Extension_2_Num,
  Office_3_Num_DD,
  Office_To_3_Num,
  Office_Extension_3_Num,
  Mobile_1_Num_DD,
  Mobile_2_Num_DD,
  Mobile_3_Num_DD,
  Home_1_Valid_Ind,
  Home_2_Valid_Ind,
  Home_3_Valid_Ind,
  Office_1_Valid_Ind,
  Office_2_Valid_Ind,
  Office_3_Valid_Ind,
  Mobile_1_Valid_Ind,
  Mobile_2_Valid_Ind,
  Mobile_3_Valid_Ind)
COMMENT '/*SHOW VIEW P1VTXEDW.VESL_T3_PARTY_TELEPHONE;*/
 /*########################################################################
  CHANGE DATE 2012-05-29 BY Anongnath A.
  R55050044: PERFORMANCE TUNNING
  CHANGE:
          USE DATA IN TEMP
  ================================================
    Change Request : For Project UNICA (CMS)
    Create Date: 2010-10-21
    Mapping version : EDW_PARTY_TELEPHONE_ESL_Spec_v1-0.ods
    Developer By : Ummara T.
    ----------------------------------------------------------------------------------------------------------------------------
    <<-- Change History  ->>
    Change By : Ummara T.
    Change Date : 2010-11-11
    Change Description : 
    - PLPS Telephone change select from table to view P1VTPACMS.PL_BASE_INC_COMM_M 
    - PLPS Telephone add business rule check PLPS_BINCCOMM.RB_NUMBER
    ----------------------------------------------------------------------------------------------------------------------------
    <<-- Change History  ->>
    Change By : Ummara T.
    Change Date : 2010-12-17
    Change Description : PLPS Telephone change select from view P1VTPACMS.PL_BASE_INC_COMM_M to Staging EDW
    ----------------------------------------------------------------------------------------------------------------------------
    MODELER NAME			: Kessanee P.
    CHANGE BY 			: Janmorakot R.
    CHANGE DATE 			: 2018-09-27
    MAPPING DOCUMENT	    : -
    CHANGE LOG			: Updated condition 9 fileds, Home_1_Valid_Ind, Home_2_Valid_Ind, Home_3_Valid_Ind, Office_1_Valid_Ind,
                Office_2_Valid_Ind, Office_3_Valid_Ind, Mobile_1_Valid_Ind, Mobile_2_Valid_Ind and Mobile_3_Valid_Ind

    ----------------------------------------------------------------------------------------------------------------------------
    MODELER NAME			: Chatchai 
    CHANGE BY 			: Chatchai
    CHANGE DATE 			: 2019-08-09
    MAPPING DOCUMENT	    : -
    CHANGE LOG			: IC19-211708 - Change condition for select telephone number 
              
  ########################################################################*/
'
AS SELECT
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
/*------------------------------------------------------------ RM Telephone ------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
Party_Id
,Party_Ctl_Id
,Home_1_Num_DD
,Home_To_1_Num
,Home_Extension_1_Num
,Home_2_Num_DD
,Home_To_2_Num
,Home_Extension_2_Num
,Home_3_Num_DD
,Home_To_3_Num
,Home_Extension_3_Num
,Office_1_Num_DD
,Office_To_1_Num
,Office_Extension_1_Num
,Office_2_Num_DD
,Office_To_2_Num
,Office_Extension_2_Num
,Office_3_Num_DD
,Office_To_3_Num
,Office_Extension_3_Num
,Mobile_1_Num_DD
,Mobile_2_Num_DD
,Mobile_3_Num_DD

,CASE WHEN CHAR_LENGTH(TRIM(TRANSLATE(Home_1_Num_DD, TRANSLATE(Home_1_Num_DD, '0123456789',''), ''))) = 9  THEN 0 ELSE 1 END AS Home_1_Valid_Ind
,CASE WHEN CHAR_LENGTH(TRIM(TRANSLATE(Home_2_Num_DD, TRANSLATE(Home_2_Num_DD, '0123456789',''), ''))) = 9  THEN 0 ELSE 1 END AS Home_2_Valid_Ind
,CASE WHEN CHAR_LENGTH(TRIM(TRANSLATE(Home_3_Num_DD, TRANSLATE(Home_3_Num_DD, '0123456789',''), ''))) = 9  THEN 0 ELSE 1 END AS Home_3_Valid_Ind

,CASE WHEN CHAR_LENGTH(TRIM(TRANSLATE(Office_1_Num_DD, TRANSLATE(Office_1_Num_DD, '0123456789',''), ''))) = 9  THEN 0 ELSE 1 END AS Office_1_Valid_Ind
,CASE WHEN CHAR_LENGTH(TRIM(TRANSLATE(Office_2_Num_DD, TRANSLATE(Office_2_Num_DD, '0123456789',''), ''))) = 9  THEN 0 ELSE 1 END AS Office_2_Valid_Ind
,CASE WHEN CHAR_LENGTH(TRIM(TRANSLATE(Office_3_Num_DD, TRANSLATE(Office_3_Num_DD, '0123456789',''), ''))) = 9  THEN 0 ELSE 1 END AS Office_3_Valid_Ind

,CASE WHEN CHAR_LENGTH(TRIM(TRANSLATE(Mobile_1_Num_DD, TRANSLATE(Mobile_1_Num_DD, '0123456789',''), ''))) = 10  THEN 0 ELSE 1 END AS Mobile_1_Valid_Ind
,CASE WHEN CHAR_LENGTH(TRIM(TRANSLATE(Mobile_2_Num_DD, TRANSLATE(Mobile_2_Num_DD, '0123456789',''), ''))) = 10  THEN 0 ELSE 1 END AS Mobile_2_Valid_Ind
,CASE WHEN CHAR_LENGTH(TRIM(TRANSLATE(Mobile_3_Num_DD, TRANSLATE(Mobile_3_Num_DD, '0123456789',''), ''))) = 10  THEN 0 ELSE 1 END AS Mobile_3_Valid_Ind

FROM (
    SELECT SUB_PARTY_TO_LOCATION_SEQ.Party_Id AS Party_Id
    ,SUB_PARTY_TO_LOCATION_SEQ.Ctl_Id AS Party_Ctl_Id
    /*----------------------------------------*/
    /*---- Telephone Home  -----*/
    /*----------------------------------------*/
    ,CAST(MAX(CASE WHEN SUB_PARTY_TO_LOCATION_SEQ.Party_Location_Usage_Cd = 11 AND SUB_PARTY_TO_LOCATION_SEQ.RANK_COND = 1 THEN SUB_TELEPHONE.Telephone_Num_DD_Derive END) AS VARCHAR(100)) AS Home_1_Num_DD
    ,CAST(MAX(CASE WHEN SUB_PARTY_TO_LOCATION_SEQ.Party_Location_Usage_Cd = 11 AND SUB_PARTY_TO_LOCATION_SEQ.RANK_COND = 1 THEN SUB_TELEPHONE.Telephone_To_Line_Num END) AS VARCHAR(50)) AS Home_To_1_Num
    ,CAST(MAX(CASE WHEN SUB_PARTY_TO_LOCATION_SEQ.Party_Location_Usage_Cd = 11 AND SUB_PARTY_TO_LOCATION_SEQ.RANK_COND = 1 THEN SUB_TELEPHONE.Telephone_Extension_Num END) AS VARCHAR(50)) AS Home_Extension_1_Num

    ,CAST(MAX(CASE WHEN SUB_PARTY_TO_LOCATION_SEQ.Party_Location_Usage_Cd = 11 AND SUB_PARTY_TO_LOCATION_SEQ.RANK_COND = 2 THEN SUB_TELEPHONE.Telephone_Num_DD_Derive END) AS VARCHAR(100)) AS Home_2_Num_DD
    ,CAST(MAX(CASE WHEN SUB_PARTY_TO_LOCATION_SEQ.Party_Location_Usage_Cd  =11 AND SUB_PARTY_TO_LOCATION_SEQ.RANK_COND = 2 THEN SUB_TELEPHONE.Telephone_To_Line_Num END) AS VARCHAR(50)) AS Home_To_2_Num
    ,CAST(MAX(CASE WHEN SUB_PARTY_TO_LOCATION_SEQ.Party_Location_Usage_Cd  =11 AND SUB_PARTY_TO_LOCATION_SEQ.RANK_COND = 2 THEN SUB_TELEPHONE.Telephone_Extension_Num  END) AS VARCHAR(50)) AS Home_Extension_2_Num

    ,CAST(MAX(CASE WHEN SUB_PARTY_TO_LOCATION_SEQ.Party_Location_Usage_Cd = 11 AND SUB_PARTY_TO_LOCATION_SEQ.RANK_COND = 3 THEN SUB_TELEPHONE.Telephone_Num_DD_Derive END) AS VARCHAR(100)) AS Home_3_Num_DD
    ,CAST(MAX(CASE WHEN SUB_PARTY_TO_LOCATION_SEQ.Party_Location_Usage_Cd = 11 AND SUB_PARTY_TO_LOCATION_SEQ.RANK_COND = 3 THEN SUB_TELEPHONE.Telephone_To_Line_Num END) AS VARCHAR(50)) AS Home_To_3_Num
    ,CAST(MAX(CASE WHEN SUB_PARTY_TO_LOCATION_SEQ.Party_Location_Usage_Cd = 11 AND SUB_PARTY_TO_LOCATION_SEQ.RANK_COND = 3 THEN SUB_TELEPHONE.Telephone_Extension_Num  END) AS VARCHAR(50)) AS Home_Extension_3_Num
    /*----------------------------------------*/
    /*---- Telephone Office  -----*/
    /*----------------------------------------*/
    ,CAST(MAX(CASE WHEN SUB_PARTY_TO_LOCATION_SEQ.Party_Location_Usage_Cd = 12 AND SUB_PARTY_TO_LOCATION_SEQ.RANK_COND = 1 THEN SUB_TELEPHONE.Telephone_Num_DD_Derive END) AS VARCHAR(100)) AS Office_1_Num_DD
    ,CAST(MAX(CASE WHEN SUB_PARTY_TO_LOCATION_SEQ.Party_Location_Usage_Cd = 12 AND SUB_PARTY_TO_LOCATION_SEQ.RANK_COND = 1 THEN SUB_TELEPHONE.Telephone_To_Line_Num END) AS VARCHAR(50)) AS Office_To_1_Num
    ,CAST(MAX(CASE WHEN SUB_PARTY_TO_LOCATION_SEQ.Party_Location_Usage_Cd = 12 AND SUB_PARTY_TO_LOCATION_SEQ.RANK_COND = 1 THEN SUB_TELEPHONE.Telephone_Extension_Num END) AS VARCHAR(50)) AS Office_Extension_1_Num

    ,CAST(MAX(CASE WHEN SUB_PARTY_TO_LOCATION_SEQ.Party_Location_Usage_Cd = 12 AND SUB_PARTY_TO_LOCATION_SEQ.RANK_COND = 2 THEN SUB_TELEPHONE.Telephone_Num_DD_Derive END) AS VARCHAR(100)) AS Office_2_Num_DD
    ,CAST(MAX(CASE WHEN SUB_PARTY_TO_LOCATION_SEQ.Party_Location_Usage_Cd = 12 AND SUB_PARTY_TO_LOCATION_SEQ.RANK_COND = 2 THEN SUB_TELEPHONE.Telephone_To_Line_Num END) AS VARCHAR(50)) AS Office_To_2_Num
    ,CAST(MAX(CASE WHEN SUB_PARTY_TO_LOCATION_SEQ.Party_Location_Usage_Cd = 12 AND SUB_PARTY_TO_LOCATION_SEQ.RANK_COND = 2 THEN SUB_TELEPHONE.Telephone_Extension_Num  END) AS VARCHAR(50)) AS Office_Extension_2_Num

    ,CAST(MAX(CASE WHEN SUB_PARTY_TO_LOCATION_SEQ.Party_Location_Usage_Cd = 12 AND SUB_PARTY_TO_LOCATION_SEQ.RANK_COND = 3 THEN SUB_TELEPHONE.Telephone_Num_DD_Derive END) AS VARCHAR(100)) AS Office_3_Num_DD
    ,CAST(MAX(CASE WHEN SUB_PARTY_TO_LOCATION_SEQ.Party_Location_Usage_Cd = 12 AND SUB_PARTY_TO_LOCATION_SEQ.RANK_COND = 3 THEN SUB_TELEPHONE.Telephone_To_Line_Num END) AS VARCHAR(50)) AS Office_To_3_Num
    ,CAST(MAX(CASE WHEN SUB_PARTY_TO_LOCATION_SEQ.Party_Location_Usage_Cd = 12 AND SUB_PARTY_TO_LOCATION_SEQ.RANK_COND = 3 THEN SUB_TELEPHONE.Telephone_Extension_Num  END) AS VARCHAR(50)) AS Office_Extension_3_Num
    /*----------------------*/
    /*---- Mobile -----*/
    /*----------------------*/
    ,CAST(MAX (CASE WHEN SUB_PARTY_TO_LOCATION_SEQ.Party_Location_Usage_Cd = 13 AND SUB_PARTY_TO_LOCATION_SEQ.RANK_COND = 1 THEN SUB_TELEPHONE.Telephone_Num_DD_Derive END) AS VARCHAR(100)) AS Mobile_1_Num_DD
    ,CAST(MAX (CASE WHEN SUB_PARTY_TO_LOCATION_SEQ.Party_Location_Usage_Cd = 13 AND SUB_PARTY_TO_LOCATION_SEQ.RANK_COND = 2 THEN SUB_TELEPHONE.Telephone_Num_DD_Derive END) AS VARCHAR(100)) AS Mobile_2_Num_DD
    ,CAST(MAX (CASE WHEN SUB_PARTY_TO_LOCATION_SEQ.Party_Location_Usage_Cd = 13 AND SUB_PARTY_TO_LOCATION_SEQ.RANK_COND = 3 THEN SUB_TELEPHONE.Telephone_Num_DD_Derive END) AS VARCHAR(100)) AS Mobile_3_Num_DD

    /* 2018-09-27 Updated condition by Janmorakot R. for PF6109-0001 */	
    /*,CASE WHEN COUNTDIGITS(Home_1_Num_DD) = 9  THEN 0 ELSE 1 END AS Home_1_Valid_Ind
    ,CASE WHEN COUNTDIGITS(Home_2_Num_DD) = 9  THEN 0 ELSE 1 END AS Home_2_Valid_Ind
    ,CASE WHEN COUNTDIGITS(Home_3_Num_DD) = 9  THEN 0 ELSE 1 END AS Home_3_Valid_Ind

    ,CASE WHEN COUNTDIGITS(Office_1_Num_DD) = 9  THEN 0 ELSE 1 END AS Office_1_Valid_Ind
    ,CASE WHEN COUNTDIGITS(Office_2_Num_DD) = 9  THEN 0 ELSE 1 END AS Office_2_Valid_Ind
    ,CASE WHEN COUNTDIGITS(Office_3_Num_DD) = 9  THEN 0 ELSE 1 END AS Office_3_Valid_Ind

    ,CASE WHEN COUNTDIGITS(Mobile_1_Num_DD) = 10  THEN 0 ELSE 1 END AS Mobile_1_Valid_Ind
    ,CASE WHEN COUNTDIGITS(Mobile_2_Num_DD) = 10  THEN 0 ELSE 1 END AS Mobile_2_Valid_Ind
    ,CASE WHEN COUNTDIGITS(Mobile_3_Num_DD) = 10  THEN 0 ELSE 1 END AS Mobile_3_Valid_Ind*/

    /*
    ,CASE WHEN CHAR_LENGTH(TRIM(TRANSLATE(Home_1_Num_DD, TRANSLATE(Home_1_Num_DD, '0123456789',''), ''))) = 9  THEN 0 ELSE 1 END AS Home_1_Valid_Ind
    ,CASE WHEN CHAR_LENGTH(TRIM(TRANSLATE(Home_2_Num_DD, TRANSLATE(Home_2_Num_DD, '0123456789',''), ''))) = 9  THEN 0 ELSE 1 END AS Home_2_Valid_Ind
    ,CASE WHEN CHAR_LENGTH(TRIM(TRANSLATE(Home_3_Num_DD, TRANSLATE(Home_3_Num_DD, '0123456789',''), ''))) = 9  THEN 0 ELSE 1 END AS Home_3_Valid_Ind

    ,CASE WHEN CHAR_LENGTH(TRIM(TRANSLATE(Office_1_Num_DD, TRANSLATE(Office_1_Num_DD, '0123456789',''), ''))) = 9  THEN 0 ELSE 1 END AS Office_1_Valid_Ind
    ,CASE WHEN CHAR_LENGTH(TRIM(TRANSLATE(Office_2_Num_DD, TRANSLATE(Office_2_Num_DD, '0123456789',''), ''))) = 9  THEN 0 ELSE 1 END AS Office_2_Valid_Ind
    ,CASE WHEN CHAR_LENGTH(TRIM(TRANSLATE(Office_3_Num_DD, TRANSLATE(Office_3_Num_DD, '0123456789',''), ''))) = 9  THEN 0 ELSE 1 END AS Office_3_Valid_Ind

    ,CASE WHEN CHAR_LENGTH(TRIM(TRANSLATE(Mobile_1_Num_DD, TRANSLATE(Mobile_1_Num_DD, '0123456789',''), ''))) = 10  THEN 0 ELSE 1 END AS Mobile_1_Valid_Ind
    ,CASE WHEN CHAR_LENGTH(TRIM(TRANSLATE(Mobile_2_Num_DD, TRANSLATE(Mobile_2_Num_DD, '0123456789',''), ''))) = 10  THEN 0 ELSE 1 END AS Mobile_2_Valid_Ind
    ,CASE WHEN CHAR_LENGTH(TRIM(TRANSLATE(Mobile_3_Num_DD, TRANSLATE(Mobile_3_Num_DD, '0123456789',''), ''))) = 10  THEN 0 ELSE 1 END AS Mobile_3_Valid_Ind
    */
    /* End Updated 2018-09-27 */

    FROM 
    (
      SELECT PARTY_TO_LOCATION_SEQUENCE_J01.Party_Id
      ,PARTY_TO_LOCATION_SEQUENCE_J01.Party_Location_Id
      ,PARTY_TO_LOCATION_SEQUENCE_J01.Mail_Status_Cd
      ,PARTY_TO_LOCATION_SEQUENCE_J01.Party_Location_Usage_Cd
      ,PARTY_TO_LOCATION_SEQUENCE_J01.Ctl_Id
      ,CASE
          WHEN PARTY_TO_LOCATION_SEQUENCE_J01.Mail_Status_Cd = 1 THEN 1
          WHEN PARTY_TO_LOCATION_SEQUENCE_J01.Mail_Status_Cd = 3 THEN 2
          WHEN PARTY_TO_LOCATION_SEQUENCE_J01.Mail_Status_Cd = 2 THEN 3
          WHEN PARTY_TO_LOCATION_SEQUENCE_J01.Mail_Status_Cd = 4 THEN 4
          ELSE 5
      END	AS Derive_Mail_Status_Cd
      /*-- Change date 2019-08-09 ,Change by Chatchai, Change for  IC19-211708 */
      /*--,RANK() OVER (PARTITION BY PARTY_TO_LOCATION_SEQUENCE_J01.PARTY_ID,PARTY_TO_LOCATION_SEQUENCE_J01.PARTY_LOCATION_USAGE_CD ORDER BY Derive_Mail_Status_Cd ASC, PARTY_TO_LOCATION_SEQUENCE_J01.START_DT DESC ,PARTY_TO_LOCATION_SEQUENCE_J01.PARTY_LOCATION_ID DESC)  AS RANK_COND*/
      ,RANK() OVER (PARTITION BY PARTY_TO_LOCATION_SEQUENCE_J01.PARTY_ID,PARTY_TO_LOCATION_SEQUENCE_J01.PARTY_LOCATION_USAGE_CD ORDER BY (CASE
          WHEN PARTY_TO_LOCATION_SEQUENCE_J01.Mail_Status_Cd = 1 THEN 1
          WHEN PARTY_TO_LOCATION_SEQUENCE_J01.Mail_Status_Cd = 3 THEN 2
          WHEN PARTY_TO_LOCATION_SEQUENCE_J01.Mail_Status_Cd = 2 THEN 3
          WHEN PARTY_TO_LOCATION_SEQUENCE_J01.Mail_Status_Cd = 4 THEN 4
          ELSE 5
      END) ASC, PARTY_TO_LOCATION_SEQUENCE_J01.Party_Location_Start_Dt DESC ,PARTY_TO_LOCATION_SEQUENCE_J01.PARTY_LOCATION_ID DESC)  AS RANK_COND
      /*-- Change date 2019-08-09 ,Change by Chatchai, Change for  IC19-211708 */
    
      FROM P1VTTEDW.PARTY_TO_LOCATION_SEQUENCE AS PARTY_TO_LOCATION_SEQUENCE_J01
    
      INNER JOIN P1VTPEDW.VESL_BUSINESSDATE_D AS BD
      ON  BD.Businessdate BETWEEN PARTY_TO_LOCATION_SEQUENCE_J01.START_DT AND PARTY_TO_LOCATION_SEQUENCE_J01.END_DT	
      AND PARTY_TO_LOCATION_SEQUENCE_J01.CTL_ID = '001'
      AND PARTY_TO_LOCATION_SEQUENCE_J01.Party_Location_Usage_Cd IN (11,12,13) -- [CS020350 : 11=Telephone Home,12=Telephone Office,13=Mobile]
      AND PARTY_TO_LOCATION_SEQUENCE_J01.Record_Deleted_Flag = 0

    ) AS SUB_PARTY_TO_LOCATION_SEQ

    INNER JOIN P1VTXEDW.TVESL_T3_PARTY_TEL_NUMBER AS SUB_TELEPHONE
    ON SUB_PARTY_TO_LOCATION_SEQ.Party_Location_Id = SUB_TELEPHONE.Telephone_Number_Id

    GROUP BY 1,2 
)
UNION ALL

/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
/*------------------------------------------------------------ PLPS Telephone ---------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
SELECT Party_Id
,Party_Ctl_Id
,Home_1_Num_DD
,Home_To_1_Num
,Home_Extension_1_Num
,Home_2_Num_DD
,Home_To_2_Num
,Home_Extension_2_Num
,Home_3_Num_DD
,Home_To_3_Num
,Home_Extension_3_Num
,Office_1_Num_DD
,Office_To_1_Num
,Office_Extension_1_Num
,Office_2_Num_DD
,Office_To_2_Num
,Office_Extension_2_Num
,Office_3_Num_DD
,Office_To_3_Num
,Office_Extension_3_Num
,Mobile_1_Num_DD
,Mobile_2_Num_DD
,Mobile_3_Num_DD
,CASE WHEN CHAR_LENGTH(TRIM(TRANSLATE(Home_1_Num_DD, TRANSLATE(Home_1_Num_DD, '0123456789',''), ''))) = 9   THEN 0 ELSE 1 END AS Home_1_Valid_Ind --- 0 =Valid,1=Invalid
,CASE WHEN CHAR_LENGTH(TRIM(TRANSLATE(Home_2_Num_DD, TRANSLATE(Home_2_Num_DD, '0123456789',''), ''))) = 9  THEN 0 ELSE 1 END AS Home_2_Valid_Ind --- 0 =Valid,1=Invalid
,CASE WHEN CHAR_LENGTH(TRIM(TRANSLATE(Home_3_Num_DD, TRANSLATE(Home_3_Num_DD, '0123456789',''), ''))) = 9  THEN 0 ELSE 1 END AS Home_3_Valid_Ind --- 0 =Valid,1=Invalid

,CASE WHEN CHAR_LENGTH(TRIM(TRANSLATE(Office_1_Num_DD, TRANSLATE(Office_1_Num_DD, '0123456789',''), ''))) = 9  THEN 0 ELSE 1 END AS Office_1_Valid_Ind --- 0 =Valid,1=Invalid
,CASE WHEN CHAR_LENGTH(TRIM(TRANSLATE(Office_2_Num_DD, TRANSLATE(Office_2_Num_DD, '0123456789',''), ''))) = 9  THEN 0 ELSE 1 END AS Office_2_Valid_Ind --- 0 =Valid,1=Invalid
,CASE WHEN CHAR_LENGTH(TRIM(TRANSLATE(Office_3_Num_DD, TRANSLATE(Office_3_Num_DD, '0123456789',''), ''))) = 9  THEN 0 ELSE 1 END AS Office_3_Valid_Ind --- 0 =Valid,1=Invalid

,CASE WHEN CHAR_LENGTH(TRIM(TRANSLATE(Mobile_1_Num_DD, TRANSLATE(Mobile_1_Num_DD, '0123456789',''), ''))) = 10  THEN 0 ELSE 1 END AS Mobile_1_Valid_Ind --- 0 =Valid,1=Invalid
,CASE WHEN CHAR_LENGTH(TRIM(TRANSLATE(Mobile_2_Num_DD, TRANSLATE(Mobile_2_Num_DD, '0123456789',''), ''))) = 10  THEN 0 ELSE 1 END AS Mobile_2_Valid_Ind --- 0 =Valid,1=Invalid
,CASE WHEN CHAR_LENGTH(TRIM(TRANSLATE(Mobile_3_Num_DD, TRANSLATE(Mobile_3_Num_DD, '0123456789',''), ''))) = 10  THEN 0 ELSE 1 END AS Mobile_3_Valid_Ind --- 0 =Valid,1=Invalid

FROM (
    SELECT SUB_BINCCOMM.Derive_BKEY AS Party_Id
    ,'025' AS Party_Ctl_Id
    /*----------------------------------------*/
    /*---- Telephone Home  -----*/
    /*----------------------------------------*/
    ,MAX(CASE WHEN SUB_BINCCOMM.Usage_Cd = 11 AND SUB_BINCCOMM.RANK_COND = 1 THEN SUB_BINCCOMM.Telephone_Num_DD END) AS Home_1_Num_DD
    ,MAX(CASE WHEN SUB_BINCCOMM.Usage_Cd = 11 AND SUB_BINCCOMM.RANK_COND = 1 THEN SUB_BINCCOMM.Telephone_To_Line_Num END) AS Home_To_1_Num
    ,MAX(CASE WHEN SUB_BINCCOMM.Usage_Cd = 11 AND SUB_BINCCOMM.RANK_COND = 1 THEN SUB_BINCCOMM.Telephone_Extension_Num END) AS Home_Extension_1_Num

    ,MAX(CASE WHEN SUB_BINCCOMM.Usage_Cd = 11 AND SUB_BINCCOMM.RANK_COND = 2 THEN SUB_BINCCOMM.Telephone_Num_DD END) AS Home_2_Num_DD
    ,MAX(CASE WHEN SUB_BINCCOMM.Usage_Cd = 11 AND SUB_BINCCOMM.RANK_COND = 2 THEN SUB_BINCCOMM.Telephone_To_Line_Num END) AS Home_To_2_Num
    ,MAX(CASE WHEN SUB_BINCCOMM.Usage_Cd = 11 AND SUB_BINCCOMM.RANK_COND = 2 THEN SUB_BINCCOMM.Telephone_Extension_Num  END) AS Home_Extension_2_Num

    ,MAX(CASE WHEN SUB_BINCCOMM.Usage_Cd = 11 AND SUB_BINCCOMM.RANK_COND = 3 THEN SUB_BINCCOMM.Telephone_Num_DD END) AS Home_3_Num_DD
    ,MAX(CASE WHEN SUB_BINCCOMM.Usage_Cd = 11 AND SUB_BINCCOMM.RANK_COND = 3 THEN SUB_BINCCOMM.Telephone_To_Line_Num END) AS Home_To_3_Num
    ,MAX(CASE WHEN SUB_BINCCOMM.Usage_Cd = 11 AND SUB_BINCCOMM.RANK_COND = 3 THEN SUB_BINCCOMM.Telephone_Extension_Num  END) AS Home_Extension_3_Num
    /*----------------------------------------*/
    /*---- Telephone Office  -----*/
    /*----------------------------------------*/
    ,MAX(CASE WHEN SUB_BINCCOMM.Usage_Cd = 12 AND SUB_BINCCOMM.RANK_COND = 1 THEN SUB_BINCCOMM.Telephone_Num_DD END) AS Office_1_Num_DD
    ,MAX(CASE WHEN SUB_BINCCOMM.Usage_Cd = 12 AND SUB_BINCCOMM.RANK_COND = 1 THEN SUB_BINCCOMM.Telephone_To_Line_Num END) AS Office_To_1_Num
    ,MAX(CASE WHEN SUB_BINCCOMM.Usage_Cd = 12 AND SUB_BINCCOMM.RANK_COND = 1 THEN SUB_BINCCOMM.Telephone_Extension_Num END) AS Office_Extension_1_Num

    ,MAX(CASE WHEN SUB_BINCCOMM.Usage_Cd = 12 AND SUB_BINCCOMM.RANK_COND = 2 THEN SUB_BINCCOMM.Telephone_Num_DD END) AS Office_2_Num_DD
    ,MAX(CASE WHEN SUB_BINCCOMM.Usage_Cd = 12 AND SUB_BINCCOMM.RANK_COND = 2 THEN SUB_BINCCOMM.Telephone_To_Line_Num END) AS Office_To_2_Num
    ,MAX(CASE WHEN SUB_BINCCOMM.Usage_Cd = 12 AND SUB_BINCCOMM.RANK_COND = 2 THEN SUB_BINCCOMM.Telephone_Extension_Num  END) AS Office_Extension_2_Num

    ,MAX(CASE WHEN SUB_BINCCOMM.Usage_Cd = 12 AND SUB_BINCCOMM.RANK_COND = 3 THEN SUB_BINCCOMM.Telephone_Num_DD END) AS Office_3_Num_DD
    ,MAX(CASE WHEN SUB_BINCCOMM.Usage_Cd = 12 AND SUB_BINCCOMM.RANK_COND = 3 THEN SUB_BINCCOMM.Telephone_To_Line_Num END) AS Office_To_3_Num
    ,MAX(CASE WHEN SUB_BINCCOMM.Usage_Cd = 12 AND SUB_BINCCOMM.RANK_COND = 3 THEN SUB_BINCCOMM.Telephone_Extension_Num  END) AS Office_Extension_3_Num
    /*----------------------*/
    /*---- Mobile -----*/
    /*----------------------*/
    ,MAX (CASE WHEN SUB_BINCCOMM.Usage_Cd = 13 AND SUB_BINCCOMM.RANK_COND = 1 THEN SUB_BINCCOMM.Telephone_Num_DD END) AS Mobile_1_Num_DD
    ,MAX (CASE WHEN SUB_BINCCOMM.Usage_Cd = 13 AND SUB_BINCCOMM.RANK_COND = 2 THEN SUB_BINCCOMM.Telephone_Num_DD END) AS Mobile_2_Num_DD
    ,MAX (CASE WHEN SUB_BINCCOMM.Usage_Cd = 13 AND SUB_BINCCOMM.RANK_COND = 3 THEN SUB_BINCCOMM.Telephone_Num_DD END) AS Mobile_3_Num_DD

    /* 2018-09-27 Updated condition by Janmorakot R. for PF6109-0001 */	
    /*,CASE WHEN COUNTDIGITS(Home_1_Num_DD) = 9  THEN 0 ELSE 1 END AS Home_1_Valid_Ind --- 0 =Valid,1=Invalid
    ,CASE WHEN COUNTDIGITS(Home_2_Num_DD) = 9  THEN 0 ELSE 1 END AS Home_2_Valid_Ind --- 0 =Valid,1=Invalid
    ,CASE WHEN COUNTDIGITS(Home_3_Num_DD) = 9  THEN 0 ELSE 1 END AS Home_3_Valid_Ind --- 0 =Valid,1=Invalid

    ,CASE WHEN COUNTDIGITS(Office_1_Num_DD) = 9  THEN 0 ELSE 1 END AS Office_1_Valid_Ind --- 0 =Valid,1=Invalid
    ,CASE WHEN COUNTDIGITS(Office_2_Num_DD) = 9  THEN 0 ELSE 1 END AS Office_2_Valid_Ind --- 0 =Valid,1=Invalid
    ,CASE WHEN COUNTDIGITS(Office_3_Num_DD) = 9  THEN 0 ELSE 1 END AS Office_3_Valid_Ind --- 0 =Valid,1=Invalid

    ,CASE WHEN COUNTDIGITS(Mobile_1_Num_DD) = 10  THEN 0 ELSE 1 END AS Mobile_1_Valid_Ind --- 0 =Valid,1=Invalid
    ,CASE WHEN COUNTDIGITS(Mobile_2_Num_DD) = 10  THEN 0 ELSE 1 END AS Mobile_2_Valid_Ind --- 0 =Valid,1=Invalid
    ,CASE WHEN COUNTDIGITS(Mobile_3_Num_DD) = 10  THEN 0 ELSE 1 END AS Mobile_3_Valid_Ind --- 0 =Valid,1=Invalid 
    */
    /*
    ,CASE WHEN CHAR_LENGTH(TRIM(TRANSLATE(Home_1_Num_DD, TRANSLATE(Home_1_Num_DD, '0123456789',''), ''))) = 9   THEN 0 ELSE 1 END AS Home_1_Valid_Ind --- 0 =Valid,1=Invalid
    ,CASE WHEN CHAR_LENGTH(TRIM(TRANSLATE(Home_2_Num_DD, TRANSLATE(Home_2_Num_DD, '0123456789',''), ''))) = 9  THEN 0 ELSE 1 END AS Home_2_Valid_Ind --- 0 =Valid,1=Invalid
    ,CASE WHEN CHAR_LENGTH(TRIM(TRANSLATE(Home_3_Num_DD, TRANSLATE(Home_3_Num_DD, '0123456789',''), ''))) = 9  THEN 0 ELSE 1 END AS Home_3_Valid_Ind --- 0 =Valid,1=Invalid

    ,CASE WHEN CHAR_LENGTH(TRIM(TRANSLATE(Office_1_Num_DD, TRANSLATE(Office_1_Num_DD, '0123456789',''), ''))) = 9  THEN 0 ELSE 1 END AS Office_1_Valid_Ind --- 0 =Valid,1=Invalid
    ,CASE WHEN CHAR_LENGTH(TRIM(TRANSLATE(Office_2_Num_DD, TRANSLATE(Office_2_Num_DD, '0123456789',''), ''))) = 9  THEN 0 ELSE 1 END AS Office_2_Valid_Ind --- 0 =Valid,1=Invalid
    ,CASE WHEN CHAR_LENGTH(TRIM(TRANSLATE(Office_3_Num_DD, TRANSLATE(Office_3_Num_DD, '0123456789',''), ''))) = 9  THEN 0 ELSE 1 END AS Office_3_Valid_Ind --- 0 =Valid,1=Invalid

    ,CASE WHEN CHAR_LENGTH(TRIM(TRANSLATE(Mobile_1_Num_DD, TRANSLATE(Mobile_1_Num_DD, '0123456789',''), ''))) = 10  THEN 0 ELSE 1 END AS Mobile_1_Valid_Ind --- 0 =Valid,1=Invalid
    ,CASE WHEN CHAR_LENGTH(TRIM(TRANSLATE(Mobile_2_Num_DD, TRANSLATE(Mobile_2_Num_DD, '0123456789',''), ''))) = 10  THEN 0 ELSE 1 END AS Mobile_2_Valid_Ind --- 0 =Valid,1=Invalid
    ,CASE WHEN CHAR_LENGTH(TRIM(TRANSLATE(Mobile_3_Num_DD, TRANSLATE(Mobile_3_Num_DD, '0123456789',''), ''))) = 10  THEN 0 ELSE 1 END AS Mobile_3_Valid_Ind --- 0 =Valid,1=Invalid
    */
    /* End Updated 2018-09-27 */

    FROM P1VTXEDW.TVESL_T3_PARTY_TEL_BINCCOMM AS SUB_BINCCOMM

    GROUP BY 1,2
)
