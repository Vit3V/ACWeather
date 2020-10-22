//
//  WeatherManager.swift
//  ACWeather
//
//  Created by Vitalijs Vasilevskis on 22/10/2020.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    
    class func saveWeather() {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = delegate.persistentContainer.viewContext
        if let entity = NSEntityDescription.entity(forEntityName: "Weather", in: context) {
            if let weather = NSManagedObject(entity: entity, insertInto: context) as? Weather {
                
            }
        }
    }
    
}
