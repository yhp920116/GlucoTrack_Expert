//
//  User.m
//  SugarNursing
//
//  Created by Dan on 14-12-16.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "User.h"
#import "GCHttpClient.h"
#import "NSString+MD5.h"
#import "UtilsMacro.h"
#import <objc/runtime.h>
#import "NSString+Signatrue.h"


@implementation GCParameters

- (NSDictionary *)classPropertiesFor:(id)aObject
{
    unsigned int proCount,i;
    
    NSMutableDictionary *parameters = [@{} mutableCopy];
    
    objc_property_t *properties = class_copyPropertyList([aObject class], &proCount);
    for (i=0; i < proCount; i++)
    {
        objc_property_t property = properties[i];
        const char *proName = property_getName(property);
        if (proName)
        {
            NSString *propertyName = [NSString stringWithUTF8String:proName];
            NSString *propertyValue = [aObject valueForKey:propertyName];
            [parameters setValue:propertyValue forKey:propertyName];
        }
    }
    
    free(properties);
    
    
    if ([[parameters allKeys] containsObject:@"sign"])
    {
        [parameters setObject:[NSString generateSigWithParameters:parameters] forKey:@"sign"];
    }
    
    
    DDLogDebug(@"Configure Class: %@ and Parameters: %@",[aObject class],parameters);
    
    return [NSDictionary dictionaryWithDictionary:parameters];
}

@end


@implementation GCVerify

@end

@implementation GCRegister

@end

@implementation GCUserInfo

@end

@implementation GCAccountEdit

@end

@implementation GCInfoEdit

@end

@implementation GCResetPassword

@end

@implementation GCUploadFile

@end

@implementation GCGetDepartment

@end

@implementation GCGetMsgCount

@end

@implementation GCGetVersion

@end


@implementation GCIsMember

@end

@implementation GCSendSuggest

@end

@implementation GCGetPatient

@end


@implementation User

#pragma mark Verify
+ (NSURLSessionDataTask *)verifyWithGCLogin:(GCVerify *)loginInfo block:(void (^)(NSDictionary *, NSError *))block
{
    DDLogInfo(@"Running %@ %@",[self class],NSStringFromSelector(_cmd));
    DDLogInfo(@"Requesting for URL:%@",[NSURL URLWithString:GC_EXPERT_VERIFY_URL
                                              relativeToURL:[GCHttpClient sharedClient].baseURL]);
    
    NSDictionary *parameters = [loginInfo classPropertiesFor:loginInfo];
    //MD5
    loginInfo.password = [loginInfo.password md5];
    
    
    return [[GCHttpClient sharedClient] POST:GC_EXPERT_VERIFY_URL
                                  parameters:parameters
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         
                                         DDLogDebug(@"Verify resoponseData:%@",responseObject);
                                         
                                         // 这里对获取到的sessionID、Token和用户标识进行数据持久化
                                         
                                         if (block) {
                                             block(responseObject, nil);
                                         }
                                         
                                     }
                                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                                         
                                         DDLogDebug(@"Request Error: %@ %@",[error localizedFailureReason], NSStringFromSelector(_cmd));
                                         
                                         if (block) {
                                             block(nil,error);
                                         }
                                     }];
}

#pragma mark AccountRegister
+ (NSURLSessionDataTask *)accountRegistWithGCRegister:(GCRegister *)registerInfo block:(void (^)(NSDictionary *, NSError *))block
{
    
    DDLogInfo(@"Running %@ %@",[self class],NSStringFromSelector(_cmd));
    DDLogInfo(@"Requesting for URL:%@",[NSURL URLWithString:GC_EXPERT_REGISTER_URL relativeToURL:[GCHttpClient sharedClient].baseURL]);
    
    // MD5
    registerInfo.password = [registerInfo.password md5];
    
    // Sex
    if ([registerInfo.sex isEqualToString:@"female"]) {
        registerInfo.sex = @"00";
    }else {
        registerInfo.sex = @"01";
    }
    
    //birthday
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:registerInfo.birthday];
    [dateFormatter setDateFormat:@"YYYYMMdd"];
    registerInfo.birthday = [dateFormatter stringFromDate:date];
    
    
    NSDictionary *paramters = [registerInfo classPropertiesFor:registerInfo];
    
    return [[GCHttpClient sharedClient] POST:GC_EXPERT_REGISTER_URL
                                  parameters:paramters
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         
                                         DDLogDebug(@"Account Register resoponseData:%@",responseObject);
                                         
                                         if (block) {
                                             block(responseObject,nil);
                                         }
                                     }
                                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                                         
                                         DDLogDebug(@"Request Error: %@ %@",[error localizedFailureReason], NSStringFromSelector(_cmd));
                                         
                                         if (block) {
                                             block(nil,error);
                                         }
                                     }];
}

