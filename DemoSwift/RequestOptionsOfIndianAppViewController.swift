import UIKit
import MobileConnectSDK

protocol RequestIndianOptionsDelegate {
    func sendRequestIndianOptionsData(_ scopesSet: [ProductType: Bool])
}

class RequestOptionsOfIndianAppViewController: UIViewController {
    
    
    @IBOutlet weak var openIDSwitch: UISwitch!
    @IBOutlet weak var indiaTCSwitch: UISwitch!
    @IBOutlet weak var mnvValidateSwitch: UISwitch!
    @IBOutlet weak var mnvValidatePlusSwitch: UISwitch!
    @IBOutlet weak var popUpview: UIView!
    
    var power = Bool()
    var identity = Bool()
    var scopesSet = [ProductType: Bool]()
    
    var delegate: RequestIndianOptionsDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popUpview.layer.cornerRadius = 10
        popUpview.layer.masksToBounds = true
        
        if power == false {
            updateValue()
            power = true
        }
        
        openIDSwitch.isOn = scopesSet[ProductType.indianOpenID]!
        indiaTCSwitch.isOn = scopesSet[ProductType.indiaTC]!
        mnvValidateSwitch.isOn = scopesSet[ProductType.indiaMNVValidate]!
        mnvValidatePlusSwitch.isOn = scopesSet[ProductType.indiaMNVValidatePlus]!
    }
    
    func sendScopesToConfigureView(scopesTest: [ProductType: Bool]) {
        scopesSet = scopesTest
    }

    @IBAction func closePopUp(_ sender: Any) {
        updateValue()
        if delegate != nil {
            delegate?.sendRequestIndianOptionsData(scopesSet)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func updateValue() {
        scopesSet = [ProductType.indianOpenID : openIDSwitch.isOn,
                     ProductType.indiaTC : indiaTCSwitch.isOn,
                     ProductType.indiaMNVValidate : mnvValidateSwitch.isOn,
                     ProductType.indiaMNVValidatePlus : mnvValidatePlusSwitch.isOn]
    }
    

    @IBAction func indiaTCChanged(_ sender: Any) {
        openIDSwitch.isOn = false
        mnvValidateSwitch.isOn = false
        mnvValidatePlusSwitch.isOn = false
    }
    @IBAction func mnvValidateChange(_ sender: Any) {
        openIDSwitch.isOn = false
        mnvValidatePlusSwitch.isOn = false
        indiaTCSwitch.isOn = false
    }
    
    @IBAction func openIDSwitch(_ sender: Any) {
        mnvValidateSwitch.isOn = false
        mnvValidatePlusSwitch.isOn = false
        indiaTCSwitch.isOn = false
    }
    @IBAction func mnvValidatePlusChanged(_ sender: Any) {
        openIDSwitch.isOn = false
        mnvValidateSwitch.isOn = false
        indiaTCSwitch.isOn = false
    }
    
    
}
