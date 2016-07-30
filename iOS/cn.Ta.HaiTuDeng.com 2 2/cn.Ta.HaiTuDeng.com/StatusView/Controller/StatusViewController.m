//
//  StatusViewController.m
//  cn.Ta.HaiTuDeng.com
//
//  Created by piupiupiu on 16/7/20.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import "StatusViewController.h"

@interface StatusViewController ()<UIImagePickerControllerDelegate>

@end

@implementation StatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    [self backImage];
    
    UIImageView *imageview2 = [[UIImageView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height/2-40,40,80)];
    [imageview2 setImage:[UIImage imageNamed:@"状态"]];
    
    [self.view addSubview:imageview2];
    
    UIView *swipeView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-55, 20, 90, 90) ];
    
    swipeView.backgroundColor = [UIColor colorWithRed:(242/255.0f) green:(242/255.0f) blue:(242/255.0f) alpha:0.5];
    swipeView.layer.cornerRadius=45;
    swipeView.layer.masksToBounds=YES;
    swipeView.layer.borderWidth=5;
    swipeView.layer.borderColor=[[UIColor colorWithRed:0.52 green:0.09 blue:0.07 alpha:0.5]CGColor];
    [self.view addSubview:swipeView];
    
    //添加轻扫手势
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    //设置轻扫的方向
    swipeGesture.direction = UISwipeGestureRecognizerDirectionUp; //默认向上
    [swipeView addGestureRecognizer:swipeGesture];
    
    //添加轻扫手势
    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    //设置轻扫的方向
    swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft; //默认向右
    [swipeView addGestureRecognizer:swipeGestureLeft];
    
    //添加轻扫手势
    UISwipeGestureRecognizer *swipeGestureDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    //设置轻扫的方向
    swipeGestureDown.direction = UISwipeGestureRecognizerDirectionDown; //默认向下
    [swipeView addGestureRecognizer:swipeGestureDown];
    
    //**************************背景
    //****************我的背景图片********************
    
    


}
-(void)backImage
{
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDefaults objectForKey:@"name"];
    NSString *Tname= [userDefaults objectForKey:@"Ttel"];
    NSString *url = [NSString stringWithFormat:@"%@/%@.jpg", @"http://192.168.1.108/image/ingimage", name];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage *image = [UIImage imageWithData:data];
    if(image==nil)
    {
        NSString *url = [NSString stringWithFormat:@"%@/%@.jpg", @"http://192.168.1.108/image/ingimage", Tname];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        UIImage *image = [UIImage imageWithData:data];
        if(image==nil)
        {
      
            _BJImage.userInteractionEnabled = YES;
            _BJImage.backgroundColor = [UIColor whiteColor];
            
        }
        else
        {
            _BJImage.userInteractionEnabled = YES;
            [_BJImage setImage:image];
            NSDictionary *dic232319 = @{@"Ttel":Tname};
            [LDXNetWork GetThePHPWithURL:DELETEIMAGE par:dic232319 success:^(id responseObject)
             {} error:^(NSError *error) {}];
        }
    
    }
    else
    {
    _BJImage.userInteractionEnabled = YES;
   [_BJImage setImage:image];
       }
    

}
- (IBAction)backBtnClick:(id)sender {
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    // 从图库来源
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    picker.delegate  = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 获取图片数据
    UIImage *ima = info[UIImagePickerControllerEditedImage];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDefaults objectForKey:@"name"];
    NSDate *date = [NSDate date];
    NSDictionary *dic = @{@"Utel":name,@"time":date};
    [LDXNetWork PostThePHPWithURL:STATUS par:dic image:ima uploadName:@"uploadimageFile" success:^(id response) {
        NSString *success = response[@"success"];
        if ([success isEqualToString:@"1"]) {
            [self showTheAlertView:self andAfterDissmiss:1.5 title:@"上传成功" message:@""];
            [self backImage];
        }
        else if([success isEqualToString:@"-1"]){
            [self showTheAlertView:self andAfterDissmiss:1.5 title:@"账号已经被注册了" message:@""];
        }
    } error:^(NSError *error) {
        NSLog(@"错误的原因:%@",error);
    }];
    
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


-(void)swipeGesture:(id)sender
{
    UISwipeGestureRecognizer *swipe = sender;
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        MainAryViewController *ZXVC = [[MainAryViewController alloc]init];
        CATransition *animation = [CATransition animation];
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionMoveIn;
        animation.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:animation forKey:nil];
        [self presentViewController:ZXVC animated:NO completion:nil];
        
        //向左轻扫
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp)
    {
        MEViewController *MEVC = [[MEViewController alloc]init];
        CATransition *animation = [CATransition animation];
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionMoveIn;
        animation.subtype = kCATransitionFromTop;
        [self.view.window.layer addAnimation:animation forKey:nil];
        [self presentViewController:MEVC animated:YES completion:nil];
        //向上轻扫
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
