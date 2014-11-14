//
//  LoginViewController.m
//  SugarNursing
//
//  Created by Dan on 14-11-6.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate+UserLogInOut.h"
#import <MBProgressHUD.h>
#import "UIViewController+Notifications.h"

@interface LoginViewController (){
    MBProgressHUD *hud;
}

@end

@implementation LoginViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - KeyboardNotification

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotification:@selector(keyboardWillShow:) :@selector(keyboardWillHide:)];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeKeyboardNotification];
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGFloat kbHeight = kbSize.height;
    CGFloat currHeight = self.view.bounds.size.height/2-100;
    NSLog(@"currHeight = %f",currHeight);
    
    if (kbHeight > currHeight) {
        self.loginViewYCons.constant = -(kbHeight-currHeight);
        [self.view setNeedsUpdateConstraints];
        
        [UIView animateWithDuration:0.4 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    self.loginViewYCons.constant  = 0;
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)userRegist:(id)sender
{
    
}

- (IBAction)userLogin:(id)sender
{
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = @"Logining..";
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [AppDelegate userLogIn];
    }];
}

#pragma mark - dismissKeyboard
- (IBAction)dismissKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self userLogin:nil];
    return YES;
}

@end
