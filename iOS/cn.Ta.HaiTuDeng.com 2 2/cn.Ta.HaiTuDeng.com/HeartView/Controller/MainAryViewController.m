//
//  MainAryViewController.m
//  cn.Ta.HaiTuDeng.com
//
//  Created by piupiupiu on 16/7/20.
//  Copyright © 2016年 haitudeng. All rights reserved.
//  心界面


#import "MainAryViewController.h"

@interface MainAryViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate>

@property(strong,nonatomic) ChartView *chartView;
@property(nonatomic,strong) NSString* locationString;
@property (nonatomic, strong) AYPageControlView *pageControlView;
@property (nonatomic, strong) UIScrollView *bannerScrollView;
@property (nonatomic,strong)NSString * filepath;//tamax.plist,装对方数据
@property(nonatomic,strong) NSTimer* timer;// 定义倒计时实现定时器
@property (nonatomic,strong)NSDate * date;//当前时间
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UILabel *label;//当日点击时间列表


@end
int i = 20;//计时器参数
int z =0;
@implementation MainAryViewController

#pragma mark - LifeCycle

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    //-------------------------------手势-----------------------------------
    [_timer setFireDate:[NSDate distantPast]];
    i=20;
    
}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    CGFloat kWindowsWidth = [[UIScreen mainScreen] bounds].size.width;
    _swipeView = [[UIView alloc]initWithFrame:CGRectMake(kWindowsWidth-90, 20, 90, 90) ];
    
    _swipeView.backgroundColor = [UIColor colorWithRed:(242/255.0f) green:(242/255.0f) blue:(242/255.0f) alpha:0.5];
    _swipeView.layer.cornerRadius=45;
    _swipeView.layer.masksToBounds=YES;
    _swipeView.layer.borderWidth=5;
    _swipeView.layer.borderColor=[[UIColor colorWithRed:0.52 green:0.09 blue:0.07 alpha:0.5]CGColor];
    [[[UIApplication sharedApplication]keyWindow] addSubview:_swipeView];
    [[[UIApplication sharedApplication]keyWindow] bringSubviewToFront:_swipeView];
    //添加轻扫手势
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    //设置轻扫的方向
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight; //默认向右
    [_swipeView addGestureRecognizer:swipeGesture];
    
    //添加轻扫手势
    UISwipeGestureRecognizer *swipeGestureUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    //设置轻扫的方向
    swipeGestureUp.direction = UISwipeGestureRecognizerDirectionUp; //默认向上
    [_swipeView addGestureRecognizer:swipeGestureUp];
    
    //添加轻扫手势
    UISwipeGestureRecognizer *swipeGestureDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    //设置轻扫的方向
    swipeGestureDown.direction = UISwipeGestureRecognizerDirectionDown; //默认向下
    [_swipeView addGestureRecognizer:swipeGestureDown];
    

}
- (void)viewDidLoad {
    
    [self TtelName];
    [super viewDidLoad];
   
    self.dataArray = [NSMutableArray array];//初始化数据源
    
    self.view.backgroundColor = [UIColor colorWithRed:(242/255.0f) green:(242/255.0f) blue:(242/255.0f) alpha:1];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDefaults objectForKey:@"name"];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *createPath = [NSString stringWithFormat:@"%@/%@", pathDocuments,name];
    NSLog(@"%@",createPath);
    [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    _filepath = [createPath stringByAppendingPathComponent:@"timeu.plist"];
    NSLog(@"%@",_filepath);
    _date=[NSDate date];
    
    //****************我的背景图片********************
    NSString *url = [NSString stringWithFormat:@"%@/%@.jpg", @"http://192.168.1.108/image/backimage", name];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage *image = [UIImage imageWithData:data];
    _BJimge.userInteractionEnabled = YES;
    if (image == nil) {
        [_BJimge setImage:[UIImage imageNamed:@"backimage.png"]];
    }
    else{
        [_BJimge setImage:image];
    }
     //****************我的背景图片********************
    
    
    
    
    
    
    [self timedown];
    [self uptime];
    
    
    
  
    
   
    
    //--------------------------------手势-------------------------------
  
        
   
}

