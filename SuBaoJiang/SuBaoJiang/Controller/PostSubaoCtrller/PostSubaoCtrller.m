//
//  PostSubaoCtrller.m
//  SuBaoJiang
//
//  Created by apple on 15/6/26.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "PostSubaoCtrller.h"
#import "PostMainCell.h"
#import "CommonFunc.h"
#import "SelectTalkCtrller.h"
#import "XTTickConvert.h"
#import "XTFileManager.h"
#import "QiniuSDK.h"
#import "Article.h"
#import "PostShareCell.h"
#import "UMSocial.h"
#import "NSString+Extend.h"
#import "ShareUtils.h"
#import "PicWillUpload.h"
#import "PostMoreCell.h"
#import "NavCameraCtrller.h"
#import "DraftTB.h"
#import "AppDelegate.h"


#define PMainCellId     @"PostMainCell"
#define PShareCellID    @"PostShareCell"
#define PMoreCellID     @"PostMoreCell"

#define BUCKECT         @"social"

#define NONE_HEIGHT     1.0f

@interface PostSubaoCtrller () <PostMainCellDelegate,SelectTalkCtrllerDelegate,PostShareCellDelegate>
{
    BOOL            isFirstTime ;
    BOOL            m_bWeiboSelect  ;
    BOOL            m_bWeixinSelect ;
    
    int             share_articleID ;
    NSString        *share_topicStr ;
    NSString        *share_content ;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btPost;
@property (nonatomic,copy) NSString *contentEditing ;
@end

@implementation PostSubaoCtrller

#pragma mark --
#pragma mark -- Actions
- (IBAction)postButtonPressedAction:(id)sender
{
    NSLog(@"发布") ;
    
    [self postBtOnOrOff:YES] ;
    
    long long tick = [XTTickConvert getTickWithDate:[NSDate date]] ;
    
// upload Pic
    PicWillUpload *pic = [[PicWillUpload alloc] initNewWithUserID:G_USER.u_id tick:tick] ;
    [pic cachePic:_imageSend] ;
    [pic uploadPic] ;
    
// Get Main Cell Obj
    PostMainCell *mainCell = (PostMainCell *)[self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] ;
    
// Hidden Keyboard
    [mainCell hideKeyboard] ;
    
    NSString *strWillSend = mainCell.textview.text ;
    
// Judge when words over flow
    if (strWillSend.length > 140) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [XTHudManager showWordHudWithTitle:WD_WORDS_OVERFLOW] ;
        }) ;
        [self postBtOnOrOff:NO] ;
        return ;
    }
    
//  Minus Space
    strWillSend = [strWillSend minusSpaceStr] ;
    
// Save in photo library
//    [CommonFunc saveImageToLibrary:_imageSend] ;
    
// Topic Str
    NSString *strTopic = self.topicString ; // mainCell.topicStr ;
    
// Post up to subao server
    [ServerRequest uploadArticle:strWillSend
                           image:[pic qiNiuPath]
                           topic:mainCell.topicStr
                         success:^(id json) {
        
        ResultParsered *result = [[ResultParsered alloc] initWithDic:json] ;
        int articleID = [[result.info objectForKey:@"article_id"] intValue] ;
        
        // Share
        share_articleID = articleID ;
        share_topicStr = strTopic ;
        share_content = strWillSend ;
        
        [self shareArticleNow] ;
        
        // return to home ctrller
        [self makeTabBarHidden:NO] ;
        
        [self dismissViewControllerAnimated:NO completion:^{
            ((AppDelegate *)([UIApplication sharedApplication].delegate)).tabbarCtrller.selectedIndex = 0 ;
        }] ;
        
        // Insert In Home
        Article *articleNew = [[Article alloc] initWithArticleID:articleID
                                                          ImgStr:[pic qiNiuPath]
                                                         content:strWillSend
                                                    topicContent:mainCell.topicStr
                                                           title:@""
                                                      createTime:tick] ;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_UPLOAD_FINISHED
                                                            object:articleNew] ;
        [self postBtOnOrOff:NO] ;
                         
    } fail:^{
        [XTHudManager showWordHudWithTitle:WD_HUD_FAIL_RETRY] ;
        [self postBtOnOrOff:NO] ;
    }] ;
}

- (void)postBtOnOrOff:(BOOL)bOn
{
    if (bOn) {
        _btPost.enabled = NO ;
        [YXSpritesLoadingView showWithText:nil andShimmering:NO andBlurEffect:NO] ;
    } else {
        _btPost.enabled = YES ;
        [YXSpritesLoadingView dismiss] ;
    }
}

- (void)shareArticleNow
{
    share_content = ! share_content ? @"" : share_content ;
    
    // 要跳的链接
    NSString *strUrl = [NSString stringWithFormat:SHARE_DETAIL_URL,share_articleID] ;
    
    // share to weibo   if needed
    if (m_bWeiboSelect)
    {
        m_bWeiboSelect = NO ;
        
        NSString *strShow = [ShareUtils shareContent:share_content urlStr:strUrl isWeiXin:NO] ;
        
        [ShareUtils weiboShareFuncWithContent:strShow
                                        image:_imageSend
                                        topic:share_topicStr
                                      ctrller:self] ;
        
    }
    else if (m_bWeixinSelect)
    {
        // share to weixin  if needed
        m_bWeixinSelect = NO ;
        NSString *wxstrShow = [ShareUtils shareContent:share_content urlStr:strUrl isWeiXin:YES] ;
        [ShareUtils wxFriendShareFuncContent:wxstrShow
                                       image:_imageSend
                                       topic:share_topicStr
                                         url:strUrl
                                     ctrller:self] ;
    }
}

