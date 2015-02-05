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



@end

@implementation SystemSetTableViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            [self goVerificationViewWithTitle:NSLocalizedString(@"Reset password", nil)];
            break;
        case 1:
            [self performSegueWithIdentifier:@"goBindPhone" sender:nil];
            break;
        default:
            break;
    }
}





- (void)goVerificationViewWithTitle:(NSString *)vcTitle
{
    VerificationViewController *verfication = [[UIStoryboard loginStoryboard] instantiateViewControllerWithIdentifier:@"Verification"];
    
    verfication.title = NSLocalizedString(@"Reset password", nil);
    verfication.verifiedType = VerifiedTypeReset;
    
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)]) {
        // conditionly check for any version >= iOS 8
        [self showViewController:verfication sender:nil];
        
    } else
    {
        // iOS 7 or below
        [self.navigationController pushViewController:verfication animated:YES];
    }
    
}

- (IBAction)back:(UIStoryboardSegue *)sender
{
    
}

@end
