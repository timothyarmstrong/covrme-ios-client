//
//  CMAPIClient.m
//  covrme
//
//  Created by Anthony Wong on 12-03-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CMAPIClient.h"
#import "AFJSONRequestOperation.h"


@implementation CMAPIClient
+ (CMAPIClient *)sharedClient {
    static CMAPIClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"http://covrme.herokuapp.com/"]];
    });
    
    return _sharedClient;
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

- (void)getHistoryWithParameters:(NSDictionary *)params
                         success:(CMAPIClientSuccessBlock)success
                         failure:(CMAPIClientFailureBlock)failure
{
    NSDictionary *responseObject = @[@{": <#object, ...#>}]
    success(nil,)
}
@end
