-- page1
DROP TABLE ZTEST_JXL_37J_CONT_WYDATA;
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
          (
               SELECT
                    *
               FROM
                    DWD.DWD_LCZHZHJXLCOUNT P
               WHERE
                    P.PAYINTV = '年缴'
                    AND P.POLNO <> '21001012055'
                    AND ((P.RISKTYPE <> '短险'
                    AND P.SALECHNL IN ('02', '03'))
                    OR P.SALECHNL NOT IN ('02', '03'))
                    AND P.STATE NOT IN ('理赔终止', '特殊撤件保全')
                    AND NOT EXISTS (
                         SELECT
                              1
                         FROM
                              ODS.LCZHJXLPREMHM      HM
                         WHERE
                              HM.FREEFLAG = '1'
                              AND HM.CONTNO = P.CONTNO
                              AND HM.FREESTARTDATE <= ADD_MONTHS(P.CVALIDATE, 36)
                    )
          )                     P
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
          (
               SELECT
                    *
               FROM
                    DWD.DWD_LCZHZHJXLCOUNT P
               WHERE
                    P.PAYINTV = '年缴'
                    AND P.POLNO <> '21001012055'
                    AND ((P.RISKTYPE <> '短险'
                    AND P.SALECHNL IN ('02', '03'))
                    OR P.SALECHNL NOT IN ('02', '03'))
                    AND P.STATE NOT IN ('理赔终止', '特殊撤件保全')
                    AND NOT EXISTS (
                         SELECT
                              1
                         FROM
                              ODS.LCZHJXLPREMHM      HM
                         WHERE
                              HM.FREEFLAG = '1'
                              AND HM.CONTNO = P.CONTNO
                              AND HM.FREESTARTDATE <= ADD_MONTHS(P.CVALIDATE, 36)
                    )
          )                     P
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
          (
               SELECT
                    *
               FROM
                    DWD.DWD_LCZHZHJXLCOUNT P
               WHERE
                    P.PAYINTV = '年缴'
                    AND P.POLNO <> '21001012055'
                    AND ((P.RISKTYPE <> '短险'
                    AND P.SALECHNL IN ('02', '03'))
                    OR P.SALECHNL NOT IN ('02', '03'))
                    AND P.STATE NOT IN ('理赔终止', '特殊撤件保全')
                    AND NOT EXISTS (
                         SELECT
                              1
                         FROM
                              ODS.LCZHJXLPREMHM      HM
                         WHERE
                              HM.FREEFLAG = '1'
                              AND HM.CONTNO = P.CONTNO
                              AND HM.FREESTARTDATE <= ADD_MONTHS(P.CVALIDATE, 36)
                    )
          )                     P
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
          (
               SELECT
                    *
               FROM
                    DWD.DWD_LCZHZHJXLCOUNT P
               WHERE
                    P.PAYINTV = '月缴'
                    AND P.STATE NOT IN ('理赔终止', '特殊撤件保全')
                    AND P.RISKTYPE <> '短险'
                    AND NOT EXISTS (
                         SELECT
                              1
                         FROM
                              ODS.LCZHJXLPREMHM      HM
                         WHERE
                              HM.FREEFLAG = '1'
                              AND HM.CONTNO = P.CONTNO
                    )
          )                     P
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
-- page2
--年度当月实收日期+实收保费
--2288042
DROP TABLE ZTEST_JXL_37J_CONT_WYM0SS;

CREATE TEMPORARY TABLE ZTEST_JXL_37J_CONT_WYM0SS
AS
    SELECT P.CONTNO,
           P.POLNO,
           P.TJMONTH,
           CASE
               WHEN MAX(P.PAYINTV) = '年缴' AND MAX(P.RPAYINTV) = '0' AND
                    MAX(P.RISKPERIOD) <> 'L' AND SUM(J.SUMACTUPAYMONEY) > 0 THEN
                SUM(J.SUMACTUPAYMONEY)
               WHEN MAX(P.PAYINTV) = '年缴' AND MAX(P.RPAYINTV) = '0' AND
                    MAX(P.RISKPERIOD) <> 'L' AND SUM(J.SUMACTUPAYMONEY) IS NULL THEN
                0
               WHEN MAX(P.PAYINTV) = '年缴' AND MAX(P.RPAYINTV) = '0' AND
                    MAX(P.RISKPERIOD) = 'L' AND MAX(P.PREM) <> '0' THEN
                MAX(P.PREM) * CASE WHEN MAX(J2.ND) IS NULL THEN MAX(J3.ND) ELSE MAX(J2.ND) END
               WHEN MAX(P.PAYINTV) = '年缴' THEN
                CASE WHEN SUM(J.SUMACTUPAYMONEY) IS NULL THEN MAX(P.PREM) ELSE SUM(J.SUMACTUPAYMONEY) END
               ELSE
                0
           END PREM
      FROM (
     SELECT
           *
     FROM
           ZTEST_JXL_37J_CONT_WYDATA P
     WHERE
           P.PAYINTV = '年缴'
          AND DATE_FORMAT(ADD_MONTHS(P.CVALIDATE, 36), 'yyyyMM') <= P.TJMONTH
          AND DATE_FORMAT(P.CVALIDATE, 'MM') BETWEEN '01' AND SUBSTR(P.TJMONTH, 5, 2)
          AND (
               SELECT
                     ROUND(SUM(J1.SUMACTUPAYMONEY),
                    2)
               FROM
                     ODS.O_LIS_LJAPAYPERSON J1
               WHERE
                     J1.CONTNO = P.CONTNO
                    AND ((DATE_FORMAT(J1.LASTPAYTODATE, 'yyyyMM') <= P.TJMONTH
                    AND DATE_FORMAT(J1.LASTPAYTODATE, 'yyyy') = SUBSTR(P.TJMONTH, 0, 4))
                    OR (DATE_FORMAT(ADD_MONTHS(J1.CURPAYTODATE, -12), 'yyyyMM') <= P.TJMONTH
                    AND DATE_FORMAT(ADD_MONTHS(J1.CURPAYTODATE, -12), 'yyyy') = SUBSTR(P.TJMONTH, 0, 4)))
                    AND J1.PAYINTV IN ('0', '12')
                    AND J1.PAYTYPE NOT IN ('ZH', 'YEL')
               GROUP BY
                     J1.CONTNO
          )> 0
)P
   LEFT JOIN(
     SELECT
           J.CONTNO,
          DATE_FORMAT(J.LASTPAYTODATE,
           'yyyyMM') LASTPAYTODATE,
          ROUND(DATEDIFF(MAX(J.CURPAYTODATE),
          MAX(J.LASTPAYTODATE)) / 365) ND
     FROM
           ODS.O_LIS_LJAPAYPERSON J
     WHERE
           J.PAYINTV = '12'
     GROUP BY
           J.CONTNO,
          DATE_FORMAT(J.LASTPAYTODATE, 'yyyyMM')
) J2
   ON J2.CONTNO = P.CONTNO AND J2.LASTPAYTODATE <= P.TJMONTH AND SUBSTR(J2.LASTPAYTODATE, 0, 4)=SUBSTR(P.TJMONTH, 0, 4)
   LEFT JOIN(
     SELECT
           J.CONTNO,
          DATE_FORMAT(ADD_MONTHS(J.CURPAYTODATE,
           -12),
           'yyyyMM') CURPAYTODATE,
          ROUND(DATEDIFF(MAX(J.CURPAYTODATE),
          MAX(J.LASTPAYTODATE)) / 365) ND
     FROM
           ODS.O_LIS_LJAPAYPERSON J
     WHERE
           J.PAYINTV = '12'
     GROUP BY
           J.CONTNO,
          DATE_FORMAT(ADD_MONTHS(J.CURPAYTODATE, -12), 'yyyyMM')
) J3
   ON J3.CONTNO = P.CONTNO AND J3.CURPAYTODATE <= P.TJMONTH AND SUBSTR(J3.CURPAYTODATE, 0, 4)=SUBSTR(P.TJMONTH, 0, 4)
      LEFT JOIN ODS.O_LIS_LJAPAYPERSON J
        ON (P.CONTNO = J.CONTNO AND P.POLNO = J.POLNO AND
           ((DATE_FORMAT(J.LASTPAYTODATE, 'yyyyMM') <= P.TJMONTH AND
           DATE_FORMAT(J.LASTPAYTODATE, 'yyyy') = SUBSTR(P.TJMONTH, 0, 4)) OR
           (DATE_FORMAT(ADD_MONTHS(J.CURPAYTODATE, -12), 'yyyyMM') <= P.TJMONTH AND
           DATE_FORMAT(ADD_MONTHS(J.CURPAYTODATE, -12), 'yyyy') = SUBSTR(P.TJMONTH, 0, 4))) AND
           J.PAYINTV IN ('0', '12') AND J.PAYTYPE NOT IN ('ZH', 'YEL'))
     GROUP BY P.CONTNO, P.POLNO, P.TJMONTH
    UNION ALL
 --月缴件
    SELECT T.CONTNO,
           T.POLNO,
           T.TJMONTH,
 --看统计期间内最后一笔实收记录是什么时候产生的，如果大于等于最后应交日，则按最后应交日的月份数记为计入计算的月数；
 --如果小于最后应交日，如果确认日期的日期值比应交日日期值大，则用确认日期的月份值计入计算的月数，
 --如果。。。小，则用用确认日期的月份值-1计入计算的月数。
           CASE
               WHEN T.CONFDATE >=
                    ADD_MONTHS(T.CVALIDATE,
                               INT(MONTHS_BETWEEN(SUBSTR(TJMONTH, 0, 4)
                                                  ||'-'
                                                  ||SUBSTR(TJMONTH, 5, 2)
                                                    ||'-01',
                                                    TRUNC(CVALIDATE, 'MM')))) THEN
                T.PREM * (DATE_FORMAT(ADD_MONTHS(T.CVALIDATE,
                                             INT(MONTHS_BETWEEN(SUBSTR(TJMONTH, 0, 4)
                                                                ||'-'
                                                                ||SUBSTR(TJMONTH, 5, 2)
                                                                  ||'-01',
                                                                  TRUNC(T.CVALIDATE, 'MM')))),
                                  'MM') + 0)
               ELSE
                CASE
                    WHEN DATE_FORMAT(T.CONFDATE, 'dd') >= DATE_FORMAT(T.CVALIDATE, 'dd') THEN
                     T.PREM * (DATE_FORMAT(ADD_MONTHS(T.CONFDATE, 0), 'MM') + 0)
                    ELSE
                     T.PREM * (DATE_FORMAT(ADD_MONTHS(T.CONFDATE, -1), 'MM') + 0)
                END
           END PREM
      FROM (
     SELECT
           P.CONTNO,
                              P.POLNO,
                              P.TJMONTH,
                              P.PREM,
                              P.CVALIDATE,
                              J.CONFDATE,
                              ROW_NUMBER() OVER(PARTITION BY J.POLNO,
           P.TJMONTH ORDER BY J.CONFDATE DESC) RN
     FROM
           ZTEST_JXL_37J_CONT_WYDATA P
          JOIN ODS.O_LIS_LJAPAYPERSON J
          ON (P.CONTNO = J.CONTNO
          AND P.POLNO = J.POLNO
          AND DATE_FORMAT(J.CONFDATE,
           'yyyy') = SUBSTR(P.TJMONTH,
           0,
           4)
          AND DATE_FORMAT(J.CONFDATE,
           'yyyyMM') <= P.TJMONTH
          AND J.PAYTYPE NOT IN ('ZH',
           'YEL')
          AND J.PAYINTV = '1')
     WHERE
           1 = 1
          AND P.PAYINTV = '月缴'
) T
     WHERE T.RN = 1;
