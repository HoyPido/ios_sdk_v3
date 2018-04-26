import UIKit
import MobileConnectSDK

var withMetadataStatus = true

class WithoutDiscoveryViewController : UIViewController, RequestParametersWithoutCall, WithoutCallEndpoints {
    
    @IBOutlet weak var segmentedControll : UISegmentedControl!
    @IBOutlet weak var getTokenButton : UIButton!
    @IBOutlet weak var requestParametersButton: UIButton!
    @IBOutlet weak var endPointButton: UIButton!
    @IBOutlet weak var phoneNumberTextField : UITextField!
    @IBOutlet weak var clientNameField : UITextField!
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
        if (withoutDiscoveryFirstCall) {
            setEndpointsFromFile()
            setRequestParametersValues()
            setValues()
            withoutDiscoveryFirstCall = false
        }
        self.viewControllerNameLabel.text = "Without Discovery app"
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
            discoveryResponse = manager.makeDiscoveryResponse(subscriberID, clientSecret: clientSecret, clientKey: clientId, linksRecieved: discoveryResponseLinks)
            manager.getTokenInPresenterController(self, clientName: clientName, withScopes: [], withCompletionHandler: launchTokenViewerWithTokenResponseModel, discoveryResponse: discoveryResponse)
        } else {
            discoveryResponse = manager.makeDiscoveryResponse(subscriberID, clientSecret: clientSecret, clientKey: clientId, linksRecieved: discoveryResponseLinks)
            manager.getTokenInPresenterController(self, clientName: clientName, withScopes: [], withCompletionHandler: launchTokenViewerWithTokenResponseModel, discoveryResponse: discoveryResponse)
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
                model["access token"] = tokenResponse.tokenData?.access_token
                model["token id"] = tokenResponse.tokenData?.id_token
            }
            
            controller.datasource = model
        }
    }
    
    // MARK: Handle display/dismiss alert view
    @IBAction func alertViewDisplay() {
        let alert = UIAlertController(title: "Example App", message: "A successful call to the Mobile Connect Discovery endpoint returns the end user’s Mobile Network Operator (MNO) and describes the Mobile Connect services that MNO supports, via a URI to the MNO’s Provider Metadata. The metadata describes the Identity Gateway endpoints (Mobile Connect services) your application or service can use and how those endpoints are configured – for example, the response types an endpoint can return, the subject identifier types supported, or the Identity Services encryption algorithms in use.Although Provider Metadata is the primary source of information detailing the Identity Gateway configuration, it does not change often, so a cached version can be used without risk of expired data causing errors. The Mobile Connect SDK handles both the querying of the Provider Metadata and the caching.\n  1. If the Provider Metadata URI returns no data, the cached metadata is used.\n  2. Where the cached data is out of date (defaulting to 15-minute intervals) a subsequent query of the URI is attempted, and in the event of a second failed response, expired cached data is used.\n  3. Should neither the cached data nor the Provider Metadata URI return data (such as an error upon first user login) default values are used.\n Regardless of the source, the SDK parses the Provider Metadata into a discrete list of properties. See the OpenID Provider Metadata definition for a list of the metadata available, although you should note that Mobile Connect\'s implementation may not be exhaustive.", preferredStyle: .alert)
        self.present(alert, animated: true, completion:{
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
        })
    }
    
    @objc func alertControllerBackgroundTapped()
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
    
    @objc func longPressEndpoints() {
        let alert = UIAlertController(title: "Endpoints", message: "When you use \'with providerMetadata\' method you need only metadata URL", preferredStyle: .alert)
        self.present(alert, animated: true, completion:{
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
        })
    }
    
    @objc func longPressRequestParameters() {
        let alert = UIAlertController(title: "Request parameters", message: "Adds \'subscriber id\' to your request, used for headless auth(optional parameter)", preferredStyle: .alert)
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
