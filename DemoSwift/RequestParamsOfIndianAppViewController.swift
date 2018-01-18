import UIKit

protocol RequestParametersIndianAppDeleagete {
    func sendRequestIndianParametersData(clientID: String, clientSecret: String, discoveryURL: String, redirectURL: String, xRedirect: Bool)
}
private var IndianParametersFirstCall: Bool = true
class RequestParamsOfIndianAppViewController: UIViewController {
    
    @IBOutlet weak var clientIDField: UITextField!
    @IBOutlet weak var clientSecretField: UITextField!
    @IBOutlet weak var discoveryURLField: UITextField!
    @IBOutlet weak var redirectURLField: UITextField!
    @IBOutlet weak var popUpView: UIView!
    
    @IBOutlet weak var xRedirectState: UISwitch!
    
    var clientId = String()
    var redirectURLValue = String()
    var xRedirectValue = Bool()
    var clientSecretValue = String()
    var discoveryURLValue = String()
    var mcc = String()
    var mnc = String()
    var delegateRequestParameters: RequestParametersIndianAppDeleagete? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popUpView.layer.cornerRadius = 10
        popUpView.layer.masksToBounds = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        clientIDField.text = clientId
        clientSecretField.text = clientSecretValue
        discoveryURLField.text = discoveryURLValue
        redirectURLField.text = redirectURLValue
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
        if delegateRequestParameters != nil {
            delegateRequestParameters?.sendRequestIndianParametersData(clientID: clientId, clientSecret: clientSecretValue, discoveryURL: discoveryURLValue, redirectURL: redirectURLValue, xRedirect: xRedirectValue)
        }
        dismiss(animated: true, completion: nil)
    }
}
