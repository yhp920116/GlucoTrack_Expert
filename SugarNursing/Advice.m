//
//  Advice.m
//  SugarNursing
//
//  Created by Ian on 15-1-10.
//  Copyright (c) 2015年 Tisson. All rights reserved.
//

#import "Advice.h"
#import "CoreDataStack.h"
#import "NSManagedObject+Savers.h"
#import "NSManagedObject+Finders.h"
#import "NSDictionary+Formatting.h"

@implementation Advice

@dynamic adviceId;
@dynamic adviceTime;
@dynamic content;
@dynamic exptId;
@dynamic linkManId;


+ (void)updateCoreDataWithListArray:(NSArray *)array identifierKey:(NSString *)identifierKey
{
    if (!array || array.count <=0)
    {
        return;
    }
    
    if (!identifierKey)
    {
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            NSDictionary *dic = [obj mutableCopy];
            
            [dic minuteFormattingToServerForKey:@"adviceTime"];
            
            
            NSManagedObject *managedObj = [self createEntityInContext:[CoreDataStack sharedCoreDataStack].context];
            [managedObj updateCoreDataForData:dic withKeyPath:nil];
        }];
        
        
    }
    else
    {
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            NSDictionary *dic = [obj mutableCopy];
            
            [dic minuteFormattingToServerForKey:@"adviceTime"];
            
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
