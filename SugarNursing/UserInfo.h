//
//  UserInfo.h
//  SugarNursing
//
//  Created by Dan on 14-12-11.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

+ (instancetype)shareInstance;

@property(nonatomic) NSInteger userFontSize;

@end
