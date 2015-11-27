//
//  ThirdLoginCtrller.m
//  SuBaoJiang
//
//  Created by apple on 15/6/18.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "ThirdLoginCtrller.h"
#import "LoginSelfCtrller.h"
#import "XTAnimation.h"
#import "UMSocial.h"
#import "CommonFunc.h"
#import "WeiboSDK.h"
#import "AppDelegate.h"
#import "NotificationCenterHeader.h"

@interface ThirdLoginCtrller ()
// buttons
@property (weak, nonatomic) IBOutlet UIButton *bt_weixin;
@property (weak, nonatomic) IBOutlet UIButton *bt_weibo;
@property (weak, nonatomic) IBOutlet UIButton *bt_logOrReg;//本登陆
@property (weak, nonatomic) IBOutlet UIButton *bt_back;//随便逛逛

// images
@property (weak, nonatomic) IBOutlet UIImageView *img_fromHere;
@property (weak, nonatomic) IBOutlet UIImageView *img_wdTop;
@property (weak, nonatomic) IBOutlet UIImageView *img_flower;
@property (weak, nonatomic) IBOutlet UIImageView *img_train;
@property (weak, nonatomic) IBOutlet UIImageView *img_people;

@end

@implementation ThirdLoginCtrller

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(logSuccess)
                                                     name:NSNOTIFICATION_USER_CHANGE
                                                   object:nil] ;
        
        ((AppDelegate *)[UIApplication sharedApplication].delegate).thirdLoginCtrller = self ;
    }
    
    return self ;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(logSuccess)
                                                     name:NSNOTIFICATION_USER_CHANGE
                                                   object:nil] ;
        
        ((AppDelegate *)[UIApplication sharedApplication].delegate).thirdLoginCtrller = self ;
    }
    
    return self ;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSNOTIFICATION_USER_CHANGE
                                                  object:nil] ;
}

- (void)logSuccess
{
    [self.delegate seeMore] ; // dismiss ;
}

#pragma mark -- Actions
- (IBAction)weixinLoginAction:(id)sender
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            //得到的数据在回调Block对象形参respone的data属性
            [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
                NSLog(@"SnsInformation is %@",response.data);
                
                NSString *openID = [response.data objectForKey:@"openid"] ;
                NSNumber *gender = [response.data objectForKey:@"gender"] ;
                NSString *head   = [response.data objectForKey:@"profile_image_url"] ;
                
                [ServerRequest loginUnitWithCategory:mode_WeiXin wxopenID:openID wxUnionID:snsAccount.unionId nickName:snsAccount.userName gender:gender language:nil country:nil province:nil city:nil headpic:head wbuid:nil description:nil username:nil password:nil Success:^(id json) {
                    
                    ResultParsered *result = [[ResultParsered alloc] initWithDic:json] ;
                    [CommonFunc logSussessedWithResult:result AndWithController:self] ;
                    [CommonFunc bindWithBindMode:mode_weixin] ;
                    
                } fail:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [XTHudManager showWordHudWithTitle:WD_HUD_FAIL_RETRY] ;
                    }) ;
                }] ;
                
            }];
        }
        
    });
}

- (void)weiboSSO_Bt_Pressed
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = WB_REDIRECTURL;
    request.scope = @"all" ;
//@"email,direct_messages_write,direct_messages_read,invitation_write,friendships_groups_read,friendships_groups_write,statuses_to_me_read,follow_app_official_microblog" ; //@"all";
    
    [WeiboSDK sendRequest:request];
}

- (IBAction)weiboLoginAction:(id)sender
{
    [self weiboSSO_Bt_Pressed] ;
}

- (IBAction)loginAction:(id)sender
{
    if (self.delegate == nil)
    {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
        LoginSelfCtrller *loginSelfCtrller = [story instantiateViewControllerWithIdentifier:@"LoginSelfCtrller"] ;
        [self.navigationController pushViewController:loginSelfCtrller animated:YES] ;
    }
    else
    {
        [self.delegate logSelf] ;
    }
}

- (IBAction)backAction:(id)sender
{
    if (_bAboutUs) {
        [self.delegate seeMore] ;
        return ;
    }
    
    if (self.delegate == nil) {
        [self dismissViewControllerAnimated:YES completion:^{}] ;
    }
    else {
        [self.delegate seeMore] ;
    }
}

#pragma mark -- Life
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.myTitle = @"微博微信登录页" ;
    
    [self allHideInitial] ;

    [self flowerRain] ;
    
    if (self.bAboutUs)
    {
        _bt_weibo.hidden = YES ;
        _bt_weixin.hidden = YES ;
        _bt_logOrReg.hidden = YES ;
        [_bt_back setTitle:@"知道了" forState:UIControlStateNormal] ;
        
        return ;
    }

    //审核开关
    _bt_logOrReg.hidden = G_BOOL_OPEN_APPSTORE ;
    _bt_weibo.hidden = !G_BOOL_OPEN_APPSTORE ;
    _bt_weixin.hidden = !G_BOOL_OPEN_APPSTORE ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    [self.navigationController setNavigationBarHidden:YES animated:NO] ;
    
    if (_bLaunchInNav) [self startAnimate] ;
}

