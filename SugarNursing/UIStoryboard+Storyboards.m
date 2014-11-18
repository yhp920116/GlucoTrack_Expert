//
//  UIStoryboard+Storyboards.m
//  SugarNursing
//
//  Created by Dan on 14-11-5.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "UIStoryboard+Storyboards.h"

@implementation UIStoryboard (Storyboards)

+ (UIStoryboard *)mainStoryboard
{
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

+ (UIStoryboard *)memberCenterStoryboard
{
    return [UIStoryboard storyboardWithName:@"MemberCenter" bundle:nil];
}

+ (UIStoryboard *)loginStoryboard
{
    return [UIStoryboard storyboardWithName:@"Login" bundle:nil];
}

+ (UIStoryboard *)testTracker
{
    return [UIStoryboard storyboardWithName:@"TestTracker" bundle:nil];
}

+ (UIStoryboard *)serviceCenterStoryboard
{
    return [UIStoryboard storyboardWithName:@"ServiceCenter" bundle:nil];
}

@end
