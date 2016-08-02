//
//  ChartView.m
//  IOSlineChart
//
//  Created by Apple on 16/5/10.
//  Copyright © 2016年 zhangleishan. All rights reserved.
//
//一天的折线图



#import "ChartView.h"
#import "UUChart.h"
#import "LDXNetWork.h"


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:0.8]
#define OneColor UIColorFromRGB(0x036EB8)
#define TwoColor UIColorFromRGB(0XD7036A)
#define YeJiColor UIColorFromRGB(0XD7063A)


@interface ChartView ()<UUChartDataSource>{
    UUChart *chartView;
    int max;  //最大值
    int min;  //最小值
 
    NSMutableArray *X;  //横坐标
    NSMutableArray *Y;  //纵坐标

    UISwitch *switchs; //开关
    BOOL isShowValue;  //显示数值
    }
@property(nonatomic,strong) NSMutableArray *arrayX;//自己的折线
@property (nonatomic,strong)NSDate * date;//当前时间
@property long timepoint;//30天之前秒数
@property int key;//这里设置时间轴现实天数
@property(nonatomic,strong) NSMutableArray * time ;
@property(nonatomic,strong) NSMutableArray * timet ;
@property(nonatomic,strong) NSMutableArray * longtime;
@property(nonatomic,strong) NSMutableArray * longtimet;
@property(nonatomic,strong) NSMutableArray * tadytime ;
@end

@implementation ChartView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
         }
    [self setData];
    return self;
    
}
-(void)OK:(UISwitch *)sender{
    
    
    if (sender.on) {
        
        isShowValue = sender.on;
        
    }else{
        isShowValue = sender.on;
        
    }
    
    [chartView removeFromSuperview];
    
    chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(0, 0,self.frame.size.width, self.frame.size.height) withSource:self withStyle:UUChartLineStyle];
    

    [chartView showInView:self];
    
    
    
}
-(void)setData
{
    
    
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDefaults objectForKey:@"name"];
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    NSString *createPath3 = [NSString stringWithFormat:@"%@/%@/timeu.plist", pathDocuments,name];

    NSDictionary *dicthsj9 = [NSDictionary dictionaryWithContentsOfFile:createPath3];
    
    _time =dicthsj9[@"time"];
    _timet=dicthsj9[@"timet"];

    
    _date=[NSDate date];
    _key =10;
    
    long  now = (long)[_date timeIntervalSince1970];
    long trun=now/(24*60*60);
    long trun1=trun-_key+1;
    _timepoint=trun1*24*60*60;
              _longtime =[[NSMutableArray alloc]init];
    _longtimet =[[NSMutableArray alloc]init];
    NSString *p = [[NSString alloc]init];
     NSString *pt = [[NSString alloc]init];
    
    
   _tadytime = [[NSMutableArray alloc]init];
  for(int i=0;i<[_timet count];i++)
    {
        long  now = (long)[_date timeIntervalSince1970];
        long trun=now/(24*60*60);
        NSString * ls= [_timet objectAtIndex:i];
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
          [_tadytime addObject: tt];
        }
        

    }

            for(int i=0;i<_key;i++)
            {
                int dmax=0;
                int dmaxt=0;
                for(int j=0;j<[_time count];j++)
                {
                    NSString * ls= [_time objectAtIndex:j];
                    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
                    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                    NSDate * sls =  [formatter dateFromString:ls];
                    long longls = (long)[sls timeIntervalSince1970];
                    
                    if(longls/(24*60*60)==(_timepoint/(24*60*60))+i)
                    {
                        dmax ++;
                    }
                }
                
                
                
                
                for(int j=0;j<[_timet count];j++)
                {
                    NSString * ls= [_timet objectAtIndex:j];
                    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
                    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                    NSDate * sls =  [formatter dateFromString:ls];
                    long longls = (long)[sls timeIntervalSince1970];
                    
                    if(longls/(24*60*60)==(_timepoint/(24*60*60))+i)
                    {
                        dmaxt ++;
                    }
                }

                
               
                p=[NSString stringWithFormat:@"%d",dmax];
                pt=[NSString stringWithFormat:@"%d",dmaxt];
                [_longtime addObject: p];
                [_longtimet addObject: pt];
            }
          
    
    
    
 
    self.arrayX=[NSMutableArray arrayWithObjects:@"0",nil];
    
    
    long  kk = [_longtime count]-1;
    
    
    for (long  i= kk ;i >=0;i--)
    {
 
       long dd = (long)[_date timeIntervalSince1970];
       long fin=dd-i*86400;
       NSDate * datenow = [[NSDate alloc] initWithTimeIntervalSince1970:fin];
       NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //[dateFormatter setDateFormat:@"yy/MM/dd"];
       [dateFormatter setDateFormat:@"MM-dd"];
       NSString *strDate = [dateFormatter stringFromDate: datenow];
       [_arrayX addObject:strDate];
    }
    
   [_arrayX removeObjectAtIndex:0];//移除第一个元素
    
    
    
  //NSLog(@"shijiandian  %@",_tadytime);
    
    

   NSArray *array1Y=_longtime;
    if(array1Y==nil)
    {array1Y=[NSMutableArray arrayWithObjects:@0,nil];}
    
    NSArray *array2Y=_longtimet;
    
    if(array2Y==nil)
    {array2Y=[NSMutableArray arrayWithObjects:@0,nil];}
    //NSArray *array2Y= [NSArray arrayWithObjects:@"3",@"2",nil];;//取出纪录用户每日点击量数组max
    NSMutableArray *finalY=[NSMutableArray arrayWithCapacity:0];
    [finalY addObject:array1Y];
    [finalY addObject:array2Y];
    
    [self JsX:self.arrayX];
    [self JsY:finalY];
    [chartView removeFromSuperview];
    
    chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(0, 0,self.frame.size.width, self.frame.size.height) withSource:self withStyle:UUChartLineStyle];//这里可调图的位置和大小
    chartView.backgroundColor =[UIColor colorWithRed:(242/255.0f) green:(242/255.0f) blue:(242/255.0f) alpha:0];
    [chartView showInView:self];
    
    
}





