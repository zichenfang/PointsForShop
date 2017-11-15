//
//  TTVenderHeader.h
//  SuiTu
//
//  Created by 殷玉秋 on 2017/5/12.
//  Copyright © 2017年 fff. All rights reserved.
//

#ifndef TTVenderHeader_h
#define TTVenderHeader_h
#import "TTRequestOperationManager.h"
#import "TTUserInfoManager.h"
#import "NSDate+MyDate.h"
#import "NSString+MyCustomString.h"
#import "UIColor+MyColor.h"
#import "UIImage+MyCustomImage.h"
#import "JsonKillNull.h"
#import "UIBarButtonItem+TTStyle.h"
#import "ProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "SDCycleScrollView.h"
#import "UIViewController+MyViewController.h"
#import "ZLPhotoActionSheet.h"

typedef void (^TTBlock)(NSDictionary *info);

//屏幕宽高
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define MESSAGE_CODE_TIMEOUT 60

#define PLACEHOLDER_GENERAL [UIImage imageNamed :@"placeholder_general"]
#define PLACEHOLDER_USER [UIImage imageNamed :@"placeholder_user"]
//MARK: 列表页内容个数
#define pageSize  @"50"
/*用户信息修改会触发*/
#define kNoti_userInfoChanged @"NNNNOTI_001"
/*收到新的即时消息*/
#define kNoti_RCMsgUpdated @"NNNNOTI_003"
/*收到新的好友验证消息*/
#define kNoti_FriendAuthReceived @"NNNNOTI_004"



#endif /* TTVenderHeader_h */
