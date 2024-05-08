SELECT MAIN.*,
       ANR,
       STAT_SEGM,
       STAT_SEGM_TRSL,
       I_VERVAL,
       IS_MINOR_FLAG,
       IS_MINOR_DESCRIPTION,
       DECEASED_FLAG,
       IS_BANKRUPTCY_FLAG,
       IS_BANKRUPTCY_DESCRIPTION cs_cap,
       EXI,
       REFUGEE_CODE
FROM   (SELECT PP.PSP,
               PP.KL_PARTY_CLASSIFICATION_CODE,
               PP.KL_PARTY_CLASSIFICATION_DATE,
               PP.KL_TYPE_PERSON,
               PP.KL_GENDER,
               PP.KL_LAST_NAME,
               PP.KL_FIRST_NAME,
               PP.KL_SECOND_NAME,
               PP.KL_LANGUAGE_CODE,
               CAST(PP.KL_BIRTH_DATE_YEAR AS VARCHAR(4))  AS kl_birth_date_year,
               CAST(PP.KL_BIRTH_DATE_MONTH AS VARCHAR(2)) AS kl_birth_date_month,
               CAST(PP.KL_BIRTH_DATE_DAY AS VARCHAR(2))   AS kl_birth_date_day,
               PP.KL_STREET_NAME,
               PP.KL_STREET_NUMBER,
               PP.KL_BOX_NUMBER,
               PP.KL_POSTCODE,
               PP.KL_CITY,
               PP.KL_COUNTRY,
               PP.KL_RETCO,
               PP.KL_NATIONALITY,
               PP.KL_BIRTH_PLACE,
               PP.KL_IDENTITY_CARD,
               PP.KL_NRN,
               PP.KL_CIVIL_STATE,
               PP.KL_CIVIL_STATE_INTRODUCTION_DATE,
               PP.KL_DATE_OF_DEATH,
               PP.KL_FATCA_CLASSIF,
               PP.KL_FATCA_PRCS,
               PP.KL_FATCA_STATUS,
               PP.KL_COUNTRY_OF_BIRTH,
               PP.KL_COMPANY_NAME,
               PP.KL_SHORT_NAME,
               PP.KL_BEN,
               PP.KL_VAT_NUMBER,
               PP.KL_LEI,
               PP.KL_NACEBEL,
               PP.KL_LEGAL_STATUS,
               PP.KL_CONSTITUTION_DATE,
               PP.KL_COMPANY_TYPE,
               PP.PEP,
               PP.ONBOARDINGDATE,
               PP.LASTRECERTIFICATIONDATE,
               PP.NEXTRECERTIFICATIONDATE,
               PP.COUNTRYOFACTIVITY,
               PP.SECTOROFACTIVITY,
               PP.KYCFILE_FINANCIALSECURITYSEGMENT,
               PP.PARTY_FINANCIALSECURITYSEGMENT,
               PP.PARTY_RISKLEVEL,
               PP.PARTY_UNDERSANCTION,
               PP.HAS_UBO_ASSOCIATED,
               PP.HAS_DIRECTOR_ASSOCIATED,
               PP.INFOSUP_PSA,
               PP.INFOSUP_FRZ,
               PP.KL_WORK_PHONE_NUMBER,
               PP.KL_PRIVATE_PHONE_NUMBER,
               PP.KL_FAX_NUMBER,
               PP.KL_PRIVATE_EMAIL_ADDRESS,
               PP.KL_SWIFT_EMAIL_ADDRESS,
               PP.KL_MOBILE_PHONE_NUMBER,
               PP.KL_PROFESSIONAL_EMAIL_ADDRESS,
               CAST(PP.REL_PSP AS VARCHAR(10))            AS rel_psp
        FROM   EXTERNAL.EXTERNAL_QIT_VIEW_CIVA_DATA_SET_PP_LP PP
        UNION ALL
        SELECT IP.PSP,
               IP.KL_PARTY_CLASSIFICATION_CODE,
               IP.KL_PARTY_CLASSIFICATION_DATE,
               IP.KL_TYPE_PERSON,
               IP.KL_GENDER,
               IP.KL_LAST_NAME,
               IP.KL_FIRST_NAME,
               IP.KL_SECOND_NAME,
               IP.KL_LANGUAGE_CODE,
               ''                              AS kl_birth_date_year,
               ''                              AS kl_birth_date_month,
               ''                              AS kl_birth_date_day,
               IP.KL_STREET_NAME,
               IP.KL_STREET_NUMBER,
               IP.KL_BOX_NUMBER,
               IP.KL_POSTCODE,
               IP.KL_CITY,
               IP.KL_COUNTRY,
               IP.KL_RETCO,
               IP.KL_NATIONALITY,
               IP.KL_BIRTH_PLACE,
               IP.KL_IDENTITY_CARD,
               IP.KL_NRN,
               IP.KL_CIVIL_STATE,
               IP.KL_CIVIL_STATE_INTRODUCTION_DATE,
               IP.KL_DATE_OF_DEATH,
               IP.KL_FATCA_CLASSIF,
               IP.KL_FATCA_PRCS,
               IP.KL_FATCA_STATUS,
               IP.KL_COUNTRY_OF_BIRTH,
               IP.KL_COMPANY_NAME,
               IP.KL_SHORT_NAME,
               IP.KL_BEN,
               IP.KL_VAT_NUMBER,
               IP.KL_LEI,
               IP.KL_NACEBEL,
               IP.KL_LEGAL_STATUS,
               IP.KL_CONSTITUTION_DATE,
               IP.KL_COMPANY_TYPE,
               IP.PEP,
               PPLE.ONBOARDINGDATE,
               PPLE.LASTRECERTIFICATIONDATE,
               PPLE.NEXTRECERTIFICATIONDATE,
               PPLE.COUNTRYOFACTIVITY,
               PPLE.SECTOROFACTIVITY,
               PPLE.KYCFILE_FINANCIALSECURITYSEGMENT,
               PPLE.PARTY_FINANCIALSECURITYSEGMENT,
               PPLE.PARTY_RISKLEVEL,
               PPLE.PARTY_UNDERSANCTION,
               IP.HAS_UBO_ASSOCIATED,
               IP.HAS_DIRECTOR_ASSOCIATED,
               IP.INFOSUP_PSA,
               IP.INFOSUP_FRZ,
               IP.KL_WORK_PHONE_NUMBER,
               IP.KL_PRIVATE_PHONE_NUMBER,
               IP.KL_FAX_NUMBER,
               IP.KL_PRIVATE_EMAIL_ADDRESS,
               IP.KL_SWIFT_EMAIL_ADDRESS,
               IP.KL_MOBILE_PHONE_NUMBER,
               IP.KL_PROFESSIONAL_EMAIL_ADDRESS,
               CAST(IP.REL_PSP AS VARCHAR(10)) AS rel_psp
        FROM   EXTERNAL.EXTERNAL_QIT_VIEW_CIVA_DATA_SET_IP IP
               INNER JOIN EXTERNAL.EXTERNAL_QIT_VIEW_CIVA_DATA_SET_PP_LP PPLE
                       ON CAST(IP.REL_PSP AS VARCHAR(10)) = CAST(PPLE.PSP AS VARCHAR(10))
                          AND IP.REL_PSP IS NOT NULL -- ip  only from pp_le list
       )MAIN
       LEFT JOIN EXTERNAL.EXTERNAL_QIT_VIEW_CIVA_EXCLUSION_LIST EXCL
               ON EXCL.PSP = MAIN.PSP 




