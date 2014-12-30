//
//  NSObject_refreshPublic.h
//  E企飞
//
//  Created by Ian on 14-4-10.
//  Copyright (c) 2014年 Ian. All rights reserved.
//

#import <Foundation/Foundation.h>



#define TEXT_COLOR   [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f

#define  REFRESH_REGION_HEIGHT 65.0f




typedef enum{
    EGOOPullRefreshPulling = 0,
    EGOOPullRefreshNormal,
    EGOOPullRefreshLoading,
    EGOOPullRefreshNoMore,
} EGOPullRefreshState;

typedef enum{
    EGORefreshHeader = 0,
    EGORefreshFooter
} EGORefreshPos;

@protocol EGORefreshTableDelegate
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos;
- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view;
@optional
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view;
@end

