//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        weatherManager.delegate = self
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    @IBAction func currentLocationButtonPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         searchTextField.endEditing(true)
         return true
     }
     
     func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
         if textField.text != "" {
             return true
         } else {
             textField.placeholder = "Type something"
             return false
         }
     }
     
     func textFieldDidEndEditing(_ textField: UITextField) {
         
         if let city = searchTextField.text {
             weatherManager.fetchWeather(city: city)
         }
         
         searchTextField.text = ""
     }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        print("\(weather) condition=\(weather.conditionName)")
        DispatchQueue.main.async {
            self.cityLabel.text = weather.name.capitalized
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.temperatureLabel.text = String(format: "%.0f", weather.temp)
        }

    }
    
    func didFailWithError(_ weatherManager: WeatherManager, error: Error) {
        print(error)
    }
    
}


//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
//            manager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            weatherManager.fetchWeatherByLocation(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
