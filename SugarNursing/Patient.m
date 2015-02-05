//
//  Patient.m
//  SugarNursing
//
//  Created by Ian on 15-1-26.
//  Copyright (c) 2015年 Tisson. All rights reserved.
//

#import "Patient.h"
#import "CoreDataStack.h"
#import "NSManagedObject+Finders.h"
#import "NSManagedObject+Savers.h"
#import "NSDictionary+Formatting.h"

@implementation Patient

@dynamic birthday;
@dynamic headImageUrl;
@dynamic linkManId;
@dynamic mobilePhone;
@dynamic notTubeExptId;
@dynamic notTubeExptName;
@dynamic patientStat;
@dynamic servBeginTime;
@dynamic servLevel;
@dynamic servRelation;
@dynamic servStartTime;
@dynamic sex;
@dynamic trusteeFlag;
@dynamic userName;

+ (BOOL)patientExistWithLinkManId:(NSString *)linkManId
{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"linkManId = %@",linkManId];
    NSArray *objects = [Patient findAllWithPredicate:predicate inContext:[CoreDataStack sharedCoreDataStack].context];
    if (objects.count <= 0)
    {
        return NO;
    }
    
    return YES;
}


+ (void)updateCoreDataWithListArray:(NSArray *)array identifierKey:(NSString *)identifierKey
{
    if (!identifierKey)
    {
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            NSMutableDictionary *dic = [(NSDictionary *)obj mutableCopy];
            [dic patientStateFormattingToUserForKey:@"patientStat"];
            [dic dateFormattingByFormat:@"yyyyMMdd" toFormat:@"yyyy-MM-dd" key:@"servStartTime"];
            [dic sexFormattingToUserForKey:@"sex"];
            
            
            NSManagedObject *managedObj = [self createEntityInContext:[CoreDataStack sharedCoreDataStack].context];
            [managedObj updateCoreDataForData:dic withKeyPath:nil];
        }];
        
        
    }
    else
    {
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            NSMutableDictionary *dic = [(NSDictionary *)obj mutableCopy];
            [dic patientStateFormattingToUserForKey:@"patientStat"];
            [dic dateFormattingByFormat:@"yyyyMMdd" toFormat:@"yyyy-MM-dd" key:@"servStartTime"];
            [dic sexFormattingToUserForKey:@"sex"];
            
            NSString *identifier = dic[identifierKey];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@",identifierKey,identifier];
            NSArray *results = [self findAllWithPredicate:predicate inContext:[CoreDataStack sharedCoreDataStack].context];
            
            if (results.count<=0)
            {
                
                NSManagedObject *managedObj = [self createEntityInContext:[CoreDataStack sharedCoreDataStack].context];
                [managedObj updateCoreDataForData:dic withKeyPath:nil];
            }
            else
            {
                
                NSManagedObject *result = results[0];
                [result updateCoreDataForData:dic withKeyPath:nil];
            }
        }];
    }
}



@end
