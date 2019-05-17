//
//  Api_Handler.m
//  Etsdc
//
//  Created by Cybraum on 4/20/16.
//  Copyright © 2016 Cybraum. All rights reserved.
//

#import "Api_Handler.h"
#import "AFNetworking.h"

@implementation Api_Handler

#define Api_Link @ "https://www.dateout.co/services/v4/"

-(void)getUralCall:(NSString *)url completionHandler:(void (^)(BOOL success,NSData* data))completionBlock
{
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",Api_Link,url];
    NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc] init];
    [request1 setURL:[NSURL URLWithString:urlStr]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request1
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          NSLog(@"%@", response);
                                          if (error == nil)
                                          {
                                              completionBlock(YES,data);
                                          }
                                          else
                                          {
                                              completionBlock(NO,nil);
                                          }
                                      }
                                      ];
    [dataTask resume];
    
}

-(void)postUrlCalls:(NSString *)url parameter:(NSString *)parameters completionHandler:(void (^)(BOOL success,NSData* data))completionBlock
{
    NSLog(@"------------------------");
    NSLog(@"");
    NSLog(@"%@",parameters);
    NSLog(@"");
    NSLog(@"------------------------");

    NSData *postData = [parameters dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",Api_Link,url];
    NSLog(@"%@",urlStr);
    NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc] init];
    [request1 setURL:[NSURL URLWithString:urlStr]];
    [request1 setHTTPMethod:@"POST"];
    [request1 setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request1 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request1 setHTTPBody:postData];
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request1
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          NSLog(@"%@", response);
                                          if (error == nil)
                                          {
                                              completionBlock(YES,data);
                                          }
                                          else
                                          {
                                              completionBlock(NO,nil);
                                          }
                                      }
                                      ];
    [dataTask resume];
    
}

-(void)getUralCallDistance:(NSString *)url completionHandler:(void (^)(BOOL success,NSData* data))completionBlock
{
    
    NSString *urlStr=[NSString stringWithFormat:@"%@",url];
    NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc] init];
    [request1 setURL:[NSURL URLWithString:urlStr]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request1
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          NSLog(@"%@", response);
                                          if (error == nil)
                                          {
                                              completionBlock(YES,data);
                                          }
                                          else
                                          {
                                              completionBlock(NO,nil);
                                          }
                                      }
                                      ];
    [dataTask resume];
    
}

-(void)postUrlCalls4:(NSString *)url parameter:(NSDictionary *)parameters completionHandler:(void (^)(BOOL success,id data))completionBlock
{
    NSLog(@"%@",parameters);
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *urlStr=[NSString stringWithFormat:@"%@",url];
    NSURLRequest *request =  [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:parameters error:nil];

    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            completionBlock(NO,nil);
            
        } else {
           // NSLog(@"%@ %@", response, responseObject);
            completionBlock(YES,responseObject);
            
        }
    }];
    [dataTask resume];
    
}
-(void)postUrlCalls5:(NSString *)url parameter:(NSDictionary *)parameters completionHandler:(void (^)(BOOL success,id data))completionBlock
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *urlStr=[NSString stringWithFormat:@"%@",url];
    NSURLRequest *request =  [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:parameters error:nil];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress: %@", uploadProgress);

    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"uploadProgress: %@", downloadProgress);

    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error);
            completionBlock(NO,nil);
            
        } else {
            // NSLog(@"%@ %@", response, responseObject);
            completionBlock(YES,responseObject);
            
        }
    } ];
    [dataTask resume];

}
@end
