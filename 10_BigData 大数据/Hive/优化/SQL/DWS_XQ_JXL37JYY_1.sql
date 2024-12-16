DROP TABLE ZTEST_JXL_37J_CONT_WYDATA PURGE;

CREATE TABLE ZTEST_JXL_37J_CONT_WYDATA AS
     SELECT
          P.CONTNO,
          P.POLNO,
          D.MONTHID            TJMONTH,
          P.SALECHNL,
          P.CVALIDATE,
          P.PAYINTV,
          ROUND(P.RPAYINTV, 0) RPAYINTV,
          P.RISKPERIOD,
          P.PREM,
          P.AGENTCODE,
          P.PAYTODATE,
          P.RPAYTODATE,
          P.RPAYENDDATE,
          P.MANAGECOM,
          P.AGENTCOM,
          K.TEAM_ID            TEAMID
     FROM
          DWS_XQ_JXL37JYY_TMP_1_1 P
          JOIN (
               SELECT
                    CAST(INT(MONTHID) AS STRING)        MONTHID,
                    CAST(INT(YEARID) AS STRING)         YEARID,
                    DATE_FORMAT(DATEDATE, 'yyyy-MM-dd') DATEDATE
               FROM
                    ODS.D_DATE
               WHERE
                    DATE_FORMAT(DATEDATE, 'yyyy-MM-dd') = LAST_DAY(DATE_FORMAT(DATEDATE, 'yyyy-MM-dd'))
                    AND DATE_FORMAT(DATEDATE, 'yyyy-MM-dd') <= DATE_ADD(ADD_MONTHS(TRUNC(CURRENT_DATE(), 'YEAR'), 24), -1)
          ) D
          LEFT JOIN ODS.O_XG_T02SALESINFO K
          ON P.AGENTCODE = K.SALES_ID
     WHERE
          DATE_FORMAT(ADD_MONTHS(P.CVALIDATE, 36), 'MM') BETWEEN '01' AND SUBSTR(D.MONTHID, 5, 2)
          AND DATE_FORMAT(ADD_MONTHS(P.CVALIDATE, 36), 'yyyy') <= D.YEARID
     UNION
 --宽一部分
     SELECT
          P.CONTNO,
          P.POLNO,
          D.MONTHID            TJMONTH,
          P.SALECHNL,
          P.CVALIDATE,
          P.PAYINTV,
          ROUND(P.RPAYINTV, 0) RPAYINTV,
          P.RISKPERIOD,
          P.PREM,
          P.AGENTCODE,
          P.PAYTODATE,
          P.RPAYTODATE,
          P.RPAYENDDATE,
          P.MANAGECOM,
          P.AGENTCOM,
          K.TEAM_ID            TEAMID
     FROM
          DWS_XQ_JXL37JYY_TMP_1_1 P
          JOIN (
               SELECT
                    CAST(INT(MONTHID) AS STRING)        MONTHID,
                    CAST(INT(YEARID) AS STRING)         YEARID,
                    DATE_FORMAT(DATEDATE, 'yyyy-MM-dd') DATEDATE
               FROM
                    ODS.D_DATE
               WHERE
                    DATE_FORMAT(DATEDATE, 'yyyy-MM-dd') = LAST_DAY(DATE_FORMAT(DATEDATE, 'yyyy-MM-dd'))
                    AND DATE_FORMAT(DATEDATE, 'yyyy-MM-dd') <= DATE_ADD(ADD_MONTHS(TRUNC(CURRENT_DATE(), 'YEAR'), 24), -1)
          ) D
          LEFT JOIN ODS.O_XG_T02SALESINFO K
          ON P.AGENTCODE = K.SALES_ID
     WHERE
          DATE_FORMAT(ADD_MONTHS(P.CVALIDATE, 37), 'MM') BETWEEN '01' AND SUBSTR(D.MONTHID, 5, 2)
          AND DATE_FORMAT(ADD_MONTHS(P.CVALIDATE, 37), 'yyyy') <= D.YEARID
     UNION
 --宽末部分
     SELECT
          P.CONTNO,
          P.POLNO,
          D.MONTHID            TJMONTH,
          P.SALECHNL,
          P.CVALIDATE,
          P.PAYINTV,
          ROUND(P.RPAYINTV, 0) RPAYINTV,
          P.RISKPERIOD,
          P.PREM,
          P.AGENTCODE,
          P.PAYTODATE,
          P.RPAYTODATE,
          P.RPAYENDDATE,
          P.MANAGECOM,
          P.AGENTCOM,
          K.TEAM_ID            TEAMID
     FROM
          DWS_XQ_JXL37JYY_TMP_1_1 P
          JOIN (
               SELECT
                    CAST(INT(MONTHID) AS STRING)        MONTHID,
                    CAST(INT(YEARID) AS STRING)         YEARID,
                    DATE_FORMAT(DATEDATE, 'yyyy-MM-dd') DATEDATE
               FROM
                    ODS.D_DATE
               WHERE
                    DATE_FORMAT(DATEDATE, 'yyyy-MM-dd') = LAST_DAY(DATE_FORMAT(DATEDATE, 'yyyy-MM-dd'))
                    AND DATE_FORMAT(DATEDATE, 'yyyy-MM-dd') <= DATE_ADD(ADD_MONTHS(TRUNC(CURRENT_DATE(), 'YEAR'), 24), -1)
          ) D
          LEFT JOIN ODS.O_XG_T02SALESINFO K
          ON P.AGENTCODE = K.SALES_ID
     WHERE
          DATE_FORMAT(ADD_MONTHS(P.CVALIDATE, 38), 'MM') BETWEEN '01' AND SUBSTR(D.MONTHID, 5, 2)
          AND DATE_FORMAT(ADD_MONTHS(P.CVALIDATE, 38), 'yyyy') <= D.YEARID
     UNION
     ALL
 --月缴的部分
     SELECT
          P.CONTNO,
          P.POLNO,
          D.MONTHID            TJMONTH,
          P.SALECHNL,
          P.CVALIDATE,
          P.PAYINTV,
          ROUND(P.RPAYINTV, 0) RPAYINTV,
          P.RISKPERIOD,
          P.PREM,
          P.AGENTCODE,
          P.PAYTODATE,
          P.RPAYTODATE,
          P.RPAYENDDATE,
          P.MANAGECOM,
          P.AGENTCOM,
          K.TEAM_ID            TEAMID
     FROM
          DWS_XQ_JXL37JYY_TMP_1_2 P
          JOIN (
               SELECT
                    CAST(INT(MONTHID) AS STRING)        MONTHID,
                    CAST(INT(YEARID) AS STRING)         YEARID,
                    DATE_FORMAT(DATEDATE, 'yyyy-MM-dd') DATEDATE
               FROM
                    ODS.D_DATE
               WHERE
                    DATE_FORMAT(DATEDATE, 'yyyy-MM-dd') = LAST_DAY(DATE_FORMAT(DATEDATE, 'yyyy-MM-dd'))
                    AND DATE_FORMAT(DATEDATE, 'yyyy-MM-dd') <= DATE_ADD(ADD_MONTHS(TRUNC(CURRENT_DATE(), 'YEAR'), 24), -1)
          ) D
          LEFT JOIN ODS.O_XG_T02SALESINFO K
          ON P.AGENTCODE = K.SALES_ID
     WHERE
          DATE_FORMAT(P.CVALIDATE, 'yyyyMM') <= DATE_FORMAT(DATE_ADD(TRUNC(D.DATEDATE, 'YEAR'), -1), 'yyyyMM');