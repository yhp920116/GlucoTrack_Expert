//
//  SendSuggestViewController.h
//  SugarNursing
//
//  Created by Ian on 14-11-27.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendSuggestViewController : UIViewController
<
UITableViewDataSource,
UITableViewDelegate,
UITextViewDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *serverTextView;

@end