-- page3
--年度当月应收日期+应收保费
--3866314

DROP TABLE ZTEST_JXL_37J_CONT_WYM0YS;

CREATE TEMPORARY TABLE ZTEST_JXL_37J_CONT_WYM0YS
AS
    SELECT P.CONTNO,
           P.POLNO,
           P.TJMONTH,
           CASE
               WHEN MAX(P.CONTNO) = '2019031129156264' THEN
                250000
               WHEN MAX(P.PAYINTV) = '年缴' AND MAX(P.RPAYINTV) = '0' AND
                    MAX(P.RISKPERIOD) <> 'L' AND SUM(J.SUMACTUPAYMONEY) > 0 THEN
                MAX(P.PREM)
               WHEN MAX(P.PAYINTV) = '年缴' AND MAX(P.RPAYINTV) = '0' AND
                    MAX(P.RISKPERIOD) <> 'L' AND SUM(J.SUMACTUPAYMONEY) IS NULL THEN
                0
               WHEN MAX(P.PAYINTV) = '年缴' AND MAX(P.RPAYINTV) = '0' AND
                    MAX(P.RISKPERIOD) = 'L' AND MAX(P.PREM) = 0 THEN
                0
               WHEN MAX(P.PAYINTV) = '年缴' AND MAX(P.RPAYINTV) = '12' AND CASE WHEN MAX(J2.ND) IS NULL THEN MAX(J3.ND) ELSE MAX(J2.ND) END >= 2 THEN
                (CASE
                    WHEN MAX(E.CONTNO) IS NULL THEN
                     SUM(J.SUMACTUPAYMONEY) / CASE WHEN MAX(J2.ND) IS NULL THEN MAX(J3.ND) ELSE MAX(J2.ND) END
                    ELSE
                     0
                END)
               ELSE
                CASE WHEN SUM(J.SUMACTUPAYMONEY) IS NULL THEN MAX(P.PREM) ELSE SUM(J.SUMACTUPAYMONEY) END
           END PREM
      FROM (
     SELECT
           *
     FROM
           ZTEST_JXL_37J_CONT_WYDATA P
     WHERE
           P.PAYINTV = '年缴'
          AND DATE_FORMAT(ADD_MONTHS(P.CVALIDATE, 36), 'yyyyMM') <= P.TJMONTH
          AND DATE_FORMAT(P.CVALIDATE, 'MM') BETWEEN '01' AND SUBSTR(P.TJMONTH, 5, 2)
          AND (
               SELECT
                     ROUND(SUM(J1.SUMACTUPAYMONEY),
                    2)
               FROM
                     ODS.O_LIS_LJAPAYPERSON J1
               WHERE
                     J1.CONTNO = P.CONTNO
                    AND ((DATE_FORMAT(ADD_MONTHS(J1.LASTPAYTODATE, 12), 'yyyy') = SUBSTR(P.TJMONTH, 0, 4)
                    AND DATE_FORMAT(ADD_MONTHS(J1.LASTPAYTODATE, 12), 'yyyyMM') <= P.TJMONTH
                    AND DATE_FORMAT(ADD_MONTHS(J1.CURPAYTODATE, -12), 'yyyyMM') NOT BETWEEN SUBSTR(P.TJMONTH, 0, 4)
                                                                                            || '01'
                    AND P.TJMONTH)
                    OR DATE_FORMAT(J1.CURPAYTODATE, 'yyyyMM') BETWEEN SUBSTR(P.TJMONTH, 0, 4)
                                                                      || '01'
                    AND P.TJMONTH)
                    AND J1.PAYTYPE NOT IN ('ZH', 'YEL')
               GROUP BY
                     J1.CONTNO
          )> 0
)P
   LEFT JOIN(
     SELECT
           J.CONTNO,
          J.POLNO,
          DATE_FORMAT(ADD_MONTHS(J.LASTPAYTODATE,
           12),
           'yyyyMM') LASTPAYTODATE,
          ROUND(DATEDIFF(MAX(J.CURPAYTODATE),
          MAX(J.LASTPAYTODATE)) / 365) ND
     FROM
           ODS.O_LIS_LJAPAYPERSON J
     WHERE
           J.PAYINTV = '12'
     GROUP BY
           J.CONTNO,
          J.POLNO,
          DATE_FORMAT(ADD_MONTHS(J.LASTPAYTODATE, 12), 'yyyyMM')
) J2
   ON J2.CONTNO = P.CONTNO AND J2.POLNO = P.POLNO AND J2.LASTPAYTODATE BETWEEN SUBSTR(P.TJMONTH, 0, 4)
                                                                               || '01' AND P.TJMONTH
   LEFT JOIN(
     SELECT
           J.CONTNO,
          J.POLNO,
          DATE_FORMAT(J.CURPAYTODATE,
           'yyyyMM') CURPAYTODATE,
          ROUND(DATEDIFF(MAX(J.CURPAYTODATE),
          MAX(J.LASTPAYTODATE)) / 365) ND
     FROM
           ODS.O_LIS_LJAPAYPERSON J
     WHERE
           J.PAYINTV = '12'
     GROUP BY
           J.CONTNO,
          J.POLNO,
          DATE_FORMAT(J.CURPAYTODATE, 'yyyyMM')
) J3
   ON J3.CONTNO = P.CONTNO AND J3.POLNO = P.POLNO AND J3.CURPAYTODATE BETWEEN SUBSTR(P.TJMONTH, 0, 4)
                                                                              || '01' AND P.TJMONTH
      LEFT JOIN ODS.O_LIS_LJAPAYPERSON J
        ON (P.CONTNO = J.CONTNO AND P.POLNO = J.POLNO AND
           ((DATE_FORMAT(ADD_MONTHS(J.LASTPAYTODATE, 12), 'yyyy') = SUBSTR(P.TJMONTH, 0, 4) AND
           DATE_FORMAT(ADD_MONTHS(J.LASTPAYTODATE, 12), 'yyyyMM') <= P.TJMONTH AND
           DATE_FORMAT(ADD_MONTHS(J.CURPAYTODATE, -12), 'yyyyMM') NOT BETWEEN
           SUBSTR(P.TJMONTH, 0, 4)
           || '01' AND P.TJMONTH) OR
           DATE_FORMAT(J.CURPAYTODATE, 'yyyyMM') BETWEEN SUBSTR(P.TJMONTH, 0, 4)
                                                         || '01' AND
           P.TJMONTH) AND J.PAYINTV <> '1' AND J.PAYTYPE NOT IN ('ZH', 'YEL'))
 LEFT JOIN (
     SELECT
           E.CONTNO,
          MAX(DATE_FORMAT(E.EDORVALIDATE,
           'yyyyMM')) EDORVALIDATE
     FROM
           ODS.O_LIS_LPEDORITEM E
     WHERE
           E.EDORTYPE = 'FX'
          AND E.EDORSTATE = '0'
     GROUP BY
           E.CONTNO
) E
 ON E.CONTNO = P.CONTNO AND E.EDORVALIDATE > P.TJMONTH
     WHERE NOT EXISTS (
     SELECT
           1
     FROM
           DWD.DWD_LCZHZHJXLCOUNT PP
     WHERE
           PP.PAYTODATE = PP.RPAYENDDATE
          AND PP.RPAYINTV NOT IN ('0', '1')
          AND PP.RISKPERIOD = 'L'
          AND DATE_FORMAT(PP.PAYTODATE, 'yyyyMM') BETWEEN SUBSTR(P.TJMONTH, 0, 4)
                                                          || '01' AND P.TJMONTH
          AND PP.CONTNO = P.CONTNO
)
     GROUP BY P.CONTNO, P.POLNO, P.TJMONTH
    UNION ALL
 --月缴
    SELECT P.CONTNO,
           P.POLNO,
           P.TJMONTH,
           CASE
 --因为是算到截至月底的指标，都在应交日之后
               WHEN ((P.RPAYTODATE <> P.RPAYENDDATE) OR
                    (P.RPAYTODATE = P.PAYTODATE AND
                    P.RPAYTODATE >= LAST_DAY(SUBSTR(P.TJMONTH, 0, 4)
                                             ||'-'
                                             ||SUBSTR(P.TJMONTH, 5, 2)
                                               ||'-01')))
 --如果统计日期在应交日之后，则用统计日期月份值x与开始计入应收月份值y比较，
 --如果x-y+1>0，则年度应收为x-y+1个月保费
                    AND (SUBSTR(P.TJMONTH, 5, 2) + 1 >= R.MONTHID) THEN
                P.PREM * (SUBSTR(P.TJMONTH, 5, 2) + 1 - R.MONTHID)
               ELSE
                0
           END PREM
      FROM ZTEST_JXL_37J_CONT_WYDATA P
      LEFT JOIN DWD.DWD_XQ_FACT_JXLM0YS_RULE R
        ON (P.POLNO = R.POLNO AND P.CONTNO = R.CONTNO AND R.FLAG = 'Y' AND
           R.YEARID = SUBSTR(P.TJMONTH, 0, 4))
     WHERE P.PAYINTV = '月缴';
