import UIKit

protocol RequestParametersWithoutCall {
    func sendRequestParametersWithoutCall(clientIdValue: String, clientSecretValue: String, clientNameValue: String, subscriberIDValue: String)
}

class RequestParamsWithoutDiscoveryViewController: UIViewController {
    @IBOutlet weak var popUpView: UIView!

    @IBOutlet weak var clientSecretField: UITextField!
    @IBOutlet weak var clientIdField: UITextField!
    @IBOutlet weak var clientNameField: UITextField!
    @IBOutlet weak var subscriberIdField: UITextField!
    
    @IBOutlet weak var subscriberIdSwitch: UISwitch!
    var clientId = String()
    var clientSecret = String()
    var subscriberId = String()
    var clientName = String()
    var counter = Bool()
    
    var requestParametersDelegate: RequestParametersWithoutCall? = nil
    
    override func viewDidLoad() {
        setValues()
        if counter == false {
            setValues()
            counter = true
        }
    
        super.viewDidLoad()
        clientIdField.text = clientId
        clientSecretField.text = clientSecret
        clientNameField.text = clientName
        if subscriberIdSwitch.isOn {
            subscriberIdField.isHidden = false
            subscriberIdField.text = subscriberId
        } else {
            subscriberIdField.isHidden = true
            subscriberIdField.text = ""
        }
        

        popUpView.layer.cornerRadius = 10
        popUpView.layer.masksToBounds = true
        if withMetadataStatus == false {
            clientNameField.isUserInteractionEnabled = false
            clientNameField.alpha = 0.2
        } else {
            clientNameField.isUserInteractionEnabled = true
            clientNameField.alpha = 1.0
        }
    }

    @IBAction func subscriberIdSwitchTapped(_ sender: Any) {
        if subscriberIdSwitch.isOn {
            subscriberIdField.text = subscriberId
            subscriberIdField.isHidden = false
        } else {
            subscriberIdField.isHidden = true
        }
    }
    
    @IBAction func closePopUp(_ sender: Any) {
        if withMetadataStatus == false {
            clientId = clientIdField.text!
            clientSecret = clientSecretField.text!
            subscriberId = subscriberIdField.text!
        } else {
            clientId = clientIdField.text!
            clientSecret = clientSecretField.text!
            clientName = clientNameField.text!
            subscriberId = subscriberIdField.text!
        }
        
        if requestParametersDelegate != nil {
            requestParametersDelegate?.sendRequestParametersWithoutCall(clientIdValue: clientId, clientSecretValue: clientSecret,
                                                                        clientNameValue: clientName, subscriberIDValue: subscriberId)
        }

        dismiss(animated: true, completion: nil)
    }
    
    func setValues() {
        let pathToConfigutationFile = Bundle.main.path(forResource: "requestParamsExampleApp", ofType: "plist")
        let itemsDictionaryRoot = NSDictionary(contentsOfFile: pathToConfigutationFile!)
        clientId = (itemsDictionaryRoot?.value(forKey: "clientID") as? String)!
        clientSecret = (itemsDictionaryRoot?.value(forKey: "clientSecret") as? String)!
        subscriberId = (itemsDictionaryRoot?.value(forKey: "subscriberId") as? String)!
        clientName = (itemsDictionaryRoot?.value(forKey: "clientName") as? String)!
    }
}