SELECT IWDW_COPADI.PTY_ID                    AS psp,
       IWDW_COPADI.PTY_CLASSIF_CD            AS kl_party_classification_code,
       IWDW_COPADI.PTY_CLASSIF_DT            AS kl_party_classification_date,
       IWDW_COPADI.PTY_TYP                   AS kl_type_person,
       IWDW_COPADI.PTY_GENDER_CD             AS kl_gender,
       IWDW_COPADI.PTY_LAST_NM               AS kl_last_name,
       IWDW_COPADI.PTY_FRST_NM               AS kl_first_name,
       IWDW_COPADI.PTY_NXT_OFF_FRST_NM       AS kl_second_name,
       IWDW_COPADI.PTY_LNG_CD                AS kl_language_code,
       IWDW_COPADI.PTY_BIRTH_DT              AS kl_birth_date,
       IWDW_COPADI.PTY_STR                   AS kl_street_name,
       IWDW_COPADI.PTY_BLDG_NO               AS kl_street_number,
       IWDW_COPADI.PTY_BOX_NO                AS kl_box_number,
       IWDW_COPADI.PTY_ZIP_CD                AS kl_postcode,
       IWDW_COPADI.PTY_LCLTY_NM              AS kl_city,
       IWDW_COPADI.PTY_ISO_CTRY_CD           AS kl_country,
       IWDW_COPADI.PTY_RETURNED_MAILS_NUM    AS kl_retco,
       IWDW_COPADI.PTY_NATIONALITY_CD        AS kl_nationality,
       IWDW_COPADI.PTY_BIRTH_PL_NM           AS kl_birth_place,
       IWDW_COPADI.PTY_ID_CARD_NUM           AS kl_identity_card,
       ''                                    AS kl_nrn,
       IWDW_COPADI.PTY_MARITAL_ST_CD         AS kl_civil_state,
       IWDW_COPADI.PTY_MARITAL_STAT_INTRO_DT AS kl_civil_state_introduction_date,
       IWDW_COPADI.PTY_DEATH_DT              AS kl_date_of_death,
       IWDW_COPADI.PTY_FATCA_CLASSIF         AS kl_fatca_classif,
       IWDW_COPADI.PTY_FATCA_PRCS            AS kl_fatca_prcs,
       IWDW_COPADI.PTY_FATCA_STATUS          AS kl_fatca_status,
       IWDW_COPADI.PTY_NATIVE_CTRY           AS kl_country_of_birth,
       IWDW_COPADI.PTY_CO_LONG_NM            AS kl_company_name,
       IWDW_COPADI.PTY_CO_SHORT_NM           AS kl_short_name,
       IWDW_COPADI.PTY_CO_NAT_NO             AS kl_ben,
       IWDW_COPADI.PTY_VAT_NO                AS kl_vat_number,
       IWDW_COPADI.PTY_LGL_ENT_ID            AS kl_lei,
       IWDW_COPADI.PTY_NACEBEL_2008_CD       AS kl_nacebel,
       IWDW_COPADI.PTY_LGL_FORM              AS kl_legal_status,
       IWDW_COPADI.PTY_CONSTITUTION_DT       AS kl_constitution_date,
       IWDW_COPADI.PTY_LGL_NAT_CD            AS kl_company_type,
       IWDW_COPADI.PTY_POL_EXP_PERS_VAL_DESC AS pep,
       ''                                    AS onboardingdate,
       ''                                    AS lastrecertificationdate,
       ''                                    AS nextrecertificationdate,
       ''                                    AS countryofactivity,
       ''                                    AS sectorofactivity,
       ''                                    AS kycfile_financialsecuritysegment,
       ''                                    AS party_financialsecuritysegment,
       ''                                    AS party_risklevel,
       ''                                    AS party_undersanction,
       IWDW_IP_IP.HAS_UBO_ASSOCIATED,
       IWDW_IP_IP.HAS_DIRECTOR_ASSOCIATED,
       IWDW_INFOSUP_PSA.SUPP_INFO_CD         AS infosup_psa,
       IWDW_INFOSUP_FRZ.SUPP_INFO_CD         AS infosup_frz,
       COMMUNICATION.KL_WORK_PHONE_NUMBER,
       COMMUNICATION.KL_PRIVATE_PHONE_NUMBER,
       COMMUNICATION.KL_FAX_NUMBER,
       COMMUNICATION.KL_PRIVATE_EMAIL_ADDRESS,
       COMMUNICATION.KL_SWIFT_EMAIL_ADDRESS,
       COMMUNICATION.KL_MOBILE_PHONE_NUMBER,
       COMMUNICATION.KL_PROFESSIONAL_EMAIL_ADDRESS,
       REL_035.PSP_2                         AS rel_psp
