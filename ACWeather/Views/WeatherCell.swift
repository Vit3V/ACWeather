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
    
}
