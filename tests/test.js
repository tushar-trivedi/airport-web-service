const cds = require('@sap/cds/lib')
const { default: axios } = require('axios')
const { GET, POST, DELETE, PATCH, expect } = cds.test(__dirname + '../../')

// Set authentication for the test requests
axios.defaults.auth = { username: 'tushar', password: 'tushar' }

jest.setTimeout(11111)

describe('Test The GET Endpoints', () => {
  it('Should check AirportWebService', async () => {
    const airportService = await cds.connect.to('AirportWebService')
    const { Airports } = airportService.entities
    // This will validate that you can connect to the service and get airport entities
    expect(await SELECT.from(Airports)).to.be.an('array')
  })

  it('Test Airports Entity Endpoint', async () => {
    // Correct endpoint path
    const { data } = await GET`/odata/v4/airport-web/Airports`
    expect(data).to.be.an('object')
    expect(data.value).to.be.an('array')
  })

  it('Test Airport by ICAO', async () => {
    // Get the first airport
    const airportService = await cds.connect.to('AirportWebService')
    const { Airports } = airportService.entities
    const airports = await SELECT.from(Airports).limit(1)
    
    if (airports.length > 0) {
      const testIcao = airports[0].icao
      // Updated endpoint path
      const { data } = await GET(`/odata/v4/airport-web/Airports(icao='${testIcao}',IsActiveEntity=true)`)
      expect(data).to.be.an('object')
      expect(data.icao).to.equal(testIcao)
    } else {
      console.log('No airports found to test')
    }
  })

  it('Test calculated field region', async () => {
    // Get the first airport
    const airportService = await cds.connect.to('AirportWebService')
    const { Airports } = airportService.entities
    const airports = await SELECT.from(Airports).limit(1)
    
    if (airports.length > 0) {
      const testIcao = airports[0].icao
      // Updated endpoint path
      const { data } = await GET(`/odata/v4/airport-web/Airports(icao='${testIcao}',IsActiveEntity=true)`)
      
      // Verify the calculated region field is working
      expect(data.region).to.equal(`${data.country}-${data.state}`)
    } else {
      console.log('No airports found to test')
    }
  })
})

describe('Draft Choreography APIs', () => {
  let draftId, icaoCode = 'TEST'

  it('Create an airport ', async () => {
    // Updated endpoint path
    const { status, statusText, data } = await POST(`/odata/v4/airport-web/Airports`, {
      icao: icaoCode,
      iata: 'TST',
      name: 'Test Airport',
      city: 'Test City',
      state: 'Test State',
      country: 'TS',
      elevation: 1000,
      lat: 12.345678,
      lon: -98.765432,
      tz: 'UTC'
    })
    draftId = data.icao
    expect(status).to.equal(201)
    expect(statusText).to.equal('Created')
    expect(data.IsActiveEntity).to.equal(false)
  })

  it('+ Activate the draft', async () => {
    // Updated endpoint path
    const response = await POST(
      `/odata/v4/airport-web/Airports(icao='${draftId}',IsActiveEntity=false)/AirportWebService.draftActivate`
    )
    expect(response.status).to.eql(201)
    expect(response.data.IsActiveEntity).to.equal(true)
  })

  it('+ Test the airport data after activation', async () => {
    // Updated endpoint path
    const { status, data } = await GET(`/odata/v4/airport-web/Airports(icao='${draftId}',IsActiveEntity=true)`)
    expect(status).to.eql(200)
    expect(data.name).to.eql('Test Airport')
    expect(data.city).to.eql('Test City')
    // Verify the calculated region field
    expect(data.region).to.eql('TS-Test State')
  })

  it('+ Edit the airport', async () => {
    // Updated endpoint path
    const { status } = await POST(
      `/odata/v4/airport-web/Airports(icao='${draftId}',IsActiveEntity=true)/AirportWebService.draftEdit`,
      {
        PreserveChanges: true
      }
    )
    expect(status).to.equal(201)
  })

  it('+ Update the airport details', async () => {
    // Updated endpoint path
    const { status } = await PATCH(`/odata/v4/airport-web/Airports(icao='${draftId}',IsActiveEntity=false)`, {
      name: 'Updated Test Airport',
      elevation: 2000
    })
    expect(status).to.equal(200)
  })

  it('+ Activate the updated draft', async () => {
    // Updated endpoint path
    const response = await POST(
      `/odata/v4/airport-web/Airports(icao='${draftId}',IsActiveEntity=false)/AirportWebService.draftActivate`
    )
    expect(response.status).to.eql(200)
  })

  it('+ Verify updated data', async () => {
    // Updated endpoint path
    const { status, data } = await GET(`/odata/v4/airport-web/Airports(icao='${draftId}',IsActiveEntity=true)`)
    expect(status).to.eql(200)
    expect(data.name).to.eql('Updated Test Airport')
    expect(data.elevation).to.eql(2000)
  })

  it('- Delete the Airport', async () => {
    // Updated endpoint path
    const response = await DELETE(`/odata/v4/airport-web/Airports(icao='${draftId}',IsActiveEntity=true)`)
    expect(response.status).to.eql(204)
  })

  it('- Verify deletion', async () => {
    try {
      // Updated endpoint path
      await GET(`/odata/v4/airport-web/Airports(icao='${draftId}',IsActiveEntity=true)`)
    } catch (error) {
      expect(error.response.status).to.eql(404)
    }
  })
})