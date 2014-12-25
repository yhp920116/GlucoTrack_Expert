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
    NSArray *_serviceArray;
    NSArray *titleArray;
}


@property (strong, readwrite, nonatomic) REMenu *menu;

@property (strong, nonatomic) UIButton *sectionTitleButton;

@end

@implementation MyPatientsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    
    [self layoutView];
    
    
    
}


- (void)initData
{
    
    UIImage *image = [UIImage imageNamed:@"019"];
    
    _serviceArray=@[@{@"name":@"思思",@"age":@"35",@"gender":@"女",@"serviceRank":@"低",@"bindingDate":@"1979-02-08",@"state":@"接管中~",@"image":image},
                    @{@"name":@"王子运",@"age":@"35",@"gender":@"男",@"serviceRank":@"低",@"bindingDate":@"1979-02-08",@"state":@"接管中~",@"image":image},
                    
                    @{@"name":@"王诗雅",@"age":@"49",@"gender":@"女",@"serviceRank":@"低",@"bindingDate":@"1979-02-08",@"state":@"接管中~",@"image":image},
                    
                    @{@"name":@"李楠钰",@"age":@"28",@"gender":@"男",@"serviceRank":@"低",@"bindingDate":@"1979-02-08",@"state":@"接管中~",@"image":image},
                    
                    @{@"name":@"王柄灰",@"age":@"53",@"gender":@"男",@"serviceRank":@"低",@"bindingDate":@"1979-02-08",@"state":@"接管中~",@"image":image},
                    ];
    
    
    
    titleArray = [NSArray arrayWithObjects:NSLocalizedString(@"The binding time inverted order", nil),
                  NSLocalizedString(@"The binding time plain sequence", nil),
                  NSLocalizedString(@"Age from old to young", nil),
                  NSLocalizedString(@"Age from young to old", nil),
                  NSLocalizedString(@"Service level from high to low", nil),
                  NSLocalizedString(@"Service level from low to high", nil),
                  NSLocalizedString(@"Only takeover", nil),
                  NSLocalizedString(@"Only Hosting", nil),
                  nil];
}

- (void)layoutView
{
    
    self.sectionTitleButton = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                         0,
                                                                         320,
                                                                         40)];
    self.sectionTitleButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.sectionTitleButton setBackgroundColor:[UIColor colorWithRed:44/255.0
                                                                green:125/255.0
                                                                 blue:198/255.0
                                                                alpha:1.0]];
    
    [self.sectionTitleButton setTitleColor:[UIColor colorWithRed:255.0/255.0
                                                           green:255.0/255.0
                                                            blue:255.0/255.0
                                                           alpha:1.0]
                                  forState:UIControlStateNormal];
    
    [self.sectionTitleButton addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.sectionTitleButton setTitle:NSLocalizedString(@"Click this select mode of sort", nil)
                             forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    NSIndexPath *indexPath = [self.mainTableView indexPathForSelectedRow];
    if (indexPath)
    {
        [self.mainTableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
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
    return _serviceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"MyPatientsCell";
    MyPatientsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [self configureCell:cell parameter:_serviceArray[indexPath.row]];
    return cell;
}

- (void)configureCell:(MyPatientsCell *)cell parameter:(NSDictionary *)dic
{
    
    
    UIImage *image = [dic objectForKey:@"image"];
    
    [cell.patientImageView setImage:image];
    [cell.nameLabel setText:[dic objectForKey:@"name"]];
    [cell.genderLabel setText:[dic objectForKey:@"gender"]];
    [cell.ageLabel setText:[dic objectForKey:@"age"]];
    [cell.serviceRankLabel setText:[dic objectForKey:@"serviceRank"]];
    [cell.bindingDateLabel setText:[dic objectForKey:@"bindingDate"]];
    
    [cell.stateLabel setText:[dic objectForKey:@"state"]];
}



- (IBAction)back:(UIStoryboardSegue *)sender
{
    
}

@end
