WeatherAPI api = new WeatherAPI();
api.setLocation('Lucknow').makeAPIRequest().populateData();
System.debug(api.getCurrentWeather());