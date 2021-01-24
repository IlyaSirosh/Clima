//
//  WeatherManager.swift
//  Clima
//
//  Created by Illya Sirosh on 17.08.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(_ weatherManager: WeatherManager, error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=02597d1e45379dee369c791cc674ee95&units=metric"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(city: String) {
        let urlString = "\(weatherURL)&q=\(city)"
        
        performRequest(with: urlString)
    }
    
    func fetchWeatherByLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        guard let url = URL(string: urlString) else {
            return
        }
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, handler, error) in
            guard error == nil else {
                self.delegate?.didFailWithError(self, error: error!)
                return
            }
            if  let safeData = data,
                let weather = self.parseJSON(safeData) {
                self.delegate?.didUpdateWeather(self, weather: weather)
            }
        }
        task.resume()
    }

    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            
            return WeatherModel(conditionId: id, name: name, temp: temp)
        } catch {
            self.delegate?.didFailWithError(self, error: error)
            return nil
        }
    }
}
