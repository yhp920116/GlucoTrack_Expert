//
//  BindPhoneViewController.m
//  SugarNursing
//
//  Created by Ian on 14-12-18.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "BindPhoneViewController.h"
#import "UIViewController+Notifications.h"

@interface BindPhoneViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *phoneButtonView;
@property (weak, nonatomic) IBOutlet UIImageView *passwordButtonView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleYCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topYCons;

@end

@implementation BindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self registerForKeyboardNotification:@selector(keyBoardWillShow:) :@selector(keyBoardWillHide:)];
}

- (void)keyBoardWillShow:(NSNotification *)notification
{
    
    CGSize kbSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGFloat kbHeight = kbSize.height;
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    if (screenHeight - kbHeight >= 120)
    {
        return;
    }
    else
    {
        self.topYCons.constant = 30;
        [self.view setNeedsUpdateConstraints];
        
        [UIView animateWithDuration:0.4 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)keyBoardWillHide:(NSNotification *)notaification
{
    
    self.topYCons.constant = 80;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
    }];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 101:
            [self.phoneButtonView setImage:[UIImage imageNamed:@"003"]];
            break;
        case 102:
            [self.passwordButtonView setImage:[UIImage imageNamed:@"003"]];
            break;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 101:
            [self.phoneButtonView setImage:[UIImage imageNamed:@"004"]];
            break;
        case 102:
            [self.passwordButtonView setImage:[UIImage imageNamed:@"004"]];
            break;
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if ([string isEqualToString:@"\n"])
    {
        
        if (textField.tag == 101)
        {
            
            UITextField *tv = (UITextField *)[self.view viewWithTag:102];
            [tv becomeFirstResponder];
        }
        else
        {
            [textField resignFirstResponder];
        }
        
        return NO;
    }
    
    return YES;
}



- (IBAction)verificationButtonEvent:(id)sender
{
    [self performSegueWithIdentifier:@"goInputPhone" sender:nil];
    
}

- (IBAction)back:(UIStoryboardSegue *)sender
{
    
}

@end
