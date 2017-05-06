import UIKit
import MobileConnectSDK

protocol RequestOptionsDelegate {
    func sendRequestOptionsData(_ scopesSet: [ProductType: Bool])
}

class RequestOptionsViewController: UIViewController {
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var addressSwitch: UISwitch!
    @IBOutlet weak var emailSwitch: UISwitch!
    @IBOutlet weak var phoneSwitch: UISwitch!
    @IBOutlet weak var profileSwitch: UISwitch!
    @IBOutlet weak var nationalIDSwitch: UISwitch!
    @IBOutlet weak var phoneNumberSwitch: UISwitch!
    @IBOutlet weak var signUpSwitch: UISwitch!
    
    var power = Bool()
    var identity = Bool()
    var scopesSet = [ProductType: Bool]()
    
    var delegate: RequestOptionsDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popUpView.layer.cornerRadius = 10
        popUpView.layer.masksToBounds = true
        
        if power == false {
            updateValue()
            power = true
        }
        
        addressSwitch.isOn = scopesSet[ProductType.address]!
        emailSwitch.isOn = scopesSet[ProductType.email]!
        phoneSwitch.isOn = scopesSet[ProductType.phone]!
        profileSwitch.isOn = scopesSet[ProductType.profile]!
        nationalIDSwitch.isOn = scopesSet[ProductType.identityNationalID]!
        phoneNumberSwitch.isOn = scopesSet[ProductType.identityPhoneNumber]!
        signUpSwitch.isOn = scopesSet[ProductType.identitySignUp]!
    }
    
    func sendScopesToConfigureView(scopesTest: [ProductType: Bool]) {
        scopesSet = scopesTest
    }
    
    @IBAction func closePopUp(_ sender: Any) {
        updateValue()
        if delegate != nil {
            delegate?.sendRequestOptionsData(scopesSet)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func updateValue() {
        scopesSet = [ProductType.address : addressSwitch.isOn,
                     ProductType.email : emailSwitch.isOn,
                     ProductType.phone : phoneSwitch.isOn,
                     ProductType.profile : profileSwitch.isOn,
                     ProductType.identitySignUp : signUpSwitch.isOn,
                     ProductType.identityPhoneNumber : phoneNumberSwitch.isOn,
                     ProductType.identityNationalID : nationalIDSwitch.isOn]
    }

}
