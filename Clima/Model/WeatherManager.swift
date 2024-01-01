import Foundation
struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=b6a17e9857279ebe7c7dd6c1053de423&units=metric"
 var delegate:WeatherManagerDeletgate?
mutating func fetchWeather(cityName:String)  {
        let query = weatherURL+"&q=\(cityName)"
    performRequest(urlString: query)
    }
    mutating func fetchWeather(latitude:Double,longitude:Double) {
        let query = weatherURL+"&lat=\(latitude)&lon=\(longitude)"
     
        performRequest(urlString: query)
    }
    func performRequest(urlString:String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){(data,respnse,error) in
                guard let data = data else {
                    fatalError("Couldn't get data")
                }
                
               let weather =  parseJASON(data: data)
                delegate?.didUpdateWeather(weather: weather)
            }
            task.resume()
        }
    }
    func parseJASON(data:Data)->WeatherModel {
        let decoder = JSONDecoder()
        let weatherData = try! decoder.decode(WeatherData.self, from: data)
        let weatherModel = WeatherModel(conditionId: weatherData.weather[0].id, cityName: weatherData.name, temperature: weatherData.main.temp,country: weatherData.sys.country)
        return weatherModel
    }
}
