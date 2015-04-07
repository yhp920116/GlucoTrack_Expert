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
#import "GCRequest.h"
#import <UIAlertView+AFNetworking.h>
#import "NSString+MD5.h"
#import "User.h"
#import "CoreDataStack.h"
#import "NSManagedObject+Finders.h"
#import "NSManagedObject+Savers.h"
#import "AppDelegate+Clean.h"
#import "AppDelegate.h"


@interface LoginViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *hud;
}


@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;


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
        verificationVC.title = NSLocalizedString(@"Register", nil);
        verificationVC.verifiedType = VerifiedTypeRegister;
        
    }
    else if ([segue.identifier isEqualToString:@"Reset"])
    {
        verificationVC.title = NSLocalizedString(@"Reset", nil);
        verificationVC.verifiedType = VerifiedTypeForget;
        
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

#pragma mark - MBProgressHUD Delegate
- (void)hudWasHidden:(MBProgressHUD *)hud2
{
    hud2 = nil;
}

#pragma mark - userAction

- (IBAction)userRegist:(id)sender
{
    
}

- (IBAction)userLogin:(id)sender
{
    
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = NSLocalizedString(@"Login..", nil);
    [hud show:YES];

    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    
    NSDictionary *parameters = @{@"method":@"verify",
                                 @"accountName":self.usernameField.text,
                                 @"password":self.passwordField.text,
                                 @"language":[self detectApplicationLanguage],
                                 @"clientSource":@"ios",
                                 @"deviceToken":appDelegate.deviceToken ? appDelegate.deviceToken : @""};
    
    
    [GCRequest verifyWithParameters:parameters block:^(NSDictionary *responseData, NSError *error) {
        if (!error)
        {
            NSString *ret_code = [responseData objectForKey:@"ret_code"];
            if ([ret_code isEqualToString:@"0"])
            {
                // 这里对获取到的会话标识、会话标识Token和用户标识等进行数据持久化
                NSMutableDictionary *responseDic = [responseData mutableCopy];
                [responseDic setValue:[self.passwordField.text md5] forKey:@"password"];
                [responseDic setValue:self.usernameField.text forKey:@"username"];
                
                NSArray *userObjects = [User findAllInContext:[CoreDataStack sharedCoreDataStack].context];
                
                // 这里的user是一个单例，有且只有一个用户数据，标识当前的用户
                User *user;
                if ([userObjects count]== 0)
                {
                    user = [User createEntityInContext:[CoreDataStack sharedCoreDataStack].context];
                }
                else
                {
                    user = userObjects[0];
                }
                
                [user updateCoreDataForData:responseDic withKeyPath:nil];
                [[CoreDataStack sharedCoreDataStack] saveContext];
                
                //判断当前登陆的账号跟上一次登陆的账号是否相同
                [self isOtherPhoneLogin];
                
                if (![UserInfo existWithContext:[CoreDataStack sharedCoreDataStack].context])
                {
                    
                    [self requestUserInfo];
                }
                else
                {
                    
                    [AppDelegate userLogIn];
                    [hud hide:YES afterDelay:0.25];
                }
            }
            else
            {
                hud.mode = MBProgressHUDModeText;
                hud.labelText = [NSString localizedMsgFromRet_code:ret_code withHUD:YES];
                [hud hide:YES afterDelay:1.2];
            }
        }
        else
        {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [NSString localizedErrorMesssagesFromError:error];
            [hud hide:YES afterDelay:HUD_TIME_DELAY];
        }

    }];
    
}


- (void)requestUserInfo
{
    
    NSDictionary *parameters = @{@"method":@"getPersonalInfo",
                                 @"sign":@"sign",
                                 @"sessionId":[NSString sessionID],
                                 @"exptId":[NSString exptId]};
    
    
    [GCRequest getPersonalInfoWithParameters:parameters block:^(NSDictionary *responseData, NSError *error) {
        NSArray *objects = [UserInfo findAllInContext:[CoreDataStack sharedCoreDataStack].context];
        
        UserInfo *info;
        
        if (objects.count <= 0)
        {
            info = [UserInfo createEntityInContext:[CoreDataStack sharedCoreDataStack].context];
            
        }
        else
        {
            info = objects[0];
        }
        
        info.exptId = [NSString exptId];
        
        if (!error)
        {
            if ([responseData[@"ret_code"] isEqualToString:@"0"])
            {
                
                responseData = [responseData[@"expert"] mutableCopy];
                
                [responseData sexFormattingToUserForKey:@"sex"];
                
                [responseData dateFormattingToUserForKey:@"birthday"];
                [responseData expertLevelFormattingToUserForKey:@"expertLevel"];
                
                [info updateCoreDataForData:responseData withKeyPath:nil];
                
                [[CoreDataStack sharedCoreDataStack] saveContext];
                
                
                [AppDelegate userLogIn];
                [hud hide:YES afterDelay:0.25];
                
                
            }
            else
            {
                
                hud.mode = MBProgressHUDModeText;
                hud.labelText = [NSString localizedMsgFromRet_code:responseData[@"ret_code"] withHUD:YES];
                [hud hide:YES afterDelay:1.2];
            }
        }
        else
        {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = error.localizedDescription;
            [hud hide:YES afterDelay:HUD_TIME_DELAY];
        }
        
    }];
    
}

//检测设备语言
- (NSString *)detectApplicationLanguage
{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSArray *allLanguages = [user objectForKey:@"AppleLanguages"];
    NSString *currentLanguage = allLanguages[0];
    
    if ([currentLanguage isEqualToString:@"zh-Hans"])
    {
        return @"1";
    }
    else if ([currentLanguage isEqualToString:@"zh-Hant"])
    {
        return @"2";
    }
    else if ([currentLanguage isEqualToString:@"en"])
    {
        return @"3";
    }
    else
    {
        return @"2";
    }
}

#pragma mark 判断当前登陆的账号跟上一次登陆的账号是否相同,不同则清楚所有缓存
- (void)isOtherPhoneLogin
{
    NSArray *userObjects = [User findAllInContext:[CoreDataStack sharedCoreDataStack].context];
    User *user = userObjects[0];
    
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *lastUsername = [userDefault objectForKey:@"LastUsername"];
    
    if (![lastUsername isEqualToString:user.username])
    {
        [AppDelegate cleanAllCoreData];
    }
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:self.passwordField])
    {
        
        NSString *fieldText = self.passwordField.text;
        if (fieldText.length + string.length >16)
        {
            return NO;
        }
    }
    
    return YES;
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
