//
//  ResetPwdViewController.m
//  SugarNursing
//
//  Created by Dan on 14-11-17.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "ResetPwdViewController.h"
#import "AppDelegate+UserLogInOut.h"
#import <MBProgressHUD.h>
#import "UIStoryboard+Storyboards.h"

@interface ResetPwdViewController (){
    MBProgressHUD *hud;
}

@end

@implementation ResetPwdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)getCodeAgain:(id)sender
{
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(2);
        hud.mode = MBProgressHUDModeText;
        hud.labelText = NSLocalizedString(@"A code has sent to your phone", nil);
        sleep(1);
    } completionBlock:^{
     
    }];
}

- (IBAction)resetAndLogin:(id)sender
{
    //判断入口是登陆页面的'忘记密码'还是系统设置的'重设密码'
    UIViewController *vc = self.navigationController.viewControllers[0];
    
    if ([vc isKindOfClass:[UITableViewController class]])
    {
        
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
        
        hud.mode = MBProgressHUDModeText;
        hud.labelText = NSLocalizedString(@"Password is changed", nil);
        [hud showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }
    else
    {
        
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
        
        hud.labelText = NSLocalizedString(@"Reset And Logining..", nil);
        [hud showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            [AppDelegate userLogIn];
        }];
    }
}
@end