#pragma mark GetPersonalInfo
+ (NSURLSessionDataTask *)getPersonalInfoWithGCUserInfo:(GCUserInfo *)userInfo block:(void (^)(NSDictionary *, NSError *))block
{
    
    DDLogInfo(@"Running %@ %@",[self class],NSStringFromSelector(_cmd));
    DDLogInfo(@"Requesting for URL:%@",[NSURL URLWithString:GC_EXPERT_USERINFO_URL relativeToURL:[GCHttpClient sharedClient].baseURL]);
    
    
    NSDictionary *paramters = [userInfo classPropertiesFor:userInfo];
    
    return [[GCHttpClient sharedClient] POST:GC_EXPERT_USERINFO_URL
                                  parameters:paramters
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         
                                         DDLogDebug(@"Get Personal Info resoponseData:%@",responseObject);
                                         
                                         
                                         if (block) {
                                             block(responseObject, nil);
                                         }
                                     }
                                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                                         
                                         DDLogDebug(@"Request Error: %@ %@",[error localizedFailureReason], NSStringFromSelector(_cmd));
                                         
                                         if (block)
                                         {
                                             block(nil,error);
                                         }
                                     }];
}

#pragma mark AccountEdit
+ (NSURLSessionDataTask *)accountEditWithGCAccountEdit:(GCAccountEdit *)accountInfo block:(void (^)(NSDictionary *, NSError *))block
{
    
    DDLogInfo(@"Running %@ %@",[self class],NSStringFromSelector(_cmd));
    DDLogInfo(@"Requesting for URL:%@",[NSURL URLWithString:GC_EXPERT_ACCOUNTEDIT_URL relativeToURL:[GCHttpClient sharedClient].baseURL]);
    
    accountInfo.password = [accountInfo.password md5];
    
    NSDictionary *parameters = [accountInfo classPropertiesFor:accountInfo];
    
    return [[GCHttpClient sharedClient] POST:GC_EXPERT_ACCOUNTEDIT_URL
                                  parameters:parameters
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         
                                         DDLogDebug(@"Account Edit resoponseData:%@",responseObject);
                                         
                                         if (block)
                                         {
                                             block(responseObject,nil);
                                         }
                                     }
                                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                                         
                                         DDLogDebug(@"Request Error: %@ %@",[error localizedFailureReason], NSStringFromSelector(_cmd));
                                         
                                         if (block)
                                         {
                                             block(nil,error);
                                         }
                                         
                                     }];
}


#pragma mark ExpertInfoEdit
+ (NSURLSessionDataTask *)expertInfoEditWithGCInfoEdit:(GCInfoEdit *)editInfo block:(void (^)(NSDictionary *, NSError *))block
{
    
    
    DDLogInfo(@"Running %@ %@",[self class],NSStringFromSelector(_cmd));
    DDLogInfo(@"Requesting for URL:%@",[NSURL URLWithString:GC_EXPERT_INFOEDIT_URL relativeToURL:[GCHttpClient sharedClient].baseURL]);
    
    
    
    // Sex
    if ([editInfo.sex isEqualToString:@"female"]) {
        editInfo.sex = @"00";
    }else {
        editInfo.sex = @"01";
    }
    
    //birthday
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:editInfo.birthday];
    [dateFormatter setDateFormat:@"YYYYMMdd"];
    editInfo.birthday = [dateFormatter stringFromDate:date];
    
    NSDictionary *parameters = [editInfo classPropertiesFor:editInfo];
    
    return [[GCHttpClient sharedClient] POST:GC_EXPERT_INFOEDIT_URL
                                  parameters:parameters
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         
                                         DDLogDebug(@"Expert Info Edit resoponseData:%@",responseObject);
                                         
                                         block(responseObject,nil);
                                     }
                                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                                         
                                         DDLogDebug(@"Request Error: %@ %@",[error localizedFailureReason], NSStringFromSelector(_cmd));
                                         
                                         block(nil,error);
                                     }];
}


