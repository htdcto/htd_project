//
//  Helper.m
//  cn.Ta.HaiTuDeng.com
//
//  Created by htd on 16/8/4.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import "Helper.h"
#import "BDViewController.h"

@implementation Helper

static Helper *helper = nil;

+ (instancetype)shareHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[Helper alloc] init];
    });
    return helper;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initHelper];
    }
    return self;
}

- (void)initHelper
{
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
}

#pragma mark - EMContactManagerDelegate
- (void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername
                                    message:(NSString *)aMessage
{
    NSString *username =aUsername;
    NSString *aleraTitle = @"请求与您绑定";
    NSString *alert = [username stringByAppendingString:aleraTitle];
    NSLog(@"%@",username);
    [self.delegate addFriendNotice:username alert:alert];
//绑定提示框截止
}

- (void)didReceiveAgreedFromUsername:(NSString *)aUsername
{
    [self.delegate didReceiveAgreeFromFriendNotice:aUsername];
}

- (void)didReceiveDeclinedFromUsername:(NSString *)aUsername
{
    [self.delegate didReceiveDeclineFromFriendNotice:aUsername];
}

#pragma mark -
//-------------------------------------------------
-(void)didAutoLoginWithError:(EMError *)aError
{
    NSLog(@"来自IM：已经自动登录");
}

- (void)didConnectionStateChanged:(EMConnectionState)aConnectionState;
{
    NSLog(@"来自IM:连接状态发生改变");
}
//-------------------------------------------------xzl

@end
