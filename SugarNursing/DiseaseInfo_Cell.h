//
//  DiseaseInfo_Cell.h
//  SugarNursing
//
//  Created by Ian on 14-12-10.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DiseaseInfo_Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *hospitalLabel;
@property (weak, nonatomic) IBOutlet UILabel *cureConditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *medicalHistoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *cureScheme;

- (void)configureCellWithDictionary:(NSDictionary *)dic;

@end
