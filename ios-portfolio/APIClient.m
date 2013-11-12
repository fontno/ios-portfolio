//
//  APIClient.m
//  ios-portfolio
//
//  Created by Brian Fontenot on 11/11/13.
//  Copyright (c) 2013 Brian Fontenot. All rights reservedhrfanb
//

#import "APIClient.h"
#import "AFJSONRequestOperation.h"

NSString * const kAPIBaseUrl = @"http://localhost:3000";

@implementation APIClient

+ (APIClient *)sharedClient {
    static APIClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kAPIBaseUrl]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    
    return self;
}

@end
