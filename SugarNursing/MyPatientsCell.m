//
//  MyPatientsCell.m
//  SugarNursing
//
//  Created by Ian on 14-11-21.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "MyPatientsCell.h"

@implementation MyPatientsCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)configureCellWithParameter:(NSDictionary *)parameter
{
    
    NSString *imageString = [parameter objectForKey:@"image"];
    
    
    [self.patientImageView setImage:[self stringToImage:imageString]];
    [self.nameLabel setText:[parameter objectForKey:@"name"]];
    [self.genderLabel setText:[parameter objectForKey:@"gender"]];
    [self.ageLabel setText:[parameter objectForKey:@"age"]];
    [self.serviceRankLabel setText:[NSString stringWithFormat:@"服务等级: %@",[parameter objectForKey:@"serviceRank"]]];
    [self.bindingDateLabel setText:[NSString stringWithFormat:@"绑定时间: %@",[parameter objectForKey:@"bindingDate"]]];
    
    [self.stateLabel setText:[parameter objectForKey:@"state"]];
}




#pragma mark - base64 字符串转图片格式
- (UIImage *)stringToImage:(NSString *)string
{
    if (string && string.length > 0)
    {
        
        NSData *data = [[NSData alloc] initWithBase64Encoding:string];
        UIImage *image = [UIImage imageWithData:data];
        return image;
    }
    
    return nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
