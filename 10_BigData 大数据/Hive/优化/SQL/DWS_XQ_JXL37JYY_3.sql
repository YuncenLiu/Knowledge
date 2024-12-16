--年度当月应收日期+应收保费
--3866314

DROP TABLE ZTEST_JXL_37J_CONT_WYM0YS PURGE;

CREATE TABLE ZTEST_JXL_37J_CONT_WYM0YS AS
     SELECT
          P.CONTNO,
          P.POLNO,
          P.TJMONTH,
          CASE
               WHEN MAX(P.CONTNO) = '2019031129156264' THEN
                    250000
               WHEN MAX(P.PAYINTV) = '年缴' AND MAX(P.RPAYINTV) = '0' AND MAX(P.RISKPERIOD) <> 'L' AND SUM(J.SUMACTUPAYMONEY) > 0 THEN
                    MAX(P.PREM)
               WHEN MAX(P.PAYINTV) = '年缴' AND MAX(P.RPAYINTV) = '0' AND MAX(P.RISKPERIOD) <> 'L' AND SUM(J.SUMACTUPAYMONEY) IS NULL THEN
                    0
               WHEN MAX(P.PAYINTV) = '年缴' AND MAX(P.RPAYINTV) = '0' AND MAX(P.RISKPERIOD) = 'L' AND MAX(P.PREM) = 0 THEN
                    0
               WHEN MAX(P.PAYINTV) = '年缴' AND MAX(P.RPAYINTV) = '12' AND CASE
                    WHEN MAX(J2.ND) IS NULL THEN
                         MAX(J3.ND)
                    ELSE
                         MAX(J2.ND)
               END >= 2 THEN
                    (
                         CASE
                              WHEN MAX(E.CONTNO) IS NULL THEN
                                   SUM(J.SUMACTUPAYMONEY) / CASE
                                        WHEN MAX(J2.ND) IS NULL THEN
                                             MAX(J3.ND)
                                        ELSE
                                             MAX(J2.ND)
                                   END
                              ELSE
                                   0
                         END)
               ELSE
                    CASE
                         WHEN SUM(J.SUMACTUPAYMONEY) IS NULL THEN
                              MAX(P.PREM)
                         ELSE
                              SUM(J.SUMACTUPAYMONEY)
                    END
          END       PREM
     FROM
          DWS_XQ_JXL37JYY_TMP_3_1 P                            
          LEFT JOIN(
               SELECT
                    J.CONTNO,
                    J.POLNO,
                    DATE_FORMAT(ADD_MONTHS(J.LASTPAYTODATE, 12), 'yyyyMM')           LASTPAYTODATE,
                    ROUND(DATEDIFF(MAX(J.CURPAYTODATE), MAX(J.LASTPAYTODATE)) / 365) ND
               FROM
                    ODS.O_LIS_LJAPAYPERSON J
               WHERE
                    J.PAYINTV = '12'
               GROUP BY
                    J.CONTNO,
                    J.POLNO,
                    DATE_FORMAT(ADD_MONTHS(J.LASTPAYTODATE, 12), 'yyyyMM')
          ) J2
          ON J2.CONTNO = P.CONTNO
          AND J2.POLNO = P.POLNO
          AND J2.LASTPAYTODATE BETWEEN SUBSTR(P.TJMONTH,
          0,
          4)
          || '01'
          AND P.TJMONTH
          LEFT JOIN(
               SELECT
                    J.CONTNO,
                    J.POLNO,
                    DATE_FORMAT(J.CURPAYTODATE, 'yyyyMM')                            CURPAYTODATE,
                    ROUND(DATEDIFF(MAX(J.CURPAYTODATE), MAX(J.LASTPAYTODATE)) / 365) ND
               FROM
                    ODS.O_LIS_LJAPAYPERSON J
               WHERE
                    J.PAYINTV = '12'
               GROUP BY
                    J.CONTNO,
                    J.POLNO,
                    DATE_FORMAT(J.CURPAYTODATE, 'yyyyMM')
          ) J3
          ON J3.CONTNO = P.CONTNO
          AND J3.POLNO = P.POLNO
          AND J3.CURPAYTODATE BETWEEN SUBSTR(P.TJMONTH,
          0,
          4)
          || '01'
          AND P.TJMONTH
          LEFT JOIN ODS.O_LIS_LJAPAYPERSON J
          ON (P.CONTNO = J.CONTNO
          AND P.POLNO = J.POLNO
          AND ((DATE_FORMAT(ADD_MONTHS(J.LASTPAYTODATE,
          12),
          'yyyy') = SUBSTR(P.TJMONTH,
          0,
          4)
          AND DATE_FORMAT(ADD_MONTHS(J.LASTPAYTODATE,
          12),
          'yyyyMM') <= P.TJMONTH
          AND DATE_FORMAT(ADD_MONTHS(J.CURPAYTODATE,
          -12),
          'yyyyMM') NOT BETWEEN SUBSTR(P.TJMONTH,
          0,
          4)
          || '01'
          AND P.TJMONTH)
          OR DATE_FORMAT(J.CURPAYTODATE,
          'yyyyMM') BETWEEN SUBSTR(P.TJMONTH,
          0,
          4)
          || '01'
          AND P.TJMONTH)
          AND J.PAYINTV <> '1'
          AND J.PAYTYPE NOT IN ('ZH',
          'YEL'))
          LEFT JOIN (
               SELECT
                    E.CONTNO,
                    MAX(DATE_FORMAT(E.EDORVALIDATE, 'yyyyMM')) EDORVALIDATE
               FROM
                    ODS.O_LIS_LPEDORITEM E
               WHERE
                    E.EDORTYPE = 'FX'
                    AND E.EDORSTATE = '0'
               GROUP BY
                    E.CONTNO
          ) E
          ON E.CONTNO = P.CONTNO
          AND E.EDORVALIDATE > P.TJMONTH
     WHERE
          NOT EXISTS (
               SELECT
                    1
               FROM
                    DWD.DWD_LCZHZHJXLCOUNT       PP
               WHERE
                    PP.PAYTODATE = PP.RPAYENDDATE
                    AND PP.RPAYINTV NOT IN ('0', '1')
                    AND PP.RISKPERIOD = 'L'
                    AND DATE_FORMAT(PP.PAYTODATE, 'yyyyMM') BETWEEN SUBSTR(P.TJMONTH, 0, 4)
                                                                    || '01' AND P.TJMONTH
                    AND PP.CONTNO = P.CONTNO
          )
     GROUP BY
          P.CONTNO,
          P.POLNO,
          P.TJMONTH
     UNION
     ALL
 --月缴
     SELECT
          P.CONTNO,
          P.POLNO,
          P.TJMONTH,
          CASE
 --因为是算到截至月底的指标，都在应交日之后
               WHEN ((P.RPAYTODATE <> P.RPAYENDDATE)
               OR (P.RPAYTODATE = P.PAYTODATE
               AND P.RPAYTODATE >= LAST_DAY(SUBSTR(P.TJMONTH, 0, 4)
                                            ||'-'
                                            ||SUBSTR(P.TJMONTH, 5, 2)
                                              ||'-01')))
 --如果统计日期在应交日之后，则用统计日期月份值x与开始计入应收月份值y比较，
 --如果x-y+1>0，则年度应收为x-y+1个月保费
               AND (SUBSTR(P.TJMONTH, 5, 2) + 1 >= R.MONTHID) THEN
                    P.PREM * (SUBSTR(P.TJMONTH, 5, 2) + 1 - R.MONTHID)
               ELSE
                    0
          END       PREM
     FROM
          ZTEST_JXL_37J_CONT_WYDATA    P
          LEFT JOIN DWD.DWD_XQ_FACT_JXLM0YS_RULE R
          ON (P.POLNO = R.POLNO
          AND P.CONTNO = R.CONTNO
          AND R.FLAG = 'Y'
          AND R.YEARID = SUBSTR(P.TJMONTH,
          0,
          4))
     WHERE
          P.PAYINTV = '月缴';