-- page4
--年度宽一实收日期+实收保费
--2268513
DROP TABLE ZTEST_JXL_37J_CONT_WYM1SS;

CREATE TEMPORARY TABLE ZTEST_JXL_37J_CONT_WYM1SS
AS
    SELECT P.CONTNO,
           P.POLNO,
           P.TJMONTH,
           CASE
               WHEN MAX(P.PAYINTV) = '年缴' AND MAX(P.RPAYINTV) = '0' AND
                    MAX(P.RISKPERIOD) <> 'L' AND SUM(J.SUMACTUPAYMONEY) > 0 THEN
                SUM(J.SUMACTUPAYMONEY)
               WHEN MAX(P.PAYINTV) = '年缴' AND MAX(P.RPAYINTV) = '0' AND
                    MAX(P.RISKPERIOD) <> 'L' AND SUM(J.SUMACTUPAYMONEY) IS NULL THEN
                0
               WHEN MAX(P.PAYINTV) = '年缴' AND MAX(P.RPAYINTV) = '0' AND
                    MAX(P.RISKPERIOD) = 'L' AND MAX(P.PREM) <> '0' THEN
                MAX(P.PREM) * CASE WHEN MAX(J2.ND) IS NULL THEN MAX(J3.ND) ELSE MAX(J2.ND) END
               WHEN MAX(P.PAYINTV) = '年缴' THEN
                CASE WHEN SUM(J.SUMACTUPAYMONEY) IS NULL THEN MAX(P.PREM) ELSE SUM(J.SUMACTUPAYMONEY) END
               ELSE
                0
           END PREM
      FROM (
     SELECT
           *
     FROM
           ZTEST_JXL_37J_CONT_WYDATA P
     WHERE
           P.PAYINTV = '年缴'
          AND DATE_FORMAT(ADD_MONTHS(P.CVALIDATE, 37), 'yyyyMM') <= P.TJMONTH
          AND DATE_FORMAT(ADD_MONTHS(P.CVALIDATE, 1), 'MM') BETWEEN '01' AND SUBSTR(P.TJMONTH, 5, 2)
          AND (
               SELECT
                     ROUND(SUM(J1.SUMACTUPAYMONEY),
                    2)
               FROM
                     ODS.O_LIS_LJAPAYPERSON J1
               WHERE
                     J1.CONTNO = P.CONTNO
                    AND ((DATE_FORMAT(ADD_MONTHS(J1.LASTPAYTODATE, 1), 'yyyyMM') <= P.TJMONTH
                    AND DATE_FORMAT(ADD_MONTHS(J1.LASTPAYTODATE, 1), 'yyyy') = SUBSTR(P.TJMONTH, 0, 4))
                    OR (DATE_FORMAT(ADD_MONTHS(J1.CURPAYTODATE, -11), 'yyyyMM') <= P.TJMONTH
                    AND DATE_FORMAT(ADD_MONTHS(J1.CURPAYTODATE, -11), 'yyyy') = SUBSTR(P.TJMONTH, 0, 4)))
                    AND J1.PAYINTV <> '1'
                    AND J1.PAYTYPE NOT IN ('ZH', 'YEL')
               GROUP BY
                     J1.CONTNO
          )> 0
)P
   LEFT JOIN(
     SELECT
           J.CONTNO,
          DATE_FORMAT(ADD_MONTHS(J.LASTPAYTODATE,
           1),
           'yyyyMM') LASTPAYTODATE,
          ROUND(DATEDIFF(MAX(J.CURPAYTODATE),
          MAX(J.LASTPAYTODATE)) / 365) ND
     FROM
           ODS.O_LIS_LJAPAYPERSON J
     WHERE
           J.PAYINTV = '12'
     GROUP BY
           J.CONTNO,
          DATE_FORMAT(ADD_MONTHS(J.LASTPAYTODATE, 1), 'yyyyMM')
) J2
   ON J2.CONTNO = P.CONTNO AND J2.LASTPAYTODATE <= P.TJMONTH AND SUBSTR(J2.LASTPAYTODATE, 0, 4)=SUBSTR(P.TJMONTH, 0, 4)
   LEFT JOIN(
     SELECT
           J.CONTNO,
          DATE_FORMAT(ADD_MONTHS(J.CURPAYTODATE,
           -11),
           'yyyyMM') CURPAYTODATE,
          ROUND(DATEDIFF(MAX(J.CURPAYTODATE),
          MAX(J.LASTPAYTODATE)) / 365) ND
     FROM
           ODS.O_LIS_LJAPAYPERSON J
     WHERE
           J.PAYINTV = '12'
     GROUP BY
           J.CONTNO,
          DATE_FORMAT(ADD_MONTHS(J.CURPAYTODATE, -11), 'yyyyMM')
) J3
   ON J3.CONTNO = P.CONTNO AND J3.CURPAYTODATE <= P.TJMONTH AND SUBSTR(J3.CURPAYTODATE, 0, 4)=SUBSTR(P.TJMONTH, 0, 4)
      LEFT JOIN ODS.O_LIS_LJAPAYPERSON J
        ON (P.CONTNO = J.CONTNO AND P.POLNO = J.POLNO AND
           ((DATE_FORMAT(ADD_MONTHS(J.LASTPAYTODATE, 1), 'yyyyMM') <= P.TJMONTH AND
           DATE_FORMAT(ADD_MONTHS(J.LASTPAYTODATE, 1), 'yyyy') = SUBSTR(P.TJMONTH, 0, 4)) OR
           (DATE_FORMAT(ADD_MONTHS(J.CURPAYTODATE, -11), 'yyyyMM') <= P.TJMONTH AND
           DATE_FORMAT(ADD_MONTHS(J.CURPAYTODATE, -11), 'yyyy') = SUBSTR(P.TJMONTH, 0, 4))) AND
           J.PAYINTV <> '1' AND J.PAYTYPE NOT IN ('ZH', 'YEL'))
     GROUP BY P.CONTNO, P.POLNO, P.TJMONTH
    UNION ALL
 --月缴件
    SELECT T.CONTNO,
           T.POLNO,
           T.TJMONTH,
 --看统计期间内最后一笔实收记录是什么时候产生的，如果大于等于最后应交日，则按最后应交日的月份数记为计入计算的月数；
 --如果小于最后应交日，如果确认日期的日期值比应交日日期值大，则用确认日期的月份值计入计算的月数，
 --如果。。。小，则用用确认日期的月份值-1计入计算的月数。
           CASE
               WHEN T.CONFDATE >=
                    ADD_MONTHS(T.CVALIDATE,
                               INT(MONTHS_BETWEEN(SUBSTR(TJMONTH, 0, 4)
                                                  ||'-'
                                                  ||SUBSTR(TJMONTH, 5, 2)
                                                    ||'-01',
                                                    TRUNC(CVALIDATE, 'MM')))-1) THEN
                T.PREM * (DATE_FORMAT(ADD_MONTHS(T.CVALIDATE,
                                             INT(MONTHS_BETWEEN(SUBSTR(TJMONTH, 0, 4)
                                                                ||'-'
                                                                ||SUBSTR(TJMONTH, 5, 2)
                                                                  ||'-01',
                                                                  TRUNC(T.CVALIDATE, 'MM')))),
                                  'MM') + 0)
               ELSE
                CASE
                    WHEN DATE_FORMAT(T.CONFDATE, 'dd') >= DATE_FORMAT(T.CVALIDATE, 'dd') THEN
                     T.PREM * (DATE_FORMAT(ADD_MONTHS(T.CONFDATE, 1), 'MM') + 0)
                    ELSE
                     T.PREM * (DATE_FORMAT(ADD_MONTHS(T.CONFDATE, 0), 'MM') + 0)
                END
           END PREM
      FROM (
     SELECT
           P.CONTNO,
                              P.POLNO,
                              P.TJMONTH,
                              P.PREM,
                              P.CVALIDATE,
                              J.CONFDATE,
                              ROW_NUMBER() OVER(PARTITION BY J.POLNO,
           P.TJMONTH ORDER BY J.CONFDATE DESC) RN
     FROM
           ZTEST_JXL_37J_CONT_WYDATA P
          JOIN ODS.O_LIS_LJAPAYPERSON J
          ON (P.CONTNO = J.CONTNO
          AND P.POLNO = J.POLNO
          AND DATE_FORMAT(ADD_MONTHS(J.CONFDATE,
           1),
           'yyyy') = SUBSTR(P.TJMONTH,
           0,
           4)
          AND DATE_FORMAT(ADD_MONTHS(J.CONFDATE,
           1),
           'yyyyMM') <= P.TJMONTH
          AND J.PAYTYPE NOT IN ('ZH',
           'YEL')
          AND J.PAYINTV = '1')
     WHERE
           1 = 1
          AND P.PAYINTV = '月缴'
) T
     WHERE T.RN = 1;
