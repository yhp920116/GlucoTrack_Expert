//
//  SystemSetTableViewController.m
//  SugarNursing
//
//  Created by Ian on 14-12-12.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "SystemSetTableViewController.h"
#import "VerificationViewController.h"
#import "UIStoryboard+Storyboards.h"

@interface SystemSetTableViewController ()<UIActionSheetDelegate>

@property (retain, nonatomic) UIActionSheet *sheet;

@end

@implementation SystemSetTableViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            [self showActionShip];
            break;
        case 1:
            [self goVerificationViewWithTitle:@"重设密码"];
            break;
        default:
            [self performSegueWithIdentifier:@"goBindPhone" sender:nil];
            break;
    }
}

- (void)showActionShip
{
    self.sheet = [[UIActionSheet alloc] initWithTitle:@"请选择单位"
                                             delegate:self
                                    cancelButtonTitle:nil
                               destructiveButtonTitle:@"取消"
                                    otherButtonTitles:@"单位1",@"单位2",@"单位3",nil];
    [self.sheet showInView:self.view];
}

- (void)goVerificationViewWithTitle:(NSString *)vcTitle
{
    VerificationViewController *verfication = [[UIStoryboard loginStoryboard] instantiateViewControllerWithIdentifier:@"Verification"];
    
    verfication.title = vcTitle;
    verfication.labelText = @"Input your PhoneNumber to regist";
    
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)]) {
        // conditionly check for any version >= iOS 8
        [self showViewController:verfication sender:nil];
        
    } else
    {
        // iOS 7 or below
        [self.navigationController pushViewController:verfication animated:YES];
    }
    
}

- (IBAction)back:(UIStoryboardSegue *)unwindSender
{
    
}
@end
