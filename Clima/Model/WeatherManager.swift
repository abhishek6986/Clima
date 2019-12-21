//
//  WeatherManager.swift
//  Clima
//
//  Created by Abhishek Sinha on 03/12/19.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import Foundation
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailedWithError(error: Error)
}
struct WeatherManager {
    //https://api.openweathermap.org/data/2.5/forecast?appid=435205e00734e9262ada063fe3a1231c&q=London&units=metric
    let apiURL = "https://api.openweathermap.org/data/2.5/forecast?"
    let apiKey = "435205e00734e9262ada063fe3a1231c"
    let units = "metric"
    
    var delegate: WeatherManagerDelegate?
    
    // Naking URL
    func fetchWeather(cityName: String) {
        let urlString = "\(apiURL)&appid=\(apiKey)&units=\(units)&q=\(cityName)"
        performRequest(urlString: urlString)
        
    }
    
    func fetchWeather(latitude: Double, longitude: Double){
        let urlString = "\(apiURL)&appid=\(apiKey)&units=\(units)&lat=\(latitude)&lon=\(longitude)"
               performRequest(urlString: urlString)
    }
    
    
    // Performing URL Request
    func performRequest(urlString: String){
        //1. Create URL
        if let url = URL(string: urlString) {
            
            //2. Create Session
            let session = URLSession(configuration: .default)
            
            //3. Assign session a task with completion handler clouser function
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailedWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    //let dataString = String(data: safeData, encoding: .utf8)
                    if let weather = self.parseJSON(weatherData: safeData) {
                        
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                    
                }
            }
            
            //4. Start the task
            task.resume()
        }
        
    }
    
    // Parsing JSON Data
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let city = (decodedData.city.name)
            let condition = decodedData.list[0].weather[0].id
            let temp = decodedData.list[0].main.temp
            
            let weather = WeatherModel(conditionID: condition, cityName: city, temprature: temp )
            return weather
            //print(weather.conditionName)
            //print(weather.tempratureString)
        }
        catch {
            delegate?.didFailedWithError(error: error)
            return nil
        }
        
    }
    
    
    
    
}
