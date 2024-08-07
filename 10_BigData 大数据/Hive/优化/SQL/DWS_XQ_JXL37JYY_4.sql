
--年度宽一实收日期+实收保费
--2268513
DROP TABLE ZTEST_JXL_37J_CONT_WYM1SS purge;

CREATE  TABLE ZTEST_JXL_37J_CONT_WYM1SS
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
      FROM DWS_XQ_JXL37JYY_TMP_4_1 T
     WHERE T.RN = 1;