FROM   IWDW01P_IWDW_UDS_OWN.TB_IWDW_PARTY_DIM_S IWDW_COPADI
       INNER JOIN IWDW01P_IWDW_ODS_OWN.TB_KL_GF06_IPIP_S REL_035
               ON REL_035.VNRELI = '035'
                  AND REL_035.PSP_1 = IWDW_COPADI.PTY_ID
       -- IWDW IPIP
       LEFT JOIN (SELECT IWDW_IP_IP.PARTY_ID,
                         MAX(CASE
                               WHEN IWDW_IP_IP.IP_RELATION_TYPE IN ( '152', '153' ) THEN 1
                               ELSE 0
                             END) AS has_Director_associated,
                         MAX(CASE
                               WHEN IWDW_IP_IP.IP_RELATION_TYPE IN ( '105', '106', '115', '116',
                                                                     '125', '126', '158', '159' ) THEN 1
                               ELSE 0
                             END) AS has_UBO_associated
                  FROM   IWDW01P_IWDW_RDS_OWN.TB_KL_IP_TO_IP_S IWDW_IP_IP
                  WHERE  IWDW_IP_IP.IP_RELATION_TYPE IN ( '152', '153', '105', '106',
                                                          '115', '116', '125', '126',
                                                          '158', '159' )
                  GROUP  BY IWDW_IP_IP.PARTY_ID) IWDW_IP_IP
              ON IWDW_COPADI.PTY_ID = IWDW_IP_IP.PARTY_ID
       -- IWDW INFOSUP SAR
       LEFT JOIN IWDW01P_IWDW_UDS_OWN.TB_IWDW_IP_SUP_INF_S IWDW_INFOSUP_PSA
              ON IWDW_COPADI.PTY_ID = IWDW_INFOSUP_PSA.PARTY_ID
                 AND IWDW_INFOSUP_PSA.SUPP_INFO_CD = 'PSA'
       -- IWDW INFOSUP FRZ
       LEFT JOIN IWDW01P_IWDW_UDS_OWN.TB_IWDW_IP_SUP_INF_S IWDW_INFOSUP_FRZ
              ON IWDW_COPADI.PTY_ID = IWDW_INFOSUP_FRZ.PARTY_ID
                 AND IWDW_INFOSUP_FRZ.SUPP_INFO_CD = 'FRZ'
       -- Communication details
       LEFT JOIN (SELECT PSP,
                         MAX (CASE
                                WHEN SAD = '61' THEN LIBELLE
                              END) AS "kl_work_phone_number",
                         MAX (CASE
                                WHEN SAD = '62' THEN LIBELLE
                              END) AS "kl_private_phone_number",
                         MAX (CASE
                                WHEN SAD = '64' THEN LIBELLE
                              END) AS "kl_fax_number",
                         MAX (CASE
                                WHEN SAD = '65' THEN LIBELLE
                              END) AS "kl_private_email_address",
                         MAX (CASE
                                WHEN SAD = '67' THEN LIBELLE
                              END) AS "kl_swift_email_address",
                         MAX (CASE
                                WHEN SAD = '68' THEN LIBELLE
                              END) AS "kl_mobile_phone_number",
                         MAX (CASE
                                WHEN SAD = '70' THEN LIBELLE
                              END) AS "kl_professional_email_address"
                  FROM   (SELECT PSP,
                                 SAD,
                                 LIBELLE,
                                 ROW_NUMBER()
                                   OVER (
                                     PARTITION BY PSP, SAD
                                     ORDER BY DDEB DESC) AS ROWNUM
                          --we want the most recent one if more than one  
                          FROM   IWDW01P_IWDW_ODS_OWN.TB_KL_GF05_IP_ADR_S
                          WHERE  SAD IN ( '61', '62', '64', '65',
                                          '67', '68', '70' )
                                 AND DFIN = '9999-12-31') SQ_COM
                  WHERE  ROWNUM = 1
                  GROUP  BY PSP) COMMUNICATION
              ON IWDW_COPADI.PTY_ID = COMMUNICATION.PSP 




