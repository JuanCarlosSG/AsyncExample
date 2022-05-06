//
//  queueViewModel.swift
//  AsyncExample
//
//  Created by Juan Carlos Sánchez Gutiérrez on 05/05/22.
//

import Foundation

class queueViewModel: ObservableObject {
    
    let cola = DispatchQueue(label: "printer")
    
    func processFile(fileName: String, size: Int, opeartion: @escaping (String) -> ()) {
        
        cola.async {
            
            for i in 1...size {
                
                sleep(1)
                
                DispatchQueue.main.async {
                    
                    opeartion("Printing \(fileName): \(i) of \(size)")
                    
                }
                
            }
            
        }
        
        
    }
    
    
}
