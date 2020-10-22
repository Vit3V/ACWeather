//
//  ViewController.swift
//  ACWeather
//
//  Created by Vitalijs Vasilevskis on 14/10/2020.
//

import UIKit
import MapKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var api: OpenWeatherAPI?
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        guard let appKey = Bundle.main.object(forInfoDictionaryKey: "Open Weather API Key") as? String else {
            print("ERROR: Could not read AppKey from info.plist")
            return
        }
        self.api = OpenWeatherAPI(key: appKey, type: .json)
        
        NotificationCenter.default.addObserver(forName: .weatherDataAdded, object: nil, queue: .none, using: { _ in
            self.tableView.reloadData()
        })
        
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction public func updateWeather() {
        guard let location = self.locationManager.location else {
            let alert = UIAlertController(title: "ERROR: Could not retreive device location", message: "To retreive weather information for your current location - please enable the location services in the Settings Application!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: {})
            return
        }
        self.api?.weather(location: location.coordinate, success: { resp in
            DispatchQueue.main.async {
                DataManager.saveWeather(weatherResponse: resp)
            }
        }, failure: {
            
        })
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let weather = (DataManager.getEntities(name: "Weather") as [Weather])
        return weather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if let weatherCell = self.tableView.dequeueReusableCell(withIdentifier: "weather_cell") {
            cell = weatherCell
        } else {
            cell = UITableViewCell()
        }
        return cell
    }
    
}