SELECT IWDW_COPADI.PTY_ID                              AS psp,
       IWDW_COPADI.PTY_CLASSIF_CD                      AS kl_party_classification_code,
       IWDW_COPADI.PTY_CLASSIF_DT                      AS kl_party_classification_date,
       IWDW_COPADI.PTY_TYP                             AS kl_type_person,
       IWDW_COPADI.PTY_GENDER_CD                       AS kl_gender,
       IWDW_COPADI.PTY_LAST_NM                         AS kl_last_name,
       IWDW_COPADI.PTY_FRST_NM                         AS kl_first_name,
       IWDW_COPADI.PTY_NXT_OFF_FRST_NM                 AS kl_second_name,
       IWDW_COPADI.PTY_LNG_CD                          AS kl_language_code,
       --iwdw_copadi.pty_birth_dt                        AS kl_birth_date,
       KLRCGF02_INDIVIDUAL_DATA_KLRCGF02_DNA_EEJJ      AS kl_birth_date_year,
       KLRCGF02_INDIVIDUAL_DATA_KLRCGF02_DNA_MM        AS kl_birth_date_month,
       KLRCGF02_INDIVIDUAL_DATA_KLRCGF02_DNA_DD        AS kl_birth_date_day,
       IWDW_COPADI.PTY_STR                             AS kl_street_name,
       IWDW_COPADI.PTY_BLDG_NO                         AS kl_street_number,
       IWDW_COPADI.PTY_BOX_NO                          AS kl_box_number,
       IWDW_COPADI.PTY_ZIP_CD                          AS kl_postcode,
       IWDW_COPADI.PTY_LCLTY_NM                        AS kl_city,
       IWDW_COPADI.PTY_ISO_CTRY_CD                     AS kl_country,
       IWDW_COPADI.PTY_RETURNED_MAILS_NUM              AS kl_retco,
       IWDW_COPADI.PTY_NATIONALITY_CD                  AS kl_nationality,
       IWDW_COPADI.PTY_BIRTH_PL_NM                     AS kl_birth_place,
       IWDW_COPADI.PTY_ID_CARD_NUM                     AS kl_identity_card,
       IWDW_REF_CONF.EXT_REFR_CD                       AS kl_nrn,
       IWDW_COPADI.PTY_MARITAL_ST_CD                   AS kl_civil_state,
       IWDW_COPADI.PTY_MARITAL_STAT_INTRO_DT           AS kl_civil_state_introduction_date,
       IWDW_COPADI.PTY_DEATH_DT                        AS kl_date_of_death,
       IWDW_COPADI.PTY_FATCA_CLASSIF                   AS kl_fatca_classif,
       IWDW_COPADI.PTY_FATCA_PRCS                      AS kl_fatca_prcs,
       IWDW_COPADI.PTY_FATCA_STATUS                    AS kl_fatca_status,
       IWDW_COPADI.PTY_NATIVE_CTRY                     AS kl_country_of_birth,
       IWDW_COPADI.PTY_CO_LONG_NM                      AS kl_company_name,
       IWDW_COPADI.PTY_CO_SHORT_NM                     AS kl_short_name,
       IWDW_COPADI.PTY_CO_NAT_NO                       AS kl_ben,
       IWDW_COPADI.PTY_VAT_NO                          AS kl_vat_number,
       IWDW_COPADI.PTY_LGL_ENT_ID                      AS kl_lei,
       IWDW_COPADI.PTY_NACEBEL_2008_CD                 AS kl_nacebel,
       IWDW_COPADI.PTY_LGL_FORM                        AS kl_legal_status,
       IWDW_COPADI.PTY_CONSTITUTION_DT                 AS kl_constitution_date,
       IWDW_COPADI.PTY_LGL_NAT_CD                      AS kl_company_type,
       IWDW_COPADI.PTY_POL_EXP_PERS_VAL_DESC           AS pep,
       KY_FILE_ONBOARDING.KYC_FILE_PRCS_STATUS_UPD_TMS AS OnboardingDate,
       CASE
         WHEN KY_FILE.KYC_FILE_PRCS_TYP_CD = '02'
              AND KY_FILE.KYC_FILE_PRCS_STATUS_CD = '12'
              AND KY_FILE.KYC_FILE_END_PRCS_RSLT_CD = 'POS'
              AND KY_FILE.KYC_FILE_STATUS_CD = '01' THEN DATE(KY_FILE.KYC_FILE_PRCS_STATUS_UPD_TMS)
       END                                             AS LastRecertificationDate,
       KY_FILE.RCT_DUE_DT                              AS NextRecertificationDate,
       SQ_KY_ACTIVITY.COUNTRYOFACTIVITY,
       SQ_KY_ACTIVITY.SECTOROFACTIVITY,
       KY_FILE.KYC_SGMNT_CD                            AS KYCFile_FinancialSecuritySegment,
       IWDW_IP.KYC_SGMNT_CD                            AS Party_FinancialSecuritySegment,
       IWDW_IP.KYC_RISK_LVL_CD                         AS party_risklevel,
       IWKY_IP_CLASS.SCTN_VALUE_DESC                   AS Party_UnderSanction,
       SQ_IWDW_IP_IP.HAS_UBO_ASSOCIATED,
       SQ_IWDW_IP_IP.HAS_DIRECTOR_ASSOCIATED,
       INFOSUP_PSA.SUPP_INFO_CD                        AS infosup_psa,
       INFOSUP_FRZ.SUPP_INFO_CD                        AS infosup_frz,
       SQ_COMMUNICATION.KL_WORK_PHONE_NUMBER,
       SQ_COMMUNICATION.KL_PRIVATE_PHONE_NUMBER,
       SQ_COMMUNICATION.KL_FAX_NUMBER,
       SQ_COMMUNICATION.KL_PRIVATE_EMAIL_ADDRESS,
       SQ_COMMUNICATION.KL_SWIFT_EMAIL_ADDRESS,
       SQ_COMMUNICATION.KL_MOBILE_PHONE_NUMBER,
       SQ_COMMUNICATION.KL_PROFESSIONAL_EMAIL_ADDRESS,
       ''                                              AS rel_psp
