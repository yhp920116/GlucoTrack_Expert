//
//  InputPhoneViewController.m
//  SugarNursing
//
//  Created by Ian on 14-12-18.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "InputPhoneViewController.h"

@interface InputPhoneViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *phoneButtonView;

@end

@implementation InputPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
            [self.phoneButtonView setImage:[UIImage imageNamed:@"003"]];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
            [self.phoneButtonView setImage:[UIImage imageNamed:@"007"]];
}


- (IBAction)getNumberButtonEvent:(id)sender
{
    [self performSegueWithIdentifier:@"inputVerificationNum" sender:nil];
}

- (IBAction)back:(UIStoryboardSegue *)sender
{
    
}


@end