-(void)TtelName
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *Uname = [userDefaults objectForKey:@"name"];
    NSString *tname = [userDefaults objectForKey:@"Ttel"];
    NSLog(@"这就是单例：%@",tname);
    if (tname == NULL) {
        NSDictionary *dic232319 = @{@"Utel":Uname};
        //网络请求
               [LDXNetWork GetThePHPWithURL:GEINEME par:dic232319 success:^(id responseObject)
         {
       
             if ([responseObject[@"success"]isEqualToString:@"1"]) {
                 
                 
                 NSDictionary *Ttel = responseObject[@"Ttel"];
                 [userDefaults setObject:Ttel forKey:@"Ttel"];
                 
                 
                }
          
         } error:^(NSError *error) {
             
         }];
    }
    NSLog(@"这是不是单例:%@",tname);
    
}
//----------------------------列表---------------------------------

-(void)createTableView{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //PCH 预编译文件
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(290, 520, 120,200) style:UITableViewStylePlain];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:(242/255.0f) green:(242/255.0f) blue:(242/255.0f) alpha:0];
   self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _tableView.bounces = YES;
    ////////////
    
    _label =[[UILabel alloc]init];
    _label = [[UILabel alloc]initWithFrame:CGRectMake(310, 500, 100, 20)];
    long dd = (long)[_date timeIntervalSince1970];
    long fin=dd-z*86400;
    NSDate * datenow = [[NSDate alloc] initWithTimeIntervalSince1970:fin];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yy年MM月dd日"];
    NSString *nDate = [dateFormatter stringFromDate: datenow];
    _label.text = nDate;
    _label.textColor = [UIColor redColor];
    _label.font = [UIFont boldSystemFontOfSize:13.0f];
  
    [self.view addSubview:_label];
    //cell如果不能铺满tableView 是不能滑动的 只能由弹簧效果进行弹动
    [self.view addSubview:_tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil] forCellReuseIdentifier:@"BASE"];
    
    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tableSwipe:)];
    //设置轻扫的方向
    swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft; //默认向右
    [self.tableView addGestureRecognizer:swipeGestureLeft];
    
    UISwipeGestureRecognizer *swipeGestureRinght = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tableSwipe:)];
    //设置轻扫的方向
    swipeGestureRinght.direction = UISwipeGestureRecognizerDirectionRight; //默认向右
    [self.tableView addGestureRecognizer:swipeGestureRinght];

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BASE"forIndexPath:indexPath];
    //cell.backgroundColor = [UIColor redColor];
    cell.backgroundColor = [UIColor colorWithRed:(242/255.0f) green:(242/255.0f) blue:(242/255.0f) alpha:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArray.count<=0) {
        return cell;
    }
    cell.Time_Label.text = _dataArray[indexPath.row];
   
     NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
     [formatter setDateFormat:@"HH:mm:ss"];
    NSDate * q =  [formatter dateFromString: _dataArray[indexPath.row]];
   
    long w = (long)[q timeIntervalSince1970];
    long e=fmod((w+(8*60*60))/21600, 4);
  
    
    if(e==0||e==3)
    {
        cell.imageView.image = [UIImage imageNamed:@"moon.png"];
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"sun.png"];
    }
   
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(void)tableSwipe:(id)sender
{
    UISwipeGestureRecognizer *swipe = sender;
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        if(z==0)
        {}
        else
        {
        z--;
        [self uptime];
            
 
   
        }
        //向右轻扫
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight)
    {
        z++;
        [self uptime];
     

    }
    
}
//---------------------------列表---------------------------------
//******************设置对方背景图片******************