FROM   EXTERNAL.EXTERNAL_QIT_VIEW_CIVA_DATA_SET_PP_LP_PREREQ_001 KY_FILE
       -- IWKY Country of activity and sector of activity
       LEFT JOIN (SELECT KY_ACTIVITY.PARTY_ID,
                         KY_ACTIVITY.BRAND_CD,
                         KY_ACTIVITY.BRANCH_ID,
                         -- ky_activity.kyc_file_seq_no,
                         KY_ACTIVITY.REFERENCE_DATE,
                         -- Country of activity
                         Max(CASE
                               WHEN KY_ACTIVITY.AVY_CD = 'COUNTRY' THEN KY_ACTIVITY.AVY_VALUE_DESC
                             END) AS countryofactivity,
                         -- Sector of activity
                         Max(CASE
                               WHEN KY_ACTIVITY.AVY_CD = 'SECTOR' THEN KY_ACTIVITY.AVY_VALUE_DESC
                             END) AS sectorofactivity
                  FROM   EXTERNAL.EXTERNAL_QIT_VIEW_CIVA_DATA_SET_PP_LP_PREREQ_002 KY_ACTIVITY
                  WHERE  KY_ACTIVITY.AVY_CD IN ( 'COUNTRY', 'SECTOR' )
                  GROUP  BY KY_ACTIVITY.PARTY_ID,
                            KY_ACTIVITY.BRAND_CD,
                            KY_ACTIVITY.BRANCH_ID,
                            -- ky_activity.kyc_file_seq_no,
                            KY_ACTIVITY.REFERENCE_DATE) SQ_KY_ACTIVITY
              ON KY_FILE.PARTY_ID = SQ_KY_ACTIVITY.PARTY_ID
                 AND KY_FILE.BRAND_CD = SQ_KY_ACTIVITY.BRAND_CD
                 AND KY_FILE.BRANCH_ID = SQ_KY_ACTIVITY.BRANCH_ID
                 -- AND ky_file.kyc_file_seq_no = sq_ky_activity.kyc_file_seq_no
                 AND KY_FILE.REFERENCE_DATE = SQ_KY_ACTIVITY.REFERENCE_DATE
       -- IWKY FILE - Onboarding date
       LEFT JOIN EXTERNAL.EXTERNAL_QIT_VIEW_CIVA_DATA_SET_PP_LP_PREREQ_001 KY_FILE_ONBOARDING
              ON KY_FILE.PARTY_ID = KY_FILE_ONBOARDING.PARTY_ID
                 AND KY_FILE.BRAND_CD = KY_FILE_ONBOARDING.BRAND_CD
                 AND KY_FILE.BRANCH_ID = KY_FILE_ONBOARDING.BRANCH_ID
                 AND KY_FILE.REFERENCE_DATE = KY_FILE_ONBOARDING.REFERENCE_DATE
                 AND KY_FILE_ONBOARDING.KYC_FILE_PRCS_TYP_CD = '01'
                 AND KY_FILE_ONBOARDING.KYC_FILE_PRCS_STATUS_CD = '12'
                 AND KY_FILE_ONBOARDING.KYC_FILE_END_PRCS_RSLT_CD = 'POS'
       -- IWDW IP (ask new source to DH MasterData squad)
       LEFT JOIN IWDW01P_IWDW_UDS_OWN.TB_IWDW_IP_S IWDW_IP
              ON KY_FILE.PARTY_ID = IWDW_IP.PARTY_ID
       -- IWKY IP_CLASS - under sanction
       LEFT JOIN IWKY01P_IWKY_UDS_OWN.TB_IWKY_IP_CLASS_S IWKY_IP_CLASS
              ON KY_FILE.PARTY_ID = IWKY_IP_CLASS.PARTY_ID
       -- IWDW COPADI
       LEFT JOIN IWDW01P_IWDW_UDS_OWN.TB_IWDW_PARTY_DIM_S IWDW_COPADI
              ON KY_FILE.PARTY_ID = IWDW_COPADI.PTY_ID
       -- IWDW IPIP
       LEFT JOIN (SELECT IWDW_IP_IP.PARTY_ID,
                         Max(CASE
                               WHEN IWDW_IP_IP.IP_RELATION_TYPE IN ( '152', '153' ) THEN 1
                               ELSE 0
                             END) AS has_director_associated,
                         Max(CASE
                               WHEN IWDW_IP_IP.IP_RELATION_TYPE IN ( '105', '106', '115', '116',
                                                                     '125', '126', '158', '159' ) THEN 1
                               ELSE 0
                             END) AS has_ubo_associated
                  FROM   IWDW01P_IWDW_RDS_OWN.TB_KL_IP_TO_IP_S IWDW_IP_IP
                  WHERE  IWDW_IP_IP.IP_RELATION_TYPE IN ( '152', '153', '105', '106',
                                                          '115', '116', '125', '126',
                                                          '158', '159' )
                  GROUP  BY IWDW_IP_IP.PARTY_ID) SQ_IWDW_IP_IP
              ON KY_FILE.PARTY_ID = SQ_IWDW_IP_IP.PARTY_ID
       -- IWDW INFOSUP SAR
       LEFT JOIN IWDW01P_IWDW_UDS_OWN.TB_IWDW_IP_SUP_INF_S INFOSUP_PSA
              ON KY_FILE.PARTY_ID = INFOSUP_PSA.PARTY_ID
                 AND INFOSUP_PSA.SUPP_INFO_CD = 'PSA'
       -- IWDW INFOSUP FRZ
       LEFT JOIN IWDW01P_IWDW_UDS_OWN.TB_IWDW_IP_SUP_INF_S INFOSUP_FRZ
              ON KY_FILE.PARTY_ID = INFOSUP_FRZ.PARTY_ID
                 AND INFOSUP_FRZ.SUPP_INFO_CD = 'FRZ'
       -- Communication details
       LEFT JOIN (SELECT PSP,
                         Max (CASE
                                WHEN SAD = '61' THEN LIBELLE
                              END) AS "kl_work_phone_number",
                         Max (CASE
                                WHEN SAD = '62' THEN LIBELLE
                              END) AS "kl_private_phone_number",
                         Max (CASE
                                WHEN SAD = '64' THEN LIBELLE
                              END) AS "kl_fax_number",
                         Max (CASE
                                WHEN SAD = '65' THEN LIBELLE
                              END) AS "kl_private_email_address",
                         Max (CASE
                                WHEN SAD = '67' THEN LIBELLE
                              END) AS "kl_swift_email_address",
                         Max (CASE
                                WHEN SAD = '68' THEN LIBELLE
                              END) AS "kl_mobile_phone_number",
                         Max (CASE
                                WHEN SAD = '70' THEN LIBELLE
                              END) AS "kl_professional_email_address"
                  FROM   (SELECT PSP,
                                 SAD,
                                 LIBELLE,
                                 ROW_NUMBER()
                                   OVER (
                                     PARTITION BY PSP, SAD
                                     ORDER BY DDEB DESC) AS ROWNUM
                          --we want the most recent one if more than one
                          FROM   IWDW01P_IWDW_ODS_OWN.TB_KL_GF05_IP_ADR_S
                          WHERE  SAD IN ( '61', '62', '64', '65',
                                          '67', '68', '70' )
                                 AND DFIN = '9999-12-31'
                         --keep only active entries
                         ) SQ_COM
                  WHERE  ROWNUM = 1
                  GROUP  BY PSP) SQ_COMMUNICATION
              ON KY_FILE.PARTY_ID = SQ_COMMUNICATION.PSP
       -- National Registration Number
       LEFT JOIN IWDW01P_IWDW_RDS_OWN.TB_KL_EXTERNAL_REFERENCES_CONF_S IWDW_REF_CONF
              ON IWDW_REF_CONF.PARTY_ID = KY_FILE.PARTY_ID
       LEFT JOIN KL.X2P_KL_DB_SORTOUT_KLSRCM12_W0000_G0000V00 GF02
              ON GF02.KLRCGF02_INDIVIDUAL_DATA_KLRCGF02_PSP = KY_FILE.PARTY_ID
