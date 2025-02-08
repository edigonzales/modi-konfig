CREATE OR REPLACE SECRET asecret (
    TYPE S3,
    PROVIDER CREDENTIAL_CHAIN,
    CHAIN 'env',
    ENDPOINT 'sos-ch-dk-2.exo.io'
);

DROP TABLE IF EXISTS
    themapublikation_tmp
;
CREATE TEMP TABLE themapublikation_tmp AS 
SELECT
    nextval('konfig.t_ili2db_seq') AS T_Id,
    '_' || nextval('konfig.t_ili2db_seq') AS T_Ili_Tid,
    m.ID AS id,
    m.Titel AS titel,
    m.Beschreibung AS beschreibung,
    m.Modell AS modell,
    m.tags,
    m.datenherr,
    p.publiziertAm AS publiziertAm
FROM
    read_json('*/meta/meta.json') AS m
    LEFT JOIN read_json('s3://ch.so.agi.fubar1/*/publishedat.json') AS p
    ON m.ID = p.ID
;
