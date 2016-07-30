//
//  InformationViewController.m
//  SwipeGestureRecognizer
//
//  Created by piupiupiu on 16/7/14.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import "InformationViewController.h"


@interface InformationViewController ()

@end

@implementation InformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        self.view.backgroundColor = [UIColor redColor];
    
    UIImageView *imageview2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-70,20,90,28)];
    [imageview2 setImage:[UIImage imageNamed:@"资讯"]];
    
    [self.view addSubview:imageview2];
    
    UIView *swipeView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-105, 20, 90, 90) ];
    
    swipeView.backgroundColor = [UIColor colorWithRed:(242/255.0f) green:(242/255.0f) blue:(242/255.0f) alpha:0.5];
    swipeView.layer.cornerRadius=45;
    swipeView.layer.masksToBounds=YES;
    swipeView.layer.borderWidth=5;
    swipeView.layer.borderColor=[[UIColor colorWithRed:0.52 green:0.09 blue:0.07 alpha:0.5]CGColor];
    [self.view addSubview:swipeView];
    
    //添加轻扫手势
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    //设置轻扫的方向
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight; //默认向右
    [swipeView addGestureRecognizer:swipeGesture];
    
    //添加轻扫手势
    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    //设置轻扫的方向
    swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft; //默认向右
    [swipeView addGestureRecognizer:swipeGestureLeft];
    
    //添加轻扫手势
    UISwipeGestureRecognizer *swipeGestureUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    //设置轻扫的方向
    swipeGestureUp.direction = UISwipeGestureRecognizerDirectionUp; //默认向上
    [swipeView addGestureRecognizer:swipeGestureUp];
}
-(void)swipeGesture:(id)sender
{
    UISwipeGestureRecognizer *swipe = sender;
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        NSLog(@"切换视图成功");
        MainAryViewController *ZXVC = [[MainAryViewController alloc]init];
       CATransition *animation = [CATransition animation];
       // animation.duration = 1.0;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        //animation.type = @"rippleEffect";
       animation.type = kCATransitionMoveIn;
        animation.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:animation forKey:nil];
       // [ZXVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:ZXVC animated:NO completion:nil];
        
       
        //向左轻扫
        
        
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight)
    {
        NSLog(@"切换视图成功");
        StatusViewController *ZTVC = [[StatusViewController alloc]init];
        CATransition *animation = [CATransition animation];
        
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        
        animation.type = kCATransitionMoveIn;
        animation.subtype = kCATransitionFromLeft;
        [self.view.window.layer addAnimation:animation forKey:nil];
        
        
        [self presentViewController:ZTVC animated:NO completion:nil];
        //向右轻扫
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"切换视图成功");
        MEViewController *MEVC = [[MEViewController alloc]init];
        CATransition *animation = [CATransition animation];
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionMoveIn;
        animation.subtype = kCATransitionFromTop;
        [self.view.window.layer addAnimation:animation forKey:nil];
        [self presentViewController:MEVC animated:NO completion:nil];
        //向下轻扫
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
