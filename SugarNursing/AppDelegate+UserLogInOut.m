//
//  AppDelegate+UserLogInOut.m
//  SugarNursing
//
//  Created by Dan on 14-11-6.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "AppDelegate+UserLogInOut.h"
#import "UIStoryboard+Storyboards.h"

@implementation AppDelegate (UserLogInOut)

+ (void)userLogIn
{
    [UIApplication sharedApplication].keyWindow.rootViewController = [[UIStoryboard mainStoryboard] instantiateInitialViewController];
    
}

+ (void)userLogOut
{
    [UIApplication sharedApplication].keyWindow.rootViewController = [[UIStoryboard loginStoryboard] instantiateInitialViewController];
}

@end
