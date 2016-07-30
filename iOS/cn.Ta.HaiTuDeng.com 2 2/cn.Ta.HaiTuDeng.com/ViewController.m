//
//  ViewController.m
//  cn.Ta.HaiTuDeng.com
//
//  Created by piupiupiu on 16/7/20.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<LoginRegisterDelegate>
@property (nonatomic,strong)LoginView * longinR;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    self.view.layer.cornerRadius = 40;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //创建登录注册页面
    self.longinR = [[LoginView alloc]initWithFrame:self.view.frame];
    //代理
    _longinR.delegate = self;
    
    [self.view addSubview:_longinR];
}
#pragma mark - 登录注册页面的代理
//根据不同的后台给的字段 代表的意思 以及值进行不同处理
-(void)getLoginName:(NSString *)name pass:(NSString *)pass
{
    
    //后台规定登录用户名的字段必须是name 密码是pass
    NSDictionary *dic = @{@"name":name, @"pass":pass};
    //网络请求
    [LDXNetWork GetThePHPWithURL:LOGIN par:dic success:^(id responseObject) {
        if ([responseObject[@"success"]isEqualToString:@"1"]) {
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:name forKey:@"name"];
            [userDefaults setObject:pass forKey:@"password"];
            [userDefaults synchronize];//绑定之后存
            
            MainAryViewController *mainVC = [[MainAryViewController alloc]init];
            mainVC.dic = responseObject;
            [self presentViewController:mainVC animated:YES completion:nil];
            
        }
        else{
            [self showTheAlertView:self andAfterDissmiss:1.0 title:@"账号或密码错误" message:@""];
        }
    } error:^(NSError *error) {
        NSLog(@"登录失败的原因:%@",error);
    }];
    
}
-(void)getRegisterName:(NSString *)name pass:(NSString *)pass  image:(UIImage *)image
{
    
    NSDictionary *dic = @{@"Utel":name,@"Upass":pass};
    [LDXNetWork PostThePHPWithURL:REGISTER par:dic image:image uploadName:@"uploadimageFile" success:^(id response) {
        NSString *success = response[@"success"];
        if ([success isEqualToString:@"1"]) {
            [self showTheAlertView:self andAfterDissmiss:1.5 title:@"注册成功" message:@""];
            [_longinR goToLoginView];
        }
        else if([success isEqualToString:@"-1"]){
            [self showTheAlertView:self andAfterDissmiss:1.5 title:@"账号已经被注册了" message:@""];
        }
    } error:^(NSError *error) {
        NSLog(@"错误的原因:%@",error);
    }];
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
