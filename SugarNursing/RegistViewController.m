//
//  RegistViewController.m
//  SugarNursing
//
//  Created by Dan on 14-11-16.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "RegistViewController.h"
#import "AppDelegate+UserLogInOut.h"
#import <MBProgressHUD.h>
#import <SMS_SDK/SMS_SDK.h>
#import "GCRequest.h"
#import <UIAlertView+AFNetworking.h>

@interface RegistViewController ()<UIAlertViewDelegate,UIActionSheetDelegate>{
    MBProgressHUD *hud;
    
    NSArray *_departmentsArray;
}


@end


@implementation RegistViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Register", nil);
//    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    
    
    
    _departmentsArray = @[@{@"componentTitle":@"内科",@"content":@[@"神经内科",@"呼吸内科",@"心内科",@"肾内科",@"普通内科"]
                            },
                          @{@"componentTitle":@"外科",@"content":@[@"皮肤科",@"五官科",@"普通外科"]
                            }];
}

#pragma mark - IBAction

- (IBAction)getCodeAgain:(id)sender
{
    NSString *confirmInfo = [NSString stringWithFormat:@"%@:%@ %@",NSLocalizedString(@"willsendthecodeto", nil),self.areaCode, self.phoneNumber];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"suretosendphonenumber", nil) message:confirmInfo delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"sure", nil), nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex) {
        [SMS_SDK getVerifyCodeByPhoneNumber:self.phoneNumber AndZone:self.areaCode result:^(enum SMS_GetVerifyCodeResponseState state) {
            if (1 == state)
            {
                //获取验证码成功
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



- (IBAction)genderPicker:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"choosegender", nil) delegate:self cancelButtonTitle:nil destructiveButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"male", nil),NSLocalizedString(@"female", nil), nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0) {
        [self.genderBtn setTitle:[actionSheet buttonTitleAtIndex:buttonIndex] forState:UIControlStateNormal];
    }
}


- (IBAction)datePicker:(id)sender
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.customView = self.datePicker;
    hud.mode = MBProgressHUDModeCustomView;
    [hud show:YES];
}

- (IBAction)didSelectDatePicker:(id)sender
{
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    NSDate *date = [datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    
    [self.dateBtn setTitle:dateString forState:UIControlStateNormal];
    
    [hud hide:YES afterDelay:0.25];
}

- (IBAction)departmentPicker:(id)sender
{
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = self.departmentCustomView;
    
    [self.view addSubview:hud];
    [hud show:YES];
}


#pragma mark - UIPickerView DataSource & Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return _departmentsArray.count;
    }
    else
    {
        NSInteger selectRowLeft = [pickerView selectedRowInComponent:0];
        
        NSArray *rowArray = [[_departmentsArray objectAtIndex:selectRowLeft] objectForKey:@"content"];
        return rowArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (component == 0)
    {
        NSDictionary *department = [_departmentsArray objectAtIndex:row];
        NSString *componentTitle = [department objectForKey:@"componentTitle"];
        return componentTitle;
    }
    else
    {
        NSInteger selectRowLeft = [pickerView selectedRowInComponent:0];
        NSDictionary *department = [_departmentsArray objectAtIndex:selectRowLeft];
        NSArray *rowArray = [department objectForKey:@"content"];
        NSString *title = [rowArray objectAtIndex:row];
        return title;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (component == 0)
    {
        
        [self.departmentPicker reloadComponent:1];
    }
}

- (IBAction)confirmButtonEvent:(id)sender
{
    
    NSInteger selectComponent = [self.departmentPicker selectedRowInComponent:0];
    NSInteger selectRow = [self.departmentPicker selectedRowInComponent:1];
    
    
    NSDictionary *department = [_departmentsArray objectAtIndex:selectComponent];
    NSArray *rowArray = [department objectForKey:@"content"];
    NSString *title = [rowArray objectAtIndex:selectRow];
    
    
    [self.departmentBtn setTitle:title forState:UIControlStateNormal];
    
    
    [hud hide:YES];
}


- (IBAction)cancelButtonEvent:(id)sender
{
    
    [hud hide:YES];
}


#pragma mark - 注册
- (IBAction)regist:(id)sender
{
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
        
    hud.labelText = NSLocalizedString(@"Registering...", nil);
    [hud show:YES];
    
    
    
    NSDictionary *parameters = @{@"captcha":self.codeTextField.text,
                                 @"method":@"accountRegist",
                                 @"mobile":self.phoneNumber,
                                 @"password":self.passwordField.text,
                                 @"exptName":self.usernameField.text,
                                 @"sex":self.genderBtn.currentTitle,
                                 @"birthday":self.dateBtn.currentTitle,
                                 @"departmentId":@"123",
                                 @"appType":@"2",
                                 @"zone":self.areaCode};
    
    
    NSURLSessionDataTask *registerTask = [GCRequest accountRegistWithParameters:parameters block:^(NSDictionary *responseData, NSError *error) {
        
        
        if (!error)
        {
            
            if ([[responseData objectForKey:@"ret_code"] isEqualToString:@"0"])
            {
                [self performSegueWithIdentifier:@"goRegistComplete" sender:nil];
                [hud hide:YES];
            }
            else
            {
                hud.mode = MBProgressHUDModeText;
                hud.labelText = [responseData objectForKey:@"ret_msg"];
                [hud hide:YES afterDelay:1.2];
            }
            
        }
        else [hud hide:YES afterDelay:0.25];
        
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:registerTask delegate:nil];
}


@end