- (IBAction)imageBtn:(id)sender {
    
    _imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    // 从图库来源
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    picker.delegate  = self;
   
    [self presentViewController:picker animated:YES completion:nil];
    
    
    
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 获取图片数据
    UIImage *ima = info[UIImagePickerControllerEditedImage];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDefaults objectForKey:@"name"];
    NSDictionary *dic = @{@"Utel":name};
    [LDXNetWork PostThePHPWithURL:BACKIMAGE par:dic image:ima uploadName:@"uploadimageFile" success:^(id response) {
        NSString *success = response[@"success"];
        if ([success isEqualToString:@"1"]) {
            [self showTheAlertView:self andAfterDissmiss:1.5 title:@"上传成功" message:@""];
            
        }
        else if([success isEqualToString:@"-1"]){
            [self showTheAlertView:self andAfterDissmiss:1.5 title:@"账号已经被注册了" message:@""];
        }
    } error:^(NSError *error) {
        NSLog(@"错误的原因:%@",error);
    }];

    [picker dismissViewControllerAnimated:YES completion:nil];
}
//******************设置对方背景图片******************
-(void)swipeGesture:(id)sender
{
    
    if (self.presentedViewController != nil) {
        [self.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    }
    UISwipeGestureRecognizer *swipe = sender;
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight)
    {
        StatusViewController  *ZTVC = [[StatusViewController alloc]init];
        CATransition *animation = [CATransition animation];
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionMoveIn;
        animation.subtype = kCATransitionFromLeft;
        [self.view.window.layer addAnimation:animation forKey:nil];
        
        [self presentViewController:ZTVC animated:NO completion:nil];
        
        //向右轻扫
    }
    

    if (swipe.direction == UISwipeGestureRecognizerDirectionUp)
    {
        MEViewController *MEVC = [[MEViewController alloc]init];
        CATransition *animation = [CATransition animation];
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionMoveIn;
        animation.subtype = kCATransitionFromTop;
        [self.view.window.layer addAnimation:animation forKey:nil];
        [self presentViewController:MEVC animated:NO completion:nil];
        //向上轻扫
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionDown)
    {
        InformationViewController *HOVC = [[InformationViewController alloc]init];
        CATransition *animation = [CATransition animation];
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionMoveIn;
        animation.subtype = kCATransitionFromBottom;
        [self.view.window.layer addAnimation:animation forKey:nil];
        [self presentViewController:HOVC animated:YES completion:nil];
        //向下轻扫
    }
}

- (IBAction)ClickBtn:(id)sender {
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:_filepath];
    NSArray * time = dict[@"time"];
    NSString * ls = [time objectAtIndex:([time count]-1)];
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate * sls =  [formatter dateFromString:ls];
    NSDate * objdate = [NSDate dateWithTimeInterval:i sinceDate:sls];
   _date=[NSDate date];
    int   key =[ objdate timeIntervalSinceDate:_date];//目标时间和当前时间差
   
    if(key>0)//当前时间小于目标时间
    {
        i=key;
        _timer  = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runTime) userInfo:nil repeats:YES];//启动计时器
        _ClickBtn.userInteractionEnabled = NO;
        
        
    }
    else//当前时间大于目标时间说明过时了，重新以n值为key计时
    {
        i=20;
        _timer  = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runTime) userInfo:nil repeats:YES];
        _ClickBtn.userInteractionEnabled = NO;
        [self timeup];
    }

}
-(void)scrollViewUI
{
    
    
      ChartView *chView = [[ChartView alloc]initWithFrame:CGRectMake(10, [UIScreen mainScreen].bounds.size.height - 220, self.view.frame.size.width-120, 220) ];
    UIColor *color = [UIColor colorWithRed:(242/255.0f) green:(242/255.0f) blue:(242/255.0f) alpha:1];
    chView.backgroundColor = [color colorWithAlphaComponent:0];
    self.chartView = chView;
   
   
    [self.view addSubview:self.chartView];
   
   
    
}
-(void)timedown //下载时间戳数组并存到timeu里面
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDefaults objectForKey:@"name"];
    int key=10;
    NSString *Utel=name;
    _date=[NSDate date];
    long  now = (long)[_date timeIntervalSince1970];
    long trun=now/(24*60*60);
    long trun1=trun- key;
    long timepoint=trun1*24*60*60;
    NSDate * t  = [NSDate dateWithTimeIntervalSince1970:timepoint];
    
    NSDictionary *dic232319 = @{@"Utel":Utel,@"time": t };
    //网络请求
    [LDXNetWork GetThePHPWithURL:SHUJUDOWN par:dic232319 success:^(id responseObject)
     {
         if ([responseObject[@"success"]isEqualToString:@"1"]) {
            
             NSArray * time = responseObject[@"time"];
             NSArray *  timet =responseObject[@"timet"];
                 //建立数据模型存储数据
             
             NSMutableDictionary *mDicth = [[NSMutableDictionary alloc] init];
             [mDicth setObject:time forKey:@"time" ];
             [mDicth setObject:timet forKey:@"timet" ];
             [mDicth writeToFile:_filepath atomically:YES];
            
             [_bannerScrollView removeFromSuperview];//???
    
         }

         [self.chartView removeFromSuperview];
         [self scrollViewUI];

     } error:^(NSError *error) {
         NSLog(@"登录失败的原因:%@",error);
     }];
}
//usuxwyyuxw
-(void)uptime //刷新左侧具体时间表格子
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDefaults objectForKey:@"name"];
    int key=z+1;
    NSString *Utel=name;
    _date=[NSDate date];
    long  now = (long)[_date timeIntervalSince1970];
    long trun=now/(24*60*60);
    long trun1=trun- key;
    long timepoint=trun1*24*60*60;
    NSDate * t  = [NSDate dateWithTimeIntervalSince1970:timepoint];
    
    NSDictionary *dic232319 = @{@"Utel":Utel,@"time": t };
    //网络请求
    [LDXNetWork GetThePHPWithURL:SHUJUDOWN par:dic232319 success:^(id responseObject)
     {
         if ([responseObject[@"success"]isEqualToString:@"1"]) {
             
             NSArray *  timet =responseObject[@"timet"];
             
             NSDate * date =[NSDate date];
             NSMutableArray *tadytime = [[NSMutableArray alloc]init];
             for(int i=0;i<[timet count];i++)
             {
                 
                 long  now = (long)[date timeIntervalSince1970];
                 long trun=now/(24*60*60)-z;
                 NSString * ls= [timet objectAtIndex:i];
                 NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
                 [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                 NSDate * sls =  [formatter dateFromString:ls];
                 long longls = (long)[sls timeIntervalSince1970];
                 
                 if(trun==longls/(24*60*60))
                 {
                     NSDate * lst  =  [formatter dateFromString:ls];
                     NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
                     [formatter setDateFormat:@"HH:mm:ss"];
                     NSString * tt=[formatter stringFromDate:lst];
                     
                     [tadytime addObject: tt];
                 }
                 
                 
             }
             _dataArray = [[NSMutableArray alloc]init];
             [_dataArray addObjectsFromArray: tadytime];
         }
         
         [_tableView removeFromSuperview];
          [_label removeFromSuperview];
         [self createTableView];
     } error:^(NSError *error) {
         NSLog(@"登录失败的原因:%@",error);
     }];
}
//uwhsdiuwh
-(void)timeup//上传当前时间戳
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDefaults objectForKey:@"name"];
    NSString * Utel1 = name;
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString * stime =  [formatter stringFromDate:_date];
    NSDictionary *dic1 = @{@"Utel":Utel1,@"time":stime};
    //网络请求
    [LDXNetWork GetThePHPWithURL:SHUJUUP par:dic1 success:^(id responseObject) {
        if ([responseObject[@"success"]isEqualToString:@"1"]) {

            [self timedown];
   
        }
        else{
            [self showTheAlertView:self andAfterDissmiss:1.0 title:@"网络错误1" message:@""];
        }
    } error:^(NSError *error) {
        NSLog(@"登录失败的原因:%@",error);
    }];
    
}

