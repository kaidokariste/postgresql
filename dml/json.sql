-- Create temporary learning table with one json object
create temporary table myjson (
  address json
);

insert into myjson(address)
values (
    '{
	"postCode": "33789",
	"county": [{
			"countyPrefix": "PRD",
			"countyName": "Paradiseland",
			"countyIndex": 556677
		}
	],
	"city": "Palmolive",
	"streetType": "STREET",
	"street": "Paradise avenue",
	"houseNumber": "1667",
	"doorAndFloor": "3-7 "
}');


-- Parsing out value from key value pair
-- countyName is in onject array. 0 is necessary to point first array object (index = 0)
SELECT
  address #>> '{postCode}' as postcode,
  address #>> '{county,0,countyName}' as countyname
FROM myjson;


