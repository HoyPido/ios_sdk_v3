import UIKit
import MobileConnectSDK

var endpointVersion: Double = 1.1

class DemoAppViewController : UIViewController, RequestParametersDeleagete, RequestOptionsDelegate {
    
    @IBOutlet weak var segmentedControll : UISegmentedControl!
    @IBOutlet weak var getTokenButton : UIButton!
    @IBOutlet weak var phoneNumberTextField : UITextField!
    @IBOutlet weak var viewControllerNameLabel : UILabel!
    @IBOutlet weak var controllDistance : NSLayoutConstraint!
    @IBOutlet weak var identityState: UISegmentedControl!
    @IBOutlet weak var requstParametersButton: UIButton!
    @IBOutlet weak var requestOptionsButton: UIButton!
    @IBOutlet weak var endpointNameSegment: UISegmentedControl!
    
    var isCalledDiscoveryWithPhoneNumber : Bool = false
    var currentTokenResponse : TokenResponseModel?
    var currentResponse : AttributeResponseModel?
    var currentError : NSError?
    var identity = false
    var scopes: [ProductType] = []
    
    
    // MARK: Request options
    var scopesSetDemoApp = [ProductType: Bool]()
    
    // MARK: Request parameters
    var clientIdValue: String = ""
    var redirectURLValue: String = ""
    var xRedirectValue: Bool = false
    var msisdn: String = ""
    var clientSecretValue: String = ""
    var discoveryURLValue: String = ""
    var sourceIP: String = ""
    var clientNameValue = ""
    var bindingMessageValue = ""
    var contextValue = ""
    
    var userInfoResponse: UserInfoResponse? = nil
    
    func sendRequestParametersData(clientID: String, clientSecret: String, discoveryURL: String, redirectURL: String, xSourceIP: String, xRedirect: Bool, clientName: String, bindingMessage: String, context: String) {
        clientIdValue = clientID
        clientSecretValue = clientSecret
        discoveryURLValue = discoveryURL
        redirectURLValue = redirectURL
        sourceIP = xSourceIP
        xRedirectValue = xRedirect
        clientNameValue = clientName
        bindingMessageValue = bindingMessage
        contextValue = context
    }
    
