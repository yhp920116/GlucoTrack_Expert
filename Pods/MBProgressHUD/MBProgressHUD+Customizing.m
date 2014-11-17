//
//  MBProgressHUD+Customizing.m
//  Pods
//
//  Created by Dan on 14-11-17.
//
//

#import "MBProgressHUD+Customizing.h"

@implementation MBProgressHUD (Customizing)

- (void)customizeHUD
{
    self.opacity = 0.8;
    self.color = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8];
    self.cornerRadius = 10.0;
    self.dimBackground = YES;
    self.margin = 20;
    self.activityIndicatorColor = [UIColor darkGrayColor];
    self.labelColor = [UIColor darkGrayColor];
    self.detailsLabelColor = [UIColor darkGrayColor];
    
}

@end
