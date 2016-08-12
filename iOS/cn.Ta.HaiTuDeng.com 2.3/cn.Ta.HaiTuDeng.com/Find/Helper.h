//
//  Helper.h
//  cn.Ta.HaiTuDeng.com
//
//  Created by htd on 16/8/4.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "BDViewController.h"
//#import "ViewController.h"

@protocol HelperDelegate <NSObject>
-(void)addFriendNotice:(NSString *)name alert:(NSString *)alertMessage;
-(void)didReceiveAgreeFromFriendNotice:(NSString *)name;
-(void)didReceiveDeclineFromFriendNotice:(NSString *)name;

@end
@interface Helper : NSObject<EMClientDelegate, EMContactManagerDelegate>
@property (nonatomic, assign) id<HelperDelegate> delegate;
@property (nonatomic,strong) BDViewController *BD;
+ (instancetype)shareHelper;
@end