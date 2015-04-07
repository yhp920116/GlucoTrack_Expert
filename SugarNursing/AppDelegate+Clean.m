//
//  AppDelegate+Clean.m
//  SugarNursing
//
//  Created by Ian on 15-1-12.
//  Copyright (c) 2015年 Tisson. All rights reserved.
//

#import "AppDelegate+Clean.h"
#import "UtilsMacro.h"
#import "MsgRemind.h"

@implementation AppDelegate (Clean)

+ (void)cleanAllCoreData
{
    [UserInfo deleteAllEntityInContext:[CoreDataStack sharedCoreDataStack].context];
    [Patient deleteAllEntityInContext:[CoreDataStack sharedCoreDataStack].context];
    [Department deleteAllEntityInContext:[CoreDataStack sharedCoreDataStack].context];
    [ServCenter deleteAllEntityInContext:[CoreDataStack sharedCoreDataStack].context];
    [MediRecord deleteAllEntityInContext:[CoreDataStack sharedCoreDataStack].context];
    [Advice deleteAllEntityInContext:[CoreDataStack sharedCoreDataStack].context];
    [TrusExpt deleteAllEntityInContext:[CoreDataStack sharedCoreDataStack].context];
    [TrusPatient deleteAllEntityInContext:[CoreDataStack sharedCoreDataStack].context];
    [Trusteeship deleteAllEntityInContext:[CoreDataStack sharedCoreDataStack].context];
    [TemporaryInfo deleteAllEntityInContext:[CoreDataStack sharedCoreDataStack].context];
    [RecordLog deleteAllEntityInContext:[CoreDataStack sharedCoreDataStack].context];
    [Notice deleteAllEntityInContext:[CoreDataStack sharedCoreDataStack].context];
    [MsgRemind deleteAllEntityInContext:[CoreDataStack sharedCoreDataStack].context];
}

@end
