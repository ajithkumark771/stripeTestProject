//
//  ViewController.m
//  stripeTest
//
//  Created by Cybraum on 5/15/19.
//  Copyright © 2019 meridian. All rights reserved.
//

#import "ViewController.h"
#import <Stripe/Stripe.h>

@interface ViewController ()<STPAddCardViewControllerDelegate,STPPaymentCardTextFieldDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    getdata = [[Api_Handler alloc]init];
}


- (IBAction)payButton:(id)sender
{
    [self getClientSecret];
}



-(void)getClientSecret
{
    
    NSString *useridstr=[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    NSString *deviceId;
//    NSString *firUserid;
    NSString *addressId;
    
    
    
    useridstr=@"0";
    deviceId=@"9A6DFA1C-BE92-432A-8263-1AD6E38ABD4A";
    addressId = @"83";
    
    
    //  [SVProgressHUD show];
    //secretKey=sk_test_IZGLv2wrpIuPIu06YZ1L5d34&userId=0&guestDeviceToken=9A6DFA1C-BE92-432A-8263-1AD6E38ABD4A&addressId=83
    NSString *post =[NSString stringWithFormat:@"secretKey=%@&userId=%@&guestDeviceToken=%@&addressId=%@",@"sk_test_IZGLv2wrpIuPIu06YZ1L5d34",useridstr,deviceId,addressId ];
    NSLog(@"%@",post);
    NSString *urlStr=@"paymentIntent.php";
    [getdata postUrlCalls:urlStr parameter:post completionHandler:^(BOOL success, NSData *data) {
    
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(success)
            {
                NSError *myError = nil;
                NSMutableDictionary *respData;
                respData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&myError];
                NSLog(@"%@",respData);
                
                
                if( [[respData objectForKey:@"status"]  isEqualToString: @"true"])
                {
                    NSMutableDictionary *tempData;
                    tempData = [respData objectForKey:@"data"];
                    self->client_secret =  [tempData objectForKey:@"clientSecret"];
                    self->idSecret =  [tempData objectForKey:@"id"];
                    [self cardViewController];
                }
                else
                {
                    
                    NSLog(@"Unable to process payment");
                    
                }
                
                
            }
            else
            {
                NSLog(@"network failure");
            }
            
            //[SVProgressHUD dismiss];
            
        });
    }];
    
}

-(void)cardViewController
{
    STPAddCardViewController *addCardViewController = [[STPAddCardViewController alloc] init];
    addCardViewController.delegate = self;
    // STPAddCardViewController must be shown inside a UINavigationController.
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addCardViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}


- (void)addCardViewController:(STPAddCardViewController *)addCardViewController
               didCreateToken:(STPToken *)token
                   completion:(STPErrorBlock)completion
{
    
    NSLog(@"%@",token.tokenId);
    
    
    
    
    STPPaymentMethodCardParams *cardParams = [STPPaymentMethodCardParams new];
    cardParams.token = token.tokenId; //myApplePayToken.tokenId;
    
    STPPaymentMethodParams *paymentMethodParams = [STPPaymentMethodParams paramsWithCard:cardParams billingDetails:nil metadata:nil];
    NSLog(@"CLient secret--> %@",client_secret);
    STPPaymentIntentParams *paymentIntentParams = [[STPPaymentIntentParams alloc] initWithClientSecret:client_secret];
    paymentIntentParams.paymentMethodParams = paymentMethodParams;
    paymentIntentParams.returnURL = @"appname://stripe-redirect";  //payment-stripe
    
    
    [[STPAPIClient sharedClient] confirmPaymentIntentWithParams:paymentIntentParams
                                                     completion:^(STPPaymentIntent * _Nullable paymentIntent, NSError * _Nullable error)
     {
         NSLog(@"%@",paymentIntent.description);
         if (error != nil) {
             // handle error
             NSLog(@"%@",error.description);
         } else {
             NSLog(@"success");
             if (paymentIntent.status == STPPaymentIntentStatusRequiresAction) {
                 // Note you must retain this for the duration of the redirect flow - it dismisses any presented view controller upon deallocation.
                 STPRedirectContext *redirectContext = [[STPRedirectContext alloc] initWithPaymentIntent:paymentIntent completion:^(NSString *clientSecret, NSError *redirectError) {
                     NSLog(@"%ld",(long)paymentIntent.status);
                     // Fetch the latest status of the Payment Intent if necessary
                     [[STPAPIClient sharedClient] retrievePaymentIntentWithClientSecret:clientSecret completion:^(STPPaymentIntent *paymentIntent, NSError *error) {
                         // Check paymentIntent.status
                         NSLog(@"%ld",(long)paymentIntent.status);
                         if (paymentIntent.status == STPPaymentIntentStatusSucceeded)
                         {
                             NSLog(@"%ld",(long)paymentIntent.status);
                         }
                     }];
                 }];
                 if (redirectContext) {
                     
                     // opens SFSafariViewController to the necessary URL
                     [self dismissViewControllerAnimated:YES completion:nil];
                     [redirectContext startRedirectFlowFromViewController:self];
                 } else {
                     NSLog(@"Action not supported");
                     [self dismissViewControllerAnimated:YES completion:nil];
                     //Flow goes here------>>
                     NSLog(@"%@",redirectContext.description);
                     // This PaymentIntent action is not yet supported by the SDK.
                 }
                 [self dismissViewControllerAnimated:YES completion:nil];
                 // Show success message
             }
             // see below to handle the confirmed PaymentIntent
         }
     }];
}


- (void)addCardViewControllerDidCancel:(STPAddCardViewController *)addCardViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
