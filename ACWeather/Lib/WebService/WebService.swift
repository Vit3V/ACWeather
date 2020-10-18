//
//  WebService.swift
//  ACWeather
//
//  Created by Vitalijs Vasilevskis on 18/10/2020.
//

import Foundation

public enum WebServiceType {
    case xml
    case json
}

public enum WebServiceScheme: String {
    case http
    case https
}

class WebService {
    
    internal let host: String
    internal let scheme: String
    
    private var components: URLComponents
    
    public let type: WebServiceType
    
    init(serviceHost: String, serviceType: WebServiceType, serviceScheme: WebServiceScheme) {
        self.host   = serviceHost
        self.type   = serviceType
        self.scheme = serviceScheme.rawValue
        
        self.components = URLComponents()
        self.components.host = self.host
        self.components.scheme = self.scheme
    }
    
    internal func webCall(path: String, parameters: [String : String?]) {
        var comps = self.components
        comps.path = path
        comps.queryItems = []
        
        for param in parameters {
            let item = URLQueryItem(name: param.key, value: param.value)
            comps.queryItems?.append(item)
        }
        
        guard let url = comps.url else {
            print("ERROR: Could not construct url with \(comps.path)")
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let err = error {
                print("ERROR: \(err)")
                return
            }
            guard let stringData = data else {
                print("ERROR: Could not get text response!")
                return
            }
            
            switch self.type {
            case .json:
                self.parseJSON(text: stringData)
            case .xml:
                assertionFailure("XML parsing not implemented")
            }
        }
        task.resume()
    }
    
    private func parseJSON(text: Data) {
        do {
            guard let json = try JSONSerialization.jsonObject(with: text, options: []) as? [String : Any?] else {
                print("ERROR: could not parse JSON")
                return
            }
            print("JSON \(json)")
        } catch {
            print("ERROR: Could not parse JSON")
        }
    }
    
}
