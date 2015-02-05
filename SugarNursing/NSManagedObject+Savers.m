//
//  NSManagedObject+Savers.m
//  SugarNursing
//
//  Created by Dan on 14-12-29.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "NSManagedObject+Savers.h"
#import "UtilsMacro.h"
#import <objc/runtime.h>
#import "NSString+ParseData.h"
#import "NSDictionary+Formatting.h"
#import "ParseData.h"

@implementation NSManagedObject (Savers)



+ (NSString *)entityName
{
    NSString *entityName;
    if ([entityName length] == 0) {
        entityName = NSStringFromClass(self);
    }
    return entityName;
}


+ (void)updateCoreDataWithListArray:(NSArray *)array identifierKey:(NSString *)identifierKey
{
    if (!identifierKey)
    {
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            NSDictionary *dic = (NSDictionary *)obj;
            
            NSManagedObject *managedObj = [self createEntityInContext:[CoreDataStack sharedCoreDataStack].context];
            [managedObj updateCoreDataForData:dic withKeyPath:nil];
        }];
        
        
    }
    else
    {
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            NSDictionary *dic = (NSDictionary *)obj;
            
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

+ (void)coverCoreDataWithArray:(NSArray *)array
{
    
    [self deleteAllEntityInContext:[CoreDataStack sharedCoreDataStack].context];
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSDictionary *dic = (NSDictionary *)obj;
        
        NSManagedObject *managedObj = [self createEntityInContext:[CoreDataStack sharedCoreDataStack].context];
        [managedObj updateCoreDataForData:dic withKeyPath:nil];
        
    }];
}


- (void)updateCoreDataForData:(NSDictionary *)data withKeyPath:(NSString *)keyPath
{
    
    // Data is responseObject from server
    // Stay NSManagedObject's property the same with responseObject's key
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if (propName) {
            NSString *propertyName = [NSString stringWithUTF8String:propName];
            
            NSString *aKeyPath;
            if (keyPath) {
                aKeyPath = [NSString stringWithFormat:@"%@.%@",keyPath,propertyName];
            }else{
                aKeyPath = propertyName;
            }
            //            NSString *propertyValue = [NSString parseDictionary:data ForKeyPath:aKeyPath];
            id propertyValue = [ParseData parseDictionary:data ForKeyPath:aKeyPath];
            
            
            // Only when data return a un-nil value does it invoke setValue:key:
            if (propertyValue && ([propertyValue isKindOfClass:[NSString class]] || [propertyValue isKindOfClass:[NSNumber class]])) {
                propertyValue = [NSString stringWithFormat:@"%@",propertyValue];
                //                NSLog(@"value = %@, key = %@",propertyValue,propertyName);
                [self setValue:propertyValue forKey:propertyName];
            }
        }
        
    }
    
    
}

@end
