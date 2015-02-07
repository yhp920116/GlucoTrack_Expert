//
//  MBProgressHUD+Customizing.m
//  Pods
//
//  Created by Ian on 15-2-6.
//
//

#import "MBProgressHUD+Customizing.h"

@implementation MBProgressHUD (Customizing)

- (void)customizeHUD
{
    self.opacity = 1.0;
    self.color = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    self.cornerRadius = 5.0;
    self.dimBackground = YES;
    self.margin = 20;
    self.activityIndicatorColor = [UIColor darkGrayColor];
    self.labelColor = [UIColor darkGrayColor];
    self.detailsLabelColor = [UIColor darkGrayColor];
    
}

@end
