//
//  Advice.h
//  SugarNursing
//
//  Created by Ian on 15-1-10.
//  Copyright (c) 2015年 Tisson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Advice : NSManagedObject

@property (nonatomic, retain) NSString * adviceId;
@property (nonatomic, retain) NSString * adviceTime;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * exptId;
@property (nonatomic, retain) NSString * linkManId;

+ (void)updateCoreDataWithListArray:(NSArray *)array identifierKey:(NSString *)identifierKey;

@end
