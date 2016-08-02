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

@property (nonatomic,strong)ShareActionView *actionView;
@end

@implementation StatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    [self backImage];
    
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
    
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage)];
    [_BJImage addGestureRecognizer:singleTap];
    
    
}
-(void)onClickImage
{
    [self.actionView actionViewShow];
}
- (ShareActionView *)actionView{
    if (!_actionView) {
        _actionView = [[ShareActionView alloc]initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height , [UIScreen mainScreen].bounds.size.width, 0) WithSourceArray:@[@"时间",@"表情",@"上传我的状态",@"定位",] WithIconArray:@[@"sns_icon_24",@"sns_icon_24",@"sns_icon_24",@"sns_icon_24",@"sns_icon_24",]];
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
