
    DROP TABLE IF EXISTS DWS_XQ_JXL37JYY_TMP_4_1 PURGE;

CREATE TABLE DWS_XQ_JXL37JYY_TMP_4_1 AS
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
        AND P.PAYINTV = '月缴';