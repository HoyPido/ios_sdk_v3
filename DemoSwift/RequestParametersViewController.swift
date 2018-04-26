import UIKit

protocol RequestParametersDeleagete {
    func sendRequestParametersData(clientID: String, clientSecret: String, discoveryURL: String, redirectURL: String, xSourceIP: String, xRedirect: Bool, clientName: String, bindingMessage: String, context: String)
}

class RequestParametersViewController: UIViewController {

    @IBOutlet weak var clientIDField: UITextField!
    @IBOutlet weak var clientSecretField: UITextField!
    @IBOutlet weak var discoveryURLField: UITextField!
    @IBOutlet weak var redirectURLField: UITextField!
    @IBOutlet weak var clientNameField: UITextField!
    @IBOutlet weak var bindingMessageField: UITextField!
    @IBOutlet weak var contextField: UITextField!
    
    @IBOutlet weak var popUpVIew: UIView!
    
    @IBOutlet weak var xRedirectState: UISwitch!
    
    var clientId = String()
    var redirectURLValue = String()
    var xRedirectValue = Bool()
    var clientSecretValue = String()
    var discoveryURLValue = String()
    var sourceIPValue = String()
    var clientNameValue = String()
    var bindingMessageValue = String()
    var contextValue = String()
    
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
        
        if endpointVersion == 1.1 {
            clientNameField.text = ""
            clientNameField.isUserInteractionEnabled = false
            clientNameField.alpha = 0.2
            
            bindingMessageField.text = ""
            bindingMessageField.isUserInteractionEnabled = false
            bindingMessageField.alpha = 0.2
            
            contextField.text = ""
            contextField.isUserInteractionEnabled = false
            contextField.alpha = 0.2
        } else {
            clientNameField.text = clientNameValue
            bindingMessageField.text = bindingMessageValue
            contextField.text = contextValue
        }
        
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func closePopUp(_ sender: Any) {
        clientId = clientIDField.text!
        clientSecretValue = clientSecretField.text!
        discoveryURLValue = discoveryURLField.text!
        redirectURLValue = redirectURLField.text!
        xRedirectValue = xRedirectState.isOn
        clientNameValue = clientNameField.text!
        bindingMessageValue = bindingMessageField.text!
        contextValue = contextField.text!
        if delegateRequestParameters != nil {
            delegateRequestParameters?.sendRequestParametersData(clientID: clientId, clientSecret: clientSecretValue, discoveryURL: discoveryURLValue, redirectURL: redirectURLValue, xSourceIP: sourceIPValue, xRedirect: xRedirectValue, clientName: clientNameValue, bindingMessage: bindingMessageValue, context: contextValue)
        }
        dismiss(animated: true, completion: nil)
    }
    
}
