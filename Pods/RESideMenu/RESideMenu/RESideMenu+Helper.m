//
//  RESideMenu+Helper.m
//  Pods
//
//  Created by Dan on 14-11-13.
//
//

#import "RESideMenu+Helper.h"
#import "BEMSimpleLineGraphView.h"

@implementation RESideMenu (Helper)

- (void)disableExpensiveLayout
{
    for (UIView *subView in [self.contentViewController.view subviews]) {
        if ([subView isKindOfClass:[BEMSimpleLineGraphView class]]) {
            BEMSimpleLineGraphView *graphView = (BEMSimpleLineGraphView *)subView;
            graphView.avoidLayoutSubviews = YES;
        }
    }
}

- (void)enableExpensiveLayout
{
    for (UIView *subView in [self.contentViewController.view subviews]) {
        if ([subView isKindOfClass:[BEMSimpleLineGraphView class]]) {
            BEMSimpleLineGraphView *graphView = (BEMSimpleLineGraphView *)subView;
            graphView.avoidLayoutSubviews = NO;
        }
    }
}

@end
