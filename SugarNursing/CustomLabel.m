//
//  CustomLabel.m
//  SugarNursing
//
//  Created by Dan on 14-12-5.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "CustomLabel.h"

@implementation CustomLabel

- (void)customSetup
{
    NSInteger fontSize = [[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_FONTSIZE"] integerValue];
    if (fontSize<=0)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:14 forKey:@"USER_FONTSIZE"];
        fontSize = 14;
    }
    self.font = [UIFont systemFontOfSize:fontSize];
    
}

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    
    [self customSetup];
    return self;
}

- (void)awakeFromNib
{
    [self customSetup];
}

@end
