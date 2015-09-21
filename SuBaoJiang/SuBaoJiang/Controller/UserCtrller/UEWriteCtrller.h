//
//  UEWriteCtrller.h
//  subao
//
//  Created by TuTu on 15/9/21.
//  Copyright © 2015年 teason. All rights reserved.
//

#import "RootCtrl.h"
#import "User.h"

typedef NS_ENUM(NSInteger, MODE_TypeOfUserInfo) {
    type_userName = 1 ,
    type_sex ,
    type_description
} ;

@protocol UEWriteCtrllerDelegate <NSObject>
- (void)sendMyUserInfoBack:(User *)userInfo ;
@end

@interface UEWriteCtrller : RootCtrl
@property (nonatomic)           MODE_TypeOfUserInfo type ;
@property (nonatomic,strong)    User                *userInfoWillChange ;
@property (nonatomic,strong)    id <UEWriteCtrllerDelegate> delegate ;
@end
