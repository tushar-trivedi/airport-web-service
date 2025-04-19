using AirportWebService as service from '../../srv/airport-web-service';
annotate service.Airports with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : icao,
            },
            {
                $Type : 'UI.DataField',
                Value : iata,
            },
            {
                $Type : 'UI.DataField',
                Value : name,
            },
            {
                $Type : 'UI.DataField',
                Value : city,
            },
            {
                $Type : 'UI.DataField',
                Value : state,
            },
            {
                $Type : 'UI.DataField',
                Value : country,
            },
            {
                $Type : 'UI.DataField',
                Value : elevation,
            },
            {
                $Type : 'UI.DataField',
                Value : lat,
            },
            {
                $Type : 'UI.DataField',
                Value : lon,
            },
            {
                $Type : 'UI.DataField',
                Value : tz,
            },
            {
                $Type : 'UI.DataField',
                Label : 'region',
                Value : region,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : icao,
            Label : '{i18n>Icao}',
        },
        {
            $Type : 'UI.DataField',
            Value : iata,
            Label : '{i18n>Iata}',
        },
        {
            $Type : 'UI.DataField',
            Value : name,
            Label : '{i18n>AirportName}',
        },
        {
            $Type : 'UI.DataField',
            Value : city,
            Label : '{i18n>City}',
        },
        {
            $Type : 'UI.DataField',
            Value : state,
            Label : '{i18n>State}',
        },
        {
            $Type : 'UI.DataField',
            Value : country,
            Label : '{i18n>Country}',
        },
        {
            $Type : 'UI.DataField',
            Value : elevation,
            Criticality : {$edmJson: {$If: [
                {$Gt: [
                    {$Path: 'elevation'},
                    8000 // Define a criticality threshold for elevation above 8000
                ]},
                1,
                0
            ]}},
            CriticalityRepresentation : #WithoutIcon,  // remove the icon from criticality 
            Label : '{i18n>Elevation}',
        },
        {
            $Type : 'UI.DataField',
            Value : lat,
            Label : '{i18n>Latitude}',
        },
        {
            $Type : 'UI.DataField',
            Value : lon,
            Label : '{i18n>Longitude}',
        },
        {
            $Type : 'UI.DataField',
            Value : region,
            Label : '{i18n>Region}',
        },
        {
            $Type : 'UI.DataField',
            Value : tz,
            Label : '{i18n>Timezone}',
        },
    ],
    UI.SelectionFields : [
        name,
        iata,
    ],
    UI.SelectionPresentationVariant #tableView : {
        $Type : 'UI.SelectionPresentationVariantType',
        PresentationVariant : {
            $Type : 'UI.PresentationVariantType',
            Visualizations : [
                '@UI.LineItem',
            ],
        },
        SelectionVariant : {
            $Type : 'UI.SelectionVariantType',
            SelectOptions : [
            ],
        },
        Text : 'Full Table View',
    },
    UI.LineItem #tableView : [
        {
            $Type : 'UI.DataField',
            Value : icao,
        },
        {
            $Type : 'UI.DataField',
            Value : name,
        },
        {
            $Type : 'UI.DataField',
            Value : city,
        },
        {
            $Type : 'UI.DataField',
            Value : region,
            Label : 'region',
        },
    ],
    Analytics.AggregatedProperty #elevation_average : {
        $Type : 'Analytics.AggregatedPropertyType',
        Name : 'elevation_average',
        AggregatableProperty : elevation,
        AggregationMethod : 'average',
        ![@Common.Label] : '{i18n>ElevationAverage}',
    },
    UI.Chart #alpChart : {
        $Type : 'UI.ChartDefinitionType',
        ChartType : #Column,
        Dimensions : [
            country,
        ],
        DynamicMeasures : [
            '@Analytics.AggregatedProperty#elevation_average',
        ],
        Title : '{i18n>Analytics}',
    },
    Analytics.AggregatedProperty #icao_countdistinct : {
        $Type : 'Analytics.AggregatedPropertyType',
        Name : 'icao_countdistinct',
        AggregatableProperty : icao,
        AggregationMethod : 'countdistinct',
        ![@Common.Label] : '{i18n>IcaoCountDistinctValues}',
    },
    );

annotate service.Airports with {
    iata @Common.Label : '{i18n>Iata}'
};

