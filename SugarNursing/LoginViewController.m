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
#import "VerificationViewController.h"


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

#pragma mark - PrepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    VerificationViewController *verificationVC= (VerificationViewController *)[[[segue destinationViewController] viewControllers] objectAtIndex:0];
    
    if ([segue.identifier isEqualToString:@"Regist"])
    {
        verificationVC.title = @"Regist by phone";
        verificationVC.labelText= @"Input your PhoneNumber to regist";

    }
    else if ([segue.identifier isEqualToString:@"Reset"])
    {
        verificationVC.title = @"Reset your password";

        verificationVC.labelText = @"Input your PhoneNumber to reset";
    }
    
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
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    CGFloat calHeight;
    if (screenHeight - kbHeight - 200 >= 20) {
         calHeight = screenHeight/2-100;

    } else {
        return;
    }
    
    if (kbHeight > calHeight) {
        self.loginViewYCons.constant = -(kbHeight-calHeight);
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

#pragma mark - userAction

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

#pragma mark - textfieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 11:
            self.userFieldBG.image = [UIImage imageNamed:@"003"];
            break;
        case 12:
            self.pwdFieldBG.image = [UIImage imageNamed:@"003"];
            break;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 11:
            self.userFieldBG.image = [UIImage imageNamed:@"004"];
            break;
        case 12:
            self.pwdFieldBG.image = [UIImage imageNamed:@"004"];
            break;
    }
}

#pragma mark - dismissKeyboard

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

#pragma mark - unwindSegue

- (IBAction)back:(UIStoryboardSegue *)unwindSegue
{
//    UIViewController *sourceViewController = unwindSegue.sourceViewController;
//    [sourceViewController.view endEditing:YES];
}


@end