    func sendRequestOptionsData(_ scopesS: [ProductType: Bool]) {
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
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DemoAppViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        if isCalledDiscoveryWithPhoneNumber{
            self.phoneNumberTextField.becomeFirstResponder()
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func commonInit() {
        self.viewControllerNameLabel.text = "Demo App"
        if (demoAppFirstCall) {
            setRequestParametersValues()
            demoAppFirstCall = false
        }
        let requestParametersLongGesture = UILongPressGestureRecognizer(target: self, action: #selector(DemoAppViewController.longPressRequestParameters))
        let requestOptionsLongGesture = UILongPressGestureRecognizer(target: self, action: #selector(DemoAppViewController.longPressRequestOptions))
        requstParametersButton.addGestureRecognizer(requestParametersLongGesture)
        requestOptionsButton.addGestureRecognizer(requestOptionsLongGesture)
        scopes = []
        phoneNumberTextField.text = msisdn
        requstParametersButton.layer.cornerRadius = 5
        requestOptionsButton.layer.cornerRadius = 5
        getTokenButton.layer.cornerRadius = 5
        getTokenButton.layer.borderWidth = 1
        getTokenButton.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func getToken() {
        scopes = []
        setScopes()
        setParameters()
        let manager : MobileConnectManager = MobileConnectManager()
        if identityState.selectedSegmentIndex == 0 {
            if (scopes.contains(ProductType.identitySignUp) || scopes.contains(ProductType.identityPhoneNumber) || scopes.contains(ProductType.identityNationalID)) {
                identity = true
                if isCalledDiscoveryWithPhoneNumber {
                    manager.getAttributeServiceResponseWithPhoneNumber(phoneNumberTextField.text ?? "", clientIP: sourceIP, clientName: clientNameValue, inPresenterController: self, withScopes: scopes, context: "MC", bindingMessage: "MC", completionHandler: launchTokenViewerWithAttributeServiceResponse)
                } else {
                    manager.getAttributeServiceResponse(self, clientIP: sourceIP, clientName: clientNameValue, context: "MC", scopes: scopes, bindingMessage: "MC", withCompletionHandler: launchTokenViewerWithAttributeServiceResponse)
                }
            } else {
                if isCalledDiscoveryWithPhoneNumber  {
                    manager.getAuthorizationTokenForPhoneNumber(phoneNumberTextField.text ?? "", clientIP: sourceIP, clientName: clientNameValue, inPresenterController: self, withScopes: scopes, context: "MC", bindingMessage: "MC",completionHandler: launchTokenViewerWithTokenResponseModel)
                } else {
                    manager.getAuthorizationTokenInPresenterController(self, clientIP: sourceIP, clientName: clientNameValue, withContext: "MC", withScopes: scopes, bindingMessage: "MC", completionHandler: launchTokenViewerWithTokenResponseModel)
                }
            }
        } else {
            if isCalledDiscoveryWithPhoneNumber {
                manager.getTokenForPhoneNumber(phoneNumberTextField.text ?? "", clientIP: sourceIP, clientName: clientNameValue, inPresenterController: self, withScopes: scopes, withCompletionHandler: launchTokenViewerWithTokenResponseModel)
            } else {
                manager.getTokenInPresenterController(self, clientIP: sourceIP, clientName: clientNameValue,withScopes: scopes, withCompletionHandler: launchTokenViewerWithTokenResponseModel)
            }
        }
    }
    
    @IBAction func endpointVersionTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            endpointVersion = 1.1
        } else {
            endpointVersion = 1.2
        }
    }
    
    @IBAction func segmentedControllTapped(_ segmentedControll : UISegmentedControl) {
        if segmentedControll.selectedSegmentIndex == 0 {
            UIView.transition(with: self.phoneNumberTextField, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
    
                self.phoneNumberTextField.isHidden = true
            }, completion: nil)
            
            isCalledDiscoveryWithPhoneNumber = false
        } else {
            UIView.transition(with: self.phoneNumberTextField, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
                self.phoneNumberTextField.isHidden = false
            }, completion: nil)
            
            isCalledDiscoveryWithPhoneNumber = true
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
        if segue.identifier == "requestParameters" {
            let sending: RequestParametersViewController = segue.destination as! RequestParametersViewController
            sending.delegateRequestParameters = self
            sending.clientId = clientIdValue
            sending.clientSecretValue = clientSecretValue
            sending.discoveryURLValue = discoveryURLValue
            sending.redirectURLValue = redirectURLValue
            sending.clientNameValue = clientNameValue
            sending.bindingMessageValue = bindingMessageValue
            sending.contextValue = contextValue
        }
        
        // MARK: identity request options button
        if segue.identifier == "requestOptions" {
            let sending: RequestOptionsViewController = segue.destination as! RequestOptionsViewController
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
                    model["nickname"] = userInfoResponse?.nickname ?? nil
                
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
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
        })
    }
    
    @objc func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setScopes(){
        for key in scopesSetDemoApp.keys {
            if scopesSetDemoApp[key] == true {
                scopes.append(key)
            }
        }
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
    
    // MARK: request parameters button dialog
    @objc func longPressRequestParameters() {
        let alert = UIAlertController(title: "Request parameters", message: "You can change your default values from application.\n", preferredStyle: .alert)
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
    
    // MARK: Request parameters from configure file
    func setRequestParametersValues() {
        let pathToConfigutationFile = Bundle.main.path(forResource: "requestParams", ofType: "plist")
        let itemsDictionaryRoot = NSDictionary(contentsOfFile: pathToConfigutationFile!)
        clientIdValue = (itemsDictionaryRoot?.value(forKey: "clientID") as? String)!
        msisdn = (itemsDictionaryRoot?.value(forKey: "msisdn") as? String)!
        clientSecretValue = (itemsDictionaryRoot?.value(forKey: "clientSecret") as? String)!
        discoveryURLValue = (itemsDictionaryRoot?.value(forKey: "discoveryURL") as? String)!
        redirectURLValue = (itemsDictionaryRoot?.value(forKey: "redirectURL") as? String)!
        xRedirectValue = ((itemsDictionaryRoot?.value(forKey: "XRedirect")) != nil)
        clientNameValue = (itemsDictionaryRoot?.value(forKey: "clientName") as? String)!
        bindingMessageValue = (itemsDictionaryRoot?.value(forKey: "bindingMessage") as? String)!
        contextValue = (itemsDictionaryRoot?.value(forKey: "context") as? String)!
    }
    
}
