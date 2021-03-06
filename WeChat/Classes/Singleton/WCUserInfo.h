//
//  WCUserInfo.h
//  WeChat
//
//  Created by 刘超 on 15/4/20.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface WCUserInfo : NSObject

/** 账号 */
@property (nonatomic, copy) NSString *user;
/** 密码 */
@property (nonatomic, copy) NSString *pwd;
/** 是否已登录 */
@property (nonatomic, assign, getter=isLogined) BOOL logined;
/** JID */
@property (nonatomic, copy) NSString *JID;

/** 注册账号 */
@property (nonatomic, copy) NSString *registerUser;
/** 注册密码 */
@property (nonatomic, copy) NSString *registerPwd;

singleton_interface(WCUserInfo)

/** 保存用户信息到沙盒 */
- (void)saveUserInfoToSandbox;
/** 获取用户信息到沙盒 */
- (void)loadUserInfoToSandbox;

@end
