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
typedef void(^CMAPIClientFailureBlock)(NSHTTPURLResponse *response, NSError *error);
typedef void(^CMAPIClientCompletionBlock)();


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

- (void)getHistoryDetailWithDoorbellID:(NSString *)doorbellID
                             visitorID:(NSString *)visitorID
                               success:(CMAPIClientSuccessBlock)success
                               failure:(CMAPIClientFailureBlock)failure;

- (void)getNewDoorPictureWithParameters:(NSDictionary *)params
                                success:(CMAPIClientSuccessBlock)success
                                failure:(CMAPIClientFailureBlock)failure;

- (void)registerPushToken:(NSString *)token
                  success:(CMAPIClientSuccessBlock)success
                  failure:(CMAPIClientFailureBlock)failure;

- (void)registerUserToDoorbellID:(NSString *)doorbellID
                         success:(CMAPIClientSuccessBlock)success
                         failure:(CMAPIClientFailureBlock)failure;

- (void)sendMessageToDoorbellID:(NSString *)doorbellID
                  withVisitorID:(NSString *)visitorID
                    withMessage:(NSString *)message
                        success:(CMAPIClientSuccessBlock)success
                        failure:(CMAPIClientFailureBlock)failure;
@end
