//
//  User.h
//  SugarNursing
//
//  Created by Ian on 14-12-30.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * exptid;
@property (nonatomic, retain) NSString * sessionid;
@property (nonatomic, retain) NSString * sessiontoken;
@property (nonatomic, retain) NSString * username;

@end
