//
//  ViewController.m
//  Demo2
//
//  Created by Andoni Dan on 07/06/16.
//  Copyright © 2016 GSMA. All rights reserved.
//

#import "ViewController.h"
#import <MobileConnectSDK/MobileConnectSDK-Swift.h>
#import <MobileConnectSDK/MobileConnectSDK.h>

#define kClientKey @"a25e91c5-ab1e-4f9e-9fd9-4cd1482c0a48"

#define kClientSecret @"1d95d440-49fe-455e-8fd4-b5903b8c78ec"

#define kSandboxEndpoint @"http://discovery.sandbox2.mobileconnect.io/v2/discovery"

#define kRedirectURL @"http://test.test.com"

//#define kSubscriberId @"463d919dbf92d25892727eec51172a5f92ee458f697b34703c730785f1f7269b905bb7b813180f81b183de5659f79728ba7af93cbb29b3a6dd3d229973194e003c545633dab0ff9d3cb4916619f64e567a91494e3426db925d7765d3fdb9b045d01b03e5a87248cfda9df67ccaccb9a29b1faf87b7ed6f24bb47f4dc355d7f1c331bf3e8bff8bf3deed4119430fbc2558cbefd99a4efdb25dbdde6a2595d8e2e5a87552b1118953396913b49cbfeb79d341b086b1404581a17c11f61b2f95cc9089dee5c1c643140d365a5800c862716ef58e0de5f48e6e40984df4631420779f4e346718e0b5fda9cc8b27bd0ee0a4b82bbdd944b61dc461d7aed54ea3d27ab"
//
//#define kClientId @"a25e91c5-ab1e-4f9e-9fd9-4cd1482c0a48"
//#define kAuthorizationURL @"http://operator_a.sandbox2.mobileconnect.io/oidc/authorize"
//#define kTokenURL @"http://operator_a.sandbox2.mobileconnect.io/oidc/accesstoken"

@interface ViewController ()

@property (nonatomic) MobileConnectManager *manager;

@end

@implementation ViewController
{
    __weak IBOutlet UISegmentedControl *segmentedControl;
    __weak IBOutlet UITextField *phoneTextField;
    __weak IBOutlet UILabel *responseLabel;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [MobileConnectSDK setDelegate:self];
    self.manager = [MobileConnectManager new];
}

- (IBAction)mobileConnectAction:(id)sender
{
    if (!segmentedControl.selectedSegmentIndex) {
        [self getToken];
    }
    else
    {
        [self.view endEditing:YES];
        [self getTokenWithPhone];
    }
}

- (IBAction)segmentChanged:(id)sender {
    responseLabel.text = @"";
    phoneTextField.hidden = !segmentedControl.selectedSegmentIndex;
}

- (void)getToken
{
    
    //the delegate methods will be called as the delegate is set in view did load
    [self.manager getTokenInPresenterController:self withCompletitionHandler:nil];
}

- (void)getTokenWithPhone
{
    [self.manager getTokenForPhoneNumber:phoneTextField.text inPresenterController:self withCompletitionHandler:nil];
}

//MARK: Mobile connect delegate methods
- (void)mobileConnectWillStart
{
    NSLog(@"will start");
}

- (void)mobileConnectWillPresentWebController
{
    NSLog(@"will present");
}

- (void)mobileConnectWillDismissWebController
{
    NSLog(@"will dismiss");
}

- (void)mobileConnectDidGetTokenResponse:(TokenResponseModel *)tokenResponse
{
    responseLabel.text = tokenResponse.tokenData.access_token;
}

- (void)mobileConnectFailedGettingTokenResponseWithError:(NSError *)error
{
    responseLabel.text = error.localizedDescription;
}

@end