-(void)runTime
{
    NSString *h = [[NSString alloc]init];
    NSString *m = [[NSString alloc]init];
    NSString *s = [[NSString alloc]init];
    i--;
    int hours =i /3600;
    int minutes=fmod(i/60,60);
    int seconds=fmod(i,60);
    if (hours<10)
    {
        NSString * hour=[NSString stringWithFormat:@"%d",hours];
        h = [@"0" stringByAppendingString:hour];
        _CountDown.text = h;
    }
    else
    {
        h=[NSString stringWithFormat:@"%d",hours];
        _CountDown.text = h;
    }
    
    if (minutes<10)
    {
        NSString * minute=[NSString stringWithFormat:@"%d",minutes];
        m = [@"0" stringByAppendingString:minute];
        _CountDown.text = m;
    }
    else
    {
        m=[NSString stringWithFormat:@"%d",minutes];
        _CountDown.text = m;
    }
    if (seconds<10)
    {
        NSString * second=[NSString stringWithFormat:@"%d",seconds];
        s = [@"0" stringByAppendingString:second];
        _CountDown.text = s;
    }
    else
    {
        s=[NSString stringWithFormat:@"%d",seconds];
        _CountDown.text = s;
    }
    NSLog(@"%@",_CountDown.text);
    NSString *labletime=[NSString stringWithFormat:@"%@:%@:%@",h,m,s];
    _CountDown.text = labletime;
    if (i<=0) {
        [_timer setFireDate:[NSDate distantFuture]];//停止计时器
        _ClickBtn.userInteractionEnabled = YES;//打开按钮
    }
    
}

-(void)viewDidDisappear:(BOOL)animated
{
   
    [_timer setFireDate:[NSDate distantFuture]];
    i=20;
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