WHERE  KY_FILE.KYC_FILE_STATUS_CD = '01'
       AND KY_FILE.BRAND_CD = '00'
/**/




SELECT BRAND_CD,
       BRANCH_ID,
       KYC_FILE_END_PRCS_RSLT_CD,
       KYC_FILE_PRCS_STATUS_CD,
       KYC_FILE_PRCS_STATUS_UPD_TMS,
       KYC_FILE_PRCS_TYP_CD,
       KYC_SGMNT_CD,
       KYC_FILE_STATUS_CD,
       PARTY_ID,
       RCT_DUE_DT,
       REFERENCE_DATE
FROM   IWKY01P_IWKY_UDS_OWN.TB_IWKY_KYC_FILE_A
WHERE  REFERENCE_DATE = (SELECT MAX(REFERENCE_DATE)
                         FROM   IWKY01P_IWKY_UDS_OWN.TB_IWKY_KYC_FILE_A) 
       AND 
       KYC_FILE_STATUS_CD = '01'
       AND 
       BRAND_CD = '00'




SELECT PARTY_ID,
       BRAND_CD,
       BRANCH_ID,
       KYC_FILE_SEQ_NO,
       REFERENCE_DATE,
       AVY_CD,
       AVY_VALUE_DESC
FROM   IWKY01P_IWKY_UDS_OWN.TB_IWKY_KYC_FILE_AVY_A
WHERE  REFERENCE_DATE = (SELECT MAX(REFERENCE_DATE)
                         FROM   IWKY01P_IWKY_UDS_OWN.TB_IWKY_KYC_FILE_AVY_A)
       AND
       AVY_CD IN ('COUNTRY','SECTOR')




