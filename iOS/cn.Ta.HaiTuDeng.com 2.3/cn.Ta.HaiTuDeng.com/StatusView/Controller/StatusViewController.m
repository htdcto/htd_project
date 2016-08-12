//
//  StatusViewController.m
//  cn.Ta.HaiTuDeng.com
//
//  Created by piupiupiu on 16/7/20.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import "StatusViewController.h"

@interface StatusViewController ()<UIImagePickerControllerDelegate,ShareActionViewDelegate,UINavigationControllerDelegate>
{
    UIView *_bgview;
}
@property (nonatomic,strong)NSDictionary *Diction;
@property (nonatomic,strong)ShareActionView *actionView;
@property (nonatomic,strong)UIImage *image;
@end

@implementation StatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
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
            NSLog(@"%@",responseObject);
            
            
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
    _image = [UIImage imageWithData:data];
    if(_image==nil)
    {
        _BJImage.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(235/255.0f) blue:(227/255.0f) alpha:0.5];
        
        
    }
    else
    {
        if(Utel==Uname)
        {
            [_BJImage setImage:_image];
        }
        else
        {
            [_BJImage setImage:_image];
            
            NSString *Utel = [_Diction objectForKey:@"Utel"];
            NSDictionary *dic = @{@"Ttel":Utel};
            [LDXNetWork GetThePHPWithURL:DELETEIMAGE par:dic success:^(id responseObject)
             {} error:^(NSError *error) {}];
            
        }
        
        
    }
    
    
    _BJImage.userInteractionEnabled = YES;
    [_BJImage setImage:_image];
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage)];
    [_BJImage addGestureRecognizer:singleTap];
    
    
}
-(void)onClickImage
{
    [self.actionView actionViewShow];
}
- (ShareActionView *)actionView{
    NSString * time = _Diction[@"Time"];
    NSDate * date=[NSDate date];
    long  now = (long)[date timeIntervalSince1970];
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate * timeget  =  [formatter dateFromString:time];
    long  gettime = (long)[timeget timeIntervalSince1970];
    long ct =now-gettime-8*60*60;
    NSString * display=[[NSString alloc]init];
    if(ct<60)
    {
        
        NSString * string = [@(ct) stringValue];
        NSString * show=@"秒之前";
        display = [string stringByAppendingString:show];
        
    }else
    {
        if (ct>=60&&ct<60*60) {
            long res=ct/60;
            NSString * string = [@(res) stringValue];
            NSString * show=@"分钟之前";
            display = [string stringByAppendingString:show];
        }
        else
        {
            if (ct>=60*60&&ct<60*60*24) {
                long res=ct/(60*60);
                NSString * string = [@(res) stringValue];
                NSString * show=@"小时之前";
                display = [string stringByAppendingString:show];
                
            }
            else
            {
                if (ct>=60*60*24&&ct<60*60*24*30) {
                    long res=ct/(60*60*24);
                    NSString * string = [@(res) stringValue];
                    NSString * show=@"天之前";
                    display = [string stringByAppendingString:show];
                }
                else
                {
                    if (ct>=60*60*24*30&&ct<60*60*24*365) {
                        long res=ct/(60*60*24*30);
                        NSString * string = [@(res) stringValue];
                        NSString * show=@"个月之前";
                        display = [string stringByAppendingString:show];
                    }
                    else
                    {
                        if (ct>=60*60*24*365) {
                            long res=ct/(60*60*24*365);
                            NSString * string = [@(res) stringValue];
                            NSString * show=@"年之前";
                            display = [string stringByAppendingString:show];
                        }
                    }
                }
            }
        }
    }
    NSString *StrTag = _Diction[@"Mood"];
    NSString *StrImage = [[NSString alloc]init];
    if ([StrTag isEqualToString: @"1"]) {
        StrImage = @"表情1.png";
    }else{
        if ([StrTag isEqualToString: @"2"]) {
            StrImage = @"表情2.png";
        }else{
            if ([StrTag isEqualToString: @"3"]) {
                StrImage = @"表情3.png";
            }else{
                if ([StrTag isEqualToString: @"4"]) {
                    StrImage = @"表情4.png";
                }
            }
        }
    
    }
    
    
    
    
    
    if (_image == nil)
    {
        if (!_actionView)
        {
            _actionView = [[ShareActionView alloc]initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height-110,[UIScreen mainScreen].bounds.size.width, 0) WithSourceArray:@[@"上传"] WithInconArray:@[@"sns_icon_24"]];
            _actionView.delegate = self;
        }
    }
    else 
    {
        _actionView = [[ShareActionView alloc]initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height , [UIScreen mainScreen].bounds.size.width, 0) WithSourceArray:@[display,@"表情",@"上传我的状态",@"定位",] WithIconArray:@[@"sns_icon_24",StrImage,@"sns_icon_24",@"sns_icon_24",]];
       
        _actionView.delegate = self;
    
    }
    return _actionView;
    
}
- (void)shareToPlatWithIndex:(NSInteger)index{
    NSLog(@"index = %ld",index);
    if (index == 5||index ==2) {
        UPImageViewController * UpImage = [[UPImageViewController alloc]init];
        [self presentViewController:UpImage animated:YES completion:nil];
    }
    else {
        NSLog(@"你点谁呢～！");
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
