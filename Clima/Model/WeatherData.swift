import Foundation
struct WeatherData:Codable{
    var main:Main
    var name:String
    var weather:[Weather]
    var sys:Sys
    
    struct Main:Codable {
        var temp:Double
        
        
    }
    struct Weather:Codable {
        var description:String
        var id:Int
    }
    struct Sys:Codable {
        var country:String
    }
}
