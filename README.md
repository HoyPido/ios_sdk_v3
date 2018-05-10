### MobileConnectSDK - MobileConnect framework for iOS 

###### The library is written in swift with full support for Objective C code base.


## Requirements

- iOS 8.0+ / Mac OS X 10.9+ / tvOS 9.0+ / watchOS 2.0+
- Xcode:
  - Latest version, installed from Apple App Store;
  - Upgrades are undesirable;
  - If you have outdated Xcode version - delete, or install in a different directory and make sure you install latest version via App Store.
  
## Dependency Libraries
The library uses Alamofire and JSONModel libraries for rest service calls and deserialization. And you'll get them preconfigured if you follow the cocoa pods installation procedure described below.


## Configuration

#### 1) You'll have to have CocoaPods installed. In case you already installed it please pass to step 2

1.1) Open Terminal.

1.2) Enter $ sudo gem install cocoapods command in terminal.

1.3) Navigate to directory containing your Xcode project inside the terminal window by using cd “../directory-location/..” or cd [drag-and-drop project folder]

1.4) Pod install.

#### 2) Configure pods file and install the framework itself

2.1) After running the "Pod Install" or "pod init" command in the terminal in the directory where your project resides open the newly created Podfile or the existing one and find your target specified. Right below your target specification please add the following lines 

```
use_frameworks!
  pod 'MobileConnectSDK', :git => 'https://github.com/Mobile-Connect/ios_sdk_v3', :branch => 'master’
```


Ex: In my case I have the target of the application is named "Test2" and the podfile after modification will look like below:

```
# Uncomment this line to define a global platform for your project
# platform :ios, '10.2'

target 'Test2' do
    use_frameworks!
    pod 'JSONModel', '~> 1.7.0'
    pod 'Alamofire', '~> 4.4'
    pod 'Heimdall', '~> 1.1.3'
    pod 'MobileConnectSDK', :git => 'https://github.com/Mobile-Connect/ios_sdk_v3', :branch => 'release/3.3.0’
end
```

2.2) Save the pods file and in the terminal window navigate to your xcode project directory. After that type 

```
pod update
```

#### 3) Configure the framework inside your project

3.1) Add the framework in your targets app Linked Frameworks and Libraries

![Add the framework in your targets app Linked Frameworks and Libraries](https://cloud.githubusercontent.com/assets/19551956/16231365/d0c06eb4-37bd-11e6-80fa-eb6ce027aed9.png)

Press the plus and in the list select the MobileConnectSDK.framework and then press add
![select the MobileConnectSDK.framework and then press add](https://cloud.githubusercontent.com/assets/19551956/16231442/2365a97c-37be-11e6-99e1-f3ca275a581b.png)

As a result you'll have it added in the Linked Frameworks and Libraries section

![result](https://cloud.githubusercontent.com/assets/19551956/16231449/291b197e-37be-11e6-9a6c-93ab706f2c06.png)


###### In case you are having an Objective C code based project please set the "Allow Non-modular Includes in Framework Modules" flag to YES. (You can find this flag in your Projects Build Settings as shown in the image below)


![Objective C flag](https://cloud.githubusercontent.com/assets/19551956/16231582/bfa3486c-37be-11e6-86c3-890ab9032c33.png)


#### In case your target builds against iOS 9+ please make sure you have added App Transport Security Settings to your target Info.plist. You can do that by opening the Info.plist as source code and pasting the below key inside the plist.

```
<key>NSAppTransportSecurity</key>
<dict>
<key>NSAllowsArbitraryLoads</key><true/>
</dict>
```


#### Objective C:

At the beginning of the .m file where you intend to use the framework add 

```
@import MobileConnectSDK;
```

#### Swift:
In the .swift file you intend to use the framework just add

```
import MobileConnectSDK;
```

#### Before being able to use the library in code you'll have to provide the main developer information in your code (Redirect URI, Integration endpoint [aka application endpoint], Integration key [aka client key], Integration secret [aka client secret], x-Redirect Header) like below:

```
MobileConnectSDK.setClientKey(clientIdValue)
MobileConnectSDK.setClientSecret(clientSecretValue)
MobileConnectSDK.setApplicationEndpoint(discoveryURLValue)
MobileConnectSDK.setRedirect(URL(string: redirectURLValue)!)
MobileConnectSDK.setXRedirect("APP")
```
Note: if you operate in the EU then you should use EU Discovery Service domain in discovery URL: eu.discovery.mobileconnect.io  
And that's it!



## Usage


### In case you just want to get the token there are several ways:

* By providing a delegate which will receive the main MobileConnectSDK events and dropping a button in the storyboards where you intend to use it


1) Make sure the delegate conforms to protocol MobileConnectManagerDelegate


#### Objective-C:
```
@interface ViewController ()<MobileConnectManagerDelegate>
```

#### Swift 3:
```
class ViewController : MobileConnectManagerDelegate
```
2) Implement the MobileConnectManagerDelegate in that class

#### Objective-C:
```
- (void)mobileConnectWillStart;
- (void)mobileConnectWillPresentWebController;
- (void)mobileConnectWillDismissWebController;
- (void)mobileConnectDidGetTokenResponse:(TokenResponseModel * _Nonnull)tokenResponse;
- (void)mobileConnectFailedGettingTokenResponseWithError:(NSError * _Nonnull)error;
```
#### Swift 3:
```
func mobileConnectWillStart()
func mobileConnectWillPresentWebController()
func mobileConnectWillDismissWebController()
func mobileConnectDidGetTokenResponse(tokenResponse : TokenResponseModel)
func mobileConnectFailedGettingTokenResponseWithError(error : NSError)
```

3) Drag and drop a view in your storyboards and set it's class to MobileConnectManagerButton

![Dropping the button and setting it's class](https://cloud.githubusercontent.com/assets/19551956/16233183/6234cc76-37c5-11e6-8c0a-1100fe0d850f.png)

You'll receive the token response or the error in the above specified delegate methods.

* By using MobileConnectManager

1) Create the MobileConnectManager instance

#### Objective-C:
```
MobileConnectManager *manager = [MobileConnectManager new];
```

#### Swift 3:
```
let mobileConnectManager : MobileConnectManager = MobileConnectManager()
```

2) Call one of the below methods.

