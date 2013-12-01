//

//  MainViewController.m
//  ios-portfolio
//
//  Created by Brian Fontenot on 11/19/13.
//  Copyright (c) 2013 Brian Fontenot. All rights reserved.
//

#import "MainViewController.h"
#import "AuthenticationTokenStore.h"
#import "LoginViewController.h"
#import "SVProgressHUD.h"
#import "APIClient.h"

@interface MainViewController ()

@property (strong, nonatomic) UIButton *clearAuthTokenButton;
@property (strong, nonatomic) UIButton *statusButton;
@property (strong, nonatomic) UITextView *consoleTextView;
@property (strong, nonatomic) AuthenticationTokenStore *authenticationTokenStore;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.authenticationTokenStore = [[AuthenticationTokenStore alloc] init];
    
    CGSize size = self.view.frame.size;
    
    // Status button
    self.statusButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.statusButton.frame = CGRectMake(size.width * 0.2f, size.height * 0.1f, 200.0f, 31.0f);
    [self.statusButton setTitle:@"login status" forState:UIControlStateNormal];
    [self.statusButton addTarget:self action:@selector(fetchMessage:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.statusButton];
    
    // Logout
    // Clear auth token button
    self.clearAuthTokenButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.clearAuthTokenButton.frame = CGRectMake(size.width * 0.2f, size.height * 0.3f, 200.0f, 31.0f);
    [self.clearAuthTokenButton setTitle:@"Logout" forState:UIControlStateNormal];
    [self.clearAuthTokenButton addTarget:self action:@selector(clearAuthToken:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.clearAuthTokenButton];
    
    // Console view
    self.consoleTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, size.height * 0.5f, size.width, size.height)];
    self.consoleTextView.backgroundColor = [UIColor whiteColor];
    self.consoleTextView.font = [UIFont systemFontOfSize:16.0f];
    [self.view addSubview:self.consoleTextView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)ensureAuthentication
{
    if (![self.authenticationTokenStore isAuthenticated]) {
        [LoginViewController presentLoginScreenFromViewController:self];
        
        return NO;
    }
    
    return YES;
}

- (void)clearAuthToken:(id)sender
{
    [self.authenticationTokenStore clearAuthenticationTokenStore];
    
    [SVProgressHUD showSuccessWithStatus:@"Authentication Token Cleared"];
}



- (void)fetchMessage:(id)sender
{
    self.consoleTextView.text = @"";
    
    if (![self ensureAuthentication]) {
        return;
    }
    
    [SVProgressHUD show];
    
    [[APIClient sharedClient] getPath:@"posts.json"
                               parameters:nil
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      [SVProgressHUD dismiss];
                                      self.consoleTextView.text = operation.responseString;
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      if (operation.response.statusCode == 500) {
                                          [SVProgressHUD showErrorWithStatus:@"Something went wrong!"];
                                      } else {
                                          NSData *jsonData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                                          NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                                               options:0
                                                                                                 error:nil];
                                          NSString *errorMessage = [json objectForKey:@"error"];
                                          [SVProgressHUD showErrorWithStatus:errorMessage];
                                      }
                                      
                                      if (operation.response.statusCode == 401) {
                                          [SVProgressHUD showErrorWithStatus:@"401"];
                                      }
                                  }];
}

@end