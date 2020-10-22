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
        self.api?.weather(location: location.coordinate, units: .metric, success: { resp in
            DispatchQueue.main.async {
                DataManager.saveWeather(weatherResponse: resp)
            }
        }, failure: {
            
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let details = segue.destination as? DetailsController, let cell = sender as? WeatherCell {
            details.weather = cell.weatherData
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let weather = (DataManager.getEntities(name: "Weather") as [Weather])
        return weather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if let weatherCell = self.tableView.dequeueReusableCell(withIdentifier: "weather_cell") as? WeatherCell {
            let weatherArray = (DataManager.getEntities(name: "Weather") as [Weather])
            let weatherData = weatherArray[indexPath.row]
            weatherCell.weatherData = weatherData
            cell = weatherCell
        } else {
            cell = UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "weather_cell") {
            return cell.frame.height
        }
        return 100
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let weather = (DataManager.getEntities(name: "Weather") as [Weather])
            guard indexPath.row < weather.count else {
                print("ERROR: The item seems not to exist in this array!")
                return
            }
            DataManager.removeItem(item: weather[indexPath.row])
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = DataManager.getEntities(name: "Weather") as [Weather]
        guard indexPath.row < data.count else { return }
        self.tableView.deselectRow(at: indexPath, animated: false)
        self.performSegue(withIdentifier: "show_details", sender: self.tableView.cellForRow(at: indexPath))
    }
    
}
