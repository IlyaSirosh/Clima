//
//  WeatherModel.swift
//  Clima
//
//  Created by Illya Sirosh on 17.08.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel{
    let conditionId: Int
    let name: String
    let temp: Double
    
    
    var conditionName: String {
           switch conditionId {
           case 200..<300:
               return "cloud.bolt.rain"
           case 300..<400:
               return "cloud.drizzle"
           case 500..<600:
               return "cloud.rain"
           case 600..<700:
               return "snow"
           case 700..<800:
               return "cloud.fog"
           case 800:
               return "sun.max"
           case 801..<900:
               return "cloud"
           default:
               return "cloud"
           }
       }
       
    
}
