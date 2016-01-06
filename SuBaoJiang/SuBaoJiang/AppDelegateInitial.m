//
//  AppDelegateInitial.m
//  subao
//
//  Created by apple on 15/9/14.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "AppDelegateInitial.h"
#import "UIImage+AddFunction.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "CommonFunc.h"
#import "MobClick.h"
#import "ServerRequest.h"
#import "PicUploadTB.h"
#import "DraftTB.h"
#import "SequenceTB.h"
#import "XTPicCacheUploadManager.h"
#import <PhotoEditFramework/PhotoEditFramework.h>
#import "WeiboSDK.h"
#import "PasterManagement.h"
#import "UMessage.h"

#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface AppDelegateInitial ()
@property (nonatomic,strong) NSDictionary *launchOptions ;
@property (nonatomic,strong) UIApplication *application ;
@property (nonatomic,strong) UIWindow *window ;
@end

@implementation AppDelegateInitial

- (instancetype)initWithApplication:(UIApplication *)application options:(NSDictionary *)launchOptions window:(UIWindow *)window
{
    self = [super init];
    if (self) {
        self.application = application ;
        self.launchOptions = launchOptions ;
        self.window = window ;
    }
    
    return self;
}

- (void)setup
{
    //  Icon Badge
    [self setupIconBadge] ;
    
    //  Get App store Check Switch
    [self getAppCheckSwitch] ;
    
    //  Initial DB
    [self initialDB] ;
    
    //  Sand Box
    [CommonFunc getSandBoxPath] ;
    
    //  My Style
    [self setMyStyleWithWindow:self.window] ;
    
    //  Get Token and userInfo if loginED (token existed)
    [self getTokenAndUser] ;
    
    //  Camera360 SDK
    [self camera360Initialization] ;
    
    //  Umeng SDK initial .
    [self UmengSdkInitialization] ;
    
    //  weibo and weixin .
    [self weiboInitialization] ;
    
    //  Umeng SDK Analytics
    [self UMAnalyticsInitialization] ;
    
    //  Umeng Message Notification
    [self UMMessageNotificationInitializationWithLaunchOptions:self.launchOptions] ;
    
    //  Active RunLoop
    [self runloopForNewNotes] ;
    
    //  Upload Pictures RunLoop
    [self runloopForUploadPictures] ;
    
    //  initial paseter manegement and get pasterlist from server
    [self initialPastermanagement] ;
    
    //  initial cate colors
    [self initailCateColors] ;
    
    //  Back Ground Fetch
    [self.application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum] ;
}

#pragma mark --
// set My Style
- (void)setMyStyleWithWindow:(UIWindow *)window
{
    [[UIApplication sharedApplication] keyWindow].tintColor = COLOR_MAIN ;
    
    //1 base white at window not black background
    UIView *baseView = [[UIView alloc] initWithFrame:APPFRAME] ;
    baseView.backgroundColor = [UIColor whiteColor] ;
    [window addSubview:baseView] ;
    [window sendSubviewToBack:baseView] ;
    
    //2 nav style
    UIImage *img = [UIImage imageWithColor:COLOR_MAIN size:CGSizeMake(320.0, 64.0)];
    [[UINavigationBar appearance] setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
    //  nav base line
    [[UINavigationBar appearance] setShadowImage:[UIImage imageWithColor:COLOR_RED_LINE_NAV size:CGSizeMake(320.0, ONE_PIXEL_VALUE)]] ;
    //  nav word style
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}] ;
    //  status bar style
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]]    ;
}

// Umeng SDK SHARE
- (void)getTokenAndUser
{
    if ([[DigitInformation shareInstance] g_token] != nil)
    {
        [[DigitInformation shareInstance] g_currentUser] ;
    }
}

// Umeng SDK SHARE
- (void)UmengSdkInitialization
{
    [UMSocialData setAppKey:UM_APPKEY] ;
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:WX_APPKEY
                            appSecret:WX_APPSECRET
                                  url:@"http://www.subaojiang.com"] ;
    
//    [UMSocialSinaHandler openSSOWithRedirectURL:WB_REDIRECTURL] ;           //um第三方
//    [UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:WB_REDIRECTURL] ; //weibo原生
    
    //由于苹果审核政策需求，建议大家对未安装客户端平台进行隐藏，在设置QQ、微信AppID之后调用下面的方法，
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite]] ;
}

- (void)weiboInitialization
{
//    [WeiboSDK enableDebugMode:YES] ;
    [WeiboSDK registerApp:WB_APPKEY] ;
}

- (void)UMAnalyticsInitialization
{
    [MobClick startWithAppkey:UM_APPKEY reportPolicy:BATCH channelId:nil] ;
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ;
    [MobClick setAppVersion:version];
}

// UM 推送通知
- (void)UMMessageNotificationInitializationWithLaunchOptions:(NSDictionary *)launchOptions
{
    //set AppKey and AppSecret
    [UMessage startWithAppkey:UM_APPKEY launchOptions:launchOptions];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        //register remoteNotification types （iOS 8.0及其以上版本）
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
    } else{
        //register remoteNotification types (iOS 8.0以下)
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
#else
    //register remoteNotification types (iOS 8.0以下)
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
    
#endif
    //for log
    [UMessage setLogEnabled:YES] ;
}

- (void)camera360Initialization
{
    bool b = [pg_edit_sdk_controller sStart:CAMERA360_KEY] ;
    NSLog(@"camera360 : %d",b) ;
}

- (void)getAppCheckSwitch
{
    dispatch_queue_t queue = dispatch_queue_create("getCheckSwitchQueue", NULL) ;
    dispatch_async(queue, ^{
        [[DigitInformation shareInstance] g_openAPPStore] ;
    }) ;    
}

- (void)setupIconBadge
{
    if ( IS_IOS_VERSION(8.0) )
    {
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    }
}

- (void)runloopForNewNotes
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:60*2
                                                      target:self
                                                    selector:@selector(getNewSumFromServer)
                                                    userInfo:nil
                                                     repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes] ;
}

- (void)runloopForUploadPictures
{
    [[XTPicCacheUploadManager shareInstance] uploadInLoops] ;
    
    [[XTPicCacheUploadManager shareInstance] deleInLoops] ;
}

- (void)getNewSumFromServer
{
    [ServerRequest getNoReadMsgCountSuccess:^(id json) {
        ResultParsered *result = [[ResultParsered alloc] initWithDic:json] ;
        int count = [[result.info objectForKey:@"count_msg"] intValue] ;
        if (count) { // post resultparsel
            [[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_RUNLOOP_NOTES object:result] ;
        }
    } fail:nil] ;
}

//initial DB
- (void)initialDB
{
    dispatch_queue_t queue = dispatch_queue_create("initial_DB", NULL) ;
    dispatch_async(queue, ^{
        [[PicUploadTB shareInstance] creatTable] ;
        [[DraftTB shareInstance] creatTable] ;
        [[SequenceTB shareInstance] creatTable] ;
    }) ;
}

//initial paseter manegement and get pasterlist from server
- (void)initialPastermanagement
{
    dispatch_queue_t queue = dispatch_queue_create("pasterInitial", NULL) ;
    dispatch_async(queue, ^{
        [[PasterManagement shareInstance] allPastersList] ;
    }) ;
}

// initail Cate Colors
- (void)initailCateColors
{
    dispatch_queue_t queue = dispatch_queue_create("getCateColorsQueue", NULL) ;
    dispatch_async(queue, ^{
        [[DigitInformation shareInstance] cateColors] ;
    }) ;
}

@end
