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
#import "EMError.h"
#import "EMSDK.h"

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
}
 - (IBAction)tuchu:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     EMError *error = [[EMClient sharedClient] logout:YES];
     if (!error) {
         NSLog(@"退出成功");
     }
    //移除UserDefaults中存储的用户信息
    [userDefaults removeObjectForKey:@"name"];
    [userDefaults removeObjectForKey:@"password"];
    [userDefaults removeObjectForKey:@"Ttel"];
    [userDefaults synchronize];
    
    ViewController *VC = [[ViewController alloc]init];
    
    [self presentViewController:VC animated:YES completion:nil];
}

- (void)didRemovedFromServer
{
    NSLog(@"111");
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
