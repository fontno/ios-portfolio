//
//  APIClient.m
//  ios-portfolio
//
//  Created by Brian Fontenot on 11/11/13.
//  Copyright (c) 2013 Brian Fontenot. All rights reservedhrfanb
//

#import "APIClient.h"
#import "AuthenticationTokenStore.h"

#define BASE_URL @"http://localhost:3000/api/v1/"

@implementation APIClient

//+ (APIClient *)sharedClient {
//    static APIClient *_sharedClient = nil;
//    static dispatch_once_t oncePredicate;
//    dispatch_once(&oncePredicate, ^{
//        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kAPIBaseUrl]];
//    });
//    
//    return _sharedClient;
//}

+ (id)sharedClient {
    static APIClient *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseUrl = [NSURL URLWithString:BASE_URL];
        __instance = [[APIClient alloc] initWithBaseURL:baseUrl];
    });
    return __instance;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        
        [self setAuthenticationTokenHeader];
    }
    
    return self;
}

- (void)setAuthenticationTokenHeader
{
    AuthenticationTokenStore *authTokenStore = [[AuthenticationTokenStore alloc] init];
    NSString *authToken = [authTokenStore authenticationToken];
    [self setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Token token=\"%@\"", authToken]];
    NSLog(@"%@", authToken);
}

@end