#pragma mark RsetPassword
+ (NSURLSessionDataTask *)resetPasswordWithGCResetPassword:(GCResetPassword *)resetInfo block:(void (^)(NSDictionary *, NSError *))block
{
    
    DDLogInfo(@"Running %@ %@",[self class],NSStringFromSelector(_cmd));
    DDLogInfo(@"Requesting for URL:%@",[NSURL URLWithString:GC_COMMON_RESETPASSWORD_URL relativeToURL:[GCHttpClient sharedClient].baseURL]);
    
    resetInfo.password = [resetInfo.password md5];
    
    NSDictionary *parameters = [resetInfo classPropertiesFor:resetInfo];
    
    return [[GCHttpClient sharedClient] POST:GC_COMMON_RESETPASSWORD_URL
                                  parameters:parameters
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         
                                         DDLogDebug(@"Reset Password resoponseData:%@",responseObject);
                                         
                                         if (block)
                                         {
                                             block(responseObject, nil);
                                         }
                                     }
                                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                                         
                                         DDLogDebug(@"Request Error: %@ %@",[error localizedFailureReason], NSStringFromSelector(_cmd));
                                         
                                         block(nil, error);
                                     }];
}


#pragma mark UploadFile
+ (NSURLSessionDataTask *)uploadFileWithGCUploadFile:(GCUploadFile *)uploadInfo block:(void (^)(NSDictionary *, NSError *))block
{
    
    DDLogInfo(@"Running %@ %@",[self class],NSStringFromSelector(_cmd));
    DDLogInfo(@"Requesting for URL:%@",[NSURL URLWithString:GC_COMMON_UPLOADFILE_URL
                                              relativeToURL:[GCHttpClient sharedClient].baseURL]);
    
    NSDictionary *parameters = [uploadInfo classPropertiesFor:uploadInfo];
    
    return [[GCHttpClient sharedClient] POST:GC_COMMON_UPLOADFILE_URL
                                  parameters:parameters
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         
                                         DDLogDebug(@"uploadFile resoponseData:%@",responseObject);
                                         
                                         if (block)
                                         {
                                             block(responseObject, nil);
                                         }
                                     }
                                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                                         
                                         DDLogDebug(@"Request Error: %@ %@",[error localizedFailureReason], NSStringFromSelector(_cmd));
                                         
                                         if (block)
                                         {
                                             block(nil, error);
                                         }
                                     }];
}


#pragma mark GetDepartment
+ (NSURLSessionDataTask *)getDepartmentInfoListWithGCGetDepartment:(GCGetDepartment *)departmentInfo block:(void (^)(NSDictionary *, NSError *))block
{
    
    DDLogInfo(@"Running %@ %@",[self class],NSStringFromSelector(_cmd));
    DDLogInfo(@"Requesting for URL:%@",[NSURL URLWithString:GC_COMMON_GETDEPARTMENT_URL
                                              relativeToURL:[GCHttpClient sharedClient].baseURL]);
    
    NSDictionary *parameters = [departmentInfo classPropertiesFor:departmentInfo];
    
    return [[GCHttpClient sharedClient] POST:GC_COMMON_GETDEPARTMENT_URL
                                  parameters:parameters
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         
                                         DDLogDebug(@"Get Department resoponseData:%@",responseObject);
                                         
                                         if (block)
                                         {
                                             block(responseObject, nil);
                                         }
                                     }
                                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                                         
                                         DDLogDebug(@"Request Error: %@ %@",[error localizedFailureReason], NSStringFromSelector(_cmd));
                                         
                                         if (block)
                                         {
                                             block(nil, error);
                                         }
                                     }];
}


#pragma mark GetNewMessageCount
+ (NSURLSessionDataTask *)getNewMessageCountWithGCGetMsgCount:(GCGetMsgCount *)msgInfo block:(void (^)(NSDictionary *, NSError *))block
{
    
    DDLogInfo(@"Running %@ %@",[self class],NSStringFromSelector(_cmd));
    DDLogInfo(@"Requesting for URL:%@",[NSURL URLWithString:GC_COMMON_GETMSGCOUNT_URL
                                              relativeToURL:[GCHttpClient sharedClient].baseURL]);
    
    NSDictionary *parameters = [msgInfo classPropertiesFor:msgInfo];
    
    return [[GCHttpClient sharedClient] POST:GC_COMMON_GETMSGCOUNT_URL
                                  parameters:parameters
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         
                                         DDLogDebug(@"Get Message Count resoponseData:%@",responseObject);
                                         
                                         if (block)
                                         {
                                             block(responseObject, nil);
                                         }
                                     }
                                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                                         
                                         DDLogDebug(@"Request Error: %@ %@",[error localizedFailureReason], NSStringFromSelector(_cmd));
                                         
                                         if (block)
                                         {
                                             block(nil, error);
                                         }
                                     }];
}


