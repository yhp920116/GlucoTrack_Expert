//
//  MyPatientsViewController.m
//  SugarNursing
//
//  Created by Ian on 14-11-21.
//  Copyright (c) 2014年 ;. All rights reserved.
//

#import "MyPatientsViewController.h"
#import <REMenu.h>
#import "GCRequest.h"
#import "NSString+UserCommon.h"
#import <UIAlertView+AFNetworking.h>

@interface MyPatientsViewController ()
{
    NSMutableArray *_serviceArray;    //从数据库获取的数据
    NSMutableArray *_sourceArray;     //用于排序后展示
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

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    NSIndexPath *indexPath = [self.mainTableView indexPathForSelectedRow];
    if (indexPath)
    {
        [self.mainTableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%@",[NSString sessionID]);
    NSLog(@"%@",[NSString sessionToken]);
    
    NSDictionary *parameters = @{@"method":@"queryPatientList",
                                 @"sessionId":[NSString sessionID],
                                 @"exptId":[NSString exptId],
                                 @"relationFlag":@"00",
                                 @"orderArg":@"boundTime",
                                 @"order":@"desc",
                                 @"start":@"1",
                                 @"size":@"10",
                                 @"sign":@"sign"};
    
    NSURLSessionDataTask *task = [GCRequest getPatientListWithParameters:parameters
                                                                block:^(NSDictionary *responseData, NSError *error) {
                                                                    
                                                                    NSLog(@"%@",responseData);
                                                                }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
}


- (void)initData
{
    
    UIImage *image = [UIImage imageNamed:@"019"];
    
    _serviceArray=[@[@{@"name":@"思思",@"age":@"35",@"gender":@"女",@"serviceRank":@"高",@"bindingDate":@"1979-02-08",@"state":@"接管中~",@"image":image},
                    @{@"name":@"王子运",@"age":@"35",@"gender":@"男",@"serviceRank":@"中",@"bindingDate":@"1973-02-08",@"state":@"接管中~",@"image":image},
                    
                    @{@"name":@"王诗雅",@"age":@"49",@"gender":@"女",@"serviceRank":@"高",@"bindingDate":@"1979-02-08",@"state":@"托管中~",@"image":image},
                    
                    @{@"name":@"李楠钰",@"age":@"28",@"gender":@"男",@"serviceRank":@"低",@"bindingDate":@"1973-02-08",@"state":@"接管中~",@"image":image},
                    
                    @{@"name":@"王柄灰",@"age":@"53",@"gender":@"男",@"serviceRank":@"低",@"bindingDate":@"1923-02-08",@"state":@"托管中~",@"image":image},
                    ] mutableCopy];
    
    
    
    titleArray = [NSArray arrayWithObjects:NSLocalizedString(@"The binding time inverted order", nil),
                  NSLocalizedString(@"The binding time plain sequence", nil),
                  NSLocalizedString(@"Age from old to young", nil),
                  NSLocalizedString(@"Age from young to old", nil),
                  NSLocalizedString(@"Service level from high to low", nil),
                  NSLocalizedString(@"Service level from low to high", nil),
                  NSLocalizedString(@"Only takeover", nil),
                  NSLocalizedString(@"Only Hosting", nil),
                  nil];
    
    _sourceArray = [NSMutableArray arrayWithArray:_serviceArray];
    
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
        
        
        
        [itemArray addObject:homeItem];
    }
    
    self.menu = [[REMenu alloc] initWithItems:itemArray];
    
    [self.menu showFromNavigationController:self.navigationController];
}

- (void)remenuItemDidSelectRow:(NSInteger)row
{
    [self.sectionTitleButton setTitle:[titleArray objectAtIndex:row] forState:UIControlStateNormal];
    
    [self sortListWithSelectRow:row];
    
    [self.menu close];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"goSinglePatient" sender:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _sourceArray.count;
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
    [self configureCell:cell parameter:_sourceArray[indexPath.row]];
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


- (void)sortListWithSelectRow:(NSInteger)row
{
    switch (row)
    {
        case 0:
            [self sortArray:_serviceArray firstCondition:@"bindingDate" firstAscending:NO secondCondition:nil secondAscending:NO];
            break;
        case 1:
            [self sortArray:_serviceArray firstCondition:@"bindingDate" firstAscending:YES secondCondition:nil secondAscending:NO];
            break;
        case 2:
            [self sortArray:_serviceArray firstCondition:@"age" firstAscending:NO secondCondition:nil secondAscending:NO];
            break;
        case 3:
            [self sortArray:_serviceArray firstCondition:@"age" firstAscending:YES secondCondition:nil secondAscending:NO];
            break;
        case 4:
            [self sortArray:_serviceArray firstCondition:@"serviceRank" firstAscending:NO secondCondition:nil secondAscending:NO];
            break;
        case 5:
            [self sortArray:_serviceArray firstCondition:@"serviceRank" firstAscending:YES secondCondition:nil secondAscending:NO];
            break;
        case 6:
            [self filtrateArrayOnlyKey:@"state" value:@"接管中~"];
            break;
        case 7:
            [self filtrateArrayOnlyKey:@"state" value:@"托管中~"];
            break;
        default:
            break;
    }
    
    [self.mainTableView reloadData];
}

- (void)filtrateArrayOnlyKey:(NSString *)key value:(NSString *)value
{
    _sourceArray = [NSMutableArray arrayWithArray:_serviceArray];
    
    [_serviceArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dic = (NSDictionary *)obj;
        NSString *string = [dic objectForKey:key];
        if (![string isEqualToString:value])
        {
            [_sourceArray removeObject:obj];
        }
    }];
    
    [self sortArray:_sourceArray firstCondition:@"bindingDate" firstAscending:NO secondCondition:nil secondAscending:NO];
}

- (void)sortArray:(NSArray *)array firstCondition:(NSString *)first firstAscending:(BOOL)firstAscending secondCondition:(NSString *)second  secondAscending:(BOOL)secondAscending
{
    if (!first || first.length <= 0)  return;
    
    NSArray *sortDescriptors;
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:first ascending:firstAscending];
    
    if (second || second.length>0)
    {
        NSSortDescriptor *sorter2 = [[NSSortDescriptor alloc] initWithKey:second ascending:secondAscending];
        sortDescriptors = [[NSArray alloc] initWithObjects:sorter,sorter2,nil];
    }
    else
    {
        sortDescriptors = [[NSArray alloc] initWithObjects:sorter,nil];
    }
    
    NSArray *sortArray = [array sortedArrayUsingDescriptors:sortDescriptors];
    
    _sourceArray = [NSMutableArray arrayWithArray:sortArray];
}


- (IBAction)back:(UIStoryboardSegue *)sender
{
    
}

@end
