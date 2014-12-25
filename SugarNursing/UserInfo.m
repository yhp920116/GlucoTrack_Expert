//
//  UserInfo.m
//  SugarNursing
//
//  Created by Dan on 14-12-11.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "UserInfo.h"

#define USER_FAVORITE_FONTSIZE @"USER_FAVORITE_FONTSIZE"

static UserInfo *userInfo = nil;


@implementation UserInfo

+ (instancetype)shareInstance
{
    if (userInfo == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            userInfo = [[UserInfo alloc] init];
            [userInfo commontInit];
        });
    }
    return userInfo;
}

- (void)commontInit
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:16 forKey:USER_FAVORITE_FONTSIZE];
    [userDefaults synchronize];
}



@end
