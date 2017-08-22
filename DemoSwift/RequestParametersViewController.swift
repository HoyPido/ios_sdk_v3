import UIKit

protocol RequestParametersDeleagete {
    func sendRequestParametersData(clientID: String, clientSecret: String, discoveryURL: String, redirectURL: String, xSourceIP: String, xRedirect: Bool)
}

class RequestParametersViewController: UIViewController {

    @IBOutlet weak var clientIDField: UITextField!
    @IBOutlet weak var clientSecretField: UITextField!
    @IBOutlet weak var discoveryURLField: UITextField!
    @IBOutlet weak var redirectURLField: UITextField!
    @IBOutlet weak var xSourceIpField: UITextField!
    
    @IBOutlet weak var popUpVIew: UIView!
    
    @IBOutlet weak var xRedirectState: UISwitch!
    @IBOutlet weak var xSourceIpSwitch: UISwitch!
    
    var clientId = String()
    var redirectURLValue = String()
    var xRedirectValue = Bool()
    var clientSecretValue = String()
    var discoveryURLValue = String()
    var sourceIPValue = String()
    var state = Bool()
    
    var delegateRequestParameters: RequestParametersDeleagete? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)

        popUpVIew.layer.cornerRadius = 10
        popUpVIew.layer.masksToBounds = true
        clientIDField.text = clientId
        clientSecretField.text = clientSecretValue
        discoveryURLField.text = discoveryURLValue
        redirectURLField.text = redirectURLValue
        xRedirectState.isOn = xRedirectValue
        xSourceIpSwitch.isOn = state
        
        if xSourceIpSwitch.isOn == false {
            xSourceIpField.isHidden = true
        } else {
            xSourceIpField.isHidden = false
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func closePopUp(_ sender: Any) {
        clientId = clientIDField.text!
        clientSecretValue = clientSecretField.text!
        discoveryURLValue = discoveryURLField.text!
        redirectURLValue = redirectURLField.text!
        xRedirectValue = xRedirectState.isOn
        sourceIPValue = xSourceIpField.text!
        state = xSourceIpSwitch.isOn
        if delegateRequestParameters != nil {
            delegateRequestParameters?.sendRequestParametersData(clientID: clientId, clientSecret: clientSecretValue, discoveryURL: discoveryURLValue, redirectURL: redirectURLValue, xSourceIP: sourceIPValue, xRedirect: xRedirectValue)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func xSourceSwitchTapped(_ sender: Any) {
        if xSourceIpSwitch.isOn == true {
            xSourceIpField.isHidden = false
        } else {
            xSourceIpField.isHidden = true
            xSourceIpField.text = ""
        }
    }
    
    
}
