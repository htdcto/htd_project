//
//  StatusViewController.h
//  cn.Ta.HaiTuDeng.com
//
//  Created by piupiupiu on 16/7/20.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *BJImage;
@property  NSInteger Ucount;
@property  NSInteger Tcount;

-(void)backImageDown;
-(void)setPieChartView;
@end
