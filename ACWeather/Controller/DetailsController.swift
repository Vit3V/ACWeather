//
//  DetailsController.swift
//  ACWeather
//
//  Created by Vitalijs Vasilevskis on 22/10/2020.
//

import Foundation
import UIKit
import CoreData

class DetailsController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var weather: Weather? {
        didSet {
            self.attributes = self.weather?.entity.attributesByName.enumerated().map { $0.element.key }
        }
    }
    
    var attributes: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.attributes?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if let attr = attributes?[indexPath.row] {
            let val = self.weather?.value(forKey: attr)
            let value: String
            if let val = val as? String {
                value = val
            } else if let val = val as? Float {
                value = String(val)
            } else if let val = val as? Double {
                value = String(val)
            } else if let val = val as? Int64 {
                value = String(val)
            } else {
                value = ""
            }
            cell.textLabel?.text = "\(attr) : \(value)"
        }
        
        return cell
    }
    
}
