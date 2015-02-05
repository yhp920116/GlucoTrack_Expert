//
//  ExerciseLog.h
//  SugarNursing
//
//  Created by Ian on 15-1-23.
//  Copyright (c) 2015年 Tisson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RecordLog;

@interface ExerciseLog : NSManagedObject

@property (nonatomic, retain) NSString * calorie;
@property (nonatomic, retain) NSString * duration;
@property (nonatomic, retain) NSString * sportId;
@property (nonatomic, retain) NSString * sportName;
@property (nonatomic, retain) NSString * sportPeriod;
@property (nonatomic, retain) NSString * sportTime;
@property (nonatomic, retain) NSString * updateTime;
@property (nonatomic, retain) RecordLog *recordLog;

@end
