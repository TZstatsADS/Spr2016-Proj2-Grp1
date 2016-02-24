#Travel Data of NYC<br/>

| Tables        | Source        | Ext.  |Dimension   |#of Obs|
| ------------- |:-------------:| :-----:|:-----:|:---:|
| Natural Preserves| [NYCOD](http://www.nyc.gov/html/dpr/nycbigapps/DPR_naturepreserves_001.csv) |csv|`Name`,`Borough`,`Directions`,`Description`,`Type`|51|
| Museums | [NYCOD](https://data.cityofnewyork.us/Recreation/New-York-City-Museums/ekax-ky3z)|Geo|`Name`,`Phone&Address`,`Closing`,`Special` |46|
| Galleries | [NYCOD](https://data.cityofnewyork.us/Recreation/New-York-City-Art-Galleries/tgyc-r5jh)|Geo|`Name`,`ID`,`Location`||
| Theatre |[NYCOD](https://data.cityofnewyork.us/Recreation/Theaters/kdu2-865w)|Geo|`Name`,`Artist`,`Discription`,`Lat&Lon`|40|
| Opera&Music |[NYCOD](https://data.cityofnewyork.us/Recreation/DOITT-CLASSICAL-MUSIC/txxa-5nhg)|xml|`Name`,`Location`,`Borough`,`Content`|2105|
| Time Sqare Venues|[NYCOD](https://data.cityofnewyork.us/Business/Times-Square-Entertainment-Venues/jxdc-hnze)|Any|`Name`,`Type`,`Phone&Address`,`Website`|78|
| Filming Permit|[Enigma](https://app.enigma.io/table/us.states.ny.cities.nyc.mome.filming-permits.events?row=0&col=2&page=1)|Any|`Name`,`Time(start&End)`,`Borough`,`Location`||
