//
//  Common.h
//  Yueba
//
//  Created by qingyun on 16/7/14.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#ifndef Common_h
#define Common_h

//url

#define kBaseURL @"http://yueba.applinzi.com/"
#define kSMSCodeAPI @"users/smsCaptcha.json"
#define kCreatedAccountAPI @"users/regist.json"
#define kLoginAPI @"users/login.json"
#define kUploaduserInfoAPI @"users/upload_user_info.json"
#define kOtherUserInfosAPI @"users/get_other_info_list.json"
#define kAddFriendAPI @"users/friend_tie.json"
#define kFriendListAPI @"users/friend_list.json"

//bounds

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width

//#define DEBUG 1

//#ifdef DEBUG
//#define DMLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__,[NSString stringWithFormat:__VA_ARGS__])
//#else
//#define DMLog(...) do{}while(0)

//#define CUSTOM 1

#ifdef DEBUG
#else
#define NSLog(...) {};
#endif


#endif /* Common_h */
