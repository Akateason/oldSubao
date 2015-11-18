//
//  NavCameraCtrller.m
//  SuBaoJiang
//
//  Created by apple on 15/6/2.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "NavCameraCtrller.h"
#import "NewCameaCtrller.h"
#import "Article.h"


@interface NavCameraCtrller ()
@property (nonatomic,copy) NSString                 *topicName ;
@property (nonatomic)      Mode_SingleOrMultiple    mode ;
@end

@implementation NavCameraCtrller
+ (void)jump2NavCameraCtrllerWithOriginCtrller:(UIViewController *)ctrller
                              AndWithTopicName:(NSString *)topicName
                                       AndMode:(Mode_SingleOrMultiple)mode
                              AndSuperAriticle:(Article *)superArticle
                   AndBigestSubArticleClientID:(int)bigestSubArticleCID
                       AndExistSubArticleCount:(int)existCount
{
    if ([NSRunLoop currentRunLoop].currentMode != NSDefaultRunLoopMode)
    {
        // dont let it push to Camera when the tableView is scrolling .
        return ;
    }
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
    NavCameraCtrller *cameraCtrller = [story instantiateViewControllerWithIdentifier:@"NavCameraCtrller"] ;
    cameraCtrller.topicName = topicName ;
    [ctrller presentViewController:cameraCtrller
                          animated:YES
                        completion:^{
                            NewCameaCtrller *newCtrller = (NewCameaCtrller *)cameraCtrller.topViewController ;
                            newCtrller.orginCtrller = ctrller ;
                            newCtrller.fetchMode = mode ;
                            newCtrller.topicStr = topicName ;
                            newCtrller.articleSuper = superArticle ;
                            newCtrller.existedSubArticleCount = existCount ;
                            newCtrller.bigestLastArticleClientID = bigestSubArticleCID ;
                        }] ;
    
}

+ (void)jump2NavCameraCtrllerWithOriginCtrller:(UIViewController *)ctrller
                              AndWithTopicName:(NSString *)topicName
                                       AndMode:(Mode_SingleOrMultiple)mode
                              AndSuperAriticle:(Article *)superArticle
{
    [self jump2NavCameraCtrllerWithOriginCtrller:ctrller
                                AndWithTopicName:topicName
                                         AndMode:mode
                                AndSuperAriticle:superArticle
                     AndBigestSubArticleClientID:0
                         AndExistSubArticleCount:0] ;
}


+ (void)jump2NavCameraCtrllerWithOriginCtrller:(UIViewController *)ctrller
                              AndWithTopicName:(NSString *)topicName
                                       AndMode:(Mode_SingleOrMultiple)mode
{
    [self jump2NavCameraCtrllerWithOriginCtrller:ctrller
                                AndWithTopicName:topicName
                                         AndMode:mode
                                AndSuperAriticle:nil
                     AndBigestSubArticleClientID:0
                         AndExistSubArticleCount:0] ;
}

+ (void)jump2NavCameraCtrllerWithOriginCtrller:(UIViewController *)ctrller
                              AndWithTopicName:(NSString *)topicName
{
    [self jump2NavCameraCtrllerWithOriginCtrller:ctrller
                                AndWithTopicName:topicName
                                         AndMode:mode_single] ;
}

+ (void)jump2NavCameraCtrllerWithOriginCtrller:(UIViewController *)ctrller
{
  
    [self jump2NavCameraCtrllerWithOriginCtrller:ctrller
                                AndWithTopicName:nil] ;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        UIImage * normalImage1 = [[UIImage imageNamed:@"tabitem_camera"]
                                  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage * selectImage1 = [[UIImage imageNamed:@"tabitem_camera"]
                                  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@""
                                                        image:normalImage1
                                                selectedImage:selectImage1] ;
        
        RESIZE_TABBAR_ITEM
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
