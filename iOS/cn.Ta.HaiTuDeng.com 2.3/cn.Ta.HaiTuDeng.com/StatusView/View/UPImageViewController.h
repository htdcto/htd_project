//
//  UPImageViewController.h
//  cn.Ta.HaiTuDeng.com
//
//  Created by piupiupiu on 16/8/7.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UPImageViewController : UIViewController

//选择表情框
@property (strong, nonatomic) IBOutlet UIScrollView *BqScrollView;
//选择状态图片
@property (strong, nonatomic) IBOutlet UIButton *StatusBtn;
//表情图片
@property (strong, nonatomic) IBOutlet UIImageView *BQimage;
@end