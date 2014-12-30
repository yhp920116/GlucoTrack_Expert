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

@implementation NSManagedObject (Savers)

+ (NSString *)entityName
{
    NSString *entityName;
    if ([entityName length] == 0) {
        entityName = NSStringFromClass(self);
    }
    return entityName;
}

- (void)updateCoreDataForData:(NSDictionary *)data withKeyPath:(NSString *)keyPath
{
    
    // Keep in mind the all keys in data is lowercased!!
    
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
            NSString *propertyValue = [NSString parseDictionary:data forKeyPath:aKeyPath];
            
            [self setValue:propertyValue forKey:propertyName];
        }
    }
}

@end
