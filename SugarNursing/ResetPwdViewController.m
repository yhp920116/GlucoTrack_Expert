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
        hud.labelText = @"A code has sent to your phone";
        sleep(1);
    } completionBlock:^{
     
    }];
}

- (IBAction)resetAndLogin:(id)sender
{
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    
    hud.labelText = @"Reset And Logining..";
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [AppDelegate userLogIn];
    }];
}
@end
