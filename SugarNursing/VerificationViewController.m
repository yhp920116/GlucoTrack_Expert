//
//  VerificationViewController.m
//  SugarNursing
//
//  Created by Dan on 14-11-14.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "VerificationViewController.h"


@interface VerificationViewController ()

@end

@implementation VerificationViewController


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topLabel.text = self.labelText;
    if ([self.title isEqualToString:@"Regist by phone"])
    {
        [self.registBtn setHidden:NO];
        [self.resetPwdBtn setHidden:YES];
    }
    else
    {
        [self.registBtn setHidden:YES];
        [self.resetPwdBtn setHidden:NO];
    }
    // Do any additional setup after loading the view.
}


- (IBAction)requestForVerification:(id)sender
{
    NSLog(@"requestForVerification...");
}

- (IBAction)back:(UIStoryboardSegue *)segue
{
    
}

@end
