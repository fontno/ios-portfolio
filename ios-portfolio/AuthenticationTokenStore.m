//
//  AuthenticationTokenStore.m
//  ios-portfolio
//
//  Created by Brian Fontenot on 11/18/13.
//  Copyright (c) 2013 Brian Fontenot. All rights reserved.
//

#import "AuthenticationTokenStore.h"
#import "SSKeychain.h"

@implementation AuthenticationTokenStore

- (NSString *)authenticationToken
{
    return [self secureValueForKey:@"auth_token"];
}

- (void)setAuthenticationToken:(NSString *)authenticationToken
{
    [self setSecureValue:authenticationToken
                  forKey:@"auth_token"];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"token-changed"
//                                                        object:self];
}

- (BOOL)isAuthenticated
{
    return [self authenticationToken] != nil;
}

- (void)clearAuthenticationTokenStore
{
    [self setAuthenticationToken:nil];
}

#pragma mark - SSKeychain

- (void)setSecureValue:(NSString *)value forKey:(NSString *)key
{
    if (value) {
        [SSKeychain setPassword:value
                     forService:@"Portfolio"
                        account:key];
    } else {
        [SSKeychain deletePasswordForService:@"Portfolio"
                                     account:key];
    }
}

- (NSString *)secureValueForKey:(NSString *)key
{
    return [SSKeychain passwordForService:@"Portfolio"
                                  account:key];
}

@end
