

import UIKit

class ViewController: UIViewController {
    
    private var coinManager = CoinManager()
    
    @IBOutlet weak var bitcoinCurrencyLabel: UILabel!
    @IBOutlet weak var currencyForBitcoin: UILabel!
    @IBOutlet weak var pickerForBitcoinCerrency: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coinManager.delegate = self
        pickerForBitcoinCerrency.delegate = self
        pickerForBitcoinCerrency.dataSource = self
    }
    
}
//MARK: - UIPickerViewDataSource

extension ViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
}

//MARK: - UIPickerViewDelegate

extension ViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.fetchRequest(for: selectedCurrency)
        
        
    }
}
//MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate {
    
    func didUpdateCurrency(price: String, currency: String) {
        DispatchQueue.main.async {
            self.bitcoinCurrencyLabel.text = price
            self.currencyForBitcoin.text = currency
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}
