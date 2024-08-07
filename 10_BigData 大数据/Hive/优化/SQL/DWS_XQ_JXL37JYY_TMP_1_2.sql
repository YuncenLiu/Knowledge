DROP TABLE IF EXISTS DWS_XQ_JXL37JYY_TMP_1_2 PURGE;

CREATE TABLE DWS_XQ_JXL37JYY_TMP_1_2 AS
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
                );