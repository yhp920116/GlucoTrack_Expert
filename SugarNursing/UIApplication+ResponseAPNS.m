//
//  UIApplication+ResponseAPNS.m
//  SugarNursing
//
//  Created by Ian on 15-3-4.
//  Copyright (c) 2015年 Tisson. All rights reserved.
//

#import "UIApplication+ResponseAPNS.h"
#import "UIStoryboard+Storyboards.h"
#import <RESideMenu.h>
#import "AppDelegate.h"
#import "RootViewController.h"
#import "MessageInfoViewController.h"
#import "MyMessageViewController.h"
#import "SystemVersion.h"
#import "MsgRemind.h"
#import "CoreDataStack.h"

@implementation UIApplication (ResponseAPNS)

+ (void)responseAPNS:(NSDictionary *)info
{
    
    NSDictionary *content = [self analysisRespondData:info];
    
    if (!content || content.count<=0)
    {
        return;
    }
    NSString *type = content[@"type"];
    
    
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    if (state == UIApplicationStateActive)
    {
        
    }
    else if (state == UIApplicationStateBackground)
    {
        [self responseNotificationWithType:type];
    }
    else if (state == UIApplicationStateInactive)
    {
        [self responseNotificationWithType:type];
    }
}

+ (void)responseNotificationWithType:(NSString *)type
{
    if ([type isEqualToString:@"messageApprove"])
    {
        [self notificationRespondForMessageWithType:MsgTypeApprove];
    }
    else if ([type isEqualToString:@"messgeBulletin"])
    {
        [self notificationRespondForMessageWithType:MsgTypeBulletin];
    }
    else if ([type isEqualToString:@"messageAgent"])
    {
        [self notificationRespondForMessageWithType:MsgTypeAgent];
    }
    else if ([type isEqualToString:@"trusteeshipConfirm"])
    {
        [self notificationRespondForMyHostingWithFlag:@"02"];
    }
    else if ([type isEqualToString:@"trusteeshipRefuse"])
    {
        [self notificationRespondForMyHostingWithFlag:@"04"];
    }
    else if ([type isEqualToString:@"takeoverWait"])
    {
        [self notificationRespondForMyTakeoverWithFlag:@"01"];
    }
}

+ (void)notificationRespondForMessageWithType:(MsgType)msgType
{
    
    UINavigationController *navigationVC = [[UIStoryboard myMessageStoryboard] instantiateInitialViewController];
//    MyMessageViewController *myMessageVC = (MyMessageViewController *)[navigationVC viewControllers][0];
//    
//    myMessageVC.isAPNS = YES;
//    myMessageVC.goMsgType = msgType;
//    
//    NSString *msgTitle;
//    
//    switch (msgType)
//    {
//        case MsgTypeApprove:
//            msgTitle = NSLocalizedString(@"Approve Result", nil);
//            break;
//        case MsgTypeBulletin:
//            msgTitle = NSLocalizedString(@"System Bulletin", nil);
//            break;
//        case MsgTypeAgent:
//            msgTitle = NSLocalizedString(@"Agent Message", nil);
//            break;
//        default:
//            break;
//    }
//    
//    
//    myMessageVC.goMsgTitle = msgTitle;
    
    [self skipToViewController:navigationVC showLeftMenu:NO];
}

+ (void)notificationRespondForMyHostingWithFlag:(NSString *)flag
{
    
    UINavigationController *navigationVC = [[UIStoryboard myHostingStoryboard] instantiateInitialViewController];
    
    [self skipToViewController:navigationVC showLeftMenu:YES];
}


+ (void)notificationRespondForMyTakeoverWithFlag:(NSString *)flag
{
    
    UINavigationController *navigationVC = [[UIStoryboard myTakeoverStoryboard] instantiateInitialViewController];
    [self skipToViewController:navigationVC showLeftMenu:YES];
    
}

+ (void)skipToViewController:(UIViewController *)viewController showLeftMenu:(BOOL)showLeftMenu
{
    RootViewController *rootVC = (RootViewController *)[self sharedApplication].delegate.window.rootViewController;
    [rootVC hideMenuViewController];
    [rootVC setContentViewController:viewController];
    
    if (showLeftMenu)
    {
        [rootVC presentLeftMenuViewController];
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
