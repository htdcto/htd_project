//
//  MEViewController.m
//  SwipeGestureRecognizer
//
//  Created by piupiupiu on 16/7/14.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import "MEViewController.h"
#import "InformationViewController.h"
#import "StatusViewController.h"
#import "MainAryViewController.h"
#import "ViewController.h"

@interface MEViewController ()

@end

@implementation MEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIImageView *imageview2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-40,self.view.frame.size.height+20,80,40)];
    [imageview2 setImage:[UIImage imageNamed:@"自己"]];
   
    
    [self.view addSubview:imageview2];
    UIView *swipeView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-55, 20, 90, 90) ];
    
    swipeView.backgroundColor = [UIColor colorWithRed:(242/255.0f) green:(242/255.0f) blue:(242/255.0f) alpha:0.5];
    swipeView.layer.cornerRadius=45;
    swipeView.layer.masksToBounds=YES;
    swipeView.layer.borderWidth=5;
    swipeView.layer.borderColor=[[UIColor colorWithRed:0.52 green:0.09 blue:0.07 alpha:0.5]CGColor];
    [self.view addSubview:swipeView];
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    //设置轻扫的方向
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight; //默认向右
    [swipeView addGestureRecognizer:swipeGesture];
    
    //添加轻扫手势
    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    //设置轻扫的方向
    swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft; //默认向左
    [swipeView addGestureRecognizer:swipeGestureLeft];
    
    //添加轻扫手势
    UISwipeGestureRecognizer *swipeGestureDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    //设置轻扫的方向
    swipeGestureDown.direction = UISwipeGestureRecognizerDirectionDown; //默认向下
    [swipeView addGestureRecognizer:swipeGestureDown];
}
-(void)swipeGesture:(id)sender
{
    UISwipeGestureRecognizer *swipe = sender;
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight)
    {
        StatusViewController *ZTVC = [[StatusViewController alloc]init];
        CATransition *animation = [CATransition animation];
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionMoveIn;
        animation.subtype = kCATransitionFromLeft;
        [self.view.window.layer addAnimation:animation forKey:nil];
        
       [self presentViewController:ZTVC animated:YES completion:nil];
        
        //向右轻扫
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        MainAryViewController *ZXVC = [[MainAryViewController alloc]init];
        CATransition *animation = [CATransition animation];
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionMoveIn;
        animation.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:animation forKey:nil];;
        [self presentViewController:ZXVC animated:YES completion:nil];
        //向左轻扫
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionDown)
    {
        InformationViewController *HOVC = [[InformationViewController alloc]init];
        CATransition *animation = [CATransition animation];
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionMoveIn;
        animation.subtype = kCATransitionFromBottom;
        [self.view.window.layer addAnimation:animation forKey:nil];
        [self presentViewController:HOVC animated:YES completion:nil];
        //向下轻扫
    }
}
- (IBAction)tuchu:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //移除UserDefaults中存储的用户信息
    [userDefaults removeObjectForKey:@"name"];
    [userDefaults removeObjectForKey:@"password"];
    [userDefaults removeObjectForKey:@"Ttel"];
    [userDefaults synchronize];
    
    ViewController *VC = [[ViewController alloc]init];
    
    [self presentViewController:VC animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
