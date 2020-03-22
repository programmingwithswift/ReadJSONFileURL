//
//  ViewController.swift
//  ReadJSONFileURL
//
//  Created by ProgrammingWithSwift on 2020/03/22.
//  Copyright © 2020 ProgrammingWithSwift. All rights reserved.
//

import UIKit

struct DemoData: Codable {
    let title: String
    let description: String
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
 
        if let localData = self.readLocalFile(forName: "data") {
            self.parse(jsonData: localData)
        }
        
        self.loadJson(fromURLString: "https://reddit.com") { (result) in
            switch result {
            case .success(let data):
                self.parse(jsonData: data)
            case .failure(let error):
                print(error)
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    private func loadJson(fromURLString urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        if let url = URL(string: urlString) {
            let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                }
                
                if let data = data {
                    completion(.success(data))
                }
            }
            
            urlSession.resume()
        }
    }

    private func parse(jsonData: Data) {
        do {
            let decodedData = try JSONDecoder().decode(DemoData.self,
                                                       from: jsonData)
            
            print("Title: ", decodedData.title)
            print("Description: ", decodedData.description)
        } catch {
            print("decode error")
        }
    }
}

