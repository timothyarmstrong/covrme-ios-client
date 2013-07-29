//
//  CMAPIClient.m
//  covrme
//
//  Created by Anthony Wong on 12-03-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CMAPIClient.h"
#import "AFJSONRequestOperation.h"

//ktpo5g5b3j6fmelsmgv9j6rt50csccrs

@implementation CMAPIClient

+ (NSString*) formattedStringForAPICall:(NSString*)body
{
    body = [CMAPIClient escapedStringForAPICall:body];
    body = [body stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    body = [body stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    body = [body stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@" +" options:NSRegularExpressionCaseInsensitive error:&error];
    body = [regex stringByReplacingMatchesInString:body options:0 range:NSMakeRange(0, [body length]) withTemplate:@" "];
    
    NSData *data = [body dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    body = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    return body;
}

+ (NSString*) escapedStringForAPICall:(NSString*)unescapedString
{
    return [unescapedString stringByReplacingOccurrencesOfString:@"%" withString:@"%25"];
}


+ (CMAPIClient *)sharedClient {
    static CMAPIClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"http://covrme-dev-armstrong-timothy.appspot.com/"]];
    });
    
    return _sharedClient;
}

- (NSString *)token
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
}

- (NSString *)userID
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"userID"];
}

- (id)initWithBaseURL:(NSURL *)url {
    
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
	
    [self setDefaultHeader:@"user-agent" value:@"covrme"];
    
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    return self;
}


- (void)postToTimsServerWithParameters:(NSDictionary*)params
                               success:(CMAPIClientSuccessBlock)success
                               failure:(CMAPIClientFailureBlock)failure
{
    [self postPath:@"http://timarm.com/covrme/response.php"
        parameters:params
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           } 
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation.response, error);
           }
     ];
}

- (void)signupUserWithName:(NSString *)name
                     email:(NSString *)email
                  password:(NSString *)pass
                   success:(CMAPIClientSuccessBlock)success
                   failure:(CMAPIClientFailureBlock)failure
{
    
    NSDictionary *params = @{@"name": [CMAPIClient formattedStringForAPICall:name],
                             @"email": [CMAPIClient formattedStringForAPICall:email],
                             @"password": [CMAPIClient formattedStringForAPICall:pass]};
    [self postPath:@"users"
        parameters:params
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation.response, error);
           }];
}

- (void)getAuthTokenWithEmail:(NSString *)email
                     password:(NSString *)password
                      success:(CMAPIClientSuccessBlock)success
                      failure:(CMAPIClientFailureBlock)failure
{
    NSDictionary *params = @{@"email": [CMAPIClient formattedStringForAPICall:email],
                             @"password": [CMAPIClient formattedStringForAPICall:password]};
    
    [self postPath:@"authtokens"
        parameters:params
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation.response, error);
           }];
    
}

- (void)getHistoryWithDoorbellID:(NSString *)ID
                         success:(CMAPIClientSuccessBlock)success
                         failure:(CMAPIClientFailureBlock)failure
{
    
    if (![self token] || ![self token].length) {
        return;
    }
    
    NSDictionary *params = @{@"authtoken": [self token]};
    
    NSString *path = [NSString stringWithFormat:@"doorbells/%@/visitors", ID];
    
    [self getPath:path
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              success(operation, responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failure(operation.response, error);
          }];
}

- (void)getHistoryDetailWithDoorbellID:(NSString *)doorbellID
                             visitorID:(NSString *)visitorID
                         success:(CMAPIClientSuccessBlock)success
                         failure:(CMAPIClientFailureBlock)failure
{
    
    if (![self token] || ![self token].length) {
        return;
    }
    
    NSDictionary *params = @{@"authtoken": [self token]};
    
    NSString *path = [NSString stringWithFormat:@"doorbells/%@/visitors/%@", doorbellID, visitorID];
    
    [self getPath:path
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              success(operation, responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failure(operation.response, error);
          }];
}


- (void)sendMessageToDoorbellID:(NSString *)doorbellID
                  withVisitorID:(NSString *)visitorID
                    withMessage:(NSString *)message
                        success:(CMAPIClientSuccessBlock)success
                        failure:(CMAPIClientFailureBlock)failure
{
    if (![self token] || ![self token].length) {
        return;
    }
    NSDictionary *params = @{@"authtoken": [self token],
                             @"message": [CMAPIClient formattedStringForAPICall:message]};
    
    NSString *path = [NSString stringWithFormat:@"doorbells/%@/visitors/%@/messages", doorbellID, visitorID];
    
    [self postPath:path
        parameters:params
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation.response, error);
           }];
    
}

- (void)getDoorPictureForVisitorID:(NSString *)visitorID
                           success:(CMAPIClientSuccessBlock)success
                           failure:(CMAPIClientFailureBlock)failure
{
    if (![self token] || ![self token].length) {
        return;
    }
    
    NSDictionary *params = @{@"authtoken": [self token]};
    
    NSString *path = [NSString stringWithFormat:@"visitors/%@/photos", visitorID];
    
    [self getPath:path
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              success(operation, responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failure(operation.response, error);
          }];
}

- (void)setDoorbellTone:(NSString *)filename
                success:(CMAPIClientSuccessBlock)success
                failure:(CMAPIClientFailureBlock)failure
{
    NSDictionary *params = @{@"authtoken": [self token],
                             @"sound": filename};
    
    NSString *path = [NSString stringWithFormat:@"users/%@/settings", [self userID]];
    
    [self putPath:path
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              success(operation, responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failure(operation.response, error);
          }];
}

- (void)registerPushToken:(NSString *)token
                  success:(CMAPIClientSuccessBlock)success
                  failure:(CMAPIClientFailureBlock)failure
{
    
    if (![self token] || ![self token].length) {
        return;
    }
    
    NSDictionary *params = @{@"authtoken": [self token],
                             @"push_token": token};
    
    NSString *path = [NSString stringWithFormat:@"users/%@/pushtokens", [self userID]];
    
    [self postPath:path
        parameters:params
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation.response, error);
           }];
}

- (void)registerUserToDoorbellID:(NSString *)doorbellID
                         success:(CMAPIClientSuccessBlock)success
                         failure:(CMAPIClientFailureBlock)failure
{
    NSDictionary *params = @{@"authtoken": [self token],
                             @"doorbellId": doorbellID};
    
    NSString *path = [NSString stringWithFormat:@"users/%@/doorbells", [self userID]];
    
    [self postPath:path
        parameters:params
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation.response, error);
           }];
}

- (void)deleteDoorbellID:(NSString *)doorbellID
                 success:(CMAPIClientSuccessBlock)success
                 failure:(CMAPIClientFailureBlock)failure
{
    NSDictionary *params = @{@"authtoken": [self token],
                             @"doorbellId": doorbellID};
    
    NSString *path = [NSString stringWithFormat:@"users/%@/doorbells", [self userID]];
    
    [self deletePath:path
          parameters:params
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation.response, error);
           }];
}
@end
