//
//  DiseaseInfo_Cell.m
//  SugarNursing
//
//  Created by Ian on 14-12-10.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "DiseaseInfo_Cell.h"
#import <UIImageView+AFNetworking.h>
#import "MediAttach.h"

//static CGFloat kMaterialImagelength = 40;

@implementation DiseaseInfo_Cell
- (void)awakeFromNib
{
    
}


- (void)configureCellWithMediRecord:(MediRecord *)mediRecord;
{
//    for (UIView *view in self.materialContentView.subviews)
//    {
//        if ([view isKindOfClass:[UIImageView class]])
//        {
//            [view removeFromSuperview];
//        }
//    }
    
    self.hospitalLabel.text = [self isEmptyString:mediRecord.diagHosp];
    self.cureConditionLabel.text = [self isEmptyString:mediRecord.treatment];
    self.medicalHistoryLabel.text = [self isEmptyString:mediRecord.mediRecode];
    self.cureScheme.text = [self isEmptyString:mediRecord.treatPlan];
    
    
    
    self.record = mediRecord;
    
    NSInteger attCount = mediRecord.mediAttach.count;
    
    
    
    if (attCount<=0)
    {
        self.collectionViewConstraintHeight.constant = 0.0f;
    }
    else if (attCount <=4)
    {
        self.collectionViewConstraintHeight.constant = 50;
    }
    else if (attCount <=8)
    {
        self.collectionViewConstraintHeight.constant = 100;
    }
    else
    {
        self.collectionViewConstraintHeight.constant = 150;
    }
    
    
    NSLog(@"%@",self.collectionView);   
    [self.collectionView reloadData];
    
    
}


- (NSString *)isEmptyString:(NSString *)string
{
    
    if (!string || string.length <= 0)
    {
        return @"无";
    }
    
    return string;
}


#pragma mark - UICollectionView DataSource & Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.record.mediAttach.count;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ImageCell";
    
    NSOrderedSet *attArray = self.record.mediAttach;
    MediAttach *attach = attArray[indexPath.row];
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    UIImageView *attImageView = (UIImageView *)[cell viewWithTag:101];
    [attImageView setImageWithURL:[NSURL URLWithString:attach.attachPath] placeholderImage:nil];
    return cell;
}



@end
