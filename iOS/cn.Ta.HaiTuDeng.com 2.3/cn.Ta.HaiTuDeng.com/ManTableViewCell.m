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
    NSString *name = [[NSUserDefaults standardUserDefaults]objectForKey:@"name"];
    NSString *pathComponent = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [NSString stringWithFormat:@"%@/%@",pathComponent,name];
    NSString *imageFilePath = [path stringByAppendingPathComponent:model.Id];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:imageFilePath]) {
        //NSData *data = [NSData dataWithContentsOfFile:_filename];
        [self.iconImage setImageWithURL:[NSURL URLWithString:imageFilePath]placeholderImage:[UIImage imageNamed:@"Snip20160317_2"]];
        
    }
    [self.iconImage setImageWithURL:[NSURL URLWithString:model.Imageurl]placeholderImage:[UIImage imageNamed:@"Snip20160317_2"]];
    
    // 将取得的图片写入本地的沙盒中，其中0.5表示压缩比例，1表示不压缩，数值越小压缩比例越大
    BOOL success = [UIImageJPEGRepresentation(self.iconImage.image, 0.5) writeToFile:imageFilePath  atomically:YES];
    if (success){
        
        NSLog(@"写入本地成功");
    }
    
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