-- page5
--年度宽一应收日期+应收保费
--3760211
DROP TABLE ZTEST_JXL_37J_CONT_WYM1YS;

CREATE TEMPORARY TABLE ZTEST_JXL_37J_CONT_WYM1YS
AS
    SELECT P.CONTNO,
           P.POLNO,
           P.TJMONTH,
           CASE
               WHEN MAX(P.CONTNO) = '2019031129156264' THEN
                250000
               WHEN MAX(P.PAYINTV) = '年缴' AND MAX(P.RPAYINTV) = '0' AND
                    MAX(P.RISKPERIOD) <> 'L' AND SUM(J.SUMACTUPAYMONEY) > 0 THEN
                MAX(P.PREM)
               WHEN MAX(P.PAYINTV) = '年缴' AND MAX(P.RPAYINTV) = '0' AND
                    MAX(P.RISKPERIOD) <> 'L' AND SUM(J.SUMACTUPAYMONEY) IS NULL THEN
                0
               WHEN MAX(P.PAYINTV) = '年缴' AND MAX(P.RPAYINTV) = '0' AND
                    MAX(P.RISKPERIOD) = 'L' AND MAX(P.PREM) = 0 THEN
                0
               WHEN MAX(P.PAYINTV) = '年缴' AND MAX(P.RPAYINTV) = '12' AND CASE WHEN MAX(J2.ND) IS NULL THEN MAX(J3.ND) ELSE MAX(J2.ND) END >= 2 THEN
                (CASE
                    WHEN MAX(E.CONTNO) IS NULL THEN
                     SUM(J.SUMACTUPAYMONEY) / CASE WHEN MAX(J2.ND) IS NULL THEN MAX(J3.ND) ELSE MAX(J2.ND) END
                    ELSE
                     0
                END)
               ELSE
                CASE WHEN SUM(J.SUMACTUPAYMONEY) IS NULL THEN MAX(P.PREM) ELSE SUM(J.SUMACTUPAYMONEY) END
           END PREM
      FROM (
     SELECT
           *
     FROM
           ZTEST_JXL_37J_CONT_WYDATA P
     WHERE
           P.PAYINTV = '年缴'
          AND DATE_FORMAT(ADD_MONTHS(P.CVALIDATE, 37), 'yyyyMM') <= P.TJMONTH
          AND DATE_FORMAT(ADD_MONTHS(P.CVALIDATE, 1), 'MM') BETWEEN '01' AND SUBSTR(P.TJMONTH, 5, 2)
          AND (
               SELECT
                     ROUND(SUM(J1.SUMACTUPAYMONEY),
                    2)
               FROM
                     ODS.O_LIS_LJAPAYPERSON J1
               WHERE
                     J1.CONTNO = P.CONTNO
                    AND ((DATE_FORMAT(ADD_MONTHS(J1.LASTPAYTODATE, 13), 'yyyy') = SUBSTR(P.TJMONTH, 0, 4)
                    AND DATE_FORMAT(ADD_MONTHS(J1.LASTPAYTODATE, 13), 'yyyyMM') <= P.TJMONTH
                    AND DATE_FORMAT(ADD_MONTHS(J1.CURPAYTODATE, -11), 'yyyyMM') NOT BETWEEN SUBSTR(P.TJMONTH, 0, 4)
                                                                                            || '01'
                    AND P.TJMONTH)
                    OR DATE_FORMAT(ADD_MONTHS(J1.CURPAYTODATE, 1), 'yyyyMM') BETWEEN SUBSTR(P.TJMONTH, 0, 4)
                                                                                     || '01'
                    AND P.TJMONTH)
                    AND J1.PAYTYPE NOT IN ('ZH', 'YEL')
               GROUP BY
                     J1.CONTNO
          )> 0
)P
      LEFT JOIN(
     SELECT
           J.CONTNO,
          J.POLNO,
          DATE_FORMAT(ADD_MONTHS(J.LASTPAYTODATE,
           13),
           'yyyyMM') LASTPAYTODATE,
          ROUND(DATEDIFF(MAX(J.CURPAYTODATE),
          MAX(J.LASTPAYTODATE)) / 365) ND
     FROM
           ODS.O_LIS_LJAPAYPERSON J
     WHERE
           J.PAYINTV = '12'
     GROUP BY
           J.CONTNO,
          J.POLNO,
          DATE_FORMAT(ADD_MONTHS(J.LASTPAYTODATE, 13), 'yyyyMM')
) J2
   ON J2.CONTNO = P.CONTNO AND J2.POLNO = P.POLNO AND J2.LASTPAYTODATE BETWEEN SUBSTR(P.TJMONTH, 0, 4)
                                                                               || '01' AND P.TJMONTH
   LEFT JOIN(
     SELECT
           J.CONTNO,
          J.POLNO,
          DATE_FORMAT(ADD_MONTHS(J.CURPAYTODATE,
           1),
           'yyyyMM') CURPAYTODATE,
          ROUND(DATEDIFF(MAX(J.CURPAYTODATE),
          MAX(J.LASTPAYTODATE)) / 365) ND
     FROM
           ODS.O_LIS_LJAPAYPERSON J
     WHERE
           J.PAYINTV = '12'
     GROUP BY
           J.CONTNO,
          J.POLNO,
          DATE_FORMAT(ADD_MONTHS(J.CURPAYTODATE, 1), 'yyyyMM')
) J3
   ON J3.CONTNO = P.CONTNO AND J3.POLNO = P.POLNO AND J3.CURPAYTODATE BETWEEN SUBSTR(P.TJMONTH, 0, 4)
                                                                              || '01' AND P.TJMONTH
      LEFT JOIN ODS.O_LIS_LJAPAYPERSON J
        ON (P.CONTNO = J.CONTNO AND P.POLNO = J.POLNO AND
           ((DATE_FORMAT(ADD_MONTHS(J.LASTPAYTODATE, 13), 'yyyy') = SUBSTR(P.TJMONTH, 0, 4) AND
           DATE_FORMAT(ADD_MONTHS(J.LASTPAYTODATE, 13), 'yyyyMM') <= P.TJMONTH AND
           DATE_FORMAT(ADD_MONTHS(J.CURPAYTODATE, -11), 'yyyyMM') NOT BETWEEN
           SUBSTR(P.TJMONTH, 0, 4)
           || '01' AND P.TJMONTH) OR
           DATE_FORMAT(ADD_MONTHS(J.CURPAYTODATE, 1), 'yyyyMM') BETWEEN
           SUBSTR(P.TJMONTH, 0, 4)
           || '01' AND P.TJMONTH) AND J.PAYINTV <> '1' AND
           J.PAYTYPE NOT IN ('ZH', 'YEL'))
 LEFT JOIN (
     SELECT
           E.CONTNO,
          MAX(DATE_FORMAT(E.EDORVALIDATE,
           'yyyyMM')) EDORVALIDATE
     FROM
           ODS.O_LIS_LPEDORITEM E
     WHERE
           E.EDORTYPE = 'FX'
          AND E.EDORSTATE = '0'
     GROUP BY
           E.CONTNO
) E
 ON E.CONTNO = P.CONTNO AND E.EDORVALIDATE > P.TJMONTH
     WHERE NOT EXISTS (
     SELECT
           1
     FROM
           DWD.DWD_LCZHZHJXLCOUNT PP
     WHERE
           PP.PAYTODATE = PP.RPAYENDDATE
          AND PP.RPAYINTV NOT IN ('0', '1')
          AND PP.RISKPERIOD = 'L'
          AND DATE_FORMAT(ADD_MONTHS(PP.PAYTODATE, 1), 'yyyyMM') BETWEEN SUBSTR(P.TJMONTH, 0, 4)
                                                                         || '01' AND P.TJMONTH
          AND PP.CONTNO = P.CONTNO
)
     GROUP BY P.CONTNO, P.POLNO, P.TJMONTH
    UNION ALL
 --月缴
    SELECT P.CONTNO,
           P.POLNO,
           P.TJMONTH,
           CASE
 --因为是算到截至月底的指标，都在应交日之后
               WHEN ((P.RPAYTODATE <> P.RPAYENDDATE) OR
                    (P.RPAYTODATE = P.PAYTODATE AND
                    P.RPAYTODATE >= LAST_DAY(SUBSTR(P.TJMONTH, 0, 4)
                                             ||'-'
                                             ||SUBSTR(P.TJMONTH, 5, 2)
                                               ||'-01')))
 --如果统计日期在应交日之后，则用统计日期月份值x与开始计入应收月份值y比较，
 --如果x-y+1>0，则年度应收为x-y+1个月保费
                    AND (SUBSTR(P.TJMONTH, 5, 2) + 1 >= R.MONTHID) THEN
                P.PREM * (SUBSTR(P.TJMONTH, 5, 2) + 1 - R.MONTHID)
               ELSE
                0
           END PREM
      FROM ZTEST_JXL_37J_CONT_WYDATA P
      LEFT JOIN DWD.DWD_XQ_FACT_JXLM0YS_RULE R
        ON (P.POLNO = R.POLNO AND P.CONTNO = R.CONTNO AND R.FLAG = 'Y' AND
           R.YEARID = SUBSTR(P.TJMONTH, 0, 4))
     WHERE P.PAYINTV = '月缴';
