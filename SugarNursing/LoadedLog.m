//
//  LoadedLog.m
//  SugarNursing
//
//  Created by Ian on 15-1-14.
//  Copyright (c) 2015年 Tisson. All rights reserved.
//

#import "LoadedLog.h"
#import "CoreDataStack.h"
#import "NSManagedObject+Finders.h"
#import "NSString+dateFormatting.h"
#import "VendorMacro.h"


@implementation LoadedLog

@dynamic department;
@dynamic serviceCenter;
@dynamic trusPatient;
@dynamic trusExpt;
@dynamic patient;
@dynamic userInfo;



+ (LoadedLog *)shareLoadedLog
{
    
    NSArray *objects = [LoadedLog findAllInContext:[CoreDataStack sharedCoreDataStack].context];
    
    LoadedLog *log;
    if (objects.count <= 0)
    {
        log = [LoadedLog createEntityInContext:[CoreDataStack sharedCoreDataStack].context];
    }
    else
    {
        log = objects[0];
    }
    
    return log;
}



+ (BOOL)needReloadedByKey:(NSString *)key
{
    
    NSDictionary *intervalDic = @{@"department":GC_FORMATTER_MONTH,
                                  @"serviceCenter":GC_FORMATTER_DAY,
                                  @"trusPatient":GC_FORMATTER_MINUTE,
                                  @"trusExpt":GC_FORMATTER_MINUTE,
                                  @"patient":GC_FORMATTER_HOUR,
                                  @"userInfo":GC_FORMATTER_MINUTE
                                  };
    
    NSString *interval = [intervalDic objectForKey:key];
    
    LoadedLog *log = [LoadedLog shareLoadedLog];
    
    NSString *lastDate = [NSString dateFormattingByBeforeFormat:GC_FORMATTER_SECOND
                                                       toFormat:interval
                                                         string:[log valueForKey:key]];
    if (!lastDate || lastDate.length <=0)
    {
        return YES;
    }
    
    
    NSString *now = [NSString stringWithDateFormatting:interval date:[NSDate date]];
    
    if ([now isEqualToString:lastDate])
    {
        return NO;
    }
    
    
    return YES;
}


@end



