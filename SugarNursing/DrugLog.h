//
//  DrugLog.h
//  SugarNursing
//
//  Created by Ian on 15-1-23.
//  Copyright (c) 2015年 Tisson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Drug, RecordLog;

@interface DrugLog : NSManagedObject

@property (nonatomic, retain) NSString * medicineId;
@property (nonatomic, retain) NSString * medicinePeriod;
@property (nonatomic, retain) NSString * medicineTime;
@property (nonatomic, retain) NSString * updateTime;
@property (nonatomic, retain) NSOrderedSet *drug;
@property (nonatomic, retain) RecordLog *recordLog;
@end

@interface DrugLog (CoreDataGeneratedAccessors)

- (void)insertObject:(Drug *)value inDrugAtIndex:(NSUInteger)idx;
- (void)removeObjectFromDrugAtIndex:(NSUInteger)idx;
- (void)insertDrug:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeDrugAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInDrugAtIndex:(NSUInteger)idx withObject:(Drug *)value;
- (void)replaceDrugAtIndexes:(NSIndexSet *)indexes withDrug:(NSArray *)values;
- (void)addDrugObject:(Drug *)value;
- (void)removeDrugObject:(Drug *)value;
- (void)addDrug:(NSOrderedSet *)values;
- (void)removeDrug:(NSOrderedSet *)values;
@end
