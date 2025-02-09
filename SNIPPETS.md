# modi-konfig

```
SELECT 
	*
FROM 
	read_json('/Users/stefan/sources/modi-konfig/*/meta/meta.json')
;
```

```
java -jar /Users/stefan/apps/ili2gpkg-5.2.1/ili2gpkg-5.2.1.jar --dbfile amt2.gpkg --nameByTopic --defaultSrsCode 2056 --models SO_AGI_Metadaten_20250202 --modeldir "." --smart2Inheritance --schemaimport
```

```
java -jar /Users/stefan/apps/ili2gpkg-5.2.1/ili2gpkg-5.2.1.jar --dbfile amt.gpkg --nameByTopic --defaultSrsCode 2056 --models SO_AGI_Metadaten_20250202 --modeldir "." --smart2Inheritance --export amt.xtf
```

```
java -jar /Users/stefan/apps/ili2gpkg-5.2.1/ili2gpkg-5.2.1.jar --dbfile amt2.gpkg --nameByTopic --defaultSrsCode 2056 --models SO_AGI_Metadaten_20250202 --modeldir "." --smart2Inheritance --coalesceJson --coalesceArray --schemaimport
```

----

```
java -jar /Users/stefan/apps/ili2duckdb-5.2.2-SNAPSHOT/ili2duckdb-5.2.2-SNAPSHOT.jar --dbfile modi-konfig.duckdb --nameByTopic --defaultSrsCode 2056 --createEnumTabs --smart2Inheritance --strokeArcs  --models SO_AGI_Metadaten_20250202 --modeldir _ili --dbschema stammdaten --schemaimport
```

```
java -jar /Users/stefan/apps/ili2duckdb-5.2.2-SNAPSHOT/ili2duckdb-5.2.2-SNAPSHOT.jar --dbfile modi-konfig.duckdb --nameByTopic --defaultSrsCode 2056 --createEnumTabs --smart2Inheritance --strokeArcs  --models SO_AGI_Metadaten_20250202 --modeldir _ili --dbschema stammdaten --import _stammdaten/amt.xtf
```

```
java -jar /Users/stefan/apps/ili2duckdb-5.2.2-SNAPSHOT/ili2duckdb-5.2.2-SNAPSHOT.jar --dbfile modi-konfig.duckdb --nameByTopic --defaultSrsCode 2056 --createEnumTabs --smart2Inheritance --strokeArcs  --models SO_AGI_Metadaten_20250202 --modeldir _ili --dbschema konfig --schemaimport
```

```
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
    read_json('/Users/stefan/sources/modi-konfig/*/meta/thema.json') AS m
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


/*
DELETE FROM 
    konfig.datensaetze_datensatz_tags
;
INSERT INTO 
    konfig.datensaetze_datensatz_tags
    (
        T_Id,
        datensaetze_datensatz_tags,
        tags
    )
SELECT
    nextval('konfig.t_ili2db_seq') AS T_Id,
    T_Id AS datensaetze_datensatz_tags,
    UNNEST(tags) AS tags
FROM 
    datensatz_tmp
;
*/
```

```
java -jar /Users/stefan/apps/ili2duckdb-5.2.2-SNAPSHOT/ili2duckdb-5.2.2-SNAPSHOT.jar --dbfile modi-konfig.duckdb --nameByTopic --defaultSrsCode 2056 --models SO_AGI_Metadaten_20250202 --modeldir _ili --dbschema konfig --disableValidation --export modi_konfig.xtf

```


docker run -i --rm --name gretl --entrypoint="/bin/sh" -u $UID -v $PWD:/home/gradle/project -v /tmp:/home/gradle/.gradle/caches sogis/gretl:3.1 -c 'gretl'