If you don't have the client's phone number then just call the below method in which you have to provide a controller from which the framework will be able to present it's own web controller. 

#### Objective-C:
```
[manager getTokenInPresenterController:<theControllerFromWhichYouWishtToLaunchMobileConnectInsertHere> withCompletitionHandler:^(TokenResponseModel * _Nullable tokenResponseModel, NSError * _Nullable error) {
        
}];
```
#### Swift 3:
```
mobileConnectManager.getTokenInPresenterController(<controllerToPresentTheWebviewController>, clientIP: <yourDeviceIP>) { (userInfoResponse, tokenResponseModel, error) in

     }
```

If you have the client's phone number just provide it as a parameter as shown in the code below. But you'll still have to provide a controller which the framework will use for presenting it's own web controller.
    
#### Objective-C:    
```
[manager getTokenForPhoneNumber:@"<clientPhoneNumberInsertHere>" inPresenterController:self withCompletitionHandler:^(TokenResponseModel * _Nullable tokenResponseModel, NSError * _Nullable error) {
        
}];
```
#### Swift 3:
```
mobileConnectManager.getTokenForPhoneNumber("clientPhoneNumberHere", clientIP: <yourDeviceIP>, inPresenterController: <controllerThatWillPresentTheWebViewController>) { 
(userInfoResponse, tokenResponseModel, error) in

     }
```
### In case you need to specifically use the Discovery service:

Create an instance of the DiscoveryService or DSService in Objective C code and use on of the the below methods. 
#### Objective-C:
```
DSService *discovery = [DSService new];
```
#### Swift 3:
```
let discovery : DSService = DSService()
```

##### If you don't have client's phone number:

Don't forget to dismiss the controller which you receive in the callback method otherwise the web view will remain on the screen.

#### Objective-C:
```
[discovery startOperatorDiscoveryInController:<theControllerFromWhichYouWishtToLaunchMobileConnectInsertHere> completitionHandler:^(BaseWebController * _Nullable controller, DiscoveryResponse * _Nullable operatorsData, NSError * _Nullable error) {
        
}];
```

#### Swift 3:
```
discovery.startOperatorDiscoveryInController(<controllerToPresentWebViewController>, clientIP: <yourDeviceIP>) { (controller, operatorsData, error) in

}
```

##### If you have client's phone number:

You don't need to offer a view controller because there is no need for a web page to be displayed to the client. And you can call the following method:

```
[discovery startOperatorDiscoveryForPhoneNumber:@"<clientPhoneNumberInsertHere>" completitionHandler:^(DiscoveryResponse * _Nullable operatorsData, NSError * _Nullable error) {
        
}];
```

##### If you have the mobile operators country code and network code:

#### Objective-C:
```
[discovery startOperatorDiscoveryWithCountryCode:@"<insertCountryCodeHere>" networkCode:@"<insertNetworkCodeHere>" completitionHandler:^(DiscoveryResponse * _Nullable operatorsData, NSError * _Nullable error) {
        
}];
```

#### Swift 3:
```
discovery.startOperatorDiscoveryWithCountryCode("<clientOperatorCountryCode>", networkCode: "<clientOperatorNetworkCode>") { (operatorsData, error) in

      }
```

### In case you need to specifically use the Mobile Connect service:

Create an instance of the MobileConnectService or MCService in Objective C. You'll have to provide the operator data which you would tipically get from the DiscoveryService class

#### Objective-C
```
MCService *mobileConnectService = [[MCService alloc] initWithClientId:@"<clientIdFromDiscoveryServiceGoesHere>" authorizationURL:@"<authorizationURLFromDiscoveryGoesHere>" tokenURL:@"<tokenURLFromDiscoveryGoesHere>"];
```

#### Swift 3:
```
let service : MCService = MCService(configuration: configuration)
```

After creating the MobileConnect or MCService instance you can get the token by providing a subcriberId if you have it from the Discovery stage or just provide nil for subscriber id. You'll also have to offer a view controller which will be used by the framework to present the web view. Don't forget to dismiss the controller which you receive in the callback method otherwise the web view will remain on the screen.

#### Objective-C
```
[mobileConnectService getTokenInController:self subscriberId:@"<inCaseYouReceivedASubscriberIDFromDiscoveryIfNotLeaveNil>" completitionHandler:^(BaseWebController * _Nullable controller, TokenModel * _Nullable tokenModel, NSError * _Nullable error) {
        
}];
```

#### Swift 3:
```
service.getTokenInController(self, completionHandler: { (controller, tokenModel, error) in
                
     })
```

## <p align="center">more information on [integration portal](https://integration.developer.mobileconnect.io)</p>
