sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'ns/airport/test/integration/FirstJourney',
		'ns/airport/test/integration/pages/AirportsList',
		'ns/airport/test/integration/pages/AirportsObjectPage'
    ],
    function(JourneyRunner, opaJourney, AirportsList, AirportsObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('ns/airport') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheAirportsList: AirportsList,
					onTheAirportsObjectPage: AirportsObjectPage
                }
            },
            opaJourney.run
        );
    }
);