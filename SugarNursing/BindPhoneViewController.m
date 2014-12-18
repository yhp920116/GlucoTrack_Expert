//
//  BindPhoneViewController.m
//  SugarNursing
//
//  Created by Ian on 14-12-18.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "BindPhoneViewController.h"

@interface BindPhoneViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *phoneButtonView;
@property (weak, nonatomic) IBOutlet UIImageView *passwordButtonView;

@end

@implementation BindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            [self.phoneButtonView setImage:[UIImage imageNamed:@"007"]];
            break;
        case 102:
            [self.passwordButtonView setImage:[UIImage imageNamed:@"007"]];
            break;
    }
}
- (IBAction)verificationButtonEvent:(id)sender
{
    [self performSegueWithIdentifier:@"goInputPhone" sender:nil];
    
}

- (IBAction)back:(UIStoryboardSegue *)sender
{
    
}

@end
