//
//  RecoveryLogViewController.h
//  SugarNursing
//
//  Created by Ian on 14-11-26.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecoveryLogViewController : UIViewController
<
UITableViewDataSource,
UITableViewDelegate
>


@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@end
