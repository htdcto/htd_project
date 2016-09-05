//
//  InformationViewController.m
//  SwipeGestureRecognizer
//
//  Created by piupiupiu on 16/7/14.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import "InformationViewController.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "MJRefresh.h"//上拉刷新，下啦加载
#import "DetaViewController.h"//详情


#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface InformationViewController ()

@end

@implementation InformationViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //友盟页面统计
    [MobClick beginLogPageView:@"情侣资讯"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //结束友盟页面统计
    [MobClick endLogPageView:@"情侣资讯"];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self createTableView];
    //[self setMyUrl];
    [self loadData];
 }
-(void)initData
{
    self.dataArray = [NSMutableArray array];
    self.pagenum = 1;
}
//-(void)setMyUrl
//{
//    self.url = [NSString stringWithFormat:address(@"title.php")];
//}
-(void)createTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,WIDTH,HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.tableView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ManTableViewCell" bundle:nil] forCellReuseIdentifier:@"BASE"];
    //上拉刷新
    [self addHeaderRefresh];
    [self addFooterRefresh];
}
-(void)addHeaderRefresh
{
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        //重置页数
        self.pagenum = 1;
        //清空数据源
        [self.dataArray removeAllObjects];
        
        [self loadData];
    }];
    [header setTitle:@"马上就好" forState:MJRefreshStateRefreshing];
    self.tableView.mj_header = header;
    
}
-(void)addFooterRefresh
{
    MJRefreshAutoGifFooter * footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        //页数增加
        self.pagenum ++;
        
        //重新请求数据
        //[self setMyUrl];
        [self loadData];
        
    }];
    self.tableView.mj_footer = footer;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ManTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BASE" forIndexPath:indexPath];
    if (self.dataArray.count <=0) {
        return cell;
    }
    
    MainModel *model = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    [cell loadDataFromModel:model];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetaViewController *detail = [[DetaViewController alloc]init];
    MainModel *model =self.dataArray[indexPath.row];
    detail.contentid = model.Id;
    detail.hidesBottomBarWhenPushed = YES;
    //[self.navigationController pushViewController:detail animated:YES];
    [self.navigationController pushViewController:detail animated:YES];
    //[self presentViewController:detail animated:YES completion:nil];
    
}
-(void)loadData{
    NSNumber *page = [NSNumber numberWithInt:self.pagenum];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:page, @"pagenum", nil];
    [LDXNetWork GetThePHPWithURL:address(@"title.php") par:dict success:^(id responseObject) {
        NSArray *resultAry = responseObject[@"date"];
        if ([resultAry isKindOfClass:[NSArray class]] && resultAry.count > 0) {
            for (NSDictionary *newDict in resultAry) {
                MainModel *model= [[MainModel alloc]init];
                [model setValuesForKeysWithDictionary:newDict];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
            NSLog(@"11111%@",resultAry);
        }else{
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }

    } error:^(NSError *error) {
        
    }];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    /*
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSNumber *page = [NSNumber numberWithInt:self.pagenum];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:page, @"pagenum", nil];
    
    [LDXNetWork GET:ZIXUN parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *resultAry = dic[@"date"];
        if ([resultAry isKindOfClass:[NSArray class]] && resultAry.count > 0) {
            for (NSDictionary *newDict in resultAry) {
                MainModel *model= [[MainModel alloc]init];
                [model setValuesForKeysWithDictionary:newDict];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
            NSLog(@"11111%@",resultAry);
        }else{
            
            [self.tableView.footer noticeNoMoreData];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
     */
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
