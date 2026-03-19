C:

cd C:\FlightGear 2020.3

SET FG_ROOT=C:\FlightGear 2020.3\data

START .\\bin\fgfs.exe --fdm=null --native-fdm=socket,in,30,localhost,5502,udp --native-ctrls=socket,out,30,localhost,5505,udp --enable-terrasync  --aircraft=Logan --fog-fastest --disable-clouds --start-date-lat=2004:06:01:09:00:00 --disable-sound --in-air --airport=SBGR --runway=09L --altitude=7224 --heading=113 --offset-distance=4.72 --offset-azimuth=0  
