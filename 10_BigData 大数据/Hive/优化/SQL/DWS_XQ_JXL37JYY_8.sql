
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