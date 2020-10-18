//
//  OpenWeather.swift
//  ACWeather
//
//  Created by Vitalijs Vasilevskis on 18/10/2020.
//

import Foundation
import MapKit

class OpenWeatherAPI: WebService {
    
    private let appKey: String
    
    init(key: String, type: WebServiceType) {
        self.appKey = key
        super.init(serviceHost: "api.openweathermap.org", serviceType: .json, serviceScheme: .https)
    }
    
    public func weather(location: CLLocationCoordinate2D, units: OpenWeatherUnits = .standard, language: OpenWeatherLang = .en, mode: String = "json") {
        self.webCall(path: "/data/2.5/weather", parameters: [
            "lat"   : String(location.latitude),
            "lon"   : String(location.longitude),
            "appid" : self.appKey,
            "units" : units.rawValue,
            "lang"  : language.rawValue,
        ])
    }
    
}
