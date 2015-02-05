//
//  RecordLog.h
//  GlucoTrack
//
//  Created by Ian on 15-2-5.
//  Copyright (c) 2015年 Tisson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DetectLine, DetectLog, DietLog, DrugLog, ExerciseLog, PatientInfo;

@interface RecordLog : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * linkManId;
@property (nonatomic, retain) NSString * logType;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSOrderedSet *detectLine;
@property (nonatomic, retain) DetectLog *detectLog;
@property (nonatomic, retain) DietLog *dietLog;
@property (nonatomic, retain) DrugLog *drugLog;
@property (nonatomic, retain) ExerciseLog *exerciseLog;
@property (nonatomic, retain) PatientInfo *patientInfo;

- (void)updateCoreDataForData:(NSDictionary *)data withKeyPath:(NSString *)keyPath;

@end

@interface RecordLog (CoreDataGeneratedAccessors)

- (void)insertObject:(DetectLine *)value inDetectLineAtIndex:(NSUInteger)idx;
- (void)removeObjectFromDetectLineAtIndex:(NSUInteger)idx;
- (void)insertDetectLine:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeDetectLineAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInDetectLineAtIndex:(NSUInteger)idx withObject:(DetectLine *)value;
- (void)replaceDetectLineAtIndexes:(NSIndexSet *)indexes withDetectLine:(NSArray *)values;
- (void)addDetectLineObject:(DetectLine *)value;
- (void)removeDetectLineObject:(DetectLine *)value;
- (void)addDetectLine:(NSOrderedSet *)values;
- (void)removeDetectLine:(NSOrderedSet *)values;
@end
