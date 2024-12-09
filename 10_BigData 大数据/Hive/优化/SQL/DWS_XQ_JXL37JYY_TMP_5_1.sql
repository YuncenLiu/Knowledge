DROP TABLE IF EXISTS DWS_XQ_JXL37JYY_TMP_5_1 PURGE;

CREATE TABLE DWS_XQ_JXL37JYY_TMP_5_1 AS
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
                ROUND(SUM(J1.SUMACTUPAYMONEY), 2)
            FROM
                ODS.O_LIS_LJAPAYPERSON J1
            WHERE
                J1.CONTNO = P.CONTNO
                AND ( ( DATE_FORMAT(ADD_MONTHS(J1.LASTPAYTODATE, 13), 'yyyy') = SUBSTR(P.TJMONTH, 0, 4)
                AND DATE_FORMAT(ADD_MONTHS(J1.LASTPAYTODATE, 13), 'yyyyMM') <= P.TJMONTH
                AND DATE_FORMAT(ADD_MONTHS(J1.CURPAYTODATE, -11), 'yyyyMM') NOT BETWEEN SUBSTR(P.TJMONTH, 0, 4)
                                                                                        || '01'
                AND P.TJMONTH )
                OR DATE_FORMAT(ADD_MONTHS(J1.CURPAYTODATE, 1), 'yyyyMM') BETWEEN SUBSTR(P.TJMONTH, 0, 4)
                                                                                 || '01'
                AND P.TJMONTH )
                AND J1.PAYTYPE NOT IN ('ZH', 'YEL')
            GROUP BY
                J1.CONTNO
        ) > 0;