//
//  DetaViewController.m
//  FlowersMan
//
//  Created by 屠夫 on 16/3/11.
//  Copyright (c) 2016年 Soul. All rights reserved.
//

#import "DetaViewController.h"
#import "MainModel.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height


@interface DetaViewController ()
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,strong)NSString *html;
@end

@implementation DetaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creaUI];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"FlowerMan";
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.navigationController.navigationBarHidden = NO;
    //友盟页面统计
    [MobClick beginLogPageView:@"资讯详情"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //结束友盟页面统计
    [MobClick endLogPageView:@"资讯详情"];
}

-(void)creaUI
{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, +64,WIDTH, HEIGHT)];
    self.webView.scrollView.bounces = NO;
    
    NSString *url = [NSString stringWithFormat:address(@"showinformation.php?Id=%@"),self.contentid];
    
    NSURL *Url = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:Url];
    
    //发送请求给服务器
    [self.webView loadRequest:request];
    
    /*
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *resultArr =dict[@"data"];
        
        _html = resultArr[@"body_html"];
        
        [self.webView loadHTMLString:_html baseURL:nil];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
*/
    [self.view addSubview:self.webView];
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
