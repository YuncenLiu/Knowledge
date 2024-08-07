
--年度当月实收日期+实收保费
--2288042
DROP TABLE ZTEST_JXL_37J_CONT_WYM0SS purge;

CREATE  TABLE ZTEST_JXL_37J_CONT_WYM0SS
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