- (void)allHideInitial
{
    _img_train.hidden = YES ;
    _img_fromHere.alpha = 0.0 ;
    _img_wdTop.alpha = 0 ;
}

- (void)startAnimate
{
    [self allHideInitial] ;
    
    [UIView animateWithDuration:0.88f animations:^{
        _img_fromHere.alpha = 1.0f ;
        _img_train.transform = CGAffineTransformMakeTranslation(APPFRAME.size.width, 0);
    } completion:^(BOOL finished) {
        [self showTopword] ;
    }] ;
    
}

- (void)people
{
    CATransform3D tran = CATransform3DMakeScale(1.02, 1.02, 1) ;
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform"] ;
    animation.toValue= [NSValue valueWithCATransform3D:tran] ;
    animation.duration= 0.23 ;
    animation.autoreverses = YES ;
    animation.cumulative = YES ;
    animation.removedOnCompletion = YES ;
    animation.fillMode = kCAFillModeForwards ;
    animation.repeatCount= 1 ;
    [_img_people.layer addAnimation:animation forKey:@"people"] ;
}


- (void)showTopword
{
    _img_train.hidden = NO ;
    
    [UIView animateWithDuration:0.8f animations:^{

        _img_wdTop.alpha = 1.0f ;

        [self people] ;

    } completion:^(BOOL finished) {
        
        [self flowerDown] ;

    }] ;
}

- (void)flowerDown
{
    [UIView animateWithDuration:0.62f animations:^{
        
        _img_flower.alpha = 1.0f ;
        
    } completion:^(BOOL finished) {
        
        [self shake] ;
        
    }] ;
}

- (void)shake
{
    [UIView animateWithDuration:0.65 animations:^{
        
//        [XTAnimation shakeRandomDirectionWithDuration:0.45 AndWithView:_bt_weixin];
//        [XTAnimation shakeRandomDirectionWithDuration:0.85 AndWithView:_bt_weibo];
        
    } completion:^(BOOL finished) {

        [self train] ;
        
    }] ;
}

- (void)train
{
    [UIView animateWithDuration:1.65f animations:^{
        _img_train.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        CABasicAnimation *animat = [XTAnimation opacityForever_Animation:0.3] ;
        [_img_flower.layer addAnimation:animat forKey:@"flower"] ;
    }] ;
}

- (void)flowerRain
{
    // Configure the particle emitter to the top edge of the screen
    CAEmitterLayer *snowEmitter = [CAEmitterLayer layer]                        ;
//    snowEmitter.emitterPosition = CGPointMake(self.view.bounds.size.width / 2.0, 300);
//    snowEmitter.emitterSize		= CGSizeMake(self.view.bounds.size.width * 2.0, 0.0) ;
    snowEmitter.emitterPosition = CGPointMake(self.view.bounds.size.width / 2.0, 0.0);
    snowEmitter.emitterSize		= CGSizeMake(self.view.bounds.size.width , 0.0) ;
    snowEmitter.velocity = 0.2 ;
    // Spawn points for the flakes are within on the outline of the line
    snowEmitter.emitterMode		= kCAEmitterLayerOutline    ;
    snowEmitter.emitterShape	= kCAEmitterLayerSphere ;//kCAEmitterLayerSphere     ; //kCAEmitterLayerLine;
    // Configure the snowflake emitter cell
    CAEmitterCell *cell = [CAEmitterCell emitterCell]  ;
//	snowflake.emissionLongitude = 1 ;
    cell.velocity		=  1;				// falling down slowly
    cell.velocityRange  =  1;

    cell.birthRate		= 1.8   ;
    cell.lifetime		= 7.1   ;
    
    cell.alphaRange    = 0.6    ;
    cell.alphaSpeed    = 0.7    ;
    
//    snowflake.redRange = 1 ;
//    snowflake.redSpeed = 1 ;
    
    //Acceleration **
	cell.yAcceleration = 11   ;
    cell.xAcceleration = 1    ;
    cell.zAcceleration = -1   ;
    
    cell.emissionRange = 1 * M_PI;		// some variation in angle
    cell.spinRange	   = 2 * M_PI;		// slow spin
    
    cell.minificationFilter     = @"1" ;
    cell.minificationFilterBias = 0.5 ;
    
    cell.contents		= (id) [[UIImage imageNamed:@"singleflower"] CGImage];
    cell.color			= [[UIColor whiteColor] CGColor];
    
    cell.scale      = 0.1  ;
    cell.scaleRange = 0.1  ;
    cell.scaleSpeed = 0.08 ;
    
    // Make the flakes seem inset in the background
    snowEmitter.shadowOpacity = 1.0;
    snowEmitter.shadowRadius  = 0.0;
    snowEmitter.shadowOffset  = CGSizeMake(0.0, 1.0);
    snowEmitter.shadowColor   = [[UIColor whiteColor] CGColor];
    
    // Add everything to our backing layer below the UIContol defined in the storyboard
    snowEmitter.emitterCells = [NSArray arrayWithObject:cell];

    [self.view.layer addSublayer:snowEmitter];

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
