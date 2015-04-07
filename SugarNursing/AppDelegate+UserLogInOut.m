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
#import "UMessage.h"

@implementation AppDelegate (UserLogInOut)

+ (void)userLogIn
{
    User*user = [User findAllInContext:[CoreDataStack sharedCoreDataStack].context][0];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:user.username forKey:@"LastUsername"];
    
    
    [UMessage addAlias:user.exptId type:@"expertId" response:nil];
    NSLog(@"ExpertId = %@",user.exptId);
    
    [UIApplication sharedApplication].keyWindow.rootViewController = [[UIStoryboard mainStoryboard]
                                                                      instantiateInitialViewController];
}

+ (void)userLogOut
{
    //删除绑定在该设备的别名
    NSArray *objects = [User findAllInContext:[CoreDataStack sharedCoreDataStack].context];
    if (objects && objects.count>0)
    {
        
        User*user = [User findAllInContext:[CoreDataStack sharedCoreDataStack].context][0];
        [UMessage removeAlias:user.exptId type:@"expertId" response:nil];
        
        [User deleteAllEntityInContext:[CoreDataStack sharedCoreDataStack].context];
        [LoadedLog deleteAllEntityInContext:[CoreDataStack sharedCoreDataStack].context];
        
        [[CoreDataStack sharedCoreDataStack] saveContext];
        
        [UIApplication sharedApplication].keyWindow.rootViewController = [[UIStoryboard loginStoryboard] instantiateInitialViewController];
    }
}


+ (BOOL)isLogin
{
    NSArray *userObjects = [User findAllInContext:[CoreDataStack sharedCoreDataStack].context];
    if (userObjects.count<=0)
    {
        return NO;
    }
    else
    {
        User *user = userObjects[0];
        if (user.sessionId && user.sessionId.length>0 && user.sessionToken && user.sessionToken.length >0)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
}

@end
