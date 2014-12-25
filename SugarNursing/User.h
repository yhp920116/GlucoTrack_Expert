//
//  User.h
//  SugarNursing
//
//  Created by Dan on 14-12-16.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Model
@interface GCParameters : NSObject

- (NSDictionary *)classPropertiesFor:(id)aObject;

@end

@interface GCVerify : GCParameters
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSString *accountName;
@property (nonatomic, strong) NSString *password;
@end


@interface GCRegister : GCParameters
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *captcha;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *exptName;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *departmentId;
@property (nonatomic, strong) NSString *zone;
@property (nonatomic, strong) NSString *appType;
@end


@interface GCUserInfo : GCParameters
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSString *sign;
@property (nonatomic, strong) NSString *sessionId;
@property (nonatomic, strong) NSString *exptId;
@end


@interface GCAccountEdit : GCParameters
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSString *sign;
@property (nonatomic, strong) NSString *sessionId;
@property (nonatomic, strong) NSString *exptId;
@property (nonatomic, strong) NSString *identifyCard;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;
@end


@interface GCInfoEdit : GCParameters
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSString *sign;
@property (nonatomic, strong) NSString *sessionId;
@property (nonatomic, strong) NSString *exptId;
@property (nonatomic, strong) NSString *areaId;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *departmentId;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *engName;
@property (nonatomic, strong) NSString *exptName;
@property (nonatomic, strong) NSString *headimageUrl;
@property (nonatomic, strong) NSString *hospitalId;
@property (nonatomic, strong) NSString *identifyCard;
@property (nonatomic, strong) NSString *intro;
@property (nonatomic, strong) NSString *realName;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *skilled;
@end


@interface GCResetPassword : GCParameters
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *zone;
@property (nonatomic, strong) NSString *captcha;
@property (nonatomic, strong) NSString *appType;
@property (nonatomic, strong) NSString *password;
@end


@interface GCUploadFile : GCParameters
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSString *fileType;
@property (nonatomic, assign) FILE *file;
@end

@interface GCGetDepartment : GCParameters
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSString *departmentId;
@property (nonatomic, strong) NSString *type;
@end


@interface GCGetMsgCount : GCParameters
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSString *recvUser;
@property (nonatomic, strong) NSString *messageType;
@end

@interface GCGetVersion : GCParameters
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSString *modelType;
@end

@interface GCIsMember : GCParameters
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *memberType;
@end


@interface GCSendSuggest : GCParameters
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSString *sign;
@property (nonatomic, strong) NSString *sessionId;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *linkManId;
@property (nonatomic, strong) NSString *exptId;
@end

@interface GCGetPatient : GCParameters
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSString *sign;
@property (nonatomic, strong) NSString *sessionId;
@property (nonatomic, strong) NSString *exptId;
@property (nonatomic, strong) NSString *sevFlag;
@property (nonatomic, strong) NSString *start;
@property (nonatomic, strong) NSString *size;
@end




#pragma mark - Network Method
@interface User : NSObject

#pragma mark Verify
+ (NSURLSessionDataTask *)verifyWithGCLogin:(GCVerify *)loginInfo block:(void (^) (NSDictionary *responseData, NSError *error))block;

#pragma mark AccountRegist
+ (NSURLSessionDataTask *)accountRegistWithGCRegister:(GCRegister *)registerInfo block:(void (^) (NSDictionary *responseData, NSError *error))block;

#pragma mark GetPersonalInfo
+ (NSURLSessionDataTask *)getPersonalInfoWithGCUserInfo:(GCUserInfo *)userInfo block:(void (^) (NSDictionary *responseData, NSError *error))block;

#pragma mark AccountEdit
+ (NSURLSessionDataTask *)accountEditWithGCAccountEdit:(GCAccountEdit *)accountInfo block:(void(^)(NSDictionary *responseData, NSError *error))block;

#pragma mark ExpertInfoEdit
+ (NSURLSessionDataTask *)expertInfoEditWithGCInfoEdit:(GCInfoEdit *)editInfo block:(void(^)(NSDictionary *responseData, NSError *error))block;

#pragma mark ResetPassword
+ (NSURLSessionDataTask *)resetPasswordWithGCResetPassword:(GCResetPassword *)resetInfo block:(void(^)(NSDictionary *responseData, NSError *error))block;


#pragma mark UploadFile
+ (NSURLSessionDataTask *)uploadFileWithGCUploadFile:(GCUploadFile *)uploadInfo block:(void(^)(NSDictionary *responseData, NSError *error))block;


#pragma mark GetDepartment
+ (NSURLSessionDataTask *)getDepartmentInfoListWithGCGetDepartment:(GCGetDepartment *)departmentInfo block:(void(^)(NSDictionary *responseData, NSError *error))block;

#pragma mark GetNewMessageCount
+ (NSURLSessionDataTask *)getNewMessageCountWithGCGetMsgCount:(GCGetMsgCount *)msgInfo block:(void(^)(NSDictionary *responseData, NSError *error))block;

#pragma mark GetLastVersion
+ (NSURLSessionDataTask *)getLastVersionWithGCGetVersion:(GCGetVersion *)versionInfo block:(void(^)(NSDictionary *responseData, NSError *error))block;

#pragma mark IsMember
+ (NSURLSessionDataTask *)isMemberWithGCIsMember:(GCIsMember *)memberInfo block:(void(^)(NSDictionary *responseData, NSError *error))block;


#pragma mark SendDoctorSuggest
+ (NSURLSessionDataTask *)sendDoctorSuggestsWithGCSendSuggest:(GCSendSuggest *)suggestInfo block:(void(^)(NSDictionary *responseData, NSError *error))block;

#pragma mark GetPatientList
+ (NSURLSessionDataTask *)getPatientListWithGCGetPatient:(GCGetPatient *)patientInfo block:(void(^)(NSDictionary *responseData, NSError *error))block;


@end
