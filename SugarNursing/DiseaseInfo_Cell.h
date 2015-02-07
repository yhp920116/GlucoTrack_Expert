//
//  DiseaseInfo_Cell.h
//  SugarNursing
//
//  Created by Ian on 14-12-10.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LinesLabel.h"
#import "MediRecord.h"

@interface DiseaseInfo_Cell : UITableViewCell
<
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (weak, nonatomic) IBOutlet LinesLabel *hospitalLabel;
@property (weak, nonatomic) IBOutlet LinesLabel *cureConditionLabel;
@property (weak, nonatomic) IBOutlet LinesLabel *medicalHistoryLabel;
@property (weak, nonatomic) IBOutlet LinesLabel *cureScheme;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewConstraintHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewConstraintWidth;


@property (assign, nonatomic) NSInteger section;

@property (strong, nonatomic) MediRecord *record;
@property (weak, nonatomic) id delegate;


- (void)configureCellWithMediRecord:(MediRecord *)mediRecord;
@end
