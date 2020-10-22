//
//  WeatherCell.swift
//  ACWeather
//
//  Created by Vitalijs Vasilevskis on 22/10/2020.
//

import Foundation
import UIKit

class WeatherCell: UITableViewCell {
    
    @IBOutlet var city: UILabel!
    @IBOutlet var temperature: UILabel!
    @IBOutlet var windSpeed: UILabel!
    @IBOutlet var weatherDate: UILabel!
    @IBOutlet var icon: UIImageView!
    
    public var weatherData: Weather? {
        didSet {
            guard let weatherData = self.weatherData else { return }
            self.city.text = weatherData.name
            self.temperature.text = String(weatherData.main_temp) + "°"
            self.windSpeed.text = "\(weatherData.wind_speed)m/s"
            let date = Date(timeIntervalSince1970: TimeInterval(Int(weatherData.dt)))
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.doesRelativeDateFormatting = true
            self.weatherDate.text = formatter.string(from: date)
            if let icon = self.icon, let url = URL(string: "http://openweathermap.org/img/wn/\(icon)@2x.png") {
                self.icon.loadFrom(url: url)
            }
        }
    }
    
}
