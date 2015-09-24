//
//  UserInfoView.h
//  subao
//
//  Created by apple on 15/9/2.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@protocol UserInfoViewDelegate <NSObject>
- (void)userInfoTappedBackground ;
- (void)editBtClick ;
@end

@interface UserInfoView : UIView
@property (nonatomic,weak)  id <UserInfoViewDelegate> delegate ;
@property (nonatomic,strong)User *theUser ;
- (void)animationForUserHead ;
@end
