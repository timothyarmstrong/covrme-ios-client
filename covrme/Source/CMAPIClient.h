//
//  CMAPIClient.h
//  covrme
//
//  Created by Anthony Wong on 12-03-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFHTTPClient.h"

@interface CMAPIClient : AFHTTPClient
+ (CMAPIClient*) sharedClient;

typedef void(^CMAPIClientStartupBlock)(NSOperation* operation);
typedef void(^CMAPIClientSuccessBlock) (AFHTTPRequestOperation *operation, id responseObject);
typedef void(^CMAPIClientCompletionBlock)();
typedef void(^CMAPIClientFailureBlock)(NSHTTPURLResponse *response, NSError *error);

- (void)postToTimsServerWithParameters:(NSDictionary*)params success:(CMAPIClientSuccessBlock)success failure:(CMAPIClientFailureBlock)failure;

- (void)signupUserWithName:(NSString *)name
                     email:(NSString *)email
                  password:(NSString *)pass
                   success:(CMAPIClientSuccessBlock)success
                   failure:(CMAPIClientFailureBlock)failure;

- (void)getAuthTokenWithEmail:(NSString *)email
                     password:(NSString *)password
                      success:(CMAPIClientSuccessBlock)success
                      failure:(CMAPIClientFailureBlock)failure;

- (void)getHistoryWithDoorbellID:(NSString *)ID
                         success:(CMAPIClientSuccessBlock)success
                         failure:(CMAPIClientFailureBlock)failure;

- (void)getNewDoorPictureWithParameters:(NSDictionary *)params
                                success:(CMAPIClientSuccessBlock)success
                                failure:(CMAPIClientFailureBlock)failure;
@end
