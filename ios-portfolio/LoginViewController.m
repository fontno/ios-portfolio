//
//  LoginViewController.m
//  ios-portfolio
//
//  Created by Brian Fontenot on 11/21/13.
//  Copyright (c) 2013 Brian Fontenot. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistrationViewController.h"
#import "AuthenticationTokenStore.h"
#import "APIClient.h"
#import "SVProgressHUD.h"

@interface LoginViewController ()

@property (strong, nonatomic) UITextField *passwordField;
@property (strong, nonatomic) UITextField *emailField;
@property (strong, nonatomic) UILabel *loginLabel;
@property (strong, nonatomic) UILabel *dividerLabel;
@property (strong, nonatomic) UIButton *registerButton;
@property (strong, nonatomic) AuthenticationTokenStore *authenticationTokenStore;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.authenticationTokenStore = [[AuthenticationTokenStore alloc] init];
    
    // Cancel Bar Button
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(cancelLogin:)];
    
    // Login Bar Button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Login"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(login:)];
    
    CGSize size = self.view.frame.size;
    
    // Login Label
    CGRect loginLabelFrame = CGRectMake(size.width * 0.2f, size.height * 0.1f, 200.0f, 21.0f);
    self.loginLabel = [[UILabel alloc] initWithFrame:loginLabelFrame];
    self.loginLabel.backgroundColor = [UIColor grayColor];
    self.loginLabel.text = @"Login";
    self.loginLabel.textColor = [UIColor whiteColor];
    self.loginLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    self.loginLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.loginLabel];
    
    
    // Email Text Field
    CGRect emailFieldFrame = CGRectMake(size.width * 0.2f, size.height * 0.2f, 200.0f, 31.0f);
    self.emailField = [[UITextField alloc] initWithFrame: emailFieldFrame];
    self.emailField.borderStyle = UITextBorderStyleRoundedRect;
    self.emailField.placeholder = @"Email";
    self.emailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:self.emailField];
    
    // Password Text Field
    CGRect passwordFieldFrame = CGRectMake(size.width * 0.2f, size.height * 0.3f, 200.0f, 31.0f);
    self.passwordField = [[UITextField alloc] initWithFrame: passwordFieldFrame];
    self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordField.placeholder = @"Password";
    self.passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:self.passwordField];
    
    // Divider Label
    CGRect dividerLabelFrame = CGRectMake(size.width * 0.2f, size.height * 0.4f, 200.0f, 21.0f);
    self.dividerLabel = [[UILabel alloc] initWithFrame:dividerLabelFrame];
    self.dividerLabel.backgroundColor = [UIColor grayColor];
    self.dividerLabel.text = @"OR";
    self.dividerLabel.textColor = [UIColor whiteColor];
    self.dividerLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    self.dividerLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.dividerLabel];
    
    // Register Button
    CGRect registerButtonFrame = CGRectMake(size.width * 0.2f, size.height * 0.5f, 200.0f, 31.0f);
    self.registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.registerButton.frame = registerButtonFrame;
    [self.registerButton setTitle:@"Register" forState:UIControlStateNormal];
    [self.registerButton addTarget:self action:@selector(registrationScreen:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void)presentLoginScreenFromViewController:(UIViewController *)viewController
{
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [viewController presentViewController:navigationController
                                 animated:YES
                               completion:nil];
}

#pragma mark - Actions

- (void)cancelLogin:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)login:(id)sender
{
    [SVProgressHUD show];
    
    id loginParams = @{@"email": self.emailField.text, @"password": self.passwordField.text};
    
    [[APIClient sharedClient] postPath:@"token/login.json"
                            parameters:loginParams
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   NSString *authToken = [responseObject objectForKey:@"auth_token"];
                                   [self.authenticationTokenStore setAuthenticationToken:authToken];
                                   NSLog(@"%@", authToken);
                                   
                                   [SVProgressHUD dismiss];
                                   [self dismissViewControllerAnimated:YES completion:nil];
                                   
                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 if (operation.response.statusCode == 500) {
                                     [SVProgressHUD showErrorWithStatus:@"Internal Server Error"];
                                 } else {
                                     NSData *jsonData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                                     NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                                          options:0
                                                                                            error:nil];
                                     NSString *errorMessage = [json objectForKey:@"error"];
                                     [SVProgressHUD showErrorWithStatus:errorMessage];
                                     
                                     NSLog(@"%@", errorMessage);
                                 }
    }];
}

- (void)registrationScreen:(id)sender
{
    [RegistrationViewController presentRegistrationScreenFromViewController:self];
}

@end