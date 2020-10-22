//
//  WeatherManager.swift
//  ACWeather
//
//  Created by Vitalijs Vasilevskis on 22/10/2020.
//

import Foundation
import UIKit
import CoreData

class DataManager {
    
    private class func getContext() -> NSManagedObjectContext? {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        return delegate?.persistentContainer.viewContext
    }
    
    class func saveWeather(weatherResponse: [String : Any?]) {
        guard let context = self.getContext() else {
            print("ERROR: could not get CoreData context")
            return
        }
        let weather = Weather(context: context)
        if let coords = weatherResponse["coord"] as? [String : Double] {
            weather.coord_lon = coords["lon"] ?? 361
            weather.coord_lat = coords["lat"] ?? 361
        }
        if let wth = (weatherResponse["weather"] as? [AnyHashable])?.first as? [String : Any?] {
            weather.weather_id = (wth["id"] as? Int32) ?? 0
            weather.weather_icon = wth["icon"] as? String
            weather.weather_main = wth["main"] as? String
            weather.weather_description = wth["description"] as? String
        }
        if let base = weatherResponse["base"] as? String {
            weather.base = base
        }
        if let main = weatherResponse["main"] as? [String : Any?] {
            weather.main_temp = main["temp"] as? Double ?? -273.15
            weather.main_humidity = main["humidity"] as? Int32 ?? 0
            weather.main_pressure = main["pressure"] as? Int32 ?? 0
            weather.main_temp_max = main["temp_max"] as? Double ?? -273.15
            weather.main_temp_min = main["temp_min"] as? Double ?? -273.15
            weather.main_sea_level = main["sea_level"] as? Float ?? 0
            weather.main_grnd_level = main["grnd_level"] as? Float ?? 0
            weather.main_feels_like = main["feels_like"] as? Double ?? -273.15
        }
        if let wind = weatherResponse["wind"] as? [String : Any?] {
            weather.wind_deg = wind["deg"] as? Float ?? 0
            weather.wind_gust = wind["gust"] as? Double ?? 0
            weather.wind_speed = wind["speed"] as? Double ?? 0
        }
        if let clouds_all = weatherResponse["clouds"] as? [String : Float], let all = clouds_all["all"] {
            weather.clouds_all = all
        }
        if let rain = weatherResponse["rain"] as? [String : Float] {
            weather.rain_1h = rain["1h"] ?? 0
            weather.rain_3h = rain["3h"] ?? 0
        }
        if let snow = weatherResponse["snow"] as? [String : Float] {
            weather.snow_1h = snow["1h"] ?? 0
            weather.snow_3h = snow["3h"] ?? 0
        }
        if let dt = weatherResponse["dt"] as? Int64 {
            weather.dt = dt
        }
        if let sys = weatherResponse["sys"] as? [String : Any?] {
            weather.sys_id = sys["id"] as? Int32 ?? 0
            weather.sys_type = sys["type"] as? Int32 ?? 0
            weather.sys_sunset = sys["sunset"] as? Int64 ?? 0
            weather.sys_sunrise = sys["sunrise"] as? Int64 ?? 0
            weather.sys_country = sys["country"] as? String
            weather.sys_message = sys["message"] as? Float ?? 0
        }
        if let timezone = weatherResponse["timezone"] as? Int32 {
            weather.timezone = timezone
        }
        if let id = weatherResponse["id"] as? Int64 {
            weather.id = id
        }
        if let name = weatherResponse["name"] as? String {
            weather.name = name
        }
        if let cod = weatherResponse["cod"] as? Int32 {
            weather.cod = cod
        }
        
        self.saveContext()
        
        NotificationCenter.default.post(name: .weatherDataAdded, object: weather)
    }
    
    class func getEntities<T: NSFetchRequestResult>(name: String) -> [T] {
        var result: [T] = []

        let context = self.getContext()
        let request = NSFetchRequest<T>(entityName: name)
        request.returnsObjectsAsFaults = false
        do {
            if let items = try context?.fetch(request) {
                result = items
            }
        } catch {
            print("ERROR: Could not retreive Weather entities from ")
        }
        
        return result
    }
    
    class func saveContext() {
        do {
            try self.getContext()?.save()
        } catch {
            print("ERROR: Could not save CoreData context!")
        }
    }
    
    class func removeItem(item: NSManagedObject) {
        let context = self.getContext()
        context?.delete(item)
        self.saveContext()
    }
    
}

extension NSNotification.Name {
    public static let weatherDataAdded = NSNotification.Name("weatherDataAdded")
}
