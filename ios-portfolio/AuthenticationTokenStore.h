//
//  AuthenticationTokenStore.h
//  ios-portfolio
//
//  Created by Brian Fontenot on 11/18/13.
//  Copyright (c) 2013 Brian Fontenot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthenticationTokenStore : NSObject

- (void)setAuthenticationToken:(NSString *)authenticationToken;
- (NSString *)authenticationToken;
- (BOOL)isAuthenticated;
- (void)clearAuthenticationTokenStore;

@end
