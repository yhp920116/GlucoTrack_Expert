//
//  AppDelegate.m
//  SugarNursing
//
//  Created by Dan on 14-11-5.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "AppDelegate.h"
#import "UIStoryboard+Storyboards.h"
#import "RootViewController.h"
#import "CoreDataStack.h"
#import <CocoaLumberjack.h>
#import "UtilsMacro.h"
#import <MobClick.h>
#import "VendorMacro.h"
#import "UMessage.h"
#import "AppDelegate+UserLogInOut.h"
#import "UIApplication+ResponseAPNS.h"
#import "SystemVersion.h"
#import "KeyValueObserver.h"
#import "MsgRemind.h"


#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending) 
#define _IPHONE80_ 80000

@interface AppDelegate ()
@property (strong, nonatomic) NSDictionary *launchOptions;
@property (strong, nonatomic) id rootVCObserveToken;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Override point for customization after application launch.
    [self configureCustomizing];
    [self configureCocoaLumberjackFramework];
    [self configureUMAnalytics];
    [self configureUMAPNS:launchOptions];
    [self configureDefaultSetting:launchOptions];
    [self configureUserLogin];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
//    UILocalNotification *notification = [[UILocalNotification alloc] init];
//    NSDate *now = [NSDate date];
//    notification.fireDate = [now dateByAddingTimeInterval:5];
//    notification.timeZone = [NSTimeZone defaultTimeZone];
//    notification.alertBody = @"开始就打开附件";
//     [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    return YES;
}


- (void)configureCustomizing
{
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:44/255.0 green:125/255.0 blue:198/255.0 alpha:1]];
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
}

- (void)configureDefaultSetting:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.launchOptions = launchOptions;
    
        self.rootVCObserveToken = [KeyValueObserver observeObject:self.window keyPath:@"rootViewController" target:self selector:@selector(rootVCDidLoad:) options:NSKeyValueObservingOptionOld];
    
}

- (void)rootVCDidLoad:(NSDictionary *)change
{
    NSDictionary *notification  = [self.launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (notification)
    {
        [UIApplication responseAPNS:notification];
    }
    else
    {
        
        if ([AppDelegate isLogin])
        {
            
            RootViewController *rootVC = (RootViewController *)self.window.rootViewController;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)1.0 *NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [rootVC presentLeftMenuViewController];
            });
        }
    }
}


#pragma mark - Application Status

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self updateNewMessageCountToServer];
    
    [[CoreDataStack sharedCoreDataStack] saveContext];
}



- (void)applicationWillEnterForeground:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [Department deleteAllEntityInContext:[CoreDataStack sharedCoreDataStack].context];
    [[CoreDataStack sharedCoreDataStack] saveContext];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"deviceToken = %@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                  stringByReplacingOccurrencesOfString: @">" withString: @""]
                 stringByReplacingOccurrencesOfString: @" " withString: @""]);
    
    NSString *token =[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                       stringByReplacingOccurrencesOfString: @">" withString: @""]
                      stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    self.deviceToken = token ? token : @"";
    [UMessage registerDeviceToken:deviceToken];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    [UMessage didReceiveRemoteNotification:userInfo];
    
    if ([AppDelegate isLogin])
    {
        
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
        {
            [self updateNewMessageCountToCoreData];
        }
        else
        {
            [UIApplication responseAPNS:userInfo];
        }
    }
}


- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //程序每次激活都获取新信息提醒
    if ([AppDelegate isLogin])
    {
        [self updateNewMessageCountToCoreData];
    }
}


#pragma Login
- (void)configureUserLogin
{
    
    if (![AppDelegate isLogin])
    {
        self.window.rootViewController = [[UIStoryboard loginStoryboard] instantiateInitialViewController];
        [self.window makeKeyAndVisible];
    }
    else
    {
        self.window.rootViewController = [[UIStoryboard mainStoryboard] instantiateInitialViewController];
        [self.window makeKeyAndVisible];
    }
}

#pragma Configure Library Framework
- (void)configureCocoaLumberjackFramework
{
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    
    UIColor *blue = [UIColor colorWithRed:(34/255.0) green:(79/255.0) blue:(188/255.0) alpha:0.8];
    UIColor *green = [UIColor colorWithRed:(27/255.0) green:(152/255.0) blue:(73/255.0) alpha:0.8];
    
    [[DDTTYLogger sharedInstance] setForegroundColor:blue backgroundColor:nil forFlag:DDLogFlagInfo];
    [[DDTTYLogger sharedInstance] setForegroundColor:green backgroundColor:nil forFlag:DDLogFlagDebug];
}

- (void)configureUMAnalytics
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick startWithAppkey:UM_ANALYTICS_KEY reportPolicy:BATCH channelId:nil];
    [MobClick setAppVersion:version];
    [MobClick checkUpdate:NSLocalizedString(@"New Version", nil) cancelButtonTitle:NSLocalizedString(@"Skip", nil) otherButtonTitles:NSLocalizedString(@"Go to Store", nil)];
}


- (void)configureUMAPNS:(NSDictionary *)launchOptions
{
    [UMessage startWithAppkey:UM_MESSAGE_APPKEY launchOptions:launchOptions];
    
    
    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        
        //register remoteNotification types
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
    }
    else
    {
        //register remoteNotification types
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
    
    
    
    [UMessage addTag:@"IOS_Expert" response:nil];
    
    //for log
    [UMessage setLogEnabled:YES];
    [UMessage setAutoAlert:NO];
}


#pragma mark - Net Working
- (void)updateNewMessageCountToServer
{
    
    NSDictionary *parameters = @{@"method":@"resetNewMessageCount",
                                 @"sign":@"sign",
                                 @"recvUser":[NSString exptId],
                                 @"sessionId":[NSString sessionID],
                                 @"sessionToken":[NSString sessionToken],
                                 @"messageTypeList":[self configureMessageListJsonString]};
    
    [GCRequest resetNewMessageCountWithParameters:parameters block:^(NSDictionary *responseData, NSError *error)
     {
         NSLog(@"%@",responseData);
    }];
}


- (void)updateNewMessageCountToCoreData
{
    
    NSDictionary *parameters = @{@"method":@"getNewMessageCount",
                                 @"sessionId":[NSString sessionID],
                                 @"sessionToken":[NSString sessionToken],
                                 @"recvUser":[NSString exptId],
                                 @"sign":@"sign"};
    [GCRequest getNewMessageCountWithParameters:parameters block:^(NSDictionary *responseData, NSError *error)
    {
        
        if (!error)
        {
            
            if ([responseData[@"ret_code"] isEqualToString:@"0"])
            {
                [MsgRemind updateSectionBadgeWithParameter:responseData];
            }
        }
    }];
}


- (NSString *)configureMessageListJsonString
{
    
    MsgRemind *remind = [MsgRemind shareMsgRemind];
    
    NSArray *messageList = @[@{@"type":@"agentMsg",@"value":remind.messageAgentRemindCount},
                             @{@"type":@"bulletin",@"value":remind.messageBulletinRemindCount},
                             @{@"type":@"personalAppr",@"value":remind.messageApproveRemindCount},
                             @{@"type":@"trusPass",@"value":remind.hostingConfirmRemindCount},
                             @{@"type":@"trusObjection",@"value":remind.hostingRefuseRemindCount},
                             @{@"type":@"trusWait",@"value":remind.takeoverWaittingRemindCount}
                             ];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:messageList options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}

@end
