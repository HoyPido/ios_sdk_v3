import UIKit
import MobileConnectSDK


private var mncAndmccFirstCall: Bool = true
private var msisdnSegmentFirstCall: Bool = true
class IndianAppViewController: UIViewController, RequestIndianOptionsDelegate, RequestParametersIndianAppDeleagete {
    
    @IBOutlet weak var viewControllerLabel: UILabel!
    @IBOutlet weak var segmentedControll: UISegmentedControl!
    @IBOutlet weak var msisdnTextField: UITextField!
    @IBOutlet weak var clientNameTextField: UITextField!
    @IBOutlet weak var mncValueField: UITextField!
    @IBOutlet weak var mccValueTextField: UITextField!
    @IBOutlet weak var requestParametersButton: UIButton!
    @IBOutlet weak var requestOptionsButton: UIButton!
    @IBOutlet weak var msisdnLabel: UILabel!
    @IBOutlet weak var getTokenButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func closePopUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var isCalledDiscoveryWithPhoneNumber : Bool = false
    var currentTokenResponse : TokenResponseModel?
    var currentResponse : AttributeResponseModel?
    var currentError : NSError?
    var identity = false
    var scopes: [ProductType] = [ProductType.indianOpenID]
    
    // MARK: Request options
    var scopesSetDemoApp = [ProductType: Bool]()
    
    // MARK: Request parameters
    var clientIdValue: String = ""
    var redirectURLValue: String = ""
    var xRedirectValue: Bool = false
    var msisdn: String = ""
    var clientName: String = ""
    var clientSecretValue: String = ""
    var discoveryURLValue: String = ""
    var mccValue: String = ""
    var mncValue: String = ""
    
    var userInfoResponse: UserInfoResponse? = nil
    
    func sendRequestIndianParametersData(clientID: String, clientSecret: String, discoveryURL: String, redirectURL: String, xRedirect: Bool) {
        clientIdValue = clientID
        clientSecretValue = clientSecret
        discoveryURLValue = discoveryURL
        redirectURLValue = redirectURL
        xRedirectValue = xRedirect
    }
    
    @IBOutlet weak var mncLabel: UILabel!
    @IBOutlet weak var mccLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var clientNameLabel: UILabel!
    
    @IBAction func segmentControllChanged(_ sender: Any) {
        if segmentedControll.selectedSegmentIndex == 0 {
            msisdnLabel.isHidden = true
            phoneNumberLabel.isHidden = true
            msisdnTextField.isHidden = true
            mncValueField.isHidden = true
            mccValueTextField.isHidden = true
            mccLabel.isHidden = true
            mncLabel.isHidden = true
        } else if segmentedControll.selectedSegmentIndex == 1{
            msisdnLabel.isHidden = true
            if (mncAndmccFirstCall) {
                mncValueField.text = mncValue
                mccValueTextField.text = mccValue
                mncAndmccFirstCall = false
            }
            phoneNumberLabel.isHidden = true
            msisdnTextField.isHidden = true
            mncLabel.isHidden = false
            mncValueField.isHidden = false
            mccLabel.isHidden = false
            mccValueTextField.isHidden = false
        } else {
            msisdnLabel.isHidden = false
            if (msisdnSegmentFirstCall) {
                msisdnTextField.text = msisdn
                msisdnSegmentFirstCall = false
            }
            
            phoneNumberLabel.isHidden = false
            msisdnTextField.isHidden = false
            mncLabel.isHidden = true
            mncValueField.isHidden = true
            mccLabel.isHidden = true
            mccValueTextField.isHidden = true
        }
        
    }
    
    @IBAction func alerViewDisplay(_ sender: Any) {
        let alert = UIAlertController(title: "Indian App", message: "Example application for Indian operators", preferredStyle: .alert)
        self.present(alert, animated: true, completion:{
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
        })
    }
    
    func sendRequestIndianOptionsData(_ scopesS: [ProductType: Bool]) {
        scopesSetDemoApp = scopesS
    }
    
