//
//  MyMessageViewController.h
//  SugarNursing
//
//  Created by Ian on 14-11-25.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMessageViewController : UIViewController
<
UITableViewDataSource,
UITableViewDelegate
>



@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end
