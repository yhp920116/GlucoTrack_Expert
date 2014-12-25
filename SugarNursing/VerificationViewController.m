//
//  VerificationViewController.m
//  SugarNursing
//
//  Created by Dan on 14-12-16.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "VerificationViewController.h"
#import <SMS_SDK/SMS_SDK.h>
#import <SMS_SDK/CountryAndAreaCode.h>
#import "AreaNameAndCodeViewController.h"
#import "RegistViewController.h"
#import "ResetPwdViewController.h"
#import <MBProgressHUD.h>


@interface VerificationViewController ()<UIAlertViewDelegate>{
    MBProgressHUD *hud;
}

@property (strong, nonatomic) CountryAndAreaCode *countryAndAreaCode;

@end

@implementation VerificationViewController

- (void)awakeFromNib
{
    // Default CountryAndAreaCode
    self.countryAndAreaCode = [[CountryAndAreaCode alloc] init];
    self.countryAndAreaCode.countryName = NSLocalizedString(@"hongkong", nil);
    self.countryAndAreaCode.areaCode = @"852";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateLabels];

}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)updateLabels
{
    self.countryLabel.text = self.countryAndAreaCode.countryName;
    self.areaCodeLabel.text = [NSString stringWithFormat:@"+%@",self.countryAndAreaCode.areaCode];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    switch (indexPath.row) {
        case 0:
        case 2:
        case 3:
            height = 30;
            break;
        case 1:
            height = 44;
            break;
        default:
            break;
    }
    return height;
}

- (IBAction)GetVerificationCode:(id)sender
{
    if ([self.phoneField.text isEqualToString:@"000"]) {
        switch (self.verifiedType) {
            case 0:
                [self performSegueWithIdentifier:@"Register" sender:nil];
                return;
            case 1:
                [self performSegueWithIdentifier:@"Reset" sender:nil];
                return;
        }
    }
    
    if (!(self.phoneField.text.length == 11 || self.phoneField.text.length == 8)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"notice", nil) message:NSLocalizedString(@"errorphonenumber", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"sure", nil) otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
   
    
    NSString *confirmInfo = [NSString stringWithFormat:@"%@:%@ %@",NSLocalizedString(@"willsendthecodeto", nil),self.countryAndAreaCode.areaCode, self.phoneField.text];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"surephonenumber", nil) message:confirmInfo delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"sure", nil), nil];
    [alert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
        
        hud.labelText = NSLocalizedString(@"Sending code", nil);
        [hud show:YES];
        
        
        [SMS_SDK getVerifyCodeByPhoneNumber:self.phoneField.text AndZone:self.countryAndAreaCode.areaCode result:^(enum SMS_GetVerifyCodeResponseState state) {
            [hud hide:YES];
            if (1 == state) {
                switch (self.verifiedType) {
                    case 0:
                        [self performSegueWithIdentifier:@"Register" sender:nil];
                        break;
                    case 1:
                        [self performSegueWithIdentifier:@"Reset" sender:nil];
                        break;
                }
            }
            else if(0==state)
            {
                //获取验证码失败
                NSString* str=[NSString stringWithFormat:NSLocalizedString(@"codesenderrormsg", nil)];
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"codesenderrtitle", nil) message:str delegate:self cancelButtonTitle:NSLocalizedString(@"sure", nil) otherButtonTitles:nil, nil];
                [alert show];
            }
            else if (SMS_ResponseStateMaxVerifyCode==state)
            {
                NSString* str=[NSString stringWithFormat:NSLocalizedString(@"maxcodemsg", nil)];
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"maxcode", nil) message:str delegate:self cancelButtonTitle:NSLocalizedString(@"sure", nil) otherButtonTitles:nil, nil];
                [alert show];
            }
            else if(SMS_ResponseStateGetVerifyCodeTooOften==state)
            {
                NSString* str=[NSString stringWithFormat:NSLocalizedString(@"codetoooftenmsg", nil)];
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"notice", nil) message:str delegate:self cancelButtonTitle:NSLocalizedString(@"sure", nil) otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
    }
}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqual:@"AreaCode"])
    {
        AreaNameAndCodeViewController *areaNameAndCodeVC = [segue destinationViewController];
        areaNameAndCodeVC.countryAndAreaCode = self.countryAndAreaCode;

    }else if ([segue.identifier isEqual:@"Register"])
    {
        RegistViewController *registerVC = [segue destinationViewController];
        registerVC.areaCode = self.countryAndAreaCode.areaCode;
        registerVC.phoneNumber = self.phoneField.text;
    }else if ([segue.identifier isEqual:@"Reset"])
    {
        ResetPwdViewController *resetVC = [segue destinationViewController];
        resetVC.areaCode = self.countryAndAreaCode.areaCode;
        resetVC.phoneNumber = self.phoneField.text;
    }
}

- (IBAction)back:(UIStoryboardSegue*)unwindSegue
{
    
}

@end
