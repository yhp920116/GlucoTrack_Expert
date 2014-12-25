//
//  RootViewController.m
//  SugarNursing
//
//  Created by Dan on 14-11-5.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "RootViewController.h"
#import "UIStoryboard+Storyboards.h"
#import "FXBlurView.h"

@interface RootViewController ()
@property (weak, nonatomic) IBOutlet FXBlurView *blurView;

@end

@implementation RootViewController

- (void)awakeFromNib
{
    self.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    self.contentViewShadowColor = [UIColor blackColor];
    self.contentViewShadowOffset = CGSizeMake(0, 0);
    self.contentViewShadowOpacity = 0.6;
    self.contentViewShadowRadius = 12;
    self.contentViewShadowEnabled = YES;
    
    self.contentViewController = [[UIStoryboard myPatientStoryboard] instantiateViewControllerWithIdentifier:@"MyPatientNav"];
    self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftMenu"];
    self.rightMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RightMenu"];
    self.delegate = self;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.blurView.blurRadius = 30;
}

- (void)sideMenu:(RESideMenu *)sideMenu didRecognizePanGesture:(UIPanGestureRecognizer *)recognizer
{
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
