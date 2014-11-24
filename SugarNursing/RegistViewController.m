//
//  RegistViewController.m
//  SugarNursing
//
//  Created by Dan on 14-11-16.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "RegistViewController.h"
#import "UIViewController+Notifications.h"
#import "AppDelegate+UserLogInOut.h"
#import <MBProgressHUD.h>

@interface RegistViewController (){
    MBProgressHUD *hud;
}

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark - KeyboardNotification

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotification:@selector(keyboardWillShow:) :@selector(keyboardWillHidden:)];
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
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
//    CGRect aRect = [[UIScreen mainScreen] bounds];
//    aRect.size.height -= kbSize.height ;
//  
//    if (CGRectContainsPoint(aRect, self.activeField.frame.origin)) {
//        [self.scrollView scrollRectToVisible:self.activeField.frame animated:YES];
//    }
        
    CGRect textFieldRect = [self.scrollView convertRect:((UIView *)self.activeField).bounds fromView:(UIView *)self.activeField];
    [self.scrollView scrollRectToVisible:textFieldRect animated:YES];
}

- (void)keyboardWillHidden:(NSNotification *)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
    }];

}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeField = textField;
}

#pragma mark - IBAction

- (IBAction)getCodeAgain:(id)sender
{
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(2);
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"A code has send to your phone";
        sleep(1);
    } completionBlock:^{
        
    }];
}

- (IBAction)genderPicker:(id)sender
{
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    
    hud.customView = self.genderPicker;
    hud.mode = MBProgressHUDModeCustomView;
    [hud show:YES];
}

- (IBAction)selectGender:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [self.genderBtn setTitle:btn.currentTitle forState:UIControlStateNormal];
    [hud hide:YES afterDelay:0.2];
}


- (IBAction)datePicker:(id)sender
{
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    
    hud.customView = self.datePicker;
    hud.mode = MBProgressHUDModeCustomView;
    [hud show:YES];
}

- (IBAction)selecteDate:(id)sender
{
    NSDate *selectDate = [self.datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *selectDateString = [dateFormatter stringFromDate:selectDate];
    [self.dateBtn setTitle:selectDateString forState:UIControlStateNormal];
    
    [hud hide:YES afterDelay:0.2];
}

- (IBAction)regist:(id)sender
{
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
        
    hud.labelText = @"loading..";
    
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [AppDelegate userLogIn];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
