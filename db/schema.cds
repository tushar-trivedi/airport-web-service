namespace db.airport;

// Airport entity
entity Airport {
    key icao : String(4) @title: 'ICAO'; 
    iata : String(3) @title: 'IATA';
    name : String(200) @title: 'Airport Name';
    city : String(100) @title: 'City';
    state : String(100) @title: 'State';
    country : String(2) @title: 'Country'; 
    elevation : Integer @title: 'Elevation';
    lat : Decimal(11,8) @title: 'Latitude';  
    lon : Decimal(12,8) @title: 'Longitude';
    tz : String(50) @title: 'Timezone';
}