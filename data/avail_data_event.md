#Travel Data of NYC<br/>

| Tables        | Source        | Ext.  |Dimension   |
| ------------- |:-------------:| :-----:|:-----:|
| Natural Preserves| [NYCOD](http://www.nyc.gov/html/dpr/nycbigapps/DPR_naturepreserves_001.csv) |csv|`Name`,`Borough`,`Directions`,`Description`,`Type`|
| Museums | [NYCOD](https://data.cityofnewyork.us/Recreation/New-York-City-Museums/ekax-ky3z)|Geo|`Name`,`Phone&Address`,`Closing`,`Special` |
| Galleries | [NYCOD](https://data.cityofnewyork.us/Recreation/New-York-City-Art-Galleries/tgyc-r5jh)|Geo|`Name`,`ID`,`Location`|
| Theatre |[NYCOD](https://data.cityofnewyork.us/Recreation/Theaters/kdu2-865w)|Geo|`Name`,`Artist`,`Discription`,`Lat&Lon`|
| Opera&Music |[NYCOD](https://data.cityofnewyork.us/Recreation/DOITT-CLASSICAL-MUSIC/txxa-5nhg)|xml|`Name`,`Location`,`Borough`,`Content`|
| Time Sqare Venues|[NYCOD](https://data.cityofnewyork.us/Business/Times-Square-Entertainment-Venues/jxdc-hnze)|Any|`Name`,`Type`,`Phone&Address`,`Website`|
| Filming Permit|[Enigma](https://app.enigma.io/table/us.states.ny.cities.nyc.mome.filming-permits.events?row=0&col=2&page=1)|Any|`Name`,`Time(start&End)`,`Borough`,`Location`|
