//
//  NSString+Signatrue.m
//  SugarNursing
//
//  Created by Ian on 14-12-25.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "NSString+Signatrue.h"
#import "NSString+MD5.h"

@implementation NSString (Signatrue)


+ (NSString *)generateSigWithParameters:(NSDictionary *)parameters
{
    NSMutableArray *allKeys = [[parameters allKeys] mutableCopy];
    [allKeys removeObject:@"method"];
    [allKeys removeObject:@"sign"];
    [allKeys removeObject:@"sessionId"];
    
    NSArray *sortedKeys = [allKeys sortedArrayUsingSelector:@selector(compare:)];
    __block NSString *joinString = @"";
    [sortedKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *akey = (NSString *)obj;
        NSString *keyAndValue = [obj stringByAppendingString:[parameters valueForKey:akey]];
        joinString = [joinString stringByAppendingString:keyAndValue];
    }];
    
    
    NSString *sessionToken = @"";
    joinString = [joinString stringByAppendingString:sessionToken];
    
    return [joinString md5];
}

@end
