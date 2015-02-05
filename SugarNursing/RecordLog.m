//
//  RecordLog.m
//  GlucoTrack
//
//  Created by Ian on 15-2-5.
//  Copyright (c) 2015年 Tisson. All rights reserved.
//

#import "RecordLog.h"
#import "DetectLine.h"
#import "DetectLog.h"
#import "DietLog.h"
#import "DrugLog.h"
#import "ExerciseLog.h"
#import "PatientInfo.h"
#import <objc/runtime.h>
#import "ParseData.h"



@implementation RecordLog

@dynamic id;
@dynamic linkManId;
@dynamic logType;
@dynamic time;
@dynamic detectLine;
@dynamic detectLog;
@dynamic dietLog;
@dynamic drugLog;
@dynamic exerciseLog;
@dynamic patientInfo;


- (void)updateCoreDataForData:(NSDictionary *)data withKeyPath:(NSString *)keyPath
{
    
    // Data is responseObject from server
    // Stay NSManagedObject's property the same with responseObject's key
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if (propName)
        {
            NSString *propertyName = [NSString stringWithUTF8String:propName];
            
            if ([propertyName isEqualToString:@"time"])
            {
                NSString *dateString = [ParseData parseDictionary:data ForKeyPath:propertyName];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyyMMddHHmmss"];
                [self setValue:[formatter dateFromString:dateString] forKey:propertyName];
            }
            else
            {
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
    
}

@end
