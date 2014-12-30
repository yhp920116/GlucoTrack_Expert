//
//  GCRequest.m
//  SugarNursing
//
//  Created by Ian on 14-12-30.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "GCRequest.h"
#import "GCHttpClient.h"
#import "NSString+MD5.h"
#import "UtilsMacro.h"
#import <objc/runtime.h>


@implementation GCRequest

#pragma mark Verify
+ (NSURLSessionDataTask *)verifyWithParameters:(id)parameters block:(void (^)(NSDictionary *, NSError *))block
{
    DDLogInfo(@"Running %@ %@",[self class],NSStringFromSelector(_cmd));
    DDLogInfo(@"Requesting for URL:%@",[NSURL URLWithString:GC_EXPERT_VERIFY_URL
                                              relativeToURL:[GCHttpClient sharedClient].baseURL]);
    
    //MD5
    parameters = [parameters mutableCopy];
    
    [parameters setValue:[[NSString parseDictionary:parameters forKeyPath:@"password"] md5] forKey:@"password"];
    
    return [[GCHttpClient sharedClient] POST:GC_EXPERT_VERIFY_URL
                                  parameters:parameters
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         
                                         DDLogDebug(@"Verify resoponseData:%@",responseObject);
                                         responseObject = [(NSDictionary *)responseObject keysLowercased];
                                         
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
+ (NSURLSessionDataTask *)accountRegistWithParameters:(id)parameters block:(void (^)(NSDictionary *, NSError *))block
{
    
    DDLogInfo(@"Running %@ %@",[self class],NSStringFromSelector(_cmd));
    DDLogInfo(@"Requesting for URL:%@",[NSURL URLWithString:GC_EXPERT_REGISTER_URL relativeToURL:[GCHttpClient sharedClient].baseURL]);
    
    //MD5
    parameters = [parameters mutableCopy];
    
    [parameters setValue:[[NSString parseDictionary:parameters forKeyPath:@"password"] md5] forKey:@"password"];
    
    // Sex
    if ([[NSString parseDictionary:parameters forKeyPath:@"sex"] isEqualToString:@"female"]){
        [parameters setValue:@"00" forKey:@"sex"];
    }else{
        [parameters setValue:@"01" forKey:@"sex"];
    }
    
    //birthday
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:[NSString parseDictionary:parameters forKeyPath:@"birthday"]];
    [dateFormatter setDateFormat:@"YYYYMMdd"];
    [parameters setValue:[dateFormatter stringFromDate:date] forKey:@"birthday"];
    
    
    return [[GCHttpClient sharedClient] POST:GC_EXPERT_REGISTER_URL
                                  parameters:parameters
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         
                                         DDLogDebug(@"Account Register resoponseData:%@",responseObject);
                                         
                                         responseObject = [(NSDictionary *)responseObject keysLowercased];
                                         
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
+ (NSURLSessionDataTask *)getPersonalInfoWithParameters:(id)parameters block:(void (^)(NSDictionary *, NSError *))block
{
    
    DDLogInfo(@"Running %@ %@",[self class],NSStringFromSelector(_cmd));
    DDLogInfo(@"Requesting for URL:%@",[NSURL URLWithString:GC_EXPERT_USERINFO_URL relativeToURL:[GCHttpClient sharedClient].baseURL]);
    
    
    parameters = [parameters mutableCopy];
    
    return [[GCHttpClient sharedClient] POST:GC_EXPERT_USERINFO_URL
                                  parameters:parameters
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         
                                         DDLogDebug(@"Get Personal Info resoponseData:%@",responseObject);
                                         
                                         responseObject = [(NSDictionary *)responseObject keysLowercased];
                                         
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
+ (NSURLSessionDataTask *)accountEditWithParameters:(id)parameters block:(void (^)(NSDictionary *, NSError *))block
{
    
    DDLogInfo(@"Running %@ %@",[self class],NSStringFromSelector(_cmd));
    DDLogInfo(@"Requesting for URL:%@",[NSURL URLWithString:GC_EXPERT_ACCOUNTEDIT_URL relativeToURL:[GCHttpClient sharedClient].baseURL]);
    
    
    parameters = [parameters mutableCopy];
    
    
    return [[GCHttpClient sharedClient] POST:GC_EXPERT_ACCOUNTEDIT_URL
                                  parameters:parameters
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         
                                         DDLogDebug(@"Account Edit resoponseData:%@",responseObject);
                                         responseObject = [(NSDictionary *)responseObject keysLowercased];
                                         
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
+ (NSURLSessionDataTask *)expertInfoEditWithParameters:(id)parameters block:(void (^)(NSDictionary *, NSError *))block
{
    
    
    DDLogInfo(@"Running %@ %@",[self class],NSStringFromSelector(_cmd));
    DDLogInfo(@"Requesting for URL:%@",[NSURL URLWithString:GC_EXPERT_INFOEDIT_URL relativeToURL:[GCHttpClient sharedClient].baseURL]);
    
    parameters = [parameters mutableCopy];
    
    
    // Sex
    if ([[NSString parseDictionary:parameters forKeyPath:@"sex"] isEqualToString:@"female"]){
        [parameters setValue:@"00" forKey:@"sex"];
    }else{
        [parameters setValue:@"01" forKey:@"sex"];
    }
    
    //birthday
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:[NSString parseDictionary:parameters forKeyPath:@"birthday"]];
    [dateFormatter setDateFormat:@"YYYYMMdd"];
    [parameters setValue:[dateFormatter stringFromDate:date] forKey:@"birthday"];
    
    
    return [[GCHttpClient sharedClient] POST:GC_EXPERT_INFOEDIT_URL
                                  parameters:parameters
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         
                                         DDLogDebug(@"Expert Info Edit resoponseData:%@",responseObject);
                                         responseObject = [(NSDictionary *)responseObject keysLowercased];
                                         
                                         block(responseObject,nil);
                                     }
                                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                                         
                                         DDLogDebug(@"Request Error: %@ %@",[error localizedFailureReason], NSStringFromSelector(_cmd));
                                         
                                         block(nil,error);
                                     }];
}


#pragma mark RsetPassword
+ (NSURLSessionDataTask *)resetPasswordWithParameters:(id)parameters block:(void (^)(NSDictionary *, NSError *))block
{
    
    DDLogInfo(@"Running %@ %@",[self class],NSStringFromSelector(_cmd));
    DDLogInfo(@"Requesting for URL:%@",[NSURL URLWithString:GC_COMMON_RESETPASSWORD_URL relativeToURL:[GCHttpClient sharedClient].baseURL]);
    
    //MD5
    parameters = [parameters mutableCopy];
    
    [parameters setValue:[[NSString parseDictionary:parameters forKeyPath:@"password"] md5] forKey:@"password"];
    
    
    return [[GCHttpClient sharedClient] POST:GC_COMMON_RESETPASSWORD_URL
                                  parameters:parameters
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         
                                         DDLogDebug(@"Reset Password resoponseData:%@",responseObject);
                                         responseObject = [(NSDictionary *)responseObject keysLowercased];
                                         
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
+ (NSURLSessionDataTask *)uploadFileWithParameters:(id)parameters block:(void (^)(NSDictionary *, NSError *))block
{
    
    DDLogInfo(@"Running %@ %@",[self class],NSStringFromSelector(_cmd));
    DDLogInfo(@"Requesting for URL:%@",[NSURL URLWithString:GC_COMMON_UPLOADFILE_URL
                                              relativeToURL:[GCHttpClient sharedClient].baseURL]);
    
    parameters = [parameters mutableCopy];

    
    return [[GCHttpClient sharedClient] POST:GC_COMMON_UPLOADFILE_URL
                                  parameters:parameters
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         
                                         DDLogDebug(@"uploadFile resoponseData:%@",responseObject);
                                         responseObject = [(NSDictionary *)responseObject keysLowercased];
                                         
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
+ (NSURLSessionDataTask *)getDepartmentInfoListWithParameters:(id)parameters block:(void (^)(NSDictionary *, NSError *))block
{
    
    DDLogInfo(@"Running %@ %@",[self class],NSStringFromSelector(_cmd));
    DDLogInfo(@"Requesting for URL:%@",[NSURL URLWithString:GC_COMMON_GETDEPARTMENT_URL
                                              relativeToURL:[GCHttpClient sharedClient].baseURL]);
    
    parameters = [parameters mutableCopy];

    
    return [[GCHttpClient sharedClient] POST:GC_COMMON_GETDEPARTMENT_URL
                                  parameters:parameters
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         
                                         DDLogDebug(@"Get Department resoponseData:%@",responseObject);
                                         responseObject = [(NSDictionary *)responseObject keysLowercased];
                                         
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
+ (NSURLSessionDataTask *)getNewMessageCountWithParameters:(id)parameters block:(void (^)(NSDictionary *, NSError *))block
{
    
    DDLogInfo(@"Running %@ %@",[self class],NSStringFromSelector(_cmd));
    DDLogInfo(@"Requesting for URL:%@",[NSURL URLWithString:GC_COMMON_GETMSGCOUNT_URL
                                              relativeToURL:[GCHttpClient sharedClient].baseURL]);
    
    parameters = [parameters mutableCopy];

    
    return [[GCHttpClient sharedClient] POST:GC_COMMON_GETMSGCOUNT_URL
                                  parameters:parameters
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         
                                         DDLogDebug(@"Get Message Count resoponseData:%@",responseObject);
                                         responseObject = [(NSDictionary *)responseObject keysLowercased];
                                         
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
+(NSURLSessionDataTask *)getLastVersionWithParameters:(id)parameters block:(void(^)(NSDictionary *responseData, NSError *error))block
{
    
    DDLogInfo(@"Running %@ %@",[self class],NSStringFromSelector(_cmd));
    DDLogInfo(@"Requesting for URL:%@",[NSURL URLWithString:GC_COMMON_GETVERSION_URL
                                              relativeToURL:[GCHttpClient sharedClient].baseURL]);
    
    parameters = [parameters mutableCopy];

    return [[GCHttpClient sharedClient] POST:GC_COMMON_GETVERSION_URL
                                  parameters:parameters
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         
                                         DDLogDebug(@"Get Last Version resoponseData:%@",responseObject);
                                         responseObject = [(NSDictionary *)responseObject keysLowercased];
                                         
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
+ (NSURLSessionDataTask *)isMemberWithParameters:(id)parameters block:(void(^)(NSDictionary *responseData, NSError *error))block
{
    
    DDLogInfo(@"Running %@ %@",[self class],NSStringFromSelector(_cmd));
    DDLogInfo(@"Requesting for URL:%@",[NSURL URLWithString:GC_COMMON_ISMEMBER_URL
                                              relativeToURL:[GCHttpClient sharedClient].baseURL]);
    
    parameters = [parameters mutableCopy];

    return [[GCHttpClient sharedClient] POST:GC_COMMON_ISMEMBER_URL
                                  parameters:parameters
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         
                                         DDLogDebug(@"Is Member resoponseData:%@",responseObject);
                                         responseObject = [(NSDictionary *)responseObject keysLowercased];
                                         
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
+ (NSURLSessionDataTask *)sendDoctorSuggestsWithParameters:(id)parameters block:(void(^)(NSDictionary *responseData, NSError *error))block
{
    
    DDLogInfo(@"Running %@ %@",[self class],NSStringFromSelector(_cmd));
    DDLogInfo(@"Requesting for URL:%@",[NSURL URLWithString:GC_EXPERT_SENDSUGGEST_URL
                                              relativeToURL:[GCHttpClient sharedClient].baseURL]);
    
    parameters = [parameters mutableCopy];

    
    return [[GCHttpClient sharedClient] POST:GC_EXPERT_SENDSUGGEST_URL
                                  parameters:parameters
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         
                                         DDLogDebug(@"Send Doctor Suggest resoponseData:%@",responseObject);
                                         responseObject = [(NSDictionary *)responseObject keysLowercased];
                                         
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
+ (NSURLSessionDataTask *)getPatientListWithParameters:(id)parameters block:(void(^)(NSDictionary *responseData, NSError *error))block
{
    
    DDLogInfo(@"Running %@ %@",[self class],NSStringFromSelector(_cmd));
    DDLogInfo(@"Requesting for URL:%@",[NSURL URLWithString:GC_EXPERT_GETPATIENT_URL
                                              relativeToURL:[GCHttpClient sharedClient].baseURL]);
    
    parameters = [parameters mutableCopy];
    
    [self signValueFor:parameters];
    
    return [[GCHttpClient sharedClient] POST:GC_EXPERT_GETPATIENT_URL
                                  parameters:parameters
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         
                                         DDLogDebug(@"Get Patient List resoponseData:%@",responseObject);
                                         responseObject = [(NSDictionary *)responseObject keysLowercased];
                                         
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


+ (id)signValueFor:(id)parameters
{
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        if ([[parameters allKeys] containsObject:@"sign"]) {
            [parameters setValue:[NSString generateSigWithParameters:parameters] forKey:@"sign"];
        }
    }
    return parameters;
}

@end
