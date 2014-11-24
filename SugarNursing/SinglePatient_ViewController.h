//
//  SinglePatient_ViewController.h
//  糖博士
//
//  Created by Ian on 14-11-12.
//  Copyright (c) 2014年 Ian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    PushDownViewStateClose = 95537,
    PushDownViewStateOpen
}
PushDownViewState;

@interface SinglePatient_ViewController : UIViewController
<
UITableViewDataSource,
UITableViewDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end
