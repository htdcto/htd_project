//
//  RankViewController.m
//  cn.Ta.HaiTuDeng.com
//
//  Created by htd on 16/9/6.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import "RankViewController.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface RankViewController ()
@property(nonatomic,strong)NSArray *rank;
@property(nonatomic,strong)NSDictionary *item;
@property(nonatomic,strong)NSString *Uname;
@property(nonatomic,strong)NSString *Tname;
@property(nonatomic,strong)NSString *rankNum;
@end

@implementation RankViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self getRank];
}

-(void)getRank
{
    [LDXNetWork GetThePHPWithURL:address(@"/rank.php") par:nil success:^(id responseObject) {
        if ([responseObject[@"success"]isEqualToString:@"1"]) {
            _rank = responseObject[@"rank"];
            [self.tableView reloadData];
        }
        else
        {
            NSLog(@"服务器数据库错误");
        }
    }error:^(NSError *error) {
        NSLog(@"访问服务器错误");
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _rank.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Base"];
    _item = _rank[indexPath.row];
    _Uname = [_item objectForKey:@"Utel"];
    _Tname = [_item objectForKey:@"Ttel"];
    _rank = [_item objectForKey:@"rank"];
    
    cell.accessoryType = UITableViewCellSeparatorStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


@end
