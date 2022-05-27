
import Foundation

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let currencyArray = ["USD","EUR","GBP","AUD", "BRL","CAD","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","ZAR"]
    
    
    func fetchRequest(for currencyForBitcoin: String) {
        let urlString = "\(baseURL)/\(currencyForBitcoin)?apikey=\("myApiKey")"
        performRequest(urlString: urlString, currency: currencyForBitcoin)
    }
    
    
    func performRequest(urlString: String, currency: String) {
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task =  session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let bitcoinCurrency = self.parseJSON(bitcoinData: safeData) {
                        let priceString = String(format: "%.2f", bitcoinCurrency)
                        self.delegate?.didUpdateCurrency(price: priceString, currency: currency)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(bitcoinData: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: bitcoinData)
            let price = decodedData.rate
            return price
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

protocol CoinManagerDelegate {
    func didUpdateCurrency(price: String, currency: String)
    func didFailWithError(error: Error)
}
