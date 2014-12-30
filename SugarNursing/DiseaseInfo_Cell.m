//
//  DiseaseInfo_Cell.m
//  SugarNursing
//
//  Created by Ian on 14-12-10.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "DiseaseInfo_Cell.h"

@implementation DiseaseInfo_Cell

- (void)awakeFromNib
{
    
}


- (void)configureCellWithDictionary:(NSDictionary *)dic
{
    self.hospitalLabel.text = [dic objectForKey:@"hospital"];
    self.cureConditionLabel.text = [dic objectForKey:@"cureCondition"];
    self.medicalHistoryLabel.text = [dic objectForKey:@"medicalHistory"];
    self.cureScheme.text = [dic objectForKey:@"cureScheme"];
    
}

@end
