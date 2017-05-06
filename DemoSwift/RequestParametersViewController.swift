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
    var reqParam = DemoAppViewController()
    
    var delegateRequestParameters: RequestParametersDeleagete? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            xSourceIpField.text = getIPAddress()
        }
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
            xSourceIpField.text = getIPAddress()
        } else {
            xSourceIpField.isHidden = true
            xSourceIpField.text = ""
        }
    }
    
    
    func getIPAddress() -> String? {
        var address : String?
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    var addr = interface.ifa_addr.pointee
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        return address
    }
    

}
