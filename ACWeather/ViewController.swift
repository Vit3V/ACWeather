//
//  ViewController.swift
//  ACWeather
//
//  Created by Vitalijs Vasilevskis on 14/10/2020.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    var api: OpenWeatherAPI?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        guard let appKey = Bundle.main.object(forInfoDictionaryKey: "Open Weather API Key") as? String else {
            print("ERROR: Could not read AppKey from info.plist")
            return
        }
        self.api = OpenWeatherAPI(key: appKey, type: .json)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.api?.weather(location: CLLocationCoordinate2D())
    }
    

}

