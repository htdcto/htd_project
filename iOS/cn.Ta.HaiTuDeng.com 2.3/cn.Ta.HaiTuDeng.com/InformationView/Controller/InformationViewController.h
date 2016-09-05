//
//  InformationViewController.h
//  SwipeGestureRecognizer
//
//  Created by piupiupiu on 16/7/14.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManTableViewCell.h"

#import "MainModel.h"

@interface InformationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

//列表
@property (nonatomic,strong)UITableView *tableView;
//数据源
@property (nonatomic,strong)NSMutableArray *dataArray;
//网址
@property (nonatomic,copy)NSString *url;
//页数
@property (nonatomic,assign)int pagenum;
//设置网址
-(void)setMyUrl;
//请求数据
-(void)loadData;


@end

