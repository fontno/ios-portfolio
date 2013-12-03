//
//  RegistrationViewController.m
//  ios-portfolio
//
//  Created by Brian Fontenot on 12/1/13.
//  Copyright (c) 2013 Brian Fontenot. All rights reserved.
//

#import "RegistrationViewController.h"
#import "APIClient.h"
#import "SVProgressHUD.h"

@interface RegistrationViewController ()

@property (strong, nonatomic) UITextField *emailField;
@property (strong, nonatomic) UITextField *passwordField;
@property (strong, nonatomic) UITextField *confirmationField;

@end

@implementation RegistrationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Cancel Bar Button
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(cancelRegistration:)];
    
    // Register Bar Button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Register"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(register:)];
    
    CGSize size = self.view.frame.size;
    
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
    
    // Password Confirmation Field
    CGRect confirmationFieldFrame = CGRectMake(size.width * 0.2f, size.height * 0.4f, 200.0f, 31.0f);
    self.confirmationField = [[UITextField alloc] initWithFrame: confirmationFieldFrame];
    self.confirmationField.borderStyle = UITextBorderStyleRoundedRect;
    self.confirmationField.placeholder = @"Confirm Password";
    self.confirmationField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:self.confirmationField];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void)presentRegistrationScreenFromViewController:(UIViewController *)viewController
{
    RegistrationViewController *registrationController = [[RegistrationViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:registrationController];
    
    [viewController presentViewController:navController
                                 animated:YES
                               completion:nil];
}

#pragma mark - Actions

- (void)cancelRegistration:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)register:(id)sender
{
    [SVProgressHUD show];
    
    id registrationParams = @{@"email": self.emailField.text,
                              @"password": self.passwordField.text,
                              @"password_confirmation": self.confirmationField.text};
    
    [[APIClient sharedClient] postPath:@"registrations.json"
                            parameters:registrationParams
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   
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

@end
