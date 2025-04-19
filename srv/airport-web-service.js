const cds = require('@sap/cds');

/**
 * Airport Web Service Implementation
 */
class AirportWebService extends cds.ApplicationService {
    async init() {
        // Get references to the entities
        const { Airports } = this.entities;

        /**
         * Calculate average elevation per country
         */
        this.on('averageElevationPerCountry', async (req) => {
            const country = req.data.country;

            // Create a native SQL query for average calculation
            let query = `SELECT country, AVG(elevation) as averageElevation 
                         FROM db_airport_Airport 
                         ${country ? `WHERE country = '${country}'` : ''} 
                         GROUP BY country`;

            // Execute native SQL query
            const results = await cds.run(query);

            // Format results
            return results.map(r => ({
                country: r.country,
                averageElevation: parseFloat(r.averageElevation)
            }));
        });

        this.on('averageElevationPerCountryAll', async (req) => {

            let query = `SELECT country, AVG(elevation) AS averageElevation
                         FROM db_airport_Airport
                         GROUP BY country`;

            // Execute native SQL query
            const results = await cds.run(query);

            // Format results
            return results.map(r => ({
                country: r.country,
                averageElevation: parseFloat(r.averageElevation)
            }));
        });

        /**
         * Find airports without IATA codes
         */
        this.on('airportsWithoutIata', async () => {
            // Use standard CDS query
            return await SELECT.from(Airports)
                .where(`iata = null OR iata = ''`);
        });

        /**
         * Determine the 10 most common timezones
         */
        this.on('top10Timezones', async () => {
            // Use native SQL for count and grouping
            const query = `SELECT tz as timezone, COUNT(icao) as count 
                          FROM db_airport_Airport 
                          GROUP BY tz 
                          ORDER BY count DESC 
                          LIMIT 10`;

            const results = await cds.run(query);

            return results.map(r => ({
                timezone: r.timezone,
                count: parseInt(r.count)
            }));
        });

        // Initialize the parent
        return super.init();
    }
}

module.exports = AirportWebService;