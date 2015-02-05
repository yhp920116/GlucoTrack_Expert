//
//  MyHostingViewController.h
//  SugarNursing
//
//  Created by Ian on 14-11-25.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyHostingViewController : UIViewController
<
UITableViewDataSource,
UITableViewDelegate,
UITabBarDelegate
>
@property (weak, nonatomic) IBOutlet UIView *hostingView;

@property (weak, nonatomic) IBOutlet UITableView *hostingTableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *hostingSegment;


@end
