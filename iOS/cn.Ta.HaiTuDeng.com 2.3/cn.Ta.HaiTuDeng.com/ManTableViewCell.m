//
//  ManTableViewCell.m
//  FlowersMan
//
//  Created by 屠夫 on 16/3/10.
//  Copyright (c) 2016年 Soul. All rights reserved.
//

#import "ManTableViewCell.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"

@implementation ManTableViewCell
-(void)loadDataFromModel:(MainModel *)model
{
    
    [self.iconImage setImageWithURL:[NSURL URLWithString:model.Imageurl]placeholderImage:[UIImage imageNamed:@"Snip20160317_2"]];
    
    //标题
    /*biaoLable;
     timeLabel;
     neiLabel;
     fuLable;*/
    
    self.biaoLable.text = model.Title;
    self.timeLabel.text = model.Uptime;
    self.neiLabel.text = model.Introduction;
    
    //详情
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
