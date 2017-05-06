import UIKit
import MobileConnectSDK

var withMetadataStatus = true

class WithoutDiscoveryViewController : UIViewController, RequestParametersWithoutCall, WithoutCallEndpoints {
    
    @IBOutlet weak var segmentedControll : UISegmentedControl!
    @IBOutlet weak var getTokenButton : UIButton!
    @IBOutlet weak var requestParametersButton: UIButton!
    @IBOutlet weak var endPointButton: UIButton!
    @IBOutlet weak var phoneNumberTextField : UITextField!
    @IBOutlet weak var viewControllerNameLabel : UILabel!
    @IBOutlet weak var controllDistance : NSLayoutConstraint!
    
    var currentTokenResponse : TokenResponseModel?
    var currentError : NSError?
    var requestParameters = RequestParamsWithoutDiscoveryViewController()
    var requestParametersDiscovery = RequestParametersViewController()
    var discoveryResponse: DiscoveryResponse = DiscoveryResponse()
    var endpoints: [String: String]? = [:]
    let discoveryResponseLinks: OperatorIdModel = OperatorIdModel()

    // MARK: request parameters
    var clientId: String = ""
    var clientSecret: String = ""
    var subscriberID: String = ""
    var clientName: String = ""
    var discoveryURLValue: String? = ""
    var redirectURLValue: String? = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Mobile Connect Example App"
        commonInit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        endPointButton.layer.cornerRadius = 5
        requestParametersButton.layer.cornerRadius = 5
    }
    
    func commonInit() {
        setEndpointsFromFile()
        setRequestParametersValues()
        setValues()
        self.viewControllerNameLabel.text = "Example App"
        let endpointsLongGesture = UILongPressGestureRecognizer(target: self, action: #selector(WithoutDiscoveryViewController.longPressEndpoints))
        endPointButton.addGestureRecognizer(endpointsLongGesture)
        let requestParametersLongGesture = UILongPressGestureRecognizer(target: self, action: #selector(WithoutDiscoveryViewController.longPressRequestParameters))
        requestParametersButton.addGestureRecognizer(requestParametersLongGesture)
        getTokenButton.layer.cornerRadius = 5
        getTokenButton.layer.borderWidth = 1
        getTokenButton.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func getToken() {
        setParameters()
        setEndpoints()
        
        let manager : MobileConnectManagerWithoutCall = MobileConnectManagerWithoutCall()
        
        if withMetadataStatus  {
            discoveryResponse = manager.makeDiscoveryResponse(subscriberID, clientSecret: clientSecret, clientKey: clientId, name: clientName, linksRecieved: discoveryResponseLinks)
            manager.getTokenInPresenterController(self, withScopes: [], withCompletionHandler: launchTokenViewerWithTokenResponseModel, discoveryResponse: discoveryResponse)
        } else {
            discoveryResponse = manager.makeDiscoveryResponse(subscriberID, clientSecret: clientSecret, clientKey: clientId, name: "", linksRecieved: discoveryResponseLinks)
            manager.getTokenInPresenterController(self, withScopes: [], withCompletionHandler: launchTokenViewerWithTokenResponseModel, discoveryResponse: discoveryResponse)
        }
    }
    
    @IBAction func metadataTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            withMetadataStatus = true
        } else {
            withMetadataStatus = false
        }
    }
    
    @IBAction func tapGestureAction() {
        self.view.endEditing(true)
    }
    
    // MARK: Navigation
    func launchTokenViewerWithTokenResponseModel(_ userInfo : UserInfoResponse?, tokenResponseModel : TokenResponseModel?, error : NSError?)
    {   
        currentTokenResponse = tokenResponseModel
        currentError = error
        self.performSegue(withIdentifier: "showResult", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "requestParametersWithoutDiscovery" {
            let sending: RequestParamsWithoutDiscoveryViewController = segue.destination as! RequestParamsWithoutDiscoveryViewController
            sending.requestParametersDelegate = self
        }
        
        if segue.identifier == "endpointConfiguration" {
            let sending: EndpointConfigurationViewController = segue.destination as! EndpointConfigurationViewController
            sending.delegate = self
        }
        
        if let controller = segue.destination as? ResultViewController {
            var model : [String : String] = [:]
            
            if let error = currentError
            {
                model["message"] = error.localizedDescription
            }
            
            if let tokenResponse = currentTokenResponse
            {
                if model["message"] == nil {
                    model["message"] = "Success"
                }
                model["client name"] = tokenResponse.discoveryResponse?.clientName ?? ""
                model["access token"] = tokenResponse.tokenData?.access_token
                model["token id"] = tokenResponse.tokenData?.id_token
            }
            
            controller.datasource = model
        }
    }
    
    // MARK: Handle display/dismiss alert view
    @IBAction func alertViewDisplay() {
        let alert = UIAlertController(title: "Example App", message: "info", preferredStyle: .alert)
        self.present(alert, animated: true, completion:{
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
        })
    }
    
    func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }
   
    func setParameters() {
        MobileConnectSDK.setClientKey(clientId)
        MobileConnectSDK.setClientSecret(clientSecret)
        MobileConnectSDK.setApplicationEndpoint(discoveryURLValue!)
        MobileConnectSDK.setRedirect(URL(string: redirectURLValue!)!)
    }
    
    func setEndpoints() {
        discoveryResponseLinks.setAuthorizationLink(endpoints?["authorizationEndpoint"])
        discoveryResponseLinks.setTokenLink(endpoints?["accessTokenEndpoint"])
        discoveryResponseLinks.setOpenIdLink(endpoints?["metadataEndpoint"])
        discoveryResponseLinks.setUserInfoLink(endpoints?["userInfoEndpoint"])
    }
    
    func longPressEndpoints() {
        let alert = UIAlertController(title: "Endpoints", message: "a bit info", preferredStyle: .alert)
        self.present(alert, animated: true, completion:{
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
        })
    }
    
    func longPressRequestParameters() {
        let alert = UIAlertController(title: "Request parameters", message: "a bit info", preferredStyle: .alert)
        self.present(alert, animated: true, completion:{
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
        })
    }
    
    func sendRequestParametersWithoutCall(clientIdValue: String, clientSecretValue: String, clientNameValue: String, subscriberIDValue: String) {
        clientId = clientIdValue
        clientSecret = clientSecretValue
        clientName = clientNameValue
        subscriberID = subscriberIDValue
    }
    
    func sendWithoutCallEndpointsData(sendedEndpoints: [String:String]) {
        endpoints = sendedEndpoints
    }
    
    // MARK: Request parameters from configure file
    func setRequestParametersValues() {
        let pathToConfigutationFile = Bundle.main.path(forResource: "requestParams", ofType: "plist")
        let itemsDictionaryRoot = NSDictionary(contentsOfFile: pathToConfigutationFile!)
        discoveryURLValue = (itemsDictionaryRoot?.value(forKey: "discoveryURL") as? String)!
        redirectURLValue = (itemsDictionaryRoot?.value(forKey: "redirectURL") as? String)!
    }
    
    func setEndpointsFromFile() {
        let pathToConfigutationFile = Bundle.main.path(forResource: "operatorURLs", ofType: "plist")
        let itemsDictionaryRoot = NSDictionary(contentsOfFile: pathToConfigutationFile!)
        endpoints = ["authorizationEndpoint" : (itemsDictionaryRoot?.value(forKey: "authorization") as? String)!,
                     "accessTokenEndpoint" : (itemsDictionaryRoot?.value(forKey: "token") as? String)!,
                     "userInfoEndpoint" : (itemsDictionaryRoot?.value(forKey: "userinfo") as? String)!,
                     "metadataEndpoint" : (itemsDictionaryRoot?.value(forKey: "openid-configuration") as? String)!]
    }
    
    func setValues() {
        let pathToConfigutationFile = Bundle.main.path(forResource: "requestParamsExampleApp", ofType: "plist")
        let itemsDictionaryRoot = NSDictionary(contentsOfFile: pathToConfigutationFile!)
        clientId = (itemsDictionaryRoot?.value(forKey: "clientID") as? String)!
        clientSecret = (itemsDictionaryRoot?.value(forKey: "clientSecret") as? String)!
        subscriberID = (itemsDictionaryRoot?.value(forKey: "subscriberId") as? String)!
        clientName = (itemsDictionaryRoot?.value(forKey: "clientName") as? String)!
    }
}