-- page6
--年度宽末实收日期+实收保费
--2232209
DROP TABLE ZTEST_JXL_37J_CONT_WYM2SS;

CREATE TEMPORARY TABLE ZTEST_JXL_37J_CONT_WYM2SS
AS
    SELECT P.CONTNO,
           P.POLNO,
           P.TJMONTH,
           CASE
               WHEN MAX(P.PAYINTV) = '年缴' AND MAX(P.RPAYINTV) = '0' AND
                    MAX(P.RISKPERIOD) <> 'L' AND SUM(J.SUMACTUPAYMONEY) > 0 THEN
                SUM(J.SUMACTUPAYMONEY)
               WHEN MAX(P.PAYINTV) = '年缴' AND MAX(P.RPAYINTV) = '0' AND
                    MAX(P.RISKPERIOD) <> 'L' AND SUM(J.SUMACTUPAYMONEY) IS NULL THEN
                0
               WHEN MAX(P.PAYINTV) = '年缴' AND MAX(P.RPAYINTV) = '0' AND
                    MAX(P.RISKPERIOD) = 'L' AND MAX(P.PREM) <> '0' THEN
                MAX(P.PREM) * CASE WHEN MAX(J2.ND) IS NULL THEN MAX(J3.ND) ELSE MAX(J2.ND) END
               WHEN MAX(P.PAYINTV) = '年缴' THEN
                CASE WHEN SUM(J.SUMACTUPAYMONEY) IS NULL THEN MAX(P.PREM) ELSE SUM(J.SUMACTUPAYMONEY) END
               ELSE
                0
           END PREM
      FROM (
     SELECT
           *
     FROM
           ZTEST_JXL_37J_CONT_WYDATA P
     WHERE
           P.PAYINTV = '年缴'
          AND DATE_FORMAT(ADD_MONTHS(P.CVALIDATE, 38), 'yyyyMM') <= P.TJMONTH
          AND DATE_FORMAT(ADD_MONTHS(P.CVALIDATE, 2), 'MM') BETWEEN '01' AND SUBSTR(P.TJMONTH, 5, 2)
          AND (
               SELECT
                     ROUND(SUM(J1.SUMACTUPAYMONEY),
                    2)
               FROM
                     ODS.O_LIS_LJAPAYPERSON J1
               WHERE
                     J1.CONTNO = P.CONTNO
                    AND ((DATE_FORMAT(ADD_MONTHS(J1.LASTPAYTODATE, 2), 'yyyyMM') <= P.TJMONTH
                    AND DATE_FORMAT(ADD_MONTHS(J1.LASTPAYTODATE, 2), 'yyyy') = SUBSTR(P.TJMONTH, 0, 4))
                    OR (DATE_FORMAT(ADD_MONTHS(J1.CURPAYTODATE, -10), 'yyyyMM') <= P.TJMONTH
                    AND DATE_FORMAT(ADD_MONTHS(J1.CURPAYTODATE, -10), 'yyyy') = SUBSTR(P.TJMONTH, 0, 4)))
                    AND J1.PAYINTV <> '1'
                    AND J1.PAYTYPE NOT IN ('ZH', 'YEL')
               GROUP BY
                     J1.CONTNO
          )> 0
)P
      LEFT JOIN(
     SELECT
           J.CONTNO,
          DATE_FORMAT(ADD_MONTHS(J.LASTPAYTODATE,
           2),
           'yyyyMM') LASTPAYTODATE,
          ROUND(DATEDIFF(MAX(J.CURPAYTODATE),
          MAX(J.LASTPAYTODATE)) / 365) ND
     FROM
           ODS.O_LIS_LJAPAYPERSON J
     WHERE
           J.PAYINTV = '12'
     GROUP BY
           J.CONTNO,
          DATE_FORMAT(ADD_MONTHS(J.LASTPAYTODATE, 2), 'yyyyMM')
) J2
   ON J2.CONTNO = P.CONTNO AND J2.LASTPAYTODATE <= P.TJMONTH AND SUBSTR(J2.LASTPAYTODATE, 0, 4)=SUBSTR(P.TJMONTH, 0, 4)
   LEFT JOIN(
     SELECT
           J.CONTNO,
          DATE_FORMAT(ADD_MONTHS(J.CURPAYTODATE,
           -10),
           'yyyyMM') CURPAYTODATE,
          ROUND(DATEDIFF(MAX(J.CURPAYTODATE),
          MAX(J.LASTPAYTODATE)) / 365) ND
     FROM
           ODS.O_LIS_LJAPAYPERSON J
     WHERE
           J.PAYINTV = '12'
     GROUP BY
           J.CONTNO,
          DATE_FORMAT(ADD_MONTHS(J.CURPAYTODATE, -10), 'yyyyMM')
) J3
   ON J3.CONTNO = P.CONTNO AND J3.CURPAYTODATE <= P.TJMONTH AND SUBSTR(J3.CURPAYTODATE, 0, 4)=SUBSTR(P.TJMONTH, 0, 4)
      LEFT JOIN ODS.O_LIS_LJAPAYPERSON J
        ON (P.CONTNO = J.CONTNO AND P.POLNO = J.POLNO AND
           ((DATE_FORMAT(ADD_MONTHS(J.LASTPAYTODATE, 2), 'yyyyMM') <= P.TJMONTH AND
           DATE_FORMAT(ADD_MONTHS(J.LASTPAYTODATE, 2), 'yyyy') = SUBSTR(P.TJMONTH, 0, 4)) OR
           (DATE_FORMAT(ADD_MONTHS(J.CURPAYTODATE, -10), 'yyyyMM') <= P.TJMONTH AND
           DATE_FORMAT(ADD_MONTHS(J.CURPAYTODATE, -10), 'yyyy') = SUBSTR(P.TJMONTH, 0, 4))) AND
           J.PAYINTV <> '1' AND J.PAYTYPE NOT IN ('ZH', 'YEL'))
     GROUP BY P.CONTNO, P.POLNO, P.TJMONTH
    UNION ALL
 --月缴件
    SELECT T.CONTNO,
           T.POLNO,
           T.TJMONTH,
 --看统计期间内最后一笔实收记录是什么时候产生的，如果大于等于最后应交日，则按最后应交日的月份数记为计入计算的月数；
 --如果小于最后应交日，如果确认日期的日期值比应交日日期值大，则用确认日期的月份值计入计算的月数，
 --如果。。。小，则用用确认日期的月份值-1计入计算的月数。
           CASE
               WHEN T.CONFDATE >=
                    ADD_MONTHS(T.CVALIDATE,
                               INT(MONTHS_BETWEEN(SUBSTR(TJMONTH, 0, 4)
                                                  ||'-'
                                                  ||SUBSTR(TJMONTH, 5, 2)
                                                    ||'-01',
                                                    TRUNC(CVALIDATE, 'MM')))-2) THEN
                T.PREM * (DATE_FORMAT(ADD_MONTHS(T.CVALIDATE,
                                             INT(MONTHS_BETWEEN(SUBSTR(TJMONTH, 0, 4)
                                                                ||'-'
                                                                ||SUBSTR(TJMONTH, 5, 2)
                                                                  ||'-01',
                                                                  TRUNC(T.CVALIDATE, 'MM')))),
                                  'MM') + 0)
               ELSE
                CASE
                    WHEN DATE_FORMAT(T.CONFDATE, 'dd') >= DATE_FORMAT(T.CVALIDATE, 'dd') THEN
                     T.PREM * (DATE_FORMAT(ADD_MONTHS(T.CONFDATE, 2), 'MM') + 0)
                    ELSE
                     T.PREM * (DATE_FORMAT(ADD_MONTHS(T.CONFDATE, 1), 'MM') + 0)
                END
           END PREM
      FROM (
     SELECT
           P.CONTNO,
                              P.POLNO,
                              P.TJMONTH,
                              P.PREM,
                              P.CVALIDATE,
                              J.CONFDATE,
                              ROW_NUMBER() OVER(PARTITION BY J.POLNO,
           P.TJMONTH ORDER BY J.CONFDATE DESC) RN
     FROM
           ZTEST_JXL_37J_CONT_WYDATA P
          JOIN ODS.O_LIS_LJAPAYPERSON J
          ON (P.CONTNO = J.CONTNO
          AND P.POLNO = J.POLNO
          AND DATE_FORMAT(ADD_MONTHS(J.CONFDATE,
           2),
           'yyyy') = SUBSTR(P.TJMONTH,
           0,
           4)
          AND DATE_FORMAT(ADD_MONTHS(J.CONFDATE,
           2),
           'yyyyMM') <= P.TJMONTH
          AND J.PAYTYPE NOT IN ('ZH',
           'YEL')
          AND J.PAYINTV = '1')
     WHERE
           1 = 1
          AND P.PAYINTV = '月缴'
) T
     WHERE T.RN = 1;
