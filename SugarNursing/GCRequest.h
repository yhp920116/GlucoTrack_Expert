//
//  GCRequest.h
//  SugarNursing
//
//  Created by Ian on 14-12-30.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark - Model

#pragma mark - Network Method
@interface GCRequest : NSObject


#pragma mark Verify
+ (NSURLSessionDataTask *)verifyWithParameters:(id)parameters block:(void (^) (NSDictionary *responseData, NSError *error))block;

#pragma mark AccountRegist
+ (NSURLSessionDataTask *)accountRegistWithParameters:(id)parameters block:(void (^) (NSDictionary *responseData, NSError *error))block;

#pragma mark GetPersonalInfo
+ (NSURLSessionDataTask *)getPersonalInfoWithParameters:(id)parameters block:(void (^) (NSDictionary *responseData, NSError *error))block;

#pragma mark AccountEdit
+ (NSURLSessionDataTask *)accountEditWithParameters:(id)parameters block:(void(^)(NSDictionary *responseData, NSError *error))block;

#pragma mark ExpertInfoEdit
+ (NSURLSessionDataTask *)expertInfoEditWithParameters:(id)parameters block:(void(^)(NSDictionary *responseData, NSError *error))block;

#pragma mark ResetPassword
+ (NSURLSessionDataTask *)resetPasswordWithParameters:(id)parameters block:(void(^)(NSDictionary *responseData, NSError *error))block;


#pragma mark UploadFile
+ (NSURLSessionDataTask *)uploadFileWithParameters:(id)parameters block:(void(^)(NSDictionary *responseData, NSError *error))block;


#pragma mark GetDepartment
+ (NSURLSessionDataTask *)getDepartmentInfoListWithParameters:(id)parameters block:(void(^)(NSDictionary *responseData, NSError *error))block;

#pragma mark GetNewMessageCount
+ (NSURLSessionDataTask *)getNewMessageCountWithParameters:(id)parameters block:(void(^)(NSDictionary *responseData, NSError *error))block;

#pragma mark GetLastVersion
+ (NSURLSessionDataTask *)getLastVersionWithParameters:(id)parameters block:(void(^)(NSDictionary *responseData, NSError *error))block;

#pragma mark IsMember
+ (NSURLSessionDataTask *)isMemberWithParameters:(id)parameters block:(void(^)(NSDictionary *responseData, NSError *error))block;


#pragma mark SendDoctorSuggest
+ (NSURLSessionDataTask *)sendDoctorSuggestsWithParameters:(id)parameters block:(void(^)(NSDictionary *responseData, NSError *error))block;

#pragma mark GetPatientList
+ (NSURLSessionDataTask *)getPatientListWithParameters:(id)parameters block:(void(^)(NSDictionary *responseData, NSError *error))block;




+ (id)signValueFor:(id)parameters;
@end
