//
//  NSString+UserCommon.m
//  SugarNursing
//
//  Created by Dan on 14-12-27.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "NSString+UserCommon.h"
#import "UtilsMacro.h"

@implementation NSString (UserCommon)

+ (User *)fetchUser
{
    NSArray *userObjects = [User findAllInContext:[CoreDataStack sharedCoreDataStack].context];
    if ([userObjects count] == 0) {
        DDLogDebug(@"No User Exists");
        return nil;
    }
    User *user = userObjects[0];
    return user;

}

+ (NSString *)exptId
{
    User *user = [self fetchUser];
    if (!user) {
        return nil;
    }
    return user.exptid;
}

+ (NSString *)sessionID
{
    User *user = [self fetchUser];
    if (!user) {
        return nil;
    }
    return user.sessionid;
}

+ (NSString *)sessionToken
{
    User *user = [self fetchUser];
    if (!user) {
        return nil;
    }
    return user.sessiontoken;
}

@end
