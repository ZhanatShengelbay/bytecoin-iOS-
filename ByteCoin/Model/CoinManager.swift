//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate{
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    //let rate: Double
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "70CC7D03-0AC1-4E17-8628-B34514C6A099" //
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?
    

    func getCoinPrice(currency: String){
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        if let url = URL(string: urlString) {
            
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        self.delegate?.didFailWithError(error: error!)
                        return
                    }
                    
                    if let safeData = data {
                        
                        if let coinPrice = self.parseJSON(safeData) {
                            
                            let priceString = String(format: "%.2f", coinPrice)
                    
                            self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                        }
                    }
                }
                
                task.resume()
            }
        }
    
    func parseJSON(_ currencyData: Data) -> Double? {
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(CoinData.self, from: currencyData)
                let rate = decodedData.rate
                print(rate)
                return rate
                
            } catch {
                delegate?.didFailWithError(error: error)
                return nil
            }
        }
        
}


    
