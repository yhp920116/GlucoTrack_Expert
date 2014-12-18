//
//  MsgRecord_Cell.h
//  糖博士
//
//  Created by Ian on 14-11-11.
//  Copyright (c) 2014年 Ian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsgRecord_Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@property (weak, nonatomic) IBOutlet UILabel *contentLabel;



- (void)bindCellWithParameter:(NSDictionary*)parameter;



@end
