//
//  ViewController.m
//  cn.Ta.HaiTuDeng.com
//
//  Created by piupiupiu on 16/7/20.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import "ViewController.h"
#import "EMSDK.h"
#import "EMError.h"
#import "DB.h"

@interface ViewController ()<LoginRegisterDelegate>
@property (nonatomic,strong)LoginView * longinR;
@property BOOL alreadyBind;
@end

@implementation ViewController

//由于自动登录IM服务器无法调用本地回调函数didAutoLoginWithError()，所以无法验证自动登录是否成功。因此统一假设自动登录成功，并直接访问本地服务器登录。----------------------------------------xzl
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
    if(isAutoLogin)
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *name = [userDefaults objectForKey:@"name"];
        NSString *pass = [userDefaults objectForKey:@"password"];
        if(name!=nil&&pass!=nil)
        {
            [self getLoginServer:name pass:pass];

        }
    }
        else{

            //创建登录注册页面
            self.longinR = [[LoginView alloc]initWithFrame:self.view.frame];
            //代理
            _longinR.delegate = self;
            
            [self.view addSubview:_longinR];
        }
    }
#pragma mark - 登录注册页面的代理
//根据不同的后台给的字段 代表的意思 以及值进行不同处理.
//如果IM框架返回1成功登录，则调用该方法做服务器端登录。若IM框架返回0，则不执行服务器端登录，直接向客户端返回登录失败。
//----------------------------------------xzl

-(void)getLoginServer:(NSString *)name pass:(NSString *)pass
{            //后台规定登录用户名的字段必须是name 密码是pass,
            //本地服务器网络请求
        NSDictionary *dic = @{@"Utel":name,@"pass":pass};
        [LDXNetWork GetThePHPWithURL:LOGIN par:dic success:^(id responseObject) {
            if ([responseObject[@"success"]isEqualToString:@"1"]) {
                    //没有绑定，服务器没有返回Tt
                if([responseObject[@"Ttel"] isEqualToString:@"-1"]){
                        
                   
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:name forKey:@"name"];
                    [userDefaults setObject:pass forKey:@"password"];
                    [userDefaults synchronize];//绑定之后存
                        BDViewController *BDVC = [[BDViewController alloc]init];
                        [self presentViewController:BDVC animated:YES completion:nil];
                        
                    _alreadyBind = NO;
                    }
                    
                    else
                    {
                        NSString *Ttel = responseObject[@"Ttel"];
                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                        [userDefaults setObject:name forKey:@"name"];
                        [userDefaults setObject:pass forKey:@"password"];
                        [userDefaults setObject:Ttel forKey:@"Ttel"];
                        [userDefaults synchronize];//绑定之后存
                        
                        _alreadyBind = YES;
                        
                        
                        DB *db = [DB shareInit];
                        [db openOrCreateDB];
                        [db updateDBAfterLoginSuccess:name];
                        MainAryViewController *mainVC = [[MainAryViewController alloc]init];
                        [self presentViewController:mainVC animated:YES completion:nil];
                        
                    }
    
                }
                else{
                    [self showTheAlertView:self andAfterDissmiss:1.0 title:@"账号或密码错误" message:@""];
                }
            } error:^(NSError *error) {
                NSLog(@"登录失败的原因:%@",error);
            }];
}

//登录IM框架，如果成功返回1，如果失败返回0----------------------------------------xzl
-(int)getLoginIM:(NSString *)name pass:(NSString *)pass
{
        EMError *error = [[EMClient sharedClient] loginWithUsername:name password:pass];
        if(!error)
        {

            [[EMClient sharedClient].options setIsAutoLogin:YES];
        return 1;
        }
        else
        {
            [self showTheAlertView:self andAfterDissmiss:1.0 title:@"账号或密码错误" message:@""];
        return 0;
        }
}

//先检测IM框架是否登录，如果登录成功返回1作服务器端登录，否则返回0报错。----------------------------------xzl
-(void)Login:(NSString *)name pass:(NSString *)pass
{
    //自动登录
    NSString *userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    NSString *userPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    if (userAccount && userPassword) {
        //存在用户名跟密码，实现自动登录
        int i =0;
        i = [self getLoginIM:name pass:pass];
        NSLog(@"%d",i);
        switch (i) {
            case (0):
                break;
                
            case(1):
            {
                [self getLoginServer:name pass:pass];
            }
                break;
        }
        
        return;
    }
    
    if ([name isEqualToString:@""] || [pass isEqualToString:@""]) {
        
        [self showTheAlertView:self andAfterDissmiss:1.0 title:@"请输入帐号跟密码" message:@""];
        return;
    }
    

    int i =0;
    i = [self getLoginIM:name pass:pass];
    NSLog(@"%d",i);
    switch (i) {
        case (0):
            break;
            
        case(1):
        {
            [self getLoginServer:name pass:pass];
        }
            break;
    }
}


-(void)getRegisterName:(NSString *)name pass:(NSString *)pass  image:(UIImage *)image
{
    
    NSDictionary *dic = @{@"Utel":name,@"Upass":pass};
    [LDXNetWork PostThePHPWithURL:REGISTER par:dic image:image uploadName:@"uploadimageFile" success:^(id response) {
        NSString *success = response[@"success"];
        
        if ([success isEqualToString:@"1"]) {
            [self showTheAlertView:self andAfterDissmiss:1.5 title:@"注册成功" message:@""];
            [_longinR goToLoginView];}
        else if([success isEqualToString:@"-1"]){
            [self showTheAlertView:self andAfterDissmiss:1.5 title:@"账号已经被注册了" message:@""];
        }
        else
        {
            [self showTheAlertView:self andAfterDissmiss:1.5 title:@"服务器故障，请稍后再试" message:@""];
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
