//
//  FeedBackViewController.m
//  SugarNursing
//
//  Created by Ian on 14-12-16.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "FeedBackViewController.h"

@interface FeedBackViewController ()

@end

@implementation FeedBackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.myTextView.placeholder = @"请输入您的反馈";
    self.myTextView.placeholderColor = [UIColor lightGrayColor];
    [self.myTextView.layer setBorderColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.5].CGColor];
    self.myTextView.layer.borderWidth = 1.0f;
}



@end
