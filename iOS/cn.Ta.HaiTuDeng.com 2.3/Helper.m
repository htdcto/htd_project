//
//  Helper.m
//  cn.Ta.HaiTuDeng.com
//
//  Created by htd on 16/8/4.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import "Helper.h"
#import "BDViewController.h"
#import "DB.h"
#import "MainAryViewController.h"
#import "StatusViewController.h"
#import "Constant.h"


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
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
}
/*
 -(void)dealloc
 {
 [[EMClient sharedClient] removeDelegate:self];
 [[EMClient sharedClient].contactManager removeDelegate:self];
 [[EMClient sharedClient].chatManager removeDelegate:self];
 }
 */

#pragma mark - EMContactManagerDelegate
- (void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername
                                       message:(NSString *)aMessage
{
    NSString *username =aUsername;
    NSString *aleraTitle = @"请求与您绑定";
    NSString *alert = [username stringByAppendingString:aleraTitle];
    if(_bdVC){
        [_bdVC addFriendNotice:username alert:alert];
    }
    else
    {
        extern_name = username;
        extern_alert = alert;
    }
}

- (void)didReceiveAgreedFromUsername:(NSString *)aUsername
{
    if(_bdVC)
    {
        [_bdVC didReceiveAgreeFromFriendNotice:aUsername];
    }
    else
    {
        extern_agreename = aUsername;
    }
}

- (void)didReceiveDeclinedFromUsername:(NSString *)aUsername
{
    if(_bdVC)
    {
        [_bdVC didReceiveDeclineFromFriendNotice:aUsername];
    }
    else
    {
        extern_declinename = aUsername;
    }
}


#pragma mark - EMChatManagerChatDelegate

- (void)didReceiveCmdMessages:(NSArray *)aCmdMessages
{
    if ( JustLogin == YES)
    {
        aCmdMessages = nil;
        JustLogin = NO;
    }
    for (EMMessage *message in aCmdMessages)
        
    {
        EMCmdMessageBody *body = (EMCmdMessageBody *)message.body;
        
        if ([body.action isEqualToString:UpdateLocalDBAndServer]) {
            [_mavc updateHeartMessage];
        }
        if([body.action isEqualToString:UpdateBackImage]){
            [_mavc setBackImage];
        }
        if ([body.action isEqualToString:UpdateStatusImage])
        {
            [_svc backImageDown];
        }
    }
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
