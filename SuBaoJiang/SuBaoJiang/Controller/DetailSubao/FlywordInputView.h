//
//  FlywordInputView.h
//  SuBaoJiang
//
//  Created by apple on 15/6/4.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleComment.h"
@class User ;

@protocol FlywordInputViewDelegate <NSObject>
- (void)resignWordSendViewAndKeyBoard ;
@end

@interface FlywordInputView : UIView
@property (nonatomic,retain) id <FlywordInputViewDelegate> delegate ;
@property (nonatomic,strong) User *userReply ;

// set flyword color
@property (nonatomic,copy)      NSString    *flyword ;
@property (nonatomic,retain)    UIColor     *flycolor ;
@property (nonatomic,retain)    UIFont      *flyfont ;

@property (nonatomic)   FLYWORD_COLOR_TYPE  typecolor ;
@property (nonatomic)   FLYWORD_SIZE_TYPE   typesize ;

// set buttons position
- (void)setButtonsHeight:(float)height ;
// get place holder str
- (NSString *)placeHolderString ;
// reset to origin
- (void)resetToOrigin ;

@end