#pragma mark -- Properties
- (void)setImageSend:(UIImage *)imageSend
{
    _imageSend = imageSend ;
    
    [self.table performSelectorOnMainThread:@selector(reloadData)
                                 withObject:nil
                              waitUntilDone:NO] ;
}

#pragma mark -- setup
- (void)setup
{
    _table.delegate = self ;
    _table.dataSource = self ;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone ;
    _table.backgroundColor = COLOR_BG_POSTCELL ;
    
    [self.table registerNib:[UINib nibWithNibName:PMainCellId bundle:nil]
     forCellReuseIdentifier:PMainCellId];
    [self.table registerNib:[UINib nibWithNibName:PShareCellID bundle:nil]
     forCellReuseIdentifier:PShareCellID];
    [self.table registerNib:[UINib nibWithNibName:PMoreCellID bundle:nil]
     forCellReuseIdentifier:PMoreCellID];
}

#pragma mark -- life
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myTitle = @"单图发布页" ;

    [self.navigationController setNavigationBarHidden:NO animated:NO] ;
    [[UIApplication sharedApplication] setStatusBarHidden:NO] ;
    
    // setup table
    [self setup] ;
    
    isFirstTime = YES ;
    
    if ([CommonFunc isFirstPostSinglePage]) {
        self.guidingStrList = @[@"guiding_post"] ;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    ((AppDelegate *)([UIApplication sharedApplication].delegate)).postSubaoCtrller = self ;

    [self.navigationController setNavigationBarHidden:NO animated:NO] ;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone] ;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
    
    isFirstTime = NO ;
    
    ((AppDelegate *)([UIApplication sharedApplication].delegate)).postSubaoCtrller = nil ;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --
#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return G_BOOL_OPEN_APPSTORE ? 3 : 2 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.section)
    {
        PostMainCell * cell = [tableView dequeueReusableCellWithIdentifier:PMainCellId] ;
        if (!cell) {
            cell = [tableView dequeueReusableCellWithIdentifier:PMainCellId] ;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        cell.image      = self.imageSend ;
        cell.topicStr   = self.topicString ;
        cell.textview.text = self.contentEditing ;
        cell.delegate = self ;
        return cell ;
    }
    else if (!(indexPath.section - 1))
    {
        PostMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:PMoreCellID] ;
        if (!cell) {
            cell = [tableView dequeueReusableCellWithIdentifier:PMoreCellID] ;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        return cell ;
    }
    else if (!(indexPath.section - 2))
    {
        PostShareCell * cell = [tableView dequeueReusableCellWithIdentifier:PShareCellID] ;
        if (!cell)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:PShareCellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        cell.delegate = self ;
        return cell ;
    }
    return nil ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if      (indexPath.section == 0) return 210.0f ;
    else if (indexPath.section == 1) return 126.0f ;
    else if (indexPath.section == 2) return 73.0f  ;
    
    return 0.0f ;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        PostMainCell *mainCell = (PostMainCell *)[self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] ;
        NSString *strWillSend = mainCell.textview.text ;

        // create super Client ID
        int maxCid = [[DraftTB shareInstance] getMaxID] ;
        maxCid ++ ;
        long long tick = [XTTickConvert getTickWithDate:[NSDate date]] ;
        NSString *picPath = [Article getPicPath:tick aid:maxCid] ;
        
        Article *superArticleTemp = [[Article alloc] initArtWithClientID:maxCid
                                                    superClientArticleID:0
                                                              createTime:tick
                                                             realpicPath:picPath
                                                                 content:strWillSend
                                                                   title:nil
                                                                topicStr:self.topicString] ;
        
        [superArticleTemp cachePicInLocal:_imageSend tick:tick] ;
        
        [NavCameraCtrller jump2NavCameraCtrllerWithOriginCtrller:self
                                                AndWithTopicName:self.topicString
                                                         AndMode:mode_multip
                                                AndSuperAriticle:superArticleTemp] ;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *backView = [[UIView alloc] init] ;
    backView.backgroundColor = nil ;
    return backView ;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return NONE_HEIGHT ;
}

// custom view for footer. will be adjusted to default or specified footer height
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *backView = [[UIView alloc] init] ;
    backView.backgroundColor = nil ;
    return backView ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return NONE_HEIGHT ;
}

#pragma mark -- PostMainCellDelegate
- (void)talkButtonPressedWithPreContent:(NSString *)preContent ;
{
    self.contentEditing = preContent ;
    [self performSegueWithIdentifier:@"post2select" sender:nil] ;
}

#pragma mark -- SelectTalkCtrllerDelegate
- (void)talkContentSelected:(NSString *)topicContent
{
    // Get Main Cell Obj
    self.topicString = topicContent ;
    [self.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                      withRowAnimation:UITableViewRowAnimationNone] ;
}

#pragma mark -- PostShareCellDelegate
- (void)weiboPressed:(BOOL)bSelected
{
    m_bWeiboSelect = bSelected ;
    if (!bSelected) return ;
}

- (void)weixinPressed:(BOOL)bSelected
{
    m_bWeixinSelect = bSelected ;
    if (!bSelected) return ;
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"post2select"])
    {
        SelectTalkCtrller *selTalkCtrller = (SelectTalkCtrller *)[segue destinationViewController] ;
        selTalkCtrller.delegate = self ;
    }
}

@end
