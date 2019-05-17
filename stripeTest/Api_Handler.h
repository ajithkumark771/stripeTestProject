//
//  Api_Handler.h
//  Etsdc
//
//  Created by Cybraum on 4/20/16.
//  Copyright © 2016 Cybraum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Api_Handler : UIViewController
{
 
}
-(void)getUralCall:(NSString *)url completionHandler:(void (^)(BOOL success,NSData* data))completionBlock;
-(void)postUrlCalls:(NSString *)url parameter:(NSString *)parameters completionHandler:(void (^)(BOOL success,NSData* data))completionBlock;
-(void)getUralCallDistance:(NSString *)url completionHandler:(void (^)(BOOL success,NSData* data))completionBlock;
-(void)postUrlCalls4:(NSString *)url parameter:(NSDictionary *)parameters completionHandler:(void (^)(BOOL success,id data))completionBlock;
-(void)postUrlCalls5:(NSString *)url parameter:(NSDictionary *)parameters completionHandler:(void (^)(BOOL success,id data))completionBlock;

@end