-- page7
--年度宽末应收日期+应收保费
--3677445
DROP TABLE ZTEST_JXL_37J_CONT_WYM2YS;

CREATE TEMPORARY TABLE ZTEST_JXL_37J_CONT_WYM2YS
AS
    SELECT P.CONTNO,
           P.POLNO,
           P.TJMONTH,
           CASE
               WHEN MAX(P.CONTNO) = '2019031129156264' THEN
                250000
               WHEN MAX(P.PAYINTV) = '年缴' AND MAX(P.RPAYINTV) = '0' AND
                    MAX(P.RISKPERIOD) <> 'L' AND SUM(J.SUMACTUPAYMONEY) > 0 THEN
                MAX(P.PREM)
               WHEN MAX(P.PAYINTV) = '年缴' AND MAX(P.RPAYINTV) = '0' AND
                    MAX(P.RISKPERIOD) <> 'L' AND SUM(J.SUMACTUPAYMONEY) IS NULL THEN
                0
               WHEN MAX(P.PAYINTV) = '年缴' AND MAX(P.RPAYINTV) = '0' AND
                    MAX(P.RISKPERIOD) = 'L' AND MAX(P.PREM) = 0 THEN
                0
               WHEN MAX(P.PAYINTV) = '年缴' AND MAX(P.RPAYINTV) = '12' AND CASE WHEN MAX(J2.ND) IS NULL THEN MAX(J3.ND) ELSE MAX(J2.ND) END >= 2 THEN
                (CASE
                    WHEN MAX(E.CONTNO) IS NULL THEN
                     SUM(J.SUMACTUPAYMONEY) / CASE WHEN MAX(J2.ND) IS NULL THEN MAX(J3.ND) ELSE MAX(J2.ND) END
                    ELSE
                     0
                END)
               ELSE
                CASE WHEN SUM(J.SUMACTUPAYMONEY) IS NULL THEN MAX(P.PREM) ELSE SUM(J.SUMACTUPAYMONEY) END
           END PREM
      FROM (
     SELECT
           *
     FROM
           ZTEST_JXL_37J_CONT_WYDATA P
     WHERE
           P.PAYINTV = '年缴'
          AND DATE_FORMAT(ADD_MONTHS(P.CVALIDATE, 38), 'yyyyMM') <= P.TJMONTH
          AND DATE_FORMAT(ADD_MONTHS(P.CVALIDATE, 2), 'MM') BETWEEN '01' AND SUBSTR(P.TJMONTH, 5, 2)
          AND (
               SELECT
                     ROUND(SUM(J1.SUMACTUPAYMONEY),
                    2)
               FROM
                     ODS.O_LIS_LJAPAYPERSON J1
               WHERE
                     J1.CONTNO = P.CONTNO
                    AND ((DATE_FORMAT(ADD_MONTHS(J1.LASTPAYTODATE, 14), 'yyyy') = SUBSTR(P.TJMONTH, 0, 4)
                    AND DATE_FORMAT(ADD_MONTHS(J1.LASTPAYTODATE, 14), 'yyyyMM') <= P.TJMONTH
                    AND DATE_FORMAT(ADD_MONTHS(J1.CURPAYTODATE, -10), 'yyyyMM') NOT BETWEEN SUBSTR(P.TJMONTH, 0, 4)
                                                                                            || '01'
                    AND P.TJMONTH)
                    OR DATE_FORMAT(ADD_MONTHS(J1.CURPAYTODATE, 2), 'yyyyMM') BETWEEN SUBSTR(P.TJMONTH, 0, 4)
                                                                                     || '01'
                    AND P.TJMONTH)
                    AND J1.PAYTYPE NOT IN ('ZH', 'YEL')
               GROUP BY
                     J1.CONTNO
          )> 0
)P
    LEFT JOIN(
     SELECT
           J.CONTNO,
          J.POLNO,
          DATE_FORMAT(ADD_MONTHS(J.LASTPAYTODATE,
           14),
           'yyyyMM') LASTPAYTODATE,
          ROUND(DATEDIFF(MAX(J.CURPAYTODATE),
          MAX(J.LASTPAYTODATE)) / 365) ND
     FROM
           ODS.O_LIS_LJAPAYPERSON J
     WHERE
           J.PAYINTV = '12'
     GROUP BY
           J.CONTNO,
          J.POLNO,
          DATE_FORMAT(ADD_MONTHS(J.LASTPAYTODATE, 14), 'yyyyMM')
) J2
   ON J2.CONTNO = P.CONTNO AND J2.POLNO = P.POLNO AND J2.LASTPAYTODATE BETWEEN SUBSTR(P.TJMONTH, 0, 4)
                                                                               || '01' AND P.TJMONTH
   LEFT JOIN(
     SELECT
           J.CONTNO,
          J.POLNO,
          DATE_FORMAT(ADD_MONTHS(J.CURPAYTODATE,
           2),
           'yyyyMM') CURPAYTODATE,
          ROUND(DATEDIFF(MAX(J.CURPAYTODATE),
          MAX(J.LASTPAYTODATE)) / 365) ND
     FROM
           ODS.O_LIS_LJAPAYPERSON J
     WHERE
           J.PAYINTV = '12'
     GROUP BY
           J.CONTNO,
          J.POLNO,
          DATE_FORMAT(ADD_MONTHS(J.CURPAYTODATE, 2), 'yyyyMM')
) J3
   ON J3.CONTNO = P.CONTNO AND J3.POLNO = P.POLNO AND J3.CURPAYTODATE BETWEEN SUBSTR(P.TJMONTH, 0, 4)
                                                                              || '01' AND P.TJMONTH
      LEFT JOIN ODS.O_LIS_LJAPAYPERSON J
        ON (P.CONTNO = J.CONTNO AND P.POLNO = J.POLNO AND
           ((DATE_FORMAT(ADD_MONTHS(J.LASTPAYTODATE, 14), 'yyyy') = SUBSTR(P.TJMONTH, 0, 4) AND
           DATE_FORMAT(ADD_MONTHS(J.LASTPAYTODATE, 14), 'yyyyMM') <= P.TJMONTH AND
           DATE_FORMAT(ADD_MONTHS(J.CURPAYTODATE, -10), 'yyyyMM') NOT BETWEEN
           SUBSTR(P.TJMONTH, 0, 4)
           || '01' AND P.TJMONTH) OR
           DATE_FORMAT(ADD_MONTHS(J.CURPAYTODATE, 2), 'yyyyMM') BETWEEN
           SUBSTR(P.TJMONTH, 0, 4)
           || '01' AND P.TJMONTH) AND J.PAYINTV <> '1' AND
           J.PAYTYPE NOT IN ('ZH', 'YEL'))
 LEFT JOIN (
     SELECT
           E.CONTNO,
          MAX(DATE_FORMAT(E.EDORVALIDATE,
           'yyyyMM')) EDORVALIDATE
     FROM
           ODS.O_LIS_LPEDORITEM E
     WHERE
           E.EDORTYPE = 'FX'
          AND E.EDORSTATE = '0'
     GROUP BY
           E.CONTNO
) E
 ON E.CONTNO = P.CONTNO AND E.EDORVALIDATE > P.TJMONTH
     WHERE NOT EXISTS (
     SELECT
           1
     FROM
           DWD.DWD_LCZHZHJXLCOUNT PP
     WHERE
           PP.PAYTODATE = PP.RPAYENDDATE
          AND PP.RPAYINTV NOT IN ('0', '1')
          AND PP.RISKPERIOD = 'L'
          AND DATE_FORMAT(ADD_MONTHS(PP.PAYTODATE, 2), 'yyyyMM') BETWEEN SUBSTR(P.TJMONTH, 0, 4)
                                                                         || '01' AND P.TJMONTH
          AND PP.CONTNO = P.CONTNO
)
     GROUP BY P.CONTNO, P.POLNO, P.TJMONTH
    UNION ALL
 --月缴
    SELECT P.CONTNO,
           P.POLNO,
           P.TJMONTH,
           CASE
 --因为是算到截至月底的指标，都在应交日之后
               WHEN ((P.RPAYTODATE <> P.RPAYENDDATE) OR
                    (P.RPAYTODATE = P.PAYTODATE AND
                    P.RPAYTODATE >= LAST_DAY(SUBSTR(P.TJMONTH, 0, 4)
                                             ||'-'
                                             ||SUBSTR(P.TJMONTH, 5, 2)
                                               ||'-01')))
 --如果统计日期在应交日之后，则用统计日期月份值x与开始计入应收月份值y比较，
 --如果x-y+1>0，则年度应收为x-y+1个月保费
                    AND (SUBSTR(P.TJMONTH, 5, 2) + 1 >= R.MONTHID) THEN
                P.PREM * (SUBSTR(P.TJMONTH, 5, 2) + 1 - R.MONTHID)
               ELSE
                0
           END PREM
      FROM ZTEST_JXL_37J_CONT_WYDATA P
      LEFT JOIN DWD.DWD_XQ_FACT_JXLM0YS_RULE R
        ON (P.POLNO = R.POLNO AND P.CONTNO = R.CONTNO AND R.FLAG = 'Y' AND
           R.YEARID = SUBSTR(P.TJMONTH, 0, 4))
     WHERE 1 = 1
       AND P.PAYINTV = '月缴';
