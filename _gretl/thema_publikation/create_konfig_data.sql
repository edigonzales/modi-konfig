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
    -- Wo, welcher Pfad verwendet werden muss, wird bisschen mühsam.
    -- Vgl. build.gradle mit den Modelldateien.
    read_json('*/meta/thema.json') AS m
    LEFT JOIN read_json('s3://ch.so.agi.fubar1/*/publishedat.json') AS p
    ON m.ID = p.ID
;

DELETE FROM
    konfig.themapublikation_themapublikation
;
INSERT INTO 
    konfig.themapublikation_themapublikation
    (
        T_Id,
        T_Ili_Tid,
        id,
        titel,
        beschreibung,
        modell,
        tags,
        publiziertam
    )
SELECT 
    T_Id,
    T_Ili_Tid,
    id,
    titel,
    beschreibung,
    modell,
    list_aggregate(tags, 'string_agg', ',') AS tags,
    publiziertam
FROM 
    themapublikation_tmp 
;

DELETE FROM 
    konfig.amt_
;
INSERT INTO 
    konfig.amt_
    (
        T_Id,
        --T_Ili_Tid,
        aname,
        abkuerzung,
        abteilung,
        amtimweb,
        zeile1,
        zeile2,
        strasse,
        hausnr,
        plz,
        ort,
        thempblktn_thmpblktion_datenherr
    )
SELECT 
    nextval('konfig.t_ili2db_seq') AS T_Id,
    --T_Ili_Tid,
    aname,
    abkuerzung,
    abteilung,
    amtimweb,
    zeile1,
    zeile2,
    strasse,
    hausnr,
    plz,
    ort,
    themapublikation_tmp.T_Id AS thempblktn_thmpblktion_datenherr
FROM 
    themapublikation_tmp
    LEFT JOIN stammdaten.amt_amt AS amt 
    ON themapublikation_tmp.datenherr = amt.T_Ili_Tid 
;
