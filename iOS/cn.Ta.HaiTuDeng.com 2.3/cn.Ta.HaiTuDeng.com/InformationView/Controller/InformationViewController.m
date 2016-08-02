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
 }

 - (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
