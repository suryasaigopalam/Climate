import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    var weatherManager = WeatherManager()
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var searchTextField: UITextField!
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
        
        locationManager.requestLocation()
   
  

        searchTextField.delegate = self
        weatherManager.delegate = self
        
    }
    
   
    @IBAction func locationBasedWeather(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}
//MARK: - UITextFieldDelegate

extension WeatherViewController:UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {

        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }
        else {
            textField.placeholder = "Try Somethin'"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    weatherManager.fetchWeather(cityName: textField.text!)
        
        textField.text = ""
    }

}

//MARK: - WeatherViewController
extension WeatherViewController:WeatherManagerDeletgate {
    
    func didUpdateWeather(weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = "\(weather.cityName), \(weather.country)"
            self.conditionImageView.image = UIImage(systemName: weather.conditionaName)
        }
      
    
    }
}
//MARK: - didUpateloaction
extension WeatherViewController:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        let location = locations.last!
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        weatherManager.fetchWeather(latitude: latitude, longitude: longitude)
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        DispatchQueue.main.async {[unowned self] in
            locationManager.requestLocation()
        }
        
    }
    
}
