//
//  UPImageViewController.m
//  cn.Ta.HaiTuDeng.com
//
//  Created by piupiupiu on 16/8/7.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import "UPImageViewController.h"

@interface UPImageViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>
@property (nonatomic,strong)UIImage *image;
@property (nonatomic ,strong)NSString *Strbtntag;

@end

@implementation UPImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ScollViewBtn];
    // Do any additional setup after loading the view from its nib.
}
-(void)ScollViewBtn
{
    _BqScrollView.pagingEnabled = YES;
    _BqScrollView.delegate = self;
    _BqScrollView.bounces = NO;
    
   
    NSArray *array = [NSArray arrayWithObjects:[UIImage imageNamed:@"表情1.png"],
                      [UIImage imageNamed:@"表情2.png"],[UIImage imageNamed:@"表情3.png"],[UIImage imageNamed:@"表情4.png"], nil];
  
    for (int i = 0 ; i < array.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10+50*i, 0, 50,50)];
        //[btn setTitle:array[i] forState:UIControlStateNormal];
        [btn setImage:array[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        
        
        [_BqScrollView addSubview:btn];
    }
    _BqScrollView.contentSize = CGSizeMake(50*array.count , 30);
    
    
}
-(void)btnClick:(UIButton *)btn{
    NSLog(@"%ld",(long)btn.tag);
    if (btn.tag == 0) {
        [_BQimage  setImage:[UIImage imageNamed:@"表情1.png"]];
        _Strbtntag  = @"1";
    }else{
        if (btn.tag == 1) {
            [_BQimage  setImage:[UIImage imageNamed:@"表情2.png"]];
            _Strbtntag  = @"2";
        }else{
            if (btn.tag == 2) {
                [_BQimage  setImage:[UIImage imageNamed:@"表情3.png"]];
                _Strbtntag  = @"3";
            }else{
                if (btn.tag == 3) {
                    [_BQimage  setImage:[UIImage imageNamed:@"表情4.png"]];
                    _Strbtntag  = @"4";
                }
            }
        }
    }
    
    
}
//选择状态图片按钮
- (IBAction)StatusBtn:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    // 从图库来源
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    picker.delegate  = self;
    
    [self presentViewController:picker animated:YES completion:nil];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    _image = info[UIImagePickerControllerEditedImage];
    // 给button按钮改变图片
    [self.StatusBtn setImage:_image forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];

    
}
//上传按钮
- (IBAction)SCBtn:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDefaults objectForKey:@"name"];
    NSDate *date = [NSDate date];
    
    if (_image == nil) {
        [self showTheAlertView:self andAfterDissmiss:1.5 title:@"状态图片不能为空" message:@""];
    }else{
        if (_Strbtntag == nil) {
            [self showTheAlertView:self andAfterDissmiss:1.5 title:@"表情不能为空" message:@""];
        }else{
            NSDictionary *dic = @{@"Utel":name,@"Time":date,@"Mood":_Strbtntag};
            [LDXNetWork PostThePHPWithURL:STATUS par:dic image:_image uploadName:@"uploadimageFile" success:^(id response) {
                NSString *success = response[@"success"];
                if ([success isEqualToString:@"1"]) {
                    
                    
                    
                    StatusViewController *sta = [[StatusViewController alloc]init];
                    
                    self.view.window.rootViewController = sta;
                    [self showTheAlertView:self andAfterDissmiss:1.5 title:@"上传成功" message:@""];
                    
                }
                
                else if([success isEqualToString:@"-1"]){
                    [self showTheAlertView:self andAfterDissmiss:1.5 title:@"上传失败" message:@""];
                }
                
            } error:^(NSError *error) {
                NSLog(@"错误的原因:%@",error);
            }];

        }
    }
    

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
