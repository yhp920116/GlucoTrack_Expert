//
//  MsgInfo_Cell.m
//  SugarNursing
//
//  Created by Ian on 14-12-24.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "MsgInfo_Cell.h"

@implementation MsgInfo_Cell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.contentLabel.bounds);
}


- (void)configureCellWithParameter:(NSDictionary *)dic
{
    self.dateLabel.text = dic[@"date"];
    self.contentLabel.text = dic[@"content"];
}

@end
