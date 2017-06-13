import UIKit


protocol WithoutCallEndpoints {
    func sendWithoutCallEndpointsData(sendedEndpoints: [String:String])
}

class EndpointConfigurationViewController: UIViewController {

    @IBOutlet weak var authURL: UITextField!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var providerMetadataURl: UITextField!
    
    @IBOutlet weak var userInfoURL: UITextField!
    @IBOutlet weak var accessTokenURL: UITextField!
    
    var counterEndpoints = true
    var endpoints : [String: String] = [:]
    var delegate: WithoutCallEndpoints? = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        if counterEndpoints == true {
            setEndpoints()
            counterEndpoints = false
        }
        
        popUpView.layer.cornerRadius = 10
        popUpView.layer.masksToBounds = true
        
        if withMetadataStatus == false {
            authURL.text = endpoints["authorizationEndpoint"]
            userInfoURL.text = endpoints["userInfoEndpoint"]
            accessTokenURL.text = endpoints["accessTokenEndpoint"]
            providerMetadataURl.text = ""
            
            providerMetadataURl.isUserInteractionEnabled = false
            providerMetadataURl.alpha = 0.2
            
            authURL.isUserInteractionEnabled = true
            authURL.alpha = 1.0
            userInfoURL.isUserInteractionEnabled = true
            userInfoURL.alpha = 1.0
            accessTokenURL.isUserInteractionEnabled = true
            accessTokenURL.alpha = 1.0
        } else {
            authURL.text = ""
            userInfoURL.text = ""
            accessTokenURL.text = ""
            
            providerMetadataURl.text = endpoints["metadataEndpoint"]
            providerMetadataURl.alpha = 1.0
            
            authURL.isUserInteractionEnabled = false
            authURL.alpha = 0.2
            userInfoURL.isUserInteractionEnabled = false
            userInfoURL.alpha = 0.2
            accessTokenURL.isUserInteractionEnabled = false
            accessTokenURL.alpha = 0.2
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func closePopUp(_ sender: Any) {
        if withMetadataStatus == false {
            endpoints["authorizationEndpoint"] = authURL.text!
            endpoints["accessTokenEndpoint"] = accessTokenURL.text!
            endpoints["userInfoEndpoint"] = userInfoURL.text!
        } else {
            endpoints["metadataEndpoint"] = providerMetadataURl.text!
        }
        
        if delegate != nil {
            delegate?.sendWithoutCallEndpointsData(sendedEndpoints: endpoints)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func setEndpoints() {
        let pathToConfigutationFile = Bundle.main.path(forResource: "operatorURLs", ofType: "plist")
        let itemsDictionaryRoot = NSDictionary(contentsOfFile: pathToConfigutationFile!)
        endpoints = ["authorizationEndpoint" : (itemsDictionaryRoot?.value(forKey: "authorization") as? String)!,
                     "accessTokenEndpoint" : (itemsDictionaryRoot?.value(forKey: "token") as? String)!,
                     "userInfoEndpoint" : (itemsDictionaryRoot?.value(forKey: "userinfo") as? String)!,
                     "metadataEndpoint" : (itemsDictionaryRoot?.value(forKey: "openid-configuration") as? String)!]
    }
}