SELECT A.PSP,
       ANR.TYPE AS anr,
       STATSEG.STAT_SEGM,
       CASE
         WHEN STATSEG.STAT_SEGM = '2' THEN 'Active Physical Person'
         WHEN STATSEG.STAT_SEGM = '3' THEN 'Active Legal Entity'
         WHEN STATSEG.STAT_SEGM = '8' THEN 'Record cancelled and not replaced'
         WHEN STATSEG.STAT_SEGM = '9' THEN'Record cancelled and replaced by another PSP/record'
       END      AS stat_segm_trsl,
       VRVL.I_VERVAL,
       CASE
         WHEN IND.STAT_JUR IN ( '1', '2', '3', '4',
                                '6', '26' ) THEN '1'
         ELSE '0'
       END      AS is_minor_flag,
       CASE
         WHEN IND.STAT_JUR = '1' THEN IND.STAT_JUR
                                      || ' - MINEUR SOUS REPRES.LEGALE PARENTS'
         WHEN IND.STAT_JUR = '2' THEN IND.STAT_JUR
                                      ||' - MINEUR SOUS REPRES.LEGALE DE LA MERE'
         WHEN IND.STAT_JUR = '3' THEN IND.STAT_JUR
                                      || ' - MINEUR SOUS REPRES.PARTICULIERE'
         WHEN IND.STAT_JUR = '4' THEN IND.STAT_JUR
                                      || ' - MINEUR SOUS REPRES.LEGALE DU PERE'
         WHEN IND.STAT_JUR = '6' THEN IND.STAT_JUR
                                      || ' - MINEUR SOUS TUTELLE D''UN TIERS'
         WHEN IND.STAT_JUR = '26' THEN IND.STAT_JUR
                                       || ' - MINEUR D''AGE'
       END      AS is_minor_description,
       CASE
         WHEN IND.ECI = '6' THEN '1'
         ELSE '0'
       END      AS deceased_flag,
       CASE
         WHEN A.C_JUR_STA IN ( '24', '77', '78', '79',
                               '80', '81', '83', '85', '89' ) THEN '1'
         ELSE '0'
       END      AS is_bankruptcy_flag,
       CASE
         WHEN A.C_JUR_STA = '24' THEN A.C_JUR_STA
                                      || ' - EN FAILLITE'
         WHEN A.C_JUR_STA = '77' THEN A.C_JUR_STA
                                      || ' - CLOTURE DE FAILLITE AVEC EXCUSABILITE'
         WHEN A.C_JUR_STA = '78' THEN A.C_JUR_STA
                                      || ' - CLOTURE FAILL. SANS EXCUSABILITE'
         WHEN A.C_JUR_STA = '79' THEN A.C_JUR_STA
                                      || ' - CLOTURE FAILL. ATTENTE D''EXCUSABILITE'
         WHEN A.C_JUR_STA = '80' THEN A.C_JUR_STA
                                      || ' - BANQUEROUTE'
         WHEN A.C_JUR_STA = '81' THEN A.C_JUR_STA
                                      || ' - CESSATION D''ACTIVITE'
         WHEN A.C_JUR_STA = '82' THEN A.C_JUR_STA
                                      || ' - EN LIQUIDATION'
         WHEN A.C_JUR_STA = '83' THEN A.C_JUR_STA
                                      || ' - CLOTURE DE LIQUIDATION'
         WHEN A.C_JUR_STA = '85' THEN A.C_JUR_STA
                                      || ' - CLOTURE DE FAILLITE'
         WHEN A.C_JUR_STA = '87' THEN A.C_JUR_STA
                                      || ' - EXCUSABILITE AVANT CLOTURE DE FAILLITE'
         WHEN A.C_JUR_STA = '88' THEN A.C_JUR_STA
                                      || ' - NON-EXCUSABILITE AVANT CLOTURE FAILLITE'
         WHEN A.C_JUR_STA = '89' THEN A.C_JUR_STA
                                      || ' - FUSION PAR ABSORPTION'
       END      AS is_bankruptcy_description,
       CSCAP.CS_CAP,
       EXI.EXI,
       RFG.REFUGEE_CODE
