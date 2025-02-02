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