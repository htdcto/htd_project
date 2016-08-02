//
//  MainAryViewController.h
//  cn.Ta.HaiTuDeng.com
//
//  Created by piupiupiu on 16/7/20.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTableViewCell.h"

@interface MainAryViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *CountDown;// 倒计时
@property (weak, nonatomic) IBOutlet UIButton *ClickBtn;//点击按钮

@property (strong, nonatomic) IBOutlet UIImageView *BJimge;//背景图

@property (nonatomic,strong)NSMutableArray *dataArray;//数据源


@property (strong, nonatomic) IBOutlet UIButton *imageBtn;//上传背景图片按钮

@property (nonatomic, strong) NSDictionary *dic;//账号单例

@property (nonatomic,strong)UIView *swipeView;
//设置网址
-(void)setMyUrl;

//请求数据
-(void)loadData;
@end
