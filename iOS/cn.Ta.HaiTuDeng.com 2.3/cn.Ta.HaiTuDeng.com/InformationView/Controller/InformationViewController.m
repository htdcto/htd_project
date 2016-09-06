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


#define ZIXUN @"http://120.26.62.17/ta/ta/title.php"


#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface InformationViewController ()
@property (nonatomic,strong)NSString *filename;


@end

@implementation InformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self createTableView];
    [self setMyUrl];
    [self loadData];
    
    
 }
-(void)initData
{
    self.dataArray = [NSMutableArray array];
    self.pagenum = 1;
}
-(void)setMyUrl
{
    self.url = [NSString stringWithFormat:ZIXUN];
}
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
    self.tableView.header = header;
    
}
-(void)addFooterRefresh
{
    MJRefreshAutoGifFooter * footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        //页数增加
        self.pagenum ++;
        
        //重新请求数据
        [self setMyUrl];
        [self loadData];
        
    }];
    self.tableView.footer = footer;
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
    [self.navigationController pushViewController:detail animated:YES];
    
    
}
-(void)loadData{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* plistPath1 = [paths objectAtIndex:0];
    
    //在此处设置文件的名字补全其中的路径, 注意对于文件内存的修改是在内存之中完成的，然后直接把现在的数据一次性更新，这样减少了文件的读写的次数
    _filename =[plistPath1 stringByAppendingPathComponent:@"InforText.plist"];
    NSNumber *page = [NSNumber numberWithInt:self.pagenum];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:page, @"pagenum", nil];
    if ([[NSFileManager defaultManager] fileExistsAtPath:_filename]) {
        //从本地读缓存文件
        //NSData *data = [NSData dataWithContentsOfFile:_filename];
        NSArray *Ary = [NSArray arrayWithContentsOfFile:_filename];
        for (NSDictionary *newDict in Ary) {
            MainModel *model= [[MainModel alloc]init];
            [model setValuesForKeysWithDictionary:newDict];
            
            [self.dataArray addObject:model];
        }
        
    }

    [LDXNetWork GetThePHPWithURL:ZIXUN par:dict success:^(id responseObject) {
        
        
        NSArray *resultAry = responseObject[@"date"];
        if ([resultAry isKindOfClass:[NSArray class]] && resultAry.count > 0) {
            for (NSDictionary *newDict in resultAry) {
                MainModel *model= [[MainModel alloc]init];
                [model setValuesForKeysWithDictionary:newDict];
                [self.dataArray addObject:model];
                [resultAry writeToFile:_filename atomically:YES];

            }
            [self.tableView reloadData];
            NSLog(@"11111%@",resultAry);
            
        }else{
            
            [self.tableView.footer noticeNoMoreData];
        }

    } error:^(NSError *error) {
        
    }];
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
