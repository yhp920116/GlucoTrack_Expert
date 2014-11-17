//
//  VerificationViewController.h
//  SugarNursing
//
//  Created by Dan on 14-11-14.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerificationViewController : UIViewController

@property (strong, nonatomic) NSString *labelText;

@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (weak, nonatomic) IBOutlet UIButton *resetPwdBtn;

@end
