using {db.airport as db} from '../db/schema';

service AirportWebService {
    @odata.draft.enabled
    entity Airports as
        projection on db.Airport {
            *,
            (country || '-' || state) as region : String(250)
        };
    
    function averageElevationPerCountry(country: String) returns array of {
        country: String;
        averageElevation: Decimal;
    };

    function averageElevationPerCountryAll() returns array of {
        country: String;
        averageElevation: Decimal;
    };
    
    function airportsWithoutIata() returns array of Airports;
    
    function top10Timezones() returns array of {
        timezone: String;
        count: Integer;
    };

    annotate AirportWebService with @(requires: 'authority');


}

annotate AirportWebService.Airports with @Aggregation.ApplySupported: {
    Transformations       : [
        'aggregate',
        'topcount',
        'groupby',
        'average'
    ],
    Rollup                : #None,
    PropertyRestrictions  : true,
    GroupableProperties   : [
        country,
        state,
        tz
    ],
    AggregatableProperties: [
        {Property: icao},
        {Property: elevation}
    ],
};
