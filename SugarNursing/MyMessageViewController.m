//
//  MyMessageViewController.m
//  SugarNursing
//
//  Created by Ian on 14-11-25.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "MyMessageViewController.h"
#import "MyMessageCell.h"

@interface MyMessageViewController ()
{
    NSArray *_serverData;
    NSInteger _selectIndexRow;
}
@end

@implementation MyMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _serverData = @[@{@"title":@"审核结果",@"date":@"16:12",@"content":@"您于12/12/01提交的个人资料的修改已经通过审核。",@"image":[UIImage imageNamed:@"103"]},
                    @{@"title":@"系统公告",@"date":@"16:12",@"content":@"一个健康的身体，一份称心的工作，一位知心的爱人，一帮信赖的朋友，一项投入的事业，一种宁静的心境，一份快乐的心情，只是因为：懂得感恩!糖无忌祝您感恩节快乐！",@"image":[UIImage imageNamed:@"100"]}
                    ];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    NSIndexPath *indexPath = [self.myTableView indexPathForSelectedRow];
    if (indexPath)
    {
        [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _serverData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MyMessageCell";
    
    MyMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [self configureCellWithCell:cell parameter:[_serverData objectAtIndex:indexPath.row]];
    return cell;
    
}

- (void)configureCellWithCell:(MyMessageCell *)cell parameter:(NSDictionary *)dic
{
    
    NSString *title = [dic objectForKey:@"title"];
    cell.msgTitleLabel.text = title;
    
    NSString *date = [dic objectForKey:@"date"];
    cell.msgDateLabel.text = date;
    
    NSString *content = [dic objectForKey:@"content"];
    cell.msgContentLabel.text = content;
    
    
    UIImage *image =[dic objectForKey:@"image"];
    [cell.msgImageView setBackgroundColor:[UIColor clearColor]];
    [cell.msgImageView setImage:image];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectIndexRow = indexPath.row;
    [self performSegueWithIdentifier:@"goMessageInfo" sender:nil];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    UIViewController *vc = (UIViewController *)[segue destinationViewController];
    if (_selectIndexRow == 0)
    {
        vc.title = @"审核结果";
    }
    else
    {
        vc.title = @"系统公告";
    }
    
}

- (IBAction)back:(UIStoryboardSegue *)sender
{
    
}

@end
