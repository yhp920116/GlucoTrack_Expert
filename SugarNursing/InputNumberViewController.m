//
//  InputNumberViewController.m
//  SugarNursing
//
//  Created by Ian on 14-12-18.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "InputNumberViewController.h"
#import <MBProgressHUD.h>

@interface InputNumberViewController ()
{
    MBProgressHUD *hud;
}
@property (weak, nonatomic) IBOutlet UIImageView *numberBottonView;
@property (weak, nonatomic) IBOutlet UIButton *sendVerificationButton;

@end

@implementation InputNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.numberBottonView setImage:[UIImage imageNamed:@"003"]];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.numberBottonView setImage:[UIImage imageNamed:@"007"]];
}

- (IBAction)sendVerificationButtonEvent:(id)sender
{
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [hud setMode:MBProgressHUDModeText];
    [hud setLabelText:@"已发送验证码"];
    [self.view addSubview:hud];
    
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    }];
}

- (IBAction)bindPhoneButtonEvent:(id)sender
{
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [hud setMode:MBProgressHUDModeText];
    [hud setLabelText:@"验证成功"];
    [self.view addSubview:hud];
    
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    }completionBlock:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}


@end
