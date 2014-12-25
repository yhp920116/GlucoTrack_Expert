//
//  MessageInfoViewController.h
//  SugarNursing
//
//  Created by Ian on 14-12-24.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageInfoViewController : UIViewController
<
UITableViewDataSource,
UITableViewDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end