FROM   IWDW01P_IWDW_ODS_OWN.TB_KL_GF01_PARTY_S A
       LEFT JOIN IWDW01P_IWDW_ODS_OWN.TB_KL_GF07_INF_SUP_S ANR
              ON ANR.PSP = A.PSP
                 AND ANR.CODE = 'ACT'
                 AND ANR.D_END = '9999-12-31'
       LEFT JOIN IWDW01P_IWDW_ODS_OWN.TB_KL_GF01_PARTY_S STATSEG
              ON STATSEG.PSP = A.PSP
       LEFT JOIN IWDW01P_IWDW_ODS_OWN.TB_KL_GF03_LEGAL_S VRVL
              ON VRVL.PSP = A.PSP
       LEFT JOIN IWDW01P_IWDW_ODS_OWN.TB_KL_GF02_INDIVIDUAL_S IND
              ON IND.PSP = A.PSP
       LEFT JOIN IWDW01P_IWDW_ODS_OWN.TB_KL_GF03_LEGAL_S BKRPT
              ON BKRPT.PSP = A.PSP
                 AND BKRPT.C_JUR_STA IN ( '24', '77', '78', '79',
                                          '80', '81', '83', '85', '89' )
       LEFT JOIN (SELECT PSP,
                         MAX(CSCAP.CS_CAP) AS CS_CAP
                  FROM   IWDW01P_IWDW_ODS_OWN.TB_KL_GF10_CLIENTSHIP_S CSCAP
                  GROUP  BY PSP)CSCAP
              ON CSCAP.PSP = A.PSP
                 AND CSCAP.CS_CAP NOT IN ( '79', '80' )
       LEFT JOIN (SELECT A.PSP,
                         A.EXI
                  FROM   (SELECT X.PSP,
                                 X.TYPE                             AS exi,
                                 ROW_NUMBER()
                                   OVER (
                                     PARTITION BY PSP
                                     ORDER BY X.TYPE, X.N_BUI DESC) AS ROWNUM
                          FROM   IWDW01P_IWDW_ODS_OWN.TB_KL_GF07_INF_SUP_S X
                          WHERE  CODE = 'EXI'
                                 AND D_END = '9999-12-31') A
                  WHERE  A.ROWNUM = 1) EXI
              ON EXI.PSP = A.PSP
       LEFT JOIN (SELECT A.PSP,
                         A.REFUGEE_CODE
                  FROM   (SELECT X.PSP,
                                 X.TYPE                             AS refugee_code,
                                 ROW_NUMBER()
                                   OVER (
                                     PARTITION BY PSP
                                     ORDER BY X.TYPE, X.N_BUI DESC) AS ROWNUM
                          FROM   IWDW01P_IWDW_ODS_OWN.TB_KL_GF07_INF_SUP_S X
                          WHERE  CODE = 'RFG'
                                 AND D_END = '9999-12-31') A
                  WHERE  A.ROWNUM = 1) RFG
              ON RFG.PSP = A.PSP
WHERE  A.STAT_SEGM IN ( '2', '3' )
       AND A.PTY_CLASS_CD = '0' 
