//
//  UserActionLog.h
//  SugarNursing
//
//  Created by Ian on 15-1-5.
//  Copyright (c) 2015年 Tisson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserActionLog : NSObject

@property (nonatomic, assign) BOOL isRefresh_patientList;




- (void)resetAllState;

@end
