//
//  MainViewController.m
//  cn.Ta.HaiTuDeng.com
//
//  Created by htd on 16/8/15.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import "MainViewController.h"
#import "MainAryViewController.h"
#import "Helper.h"


@interface MainViewController ()
{
    MainAryViewController *_mainVC;
    StatusViewController *_statusVC;
    InformationViewController *_informationVC;
    TomViewController *_meVC;


}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"首页", @"Main");
    [self setSubview];
    self.selectedIndex = 0;
    [self createConversation];
    
    [Helper shareHelper].mavc = _mainVC;
    [Helper shareHelper].svc = _statusVC;
    
    
    // Do any additional setup after loading the view.
    
}
- (void)viewWillLayoutSubviews{
    CGRect tabFrame = self.tabBar.frame; //self.TabBar is IBOutlet of your TabBar
    tabFrame.size.height = 40;
    tabFrame.origin.y = self.view.frame.size.height - 40;
    self.tabBar.frame = tabFrame;
    
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (item.tag == 0) {
        self.title = NSLocalizedString(@"首页", @"Main");
        self.navigationItem.rightBarButtonItem = nil;
    }else if (item.tag == 1){
        self.title = NSLocalizedString(@"更新状态", @"Status");
        self.navigationItem.rightBarButtonItem =nil;
    }else if (item.tag == 2){
        self.title = NSLocalizedString(@"情侣资讯", @"Information");
        self.navigationItem.rightBarButtonItem = nil;
    }else if(item.tag == 3){
        self.title = NSLocalizedString(@"Tom 办公室", @"Tom Office");
        self.navigationItem.rightBarButtonItem = nil;
    }
    
}

-(void)setSubview
{
    
    _mainVC = [[MainAryViewController alloc]initWithNibName:nil bundle:nil];
    _mainVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:NSLocalizedString(@"首页",@"Main") image:nil tag:0];
    UIOffset hight = UIOffsetMake(0, -10);
    [_mainVC.tabBarItem setTitlePositionAdjustment:hight];
    [self unSelectedTapTabBarItems:_mainVC.tabBarItem];
    [self selectedTapTabBarItems:_mainVC.tabBarItem];
    
    _statusVC = [[StatusViewController alloc]initWithNibName:nil bundle:nil];
    _statusVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:NSLocalizedString(@"更新状态", @"Status") image:nil tag:1];
    UIOffset hight1 = UIOffsetMake(0, -10);
    [_statusVC.tabBarItem setTitlePositionAdjustment:hight1];
    [self unSelectedTapTabBarItems:_statusVC.tabBarItem];
    [self selectedTapTabBarItems:_statusVC.tabBarItem];
    
    _informationVC = [[InformationViewController alloc]initWithNibName:nil bundle:nil];
    _informationVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:NSLocalizedString(@"情侣资讯",@"Information") image:nil tag:2];
    UIOffset hight2 = UIOffsetMake(0, -10);
    [_informationVC.tabBarItem setTitlePositionAdjustment:hight2];
    [self unSelectedTapTabBarItems:_informationVC.tabBarItem];
    [self selectedTapTabBarItems:_informationVC.tabBarItem];
    
    _meVC = [[TomViewController alloc]initWithNibName:nil bundle:nil];
    _meVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:NSLocalizedString(@"Tom 办公室",@"Tom Office") image:nil tag:3];
    UIOffset hight3 = UIOffsetMake(0, -10);
    [_meVC.tabBarItem setTitlePositionAdjustment:hight3];
    [self unSelectedTapTabBarItems:_meVC.tabBarItem];
    [self selectedTapTabBarItems:_meVC.tabBarItem];
    
    self.viewControllers = @[_mainVC,_statusVC,_informationVC,_meVC];
    [self selectedTapTabBarItems:_mainVC.tabBarItem];
}

-(void)selectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:14],
                                        NSFontAttributeName,RGBACOLOR(0x00, 0xac, 0xff, 1),NSForegroundColorAttributeName,
                                        nil] forState:UIControlStateSelected];
}

-(void)unSelectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:14], NSFontAttributeName,[UIColor grayColor],NSForegroundColorAttributeName,
                                        nil] forState:UIControlStateNormal];
}

//登录主见面后创建一个与另一伴的会话
-(void)createConversation
{
    NSString *another = [[NSUserDefaults standardUserDefaults]objectForKey:@"Ttel"];
    [[EMClient sharedClient].chatManager getConversation:another type:EMConversationTypeChat createIfNotExist:YES];
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
