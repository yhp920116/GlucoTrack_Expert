//
//  DetectLine.h
//  SugarNursing
//
//  Created by Ian on 15-1-23.
//  Copyright (c) 2015年 Tisson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RecordLog;

@interface DetectLine : NSManagedObject

@property (nonatomic, retain) NSString * eventObject;
@property (nonatomic, retain) NSString * eventValue;
@property (nonatomic, retain) RecordLog *recordLog;

@end