-(void)JsX:(NSMutableArray *)ary{
    X = [NSMutableArray arrayWithArray:ary];
}
-(void)JsY:(NSMutableArray *)ary{
    NSArray * old1 = [ary objectAtIndex:0];
    NSArray *old2=[ary objectAtIndex:1];
    old1=[old1 arrayByAddingObjectsFromArray:old2];
    max = [[old1 valueForKeyPath:@"@max.intValue"] intValue];
    min = [[old1 valueForKeyPath:@"@min.intValue"] intValue];
    Y = [NSMutableArray arrayWithArray:ary];

}

#pragma mark------直线图和柱状图共用的代码
- (NSMutableArray *)UUChart_xLableArray:(UUChart *)chart{  //横坐标数据
    return X;
}
- (NSMutableArray *)UUChart_yValueArray:(UUChart *)chart{  //纵坐标数据
    return Y;
}

//颜色数组
- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    return @[OneColor,TwoColor];  //返回颜色数组，不同的线返回不同的数组
}
//显示数值范围
- (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart
{
    return CGRangeMake(max, min);
}

#pragma mark 折线图专享功能

//标记数值区域颜色加深
- (CGRange)UUChartMarkRangeInLineChart:(UUChart *)chart{
    
    return CGRangeZero;
}

//判断显示横线条
- (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index
{
    return YES;
}

//判断显示最大最小值
- (BOOL)UUChart:(UUChart *)chart ShowMaxMinAtIndex:(NSInteger)index
{
    return NO;
}

//判断是否显示数值
-(BOOL)UUChartShowValues:(UUChart *)chart{
    //return isShowValue;
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
