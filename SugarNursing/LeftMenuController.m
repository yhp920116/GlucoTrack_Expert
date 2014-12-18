//
//  LeftMenuController.m
//  SugarNursing
//
//  Created by Dan on 14-11-5.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "LeftMenuController.h"
#import "LeftMenuCell.h"
#import "MemberInfoCell.h"
#import "UIStoryboard+Storyboards.h"
#import "MemberCenterViewController.h"
#import "AppDelegate+UserLogInOut.h"
#import "TestTrackerViewController.h"


@interface LeftMenuController ()

@property (nonatomic, strong) NSArray *menuArray;
@property (nonatomic) NSInteger selectedIndex;

@end

@implementation LeftMenuController

- (void)awakeFromNib
{
    [super awakeFromNib];
    _selectedIndex = -1;
    if (!self.menuArray) {
        self.menuArray  = @[
                            @[NSLocalizedString(@"My Patient",),@"IconMyPatient"],
                            @[NSLocalizedString(@"My Hosting",),@"IconMyHosting"],
                            @[NSLocalizedString(@"My Takeover",),@"IconMyTakeover"],
                            @[NSLocalizedString(@"My Message",),@"IconMyMessage"],
                            @[NSLocalizedString(@"Member Center",),@"IconMemberCenter"],
                            @[NSLocalizedString(@"System Set",),@"IconSystemSet"],
                            @[NSLocalizedString(@"Log Out",),@"IconEmpty"],
                            ];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureMenu];
    
    
}

- (void)configureMenu
{
    self.leftMenu.dataSource = self;
    self.leftMenu.delegate = self;
    
    self.leftMenu.rowHeight = UITableViewAutomaticDimension;
    self.leftMenu.estimatedRowHeight = 100;
}

#pragma mark - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuArray.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 140;
    } else return 52;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 ) {
        MemberInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberInfoCell" forIndexPath:indexPath];
        return cell;
    }
    
    LeftMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftMenuCell" forIndexPath:indexPath];
    [cell configureCellWithIconName:self.menuArray[indexPath.row-1][1] LabelText:self.menuArray[indexPath.row-1][0]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.selectedIndex == indexPath.row) {
        [self.sideMenuViewController hideMenuViewController];
        return;
    } else {
        self.selectedIndex = indexPath.row;
        [self switchToViewControllerAtIndex:self.selectedIndex];
    }

}

- (void)switchToViewControllerAtIndex:(NSInteger)index
{
    
    switch (index)
    {
        case 0:
            break;
        case 1:
            [self.sideMenuViewController setContentViewController:[[UIStoryboard myPatientStoryboard] instantiateViewControllerWithIdentifier:@"MyPatientNav"] animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        
            break;
        case 2:
            [self.sideMenuViewController setContentViewController:[[UIStoryboard myHostingStoryboard] instantiateViewControllerWithIdentifier:@"MyHostingNav"] animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 3:
            [self.sideMenuViewController setContentViewController:[[UIStoryboard myTakeoverStoryboard] instantiateViewControllerWithIdentifier:@"MyTakeoverNav"] animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 4:
            [self.sideMenuViewController setContentViewController:[[UIStoryboard myMessageStoryboard] instantiateViewControllerWithIdentifier:@"MyMessageNav"] animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 5:
            [self.sideMenuViewController setContentViewController:[[UIStoryboard memberCenterStoryboard] instantiateViewControllerWithIdentifier:@"MemberCenterNav"] animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 6:
            [self.sideMenuViewController setContentViewController:[[UIStoryboard systemSetStoryboard] instantiateViewControllerWithIdentifier:@"SystemSetNav"] animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 7:
            [AppDelegate userLogOut];
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
