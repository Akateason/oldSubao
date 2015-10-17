//
//  RootCtrl.h
//  Teason
//
//  Created by ; on 14-8-21.
//  Copyright (c) 2014年 TEASON. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <AudioToolbox/AudioToolbox.h>
//#import <AVFoundation/AVFoundation.h>
#import "ColorsHeader.h"
#import "DigitInformation.h"
#import "XTAnimation.h"
#import "NSObject+MKBlockTimer.h"
#import "ServerRequest.h"
#import "YXSpritesLoadingView.h"
#import "XTHudManager.h"
#import "RootTableView.h"


@interface RootCtrl : UIViewController

//@property (retain, nonatomic) AVAudioPlayer *avPlay;

@property (nonatomic,strong) UITableView   *myTable ;
/*
** default NO ;
** if YES     : when no data is return  , show a img in the front ;
**/
@property (nonatomic,assign) BOOL          isNetSuccess ;

#pragma mark - show guiding
@property (nonatomic,strong) NSArray       *guidingStrList ;
@property (nonatomic)        int           guidingIndex ;

#pragma mark - Set No Back BarButton
/** default NO ;
 *  IF YES , delete all bar buttons
 */
@property (nonatomic)        BOOL          isDelBarButton ;

#pragma mark - talkingData title
@property (nonatomic,copy)   NSString      *myTitle ;

#pragma mark - hide tab bar
- (void)makeTabBarHidden:(BOOL)hide ;
- (void)makeTabBarHidden:(BOOL)hide animated:(BOOL)animated ;

#pragma mark - click back button in NavgationBar
@property (nonatomic)        BOOL           bOpenClickBackButtonCallBack ; // default is NO, YES when you have to implemete SEL - iClickedBackButton in ctrller .
- (void)iClickedBackButton ;

@end
