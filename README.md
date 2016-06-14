///Instalation
In order to use it with cocoa pods just add the following to your pods file:

pod 'MobileConnectSDK', :git => 'https://github.com/Dan-Andoni-BJSS/GSMA-iOS-Swift', :branch => ’master’
use_frameworks!

In case you decide to add the framework directly in your project, you'll have to also add Alamofire and JSONModel libraries.

After adding the framework to your project, add the framework in Link libraries section of your target.


///Configuration
In order to configure it you have to provide the client key, client secret, redirect url, application endpoint.

[MobileConnectSDK setRedirect:[NSURL URLWithString:kRedirectURL]];
[MobileConnectSDK setClientKey:kClientKey];
[MobileConnectSDK setClientSecret:kClientSecret];
[MobileConnectSDK setApplicationEndpoint:kSandboxEndpoint];

///Usage
1. You can use it similar to facebook login button, which means that you can just drop a view in the storyboards and declare it's class as MobileConnectButton.
In order for you to receive the feedback from the Mobile Connect authentication make sure that you set the MobileConnectManagerDelegate like this:

[MobileConnectSDK setDelegate:self];

And then receive the responses in the MobileConnectManagerDelegate methods.
- (void)mobileConnectWillStart
- (void)mobileConnectWillPresentWebController
- (void)mobileConnectWillDismissWebController
- (void)mobileConnectDidGetTokenResponse:(TokenResponseModel *)tokenResponse
- (void)mobileConnectFailedGettingTokenResponseWithError:(NSError *)error

2. In case you need more control you can use the MobileConnectManager class

self.manager = [MobileConnectManager new];

** And get the token in the following ways:
[self.manager getTokenInPresenterController:self withCompletitionHandler:nil];

Or

[self.manager getTokenForPhoneNumber:@"clientPhoneNumber" inPresenterController:self withCompletitionHandler:nil];

You'll receive the response in the completition handler you'll provide or in the delegate methods in case you provide a delegate or in both if you provide a completitionHandler and a delegte.

3. If you need to access the Discovery service and Mobile Connect service separately you can use the MobileConnectService or DiscoveryService classes in Swift or DSService and MCService for Objective C respectively.

DSService and MCService are just wrappers around the equivalent Swift classes. This is due to the fact that Objective C does not support generics.

**In order to use Discovery Service:
//create instance
let discovery : DiscoveryService = DiscoveryService()

//call the method which will return the operator data response in completition handler
discovery.startOperatorDiscoveryInController(self) { (controller, operatorsData, error) in  }

**In order to use Mobile Connect Service:
//create instance with data received from the DiscoveryService
let mobileConnect : MobileConnectService =
            MobileConnectService(clientId: operatorsData.response?.client_id ?? "",
                                 authorizationURL: operatorsData.response?.apis?.operatorid?.authorizationLink() ?? "", 
                                 tokenURL: operatorsData.response?.apis?.operatorid?.tokenLink() ?? "")
                                 
//call the method with completition handler which will return the tokenModel
mobileConnect.getTokenInController(controller) { (controller, tokenModel, error) in }

For more detailed info regarding the response and other available usage methods please check the docs.



