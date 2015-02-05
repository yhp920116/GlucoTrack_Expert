//
//  AppDelegate+UserLogInOut.m
//  SugarNursing
//
//  Created by Dan on 14-11-6.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "AppDelegate+UserLogInOut.h"
#import "UIStoryboard+Storyboards.h"
#import "UtilsMacro.h"

@implementation AppDelegate (UserLogInOut)

+ (void)userLogIn
{
    User*user = [User findAllInContext:[CoreDataStack sharedCoreDataStack].context][0];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:user.username forKey:@"LastUsername"];
    
    
    [UIApplication sharedApplication].keyWindow.rootViewController = [[UIStoryboard mainStoryboard] instantiateInitialViewController];
}

+ (void)userLogOut
{
    [User deleteAllEntityInContext:[CoreDataStack sharedCoreDataStack].context];
    [LoadedLog deleteAllEntityInContext:[CoreDataStack sharedCoreDataStack].context];
    
    [[CoreDataStack sharedCoreDataStack] saveContext];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = [[UIStoryboard loginStoryboard] instantiateInitialViewController];
}

@end
