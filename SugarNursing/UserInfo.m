//
//  UserInfo.m
//  SugarNursing
//
//  Created by Ian on 15-1-29.
//  Copyright (c) 2015年 Tisson. All rights reserved.
//

#import "UserInfo.h"
#import "CoreDataStack.h"
#import "NSManagedObject+Finders.h"
#import "NSManagedObject+Savers.h"

@implementation UserInfo

@dynamic areaId;
@dynamic birthday;
@dynamic centerId;
@dynamic departmentId;
@dynamic email;
@dynamic engName;
@dynamic expertLevel;
@dynamic exptId;
@dynamic exptName;
@dynamic headimageUrl;
@dynamic hospital;
@dynamic identifyCard;
@dynamic intro;
@dynamic mobilePhone;
@dynamic registerTime;
@dynamic sex;
@dynamic skilled;
@dynamic stat;
@dynamic updateTime;
@dynamic mobileZone;


+ (UserInfo *)shareInfo
{
    
    NSArray *array = [UserInfo findAllInContext:[CoreDataStack sharedCoreDataStack].context];
    
    if (array.count <= 0)
    {
        
        UserInfo *info = [UserInfo createEntityInContext:[CoreDataStack sharedCoreDataStack].context];
        return info;
    }
    else
    {
        return array[0];
    }
    
    return nil;
}



@end
