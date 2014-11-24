//
//  MyPatientsViewController.m
//  SugarNursing
//
//  Created by Ian on 14-11-21.
//  Copyright (c) 2014年 ;. All rights reserved.
//

#import "MyPatientsViewController.h"
#import <REMenu.h>

@interface MyPatientsViewController ()
{
    NSMutableDictionary *serviceDic;
    NSArray *titleArray;
}


@property (strong, readwrite, nonatomic) REMenu *menu;

@property (strong, nonatomic) UIButton *sectionTitleButton;

@end

@implementation MyPatientsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    titleArray = [NSArray arrayWithObjects:@"绑定时间倒序",@"绑定时间顺序",@"年龄从大到小",@"年龄从小到大",@"服务等级从高到低",@"服务等级从低到高",@"只看接管",@"只看托管", nil];
    
    serviceDic = [NSMutableDictionary dictionary];
    
    UIImage *image = [UIImage imageNamed:@"001"];
    
    [serviceDic setObject:[self imageToString:image] forKey:@"image"];
    
    [serviceDic setObject:@"王小二" forKey:@"name"];
    [serviceDic setObject:@"64" forKey:@"age"];
    [serviceDic setObject:@"male" forKey:@"gender"];
    [serviceDic setObject:@"低" forKey:@"serviceRank"];
    [serviceDic setObject:@"14/11/9" forKey:@"bindingDate"];
    [serviceDic setObject:@"接管中~" forKey:@"state"];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.automaticallyAdjustsScrollViewInsets = NO;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    self.sectionTitleButton = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                    0,
                                                                    320,
                                                                    40)];
    self.sectionTitleButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.sectionTitleButton setBackgroundColor:[UIColor colorWithRed:53/255.0
                                                                green:53/255.0
                                                                 blue:52/255.0
                                                                alpha:1.0]];
    
    [self.sectionTitleButton setTitleColor:[UIColor colorWithRed:128/255.0
                                                          green:126/255.0
                                                           blue:124/255.0
                                                          alpha:1.0]
                                  forState:UIControlStateNormal];
    
    [self.sectionTitleButton addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.sectionTitleButton setTitle:@"点击选择排序模式" forState:UIControlStateNormal];
    
    return self.sectionTitleButton;
}

- (void)toggleMenu
{
    NSMutableArray *itemArray = [NSMutableArray array];
    
    
    for (int i=0 ; i<titleArray.count; i++)
    {
        REMenuItem *homeItem = [[REMenuItem alloc] initWithTitle:[titleArray objectAtIndex:i]
                                                        subtitle:nil
                                                           image:nil
                                                highlightedImage:nil
                                                          action:^(REMenuItem *item) {
                                                              [self remenuItemDidSelectRow:i];
                                                          }];
        
        
//        UIView *customView = [[UIView alloc] init];
//        customView.backgroundColor = [UIColor blueColor];
//        customView.alpha = 0.4;
//        REMenuItem *customViewItem = [[REMenuItem alloc] initWithCustomView:customView action:^(REMenuItem *item) {
//            NSLog(@"Tap on customView");
//        }];
        
        [itemArray addObject:homeItem];
    }
    
    self.menu = [[REMenu alloc] initWithItems:itemArray];
    
    [self.menu showFromNavigationController:self.navigationController];
}

- (void)remenuItemDidSelectRow:(NSInteger)row
{
    [self.sectionTitleButton setTitle:[titleArray objectAtIndex:row] forState:UIControlStateNormal];
    
    [self.menu close];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"goSinglePatient" sender:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier = @"MyPatientsCell";
    MyPatientsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell configureCellWithParameter:serviceDic];
    
    return cell;
}



- (NSString *)imageToString:(UIImage *)image
{
    if (image && image != nil)
    {
        
        NSData *data = UIImageJPEGRepresentation(image, 1.0f);
        NSString *imageString = [data base64Encoding];
        return imageString;
    }
    
    return @"";
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
