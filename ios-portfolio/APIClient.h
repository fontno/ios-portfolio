//
//  APIClient.h
//  ios-portfolio
//
//  Created by Brian Fontenot on 11/11/13.
//  Copyright (c) 2013 Brian Fontenot. All rights reserved.
//

#import "AFNetworking.h"

@interface APIClient : AFHTTPClient

+ (APIClient *)sharedClient;

@end