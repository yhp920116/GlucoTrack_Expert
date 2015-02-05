//
//  PatientInfo.h
//  SugarNursing
//
//  Created by Ian on 15-1-26.
//  Copyright (c) 2015年 Tisson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RecordLog;

@interface PatientInfo : NSManagedObject

@property (nonatomic, retain) NSString * realName;
@property (nonatomic, retain) NSString * pickFood;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSString * mobileZone;
@property (nonatomic, retain) NSString * mobilePhone;
@property (nonatomic, retain) NSString * linkManId;
@property (nonatomic, retain) NSString * identifyCard;
@property (nonatomic, retain) NSString * height;
@property (nonatomic, retain) NSString * headImageUrl;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * centerId;
@property (nonatomic, retain) NSString * birthday;
@property (nonatomic, retain) NSString * allergFood;
@property (nonatomic, retain) NSString * allergDrug;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * weight;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * updateTime;
@property (nonatomic, retain) NSString * updateStaff;
@property (nonatomic, retain) NSString * telePhone;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSString * servLevel;
@property (nonatomic, retain) NSOrderedSet *recordLog;
@end

@interface PatientInfo (CoreDataGeneratedAccessors)

- (void)insertObject:(RecordLog *)value inRecordLogAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRecordLogAtIndex:(NSUInteger)idx;
- (void)insertRecordLog:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeRecordLogAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRecordLogAtIndex:(NSUInteger)idx withObject:(RecordLog *)value;
- (void)replaceRecordLogAtIndexes:(NSIndexSet *)indexes withRecordLog:(NSArray *)values;
- (void)addRecordLogObject:(RecordLog *)value;
- (void)removeRecordLogObject:(RecordLog *)value;
- (void)addRecordLog:(NSOrderedSet *)values;
- (void)removeRecordLog:(NSOrderedSet *)values;
@end