-- page8
--------------------------------更新指标宽表
TRUNCATE TABLE DWD.DWS_XQ_JXL37JYY;

INSERT OVERWRITE TABLE DWD.DWS_XQ_JXL37JYY
     SELECT
          P.CONTNO,
          P.POLNO,
          SUBSTR(P.TJMONTH,
          1,
          4)||'-'||SUBSTR(P.TJMONTH,
          5,
          2) TJMONTH,
          Y1.PREM M0YSPREM,
          Y2.PREM M0SSPREM,
          Y3.PREM M1YSPREM,
          Y4.PREM M1SSPREM,
          Y5.PREM M2YSPREM,
          Y6.PREM M2SSPREM,
          P.SALECHNL,
          P.CVALIDATE,
          P.PAYINTV,
          ROUND(P.RPAYINTV,
          0) RPAYINTV,
          P.RISKPERIOD,
          P.PREM,
          P.AGENTCODE,
          P.PAYTODATE,
          P.RPAYTODATE,
          P.RPAYENDDATE,
          P.MANAGECOM,
          P.AGENTCOM,
          P.TEAMID
     FROM
          ZTEST_JXL_37J_CONT_WYDATA P
          LEFT JOIN (
               SELECT
                    A.CONTNO,
                    A.POLNO,
                    A.TJMONTH,
                    A.PREM
               FROM
                    ZTEST_JXL_37J_CONT_WYM0YS A
          ) Y1
          ON (P.CONTNO = Y1.CONTNO
          AND P.POLNO = Y1.POLNO
          AND P.TJMONTH = Y1.TJMONTH)
          LEFT JOIN (
               SELECT
                    A.CONTNO,
                    A.POLNO,
                    A.TJMONTH,
                    A.PREM
               FROM
                    ZTEST_JXL_37J_CONT_WYM0SS A
          ) Y2
          ON (P.CONTNO = Y2.CONTNO
          AND P.POLNO = Y2.POLNO
          AND P.TJMONTH = Y2.TJMONTH)
          LEFT JOIN (
               SELECT
                    A.CONTNO,
                    A.POLNO,
                    A.TJMONTH,
                    A.PREM
               FROM
                    ZTEST_JXL_37J_CONT_WYM1YS A
          ) Y3
          ON (P.CONTNO = Y3.CONTNO
          AND P.POLNO = Y3.POLNO
          AND P.TJMONTH = Y3.TJMONTH)
          LEFT JOIN (
               SELECT
                    A.CONTNO,
                    A.POLNO,
                    A.TJMONTH,
                    A.PREM
               FROM
                    ZTEST_JXL_37J_CONT_WYM1SS A
          ) Y4
          ON (P.CONTNO = Y4.CONTNO
          AND P.POLNO = Y4.POLNO
          AND P.TJMONTH = Y4.TJMONTH)
          LEFT JOIN (
               SELECT
                    A.CONTNO,
                    A.POLNO,
                    A.TJMONTH,
                    A.PREM
               FROM
                    ZTEST_JXL_37J_CONT_WYM2YS A
          ) Y5
          ON (P.CONTNO = Y5.CONTNO
          AND P.POLNO = Y5.POLNO
          AND P.TJMONTH = Y5.TJMONTH)
          LEFT JOIN (
               SELECT
                    A.CONTNO,
                    A.POLNO,
                    A.TJMONTH,
                    A.PREM
               FROM
                    ZTEST_JXL_37J_CONT_WYM2SS A
          ) Y6
          ON (P.CONTNO = Y6.CONTNO
          AND P.POLNO = Y6.POLNO
          AND P.TJMONTH = Y6.TJMONTH);