    func sendScopesToConfigureView(scopesTest: [ProductType: Bool]) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Mobile Connect Example App"
        commonInit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(IndianAppViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func commonInit() {
        
        self.viewControllerLabel.text = "Indian app"
        if (indianApplicationFirstCall) {
            setRequestParametersValues()
            indianApplicationFirstCall = false
        }
        
        let requestParametersLongGesture = UILongPressGestureRecognizer(target: self, action: #selector(IndianAppViewController.longPressRequestParameters))
        let requestOptionsLongGesture = UILongPressGestureRecognizer(target: self, action: #selector(IndianAppViewController.longPressRequestOptions))
        requestParametersButton.addGestureRecognizer(requestParametersLongGesture)
        requestOptionsButton.addGestureRecognizer(requestOptionsLongGesture)
        requestOptionsButton.layer.cornerRadius = 5
        requestParametersButton.layer.cornerRadius = 5
        getTokenButton.layer.cornerRadius = 5
        getTokenButton.layer.borderWidth = 1
        getTokenButton.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func getToken(_ sender: Any) {
        scopes = [ProductType.indianOpenID]
        setParameters()
        setScopes()
        let manager : MobileConnectManager = MobileConnectManager()
        //none
        if segmentedControll.selectedSegmentIndex == 0 {
            manager.getAuthorizationTokenInPresenterController(self, clientIP: "", clientName: clientNameTextField.text!, withScopes: scopes, completionHandler: launchTokenViewerWithTokenResponseModel)
            //mcc_mnc
        } else if segmentedControll.selectedSegmentIndex == 1{
            print(scopes)
            manager.getAuthorizationTokenForMCCAndMNC(mccValueTextField.text!, mnc: mncValueField.text!, clientName: clientNameTextField.text!, self, withScopes: scopes, withCompletionHandler: launchTokenViewerWithTokenResponseModel)
            
            //with msisdn
        } else {
            print(scopes)
            manager.getAuthorizationTokenForPhoneNumber("+91" + msisdnTextField.text! , clientIP: "", clientName: clientNameTextField.text!, inPresenterController: self, withScopes: scopes, completionHandler: launchTokenViewerWithTokenResponseModel)
        }

    }
    
    @IBAction func tapGestureAction() {
        self.view.endEditing(true)
    }
    
    // MARK: Navigation
    func launchTokenViewerWithTokenResponseModel(_ userInfo : UserInfoResponse?, tokenResponseModel : TokenResponseModel?, error : NSError?)
    {
        currentTokenResponse = tokenResponseModel
        userInfoResponse = userInfo ?? nil
        currentError = error
        self.performSegue(withIdentifier: "showResult", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // MARK: identity request parameters button
        if segue.identifier == "requestIndianParameters" {
            let sending: RequestParamsOfIndianAppViewController = segue.destination as! RequestParamsOfIndianAppViewController
            sending.delegateRequestParameters = self
            sending.clientId = clientIdValue
            sending.clientSecretValue = clientSecretValue
            sending.discoveryURLValue = discoveryURLValue
            sending.redirectURLValue = redirectURLValue
            sending.mcc = mccValue
            sending.mnc = mncValue
        }
        
        // MARK: identity request options button
        if segue.identifier == "requestIndianOptions" {
            let sending: RequestOptionsOfIndianAppViewController = segue.destination as! RequestOptionsOfIndianAppViewController
            sending.delegate = self
            sending.scopesSet = scopesSetDemoApp
        }
        
        if identity == true {
            if let controller = segue.destination as? ResultViewController {
                var model : [String : String] = [:]
                
                if let error = currentError
                {
                    model["message"] = error.localizedDescription
                }
                
                if let currentResponse = currentResponse
                {
                    model["message"] = "Success"
                    model["sub"] = currentResponse.sub ?? nil
                    model["national_identifier"] = currentResponse.national_identifier ?? nil
                    model["updated_at"] = currentResponse.updated_at ?? nil
                    model["birthdate"] = currentResponse.birthdate ?? nil
                    model["given_name"] = currentResponse.given_name ?? nil
                    model["family_name"] = currentResponse.family_name ?? nil
                    model["state"] = currentResponse.state ?? nil
                    model["city"] = currentResponse.city ?? nil
                    model["phone_number_alternate"] = currentResponse.phone_number_alternate
                    model["street_address"] = currentResponse.street_address ?? nil
                    model["postal_code"] = currentResponse.postal_code ?? nil
                    model["country"] = currentResponse.country ?? nil
                    model["email"] = currentResponse.email ?? nil
                    model["middle_name"] = currentResponse.middle_name ?? nil
                    model["email_verified"] = currentResponse.email_verified.description
                    model["preferred_username"] = currentResponse.preferred_username ?? nil
                    model["title"] = currentResponse.title ?? nil
                    model["phone number"] = currentResponse.phone_number ?? nil
                }
                
                if let tokenResponse = currentTokenResponse {
                    model["id token"] = tokenResponse.tokenData?.id_token ?? nil
                    model["access token"] = tokenResponse.tokenData?.access_token ?? nil
                }
                
                controller.datasource = model
            }
        } else {
            if let controller = segue.destination as? ResultViewController {
                var model : [String : String] = [:]
                if let error = currentError {
                    model["message"] = error.localizedDescription
                }
                
                if let tokenResponse = currentTokenResponse {
                    if model["message"] == nil {
                        model["message"] = "Success"
                    }
                    model["access token"] = tokenResponse.tokenData?.access_token ?? nil
                    model["token id"] = tokenResponse.tokenData?.id_token ?? nil
                    model["email"] = userInfoResponse?.email ?? nil
                    model["email verified"] = userInfoResponse?.email_verified.description ?? nil
                    model["Sub"] = userInfoResponse?.sub ?? nil
                    model["Update At"] = userInfoResponse?.updated_at ?? nil
                    model["Postal code"] = userInfoResponse?.address?.postal_code ?? nil
                    model["State"] = userInfoResponse?.address?.state ?? nil
                    model["City"] = userInfoResponse?.address?.city ?? nil
                    model["Street Address"] = userInfoResponse?.address?.street_address ?? nil
                    model["Country"] = userInfoResponse?.address?.country ?? nil
                    model["family name"] = userInfoResponse?.family_name ?? nil
                    model["given name"] = userInfoResponse?.given_name ?? nil
                    model["preferred username"] = userInfoResponse?.preferred_username ?? nil
                    model["nickname"] = userInfoResponse?.nickname ?? nil
                    model["name"] = userInfoResponse?.name ?? nil
                    model["middle name"] = userInfoResponse?.middle_name ?? nil
                    model["phone number"] = userInfoResponse?.phone_number ?? nil
                }
                controller.datasource = model
            }
        }
    }
    
    func launchTokenViewerWithAttributeServiceResponse(_ attributeResponseModel : AttributeResponseModel?, tokenResponseModel : TokenResponseModel?, error : NSError?) {
        currentResponse = attributeResponseModel
        currentTokenResponse = tokenResponseModel
        currentError = error
        self.performSegue(withIdentifier: "showResult", sender: nil)
    }
    
    // MARK: Handle display/dismiss alert view
    @IBAction func alertViewDisplay() {
        let alert = UIAlertController(title: "Demo app", message: "Provides 1FA, T2FA and PKI using the mobile phone as the authentication device.The Mobile Connect Authorisation product category provides two products: Simple and Two-factor. The user is authenticated as part of the flow to ensure that they have the right to provide the authorization", preferredStyle: .alert)
        self.present(alert, animated: true, completion:{
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (self.alertControllerBackgroundTapped)))
        })
    }
    
    @objc func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setScopes(){
        if (scopesSetDemoApp.count > 0) {
            for key in scopesSetDemoApp.keys {
                if scopesSetDemoApp[key] == true {
                    scopes.append(key)
                }
            }
        }
    }
    
    // MARK: request parameters button dialog
    @objc func longPressRequestParameters() {
        let alert = UIAlertController(title: "Request parameters", message: "You can change your default values from application.", preferredStyle: .alert)
        self.present(alert, animated: true, completion:{
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
        })
    }
    
    // MARK: request options button dialog
    @objc func longPressRequestOptions() {
        let alert = UIAlertController(title: "Request options", message: "Use it if you want get more info", preferredStyle: .alert)
        self.present(alert, animated: true, completion:{
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
        })
    }
    
    // MARK: parameters for request
    func setParameters() {
        MobileConnectSDK.setClientKey(clientIdValue)
        MobileConnectSDK.setClientSecret(clientSecretValue)
        MobileConnectSDK.setApplicationEndpoint(discoveryURLValue)
        MobileConnectSDK.setRedirect(URL(string: redirectURLValue)!)
        
        if xRedirectValue != false {
            MobileConnectSDK.setXRedirect("APP")
        } else {
            MobileConnectSDK.setXRedirect("")
        }
    }
    
    // MARK: Request parameters from configure file
    func setRequestParametersValues() {
        let pathToConfigutationFile = Bundle.main.path(forResource: "requestParamsIndianApp", ofType: "plist")
        let itemsDictionaryRoot = NSDictionary(contentsOfFile: pathToConfigutationFile!)
        clientIdValue = (itemsDictionaryRoot?.value(forKey: "clientID") as? String)!
        msisdn = (itemsDictionaryRoot?.value(forKey: "msisdn") as? String)!
        clientSecretValue = (itemsDictionaryRoot?.value(forKey: "clientSecret") as? String)!
        discoveryURLValue = (itemsDictionaryRoot?.value(forKey: "discoveryURL") as? String)!
        redirectURLValue = (itemsDictionaryRoot?.value(forKey: "redirectURL") as? String)!
        xRedirectValue = ((itemsDictionaryRoot?.value(forKey: "XRedirect")) != nil)
        mccValue = ((itemsDictionaryRoot?.value(forKey: "mcc")) as? String)!
        mncValue = ((itemsDictionaryRoot?.value(forKey: "mnc")) as? String)!
    }
}