#pragma mark GetLastVersion
+(NSURLSessionDataTask *)getLastVersionWithGCGetVersion:(GCGetVersion *)versionInfo block:(void(^)(NSDictionary *responseData, NSError *error))block
{
    
    DDLogInfo(@"Running %@ %@",[self class],NSStringFromSelector(_cmd));
    DDLogInfo(@"Requesting for URL:%@",[NSURL URLWithString:GC_COMMON_GETVERSION_URL
                                              relativeToURL:[GCHttpClient sharedClient].baseURL]);
    
    NSDictionary *parameters = [versionInfo classPropertiesFor:versionInfo];
    
    return [[GCHttpClient sharedClient] POST:GC_COMMON_GETVERSION_URL
                                  parameters:parameters
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         
                                         DDLogDebug(@"Get Last Version resoponseData:%@",responseObject);
                                         
                                         if (block)
                                         {
                                             block(responseObject, nil);
                                         }
                                     }
                                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                                         
                                         DDLogDebug(@"Request Error: %@ %@",[error localizedFailureReason], NSStringFromSelector(_cmd));
                                         
                                         if (block)
                                         {
                                             block(nil, error);
                                         }
                                     }];
}


#pragma mark IsMember
+ (NSURLSessionDataTask *)isMemberWithGCIsMember:(GCIsMember *)memberInfo block:(void(^)(NSDictionary *responseData, NSError *error))block
{
    
    DDLogInfo(@"Running %@ %@",[self class],NSStringFromSelector(_cmd));
    DDLogInfo(@"Requesting for URL:%@",[NSURL URLWithString:GC_COMMON_ISMEMBER_URL
                                              relativeToURL:[GCHttpClient sharedClient].baseURL]);
    
    NSDictionary *parameters = [memberInfo classPropertiesFor:memberInfo];
    
    return [[GCHttpClient sharedClient] POST:GC_COMMON_ISMEMBER_URL
                                  parameters:parameters
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         
                                         DDLogDebug(@"Is Member resoponseData:%@",responseObject);
                                         
                                         if (block)
                                         {
                                             block(responseObject, nil);
                                         }
                                     }
                                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                                         
                                         DDLogDebug(@"Request Error: %@ %@",[error localizedFailureReason], NSStringFromSelector(_cmd));
                                         
                                         if (block)
                                         {
                                             block(nil, error);
                                         }
                                     }];
}



#pragma mark SendDoctorSuggest
+ (NSURLSessionDataTask *)sendDoctorSuggestsWithGCSendSuggest:(GCSendSuggest *)suggestInfo block:(void(^)(NSDictionary *responseData, NSError *error))block
{
    
    DDLogInfo(@"Running %@ %@",[self class],NSStringFromSelector(_cmd));
    DDLogInfo(@"Requesting for URL:%@",[NSURL URLWithString:GC_EXPERT_SENDSUGGEST_URL
                                              relativeToURL:[GCHttpClient sharedClient].baseURL]);
    
    NSDictionary *parameters = [suggestInfo classPropertiesFor:suggestInfo];
    
    return [[GCHttpClient sharedClient] POST:GC_EXPERT_SENDSUGGEST_URL
                                  parameters:parameters
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         
                                         DDLogDebug(@"Send Doctor Suggest resoponseData:%@",responseObject);
                                         
                                         if (block)
                                         {
                                             block(responseObject, nil);
                                         }
                                     }
                                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                                         
                                         DDLogDebug(@"Request Error: %@ %@",[error localizedFailureReason], NSStringFromSelector(_cmd));
                                         
                                         if (block)
                                         {
                                             block(nil, error);
                                         }
                                     }];
}


#pragma mark GetPatientList
+ (NSURLSessionDataTask *)getPatientListWithGCGetPatient:(GCGetPatient *)patientInfo block:(void(^)(NSDictionary *responseData, NSError *error))block
{
    
    DDLogInfo(@"Running %@ %@",[self class],NSStringFromSelector(_cmd));
    DDLogInfo(@"Requesting for URL:%@",[NSURL URLWithString:GC_EXPERT_GETPATIENT_URL
                                              relativeToURL:[GCHttpClient sharedClient].baseURL]);
    
    NSDictionary *parameters = [patientInfo classPropertiesFor:patientInfo];
    
    return [[GCHttpClient sharedClient] POST:GC_EXPERT_GETPATIENT_URL
                                  parameters:parameters
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         
                                         DDLogDebug(@"Get Patient List resoponseData:%@",responseObject);
                                         
                                         if (block)
                                         {
                                             block(responseObject, nil);
                                         }
                                     }
                                     failure:^(NSURLSessionDataTask *task, NSError *error){
                                         
                                         DDLogDebug(@"Request Error: %@ %@",[error localizedFailureReason], NSStringFromSelector(_cmd));
                                         
                                         if (block)
                                         {
                                             block(nil, error);
                                         }
                                     }];
}


@end
