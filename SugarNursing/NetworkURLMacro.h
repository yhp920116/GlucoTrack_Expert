//
//  NetworkURLMacro.h
//  SugarNursing
//
//  Created by Dan on 14-12-18.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#ifndef SugarNursing_NetworkURLMacro_h
#define SugarNursing_NetworkURLMacro_h

/*  URLSession Configuration  */

#define TIMEOUT_INTERVAL_FORREQUEST 5

static NSString * const GCHttpBaseURLString = @"http://192.168.1.6:8080/lcp-laop/";
static NSString *const GCHttpOfficialURLString = @"http://172.16.24.72:8083/lcp-laop/";


// Login URL
//#define GC_LOGIN_URL @"rest/laop/linkMan/account"
//#define GC_USER_REGISTER_URL @"rest/laop/linkMan/account"
//#define GC_USER_GETINFO_URL @"rest/laop/linkMan/account"

#define GC_EXPERT_REGISTER_URL @"rest/laop/expert/account"
#define GC_EXPERT_VERIFY_URL @"rest/expert/account"
#define GC_EXPERT_USERINFO_URL @"rest/expert/account"
#define GC_EXPERT_ACCOUNTEDIT_URL @"rest/expert/account"
#define GC_EXPERT_INFOEDIT_URL @"rest/expert/account"
#define GC_EXPERT_GETPATIENT_URL @"rest/expert/patient"
#define GC_EXPERT_SENDSUGGEST_URL @"rest/expert/suggest"


#define GC_COMMON_RESETPASSWORD_URL @"rest/common/account"
#define GC_COMMON_UPLOADFILE_URL @"rest/common/upload"
#define GC_COMMON_GETDEPARTMENT_URL @"rest/common/hospital"
#define GC_COMMON_GETMSGCOUNT_URL @"rest/common/massage"
#define GC_COMMON_GETVERSION_URL @"rest/common/version"
#define GC_COMMON_ISMEMBER_URL @"rest/common/account"


#endif
