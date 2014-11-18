//
//  ServiceCenterViewController.h
//  SugarNursing
//
//  Created by Ian on 14-11-17.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceCenterViewController : UIViewController
<
UITableViewDataSource,
UITableViewDelegate
>


@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end
