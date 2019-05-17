//
//  ViewController.h
//  stripeTest
//
//  Created by Cybraum on 5/15/19.
//  Copyright © 2019 meridian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Api_Handler.h"

@interface ViewController : UIViewController
{
    NSString *client_secret;
    NSString *idSecret;
    Api_Handler *getdata;
}
- (IBAction)payButton:(id)sender;


@end

