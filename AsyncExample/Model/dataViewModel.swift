//
//  dataViewModel.swift
//  AsyncExample
//
//  Created by Juan Carlos Sánchez Gutiérrez on 05/05/22.
//

import Foundation

struct dataPrint: Encodable {
    var name: String
    var size: Int
}

struct apiResp: Decodable, Encodable {
    var ticket: String
}

struct apiResp2: Decodable {
    var price: String
}

class dataViewModel: ObservableObject {
    
    func uploadPrint(file: dataPrint, completion: @escaping (String) -> ()) {
        
        guard let url = URL(string: "http://172.30.83.233:8080/agregarImpresion") else {fatalError()}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try! JSONEncoder().encode(file)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, resp, error) in
            
            if let error = error {
                print("Error took place \(error)")
                return
            }
            guard let data = data else {
                print("No hubo datos")
                return
            }
            
            do {
                
                let finalResponse = try JSONDecoder().decode(apiResp.self, from: data)
                DispatchQueue.main.async {
                    completion(finalResponse.ticket)
                }
                
            } catch let jerror {
                print(jerror)
            }
            
        }
        dataTask.resume()
    }
    
    func getPrintPrice(ticket: apiResp, completion: @escaping (String) -> ())  {
        guard let url = URL(string: "http://172.30.83.233:8080/obtenerPrecio/\(ticket.ticket)") else {fatalError()}
        let urlRequest = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, resp, error) in
            
            if let error = error {
                print("Error took place \(error)")
                return
            }
            guard let data = data else {
                print("No hubo datos")
                return
            }
            
            do {
                
                let finalResponse = try JSONDecoder().decode(apiResp2.self, from: data)
                DispatchQueue.main.async {
                    completion(finalResponse.price)
                }
                
            } catch let jerror {
                print(jerror)
            }
            
        }
        dataTask.resume()
    }
}
