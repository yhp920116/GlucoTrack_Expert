//
//  LeftMenuCell.m
//  SugarNursing
//
//  Created by Dan on 14-11-5.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "LeftMenuCell.h"
#import "MsgRemind.h"
#import "CoreDataStack.h"

@implementation LeftMenuCell

- (void)configureCellWithIconName:(NSString *)iconName LabelText:(NSString *)labelText
{
    self.LeftMenuIcon.image = [UIImage imageNamed:iconName];
    self.LeftMenuLabel.text = labelText;
    
    
    [self showMsgPointWithLabelText:labelText];
}


- (void)showMsgPointWithLabelText:(NSString *)labelText
{
    
    MsgRemind *remind = [MsgRemind shareMsgRemind];
    
    if ([labelText isEqualToString:NSLocalizedString(@"My Hosting", nil)])
    {
        if ([remind.hostingConfirmRemindCount integerValue]>0 || [remind.hostingRefuseRemindCount integerValue]>0)
        {
            self.leftMenuMsgPoint.hidden = NO;
        }
        else
        {
            self.leftMenuMsgPoint.hidden = YES;
        }
    }
    else if ([labelText isEqualToString:NSLocalizedString(@"My Takeover", nil)])
    {
        self.leftMenuMsgPoint.hidden = [remind.takeoverWaittingRemindCount integerValue]>0 ? NO : YES;
    }
    else if ([labelText isEqualToString:NSLocalizedString(@"My Message", nil)])
    {
        BOOL showMsgPoint = ([remind.messageApproveRemindCount integerValue]>0 ||
                             [remind.messageAgentRemindCount integerValue]>0   ||
                             [remind.messageBulletinRemindCount integerValue]>0);
        if (showMsgPoint)
        {
            self.leftMenuMsgPoint.hidden = NO;
        }
        else
        {
            self.leftMenuMsgPoint.hidden = YES;
        }
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
