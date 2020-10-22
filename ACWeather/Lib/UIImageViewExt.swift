//
//  UIImageViewExt.swift
//  ACWeather
//
//  Created by Vitalijs Vasilevskis on 22/10/2020.
//

import UIKit
import Foundation

extension UIImageView {
    
    func loadFrom(url: URL) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                print("ERROR: Could not download image data for \(url)")
                return
            }
            DispatchQueue.main.async {
                self.image = image
            }
        }
        task.resume()
    }
    
}
