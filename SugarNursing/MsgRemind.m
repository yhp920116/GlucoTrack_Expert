//
//  MsgRemind.m
//  SugarNursing
//
//  Created by Ian on 15-3-17.
//  Copyright (c) 2015年 Tisson. All rights reserved.
//

#import "MsgRemind.h"
#import "NSManagedObject+Finders.h"
#import "CoreDataStack.h"
#import "NSManagedObject+Savers.h"
#import "NotificationName.h"



@implementation MsgRemind

@dynamic hostingConfirmRemindCount;
@dynamic hostingRefuseRemindCount;
@dynamic messageAgentRemindCount;
@dynamic messageApproveRemindCount;
@dynamic messageBulletinRemindCount;
@dynamic takeoverWaittingRemindCount;


+ (MsgRemind *)shareMsgRemind
{
    
    NSArray *array = [MsgRemind findAllInContext:[CoreDataStack sharedCoreDataStack].context];
    
    if (!array || array.count <= 0)
    {
        MsgRemind *remind = [MsgRemind createEntityInContext:[CoreDataStack sharedCoreDataStack].context];
        remind.messageAgentRemindCount = [NSNumber numberWithInteger:0];
        remind.messageApproveRemindCount = [NSNumber numberWithInteger:0];
        remind.messageBulletinRemindCount = [NSNumber numberWithInteger:0];
        remind.hostingConfirmRemindCount = [NSNumber numberWithInteger:0];
        remind.hostingRefuseRemindCount = [NSNumber numberWithInteger:0];
        remind.takeoverWaittingRemindCount = [NSNumber numberWithInteger:0];
        [[CoreDataStack sharedCoreDataStack] saveContext];
        return remind;
    }
    else
    {
        return array[0];
    }
}


+ (void)updateSectionBadgeWithParameter:(NSDictionary *)parameter
{
    
    if (!parameter || parameter.count<=0)
    {
        return;
    }
    
    NSArray *countList = parameter[@"countList"];
    
    MsgRemind *remind = [MsgRemind shareMsgRemind];
    
    for (NSDictionary *content in countList)
    {
        
        NSString *type = content[@"messageType"];
        NSInteger badge = [content[@"newNum"] integerValue];
        
        
        if ([type isEqualToString:@"personalAppr"])
        {
            remind.messageApproveRemindCount = [NSNumber numberWithInteger:[remind.messageApproveRemindCount integerValue] + badge];        }
        else if ([type isEqualToString:@"bulletin"])
        {
            remind.messageBulletinRemindCount = [NSNumber numberWithInteger:[remind.messageBulletinRemindCount integerValue] + badge];
        }
        else if ([type isEqualToString:@"agentMsg"])
        {
            remind.messageAgentRemindCount = [NSNumber numberWithInteger:[remind.messageAgentRemindCount integerValue] + badge];
        }
        else if ([type isEqualToString:@"trusPass"])
        {
            remind.hostingConfirmRemindCount = [NSNumber numberWithInteger:[remind.hostingConfirmRemindCount integerValue] + badge];
        }
        else if ([type isEqualToString:@"trusObjection"])
        {
            remind.hostingRefuseRemindCount = [NSNumber numberWithInteger:[remind.hostingRefuseRemindCount integerValue] + badge];
        }
        else if ([type isEqualToString:@"trusWait"])
        {
            remind.takeoverWaittingRemindCount = [NSNumber numberWithInteger:[remind.takeoverWaittingRemindCount integerValue] + badge];
        }
    }
    
    if ([remind.messageAgentRemindCount integerValue]>0 ||
        [remind.messageApproveRemindCount integerValue]>0 ||
        [remind.messageBulletinRemindCount integerValue]>0)
    {
        [self sendNotificationToReloadMyMessageTableView:remind];
    }
    
    [[CoreDataStack sharedCoreDataStack] saveContext];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOT_RELOADLEFTMENU object:nil];
    
}

+ (void)sendNotificationToReloadMyMessageTableView:(MsgRemind *)remind
{
    if (remind.messageAgentRemindCount>0 || remind.messageApproveRemindCount>0 || remind.messageBulletinRemindCount>0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOT_RELOADMSGMENU object:nil];
    }
}


+ (NSDictionary *)analysisRespondData:(NSDictionary *)respondData
{
    NSString *jsonString = respondData[@"content"];
    if (jsonString && [jsonString isKindOfClass:[NSString class]])
    {
        NSData *contentData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *content = [NSJSONSerialization JSONObjectWithData:contentData options:NSJSONReadingMutableContainers error:nil];
        return content;
    }
    return nil;
}


@end
