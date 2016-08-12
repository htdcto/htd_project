//
//  StatusViewController.m
//  cn.Ta.HaiTuDeng.com
//
//  Created by piupiupiu on 16/7/20.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import "StatusViewController.h"

@interface StatusViewController ()<UIImagePickerControllerDelegate,ShareActionViewDelegate>
{
    UIView *_bgview;
}
@property (nonatomic,strong)NSDictionary *Diction;
@property (nonatomic,strong)ShareActionView *actionView;
@end

@implementation StatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    [self backImageDown];
    
    //**************************背景
    //****************我的背景图片********************
    
    
    
    
}
-(void)backImageDown
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *Uname = [userDefaults objectForKey:@"name"];
    NSString *Tname = [userDefaults objectForKey:@"Ttel"];
    NSDictionary *dic = @{@"Utel":Uname,@"Ttel":Tname};
    
    [LDXNetWork GetThePHPWithURL:STATUSEDOWN par:dic success:^(id responseObject) {
        if ([responseObject[@"success"]isEqualToString:@"1"]) {
            NSString *Utel = responseObject[@"Utel"];
            NSString *uTime = responseObject[@"Time"];
            NSString *Url = responseObject [@"Url"];
            NSString *Mood = responseObject[@"Mood"];
            _Diction = @{@"Utel":Utel,@"Time":uTime,@"URL":Url,@"Mood":Mood,};
            NSLog(@"%@",_Diction);
            
            
        }
        [self backImage];
    } error:^(NSError *error) {
        NSLog(@"错了");
        
    }];
    
}
-(void)backImage
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *Uname = [userDefaults objectForKey:@"name"];
    NSString *imageUrl = _Diction [@"URL"];
    NSString *Utel = _Diction[@"Utel"];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    UIImage *image = [UIImage imageWithData:data];
    if(image==nil)
    {
        _BJImage.backgroundColor = [UIColor whiteColor];
        
    }
    else
    {
        if(Utel==Uname)
        {
            [_BJImage setImage:image];
        }
        else
        {
            [_BJImage setImage:image];
            
            NSString *Utel = [_Diction objectForKey:@"Utel"];
            NSDictionary *dic = @{@"Ttel":Utel};
            [LDXNetWork GetThePHPWithURL:DELETEIMAGE par:dic success:^(id responseObject)
             {} error:^(NSError *error) {}];
            
        }
        
        
    }
    
    
    _BJImage.userInteractionEnabled = YES;
    [_BJImage setImage:image];
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage)];
    [_BJImage addGestureRecognizer:singleTap];
    
    
}
-(void)onClickImage
{
    [self.actionView actionViewShow];
}
- (ShareActionView *)actionView{
    NSString * time = _Diction[@"Time"];
    if (!_actionView) {
        _actionView = [[ShareActionView alloc]initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height , [UIScreen mainScreen].bounds.size.width, 0) WithSourceArray:@[time,@"表情",@"上传我的状态",@"定位",] WithIconArray:@[@"sns_icon_24",@"sns_icon_24",@"sns_icon_24",@"sns_icon_24",@"sns_icon_24",]];
        _actionView.delegate = self;
        
    }
    return _actionView;
}
- (void)shareToPlatWithIndex:(NSInteger)index{
    NSLog(@"index = %ld",index);
    if (index ==2) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        // 从图库来源
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        picker.delegate  = self;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
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
