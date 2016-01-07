//
//  MultyEditCtrller.m
//  subao
//
//  Created by apple on 15/8/20.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "MultyEditCtrller.h"
#import "SelectTalkCtrller.h"
#import "Article.h"
#import "ArticleTopic.h"
#import "EditContentCtrller.h"
#import "MESuperArticleCell.h"
#import "MESubArticleCell.h"
#import "MESuperAddCell.h"
#import "PostShareCell.h"
#import "ShareUtils.h"
#import "SIAlertView.h"
#import "NavCameraCtrller.h"
#import "FMMoveTableView.h"
#import "SequenceTB.h"
#import "DraftTB.h"
#import "CommonFunc.h"
#import "PicWillUpload.h"
#import "PicUploadTB.h"
#import "NSString+Extend.h"
#import <TuSDK/TuSDK.h>
#import "XTTickConvert.h"
#import "EditPreviewCtrl.h"
#import "AppDelegate.h"
#import "XTFileManager.h"
#import "EditPrepareCtrller.h"
#import "NewCameaCtrller.h"
#import "UIImage+AddFunction.h"
#import "XTJson.h"

#define LINE_HEIGHT             0.0f
#define MESUPERARTICLECELL_ID   @"MESuperArticleCell"
#define MESUBARTICLE_ID         @"MESubArticleCell"
#define POSTSHARE_ID            @"PostShareCell"
#define MES_ADDCELL_ID          @"MESuperAddCell"

@interface MultyEditCtrller () <UITableViewDataSource,UITableViewDelegate,MESuperArticleCellDelegate,MESuperAddCellDelegate,MESubArticleCellDelegate,SelectTalkCtrllerDelegate,EditContentCtrllerDelegate,PostShareCellDelegate,FMMoveTableViewDataSource,FMMoveTableViewDelegate,EditPreviewCtrlDelegate>
{
    BOOL            m_bWeiboSelect ;
    BOOL            m_bWeixinSelect ;

    int             m_fromRowWillInsert ;
    int             m_clientAid_respond ;
    
    
    int             share_articleID ;
    NSString        *share_topicStr ;
    NSString        *share_content ;
}
@property (weak, nonatomic)IBOutlet FMMoveTableView    *table ;
@property (nonatomic,strong)        Article            *superArticle ;
@property (nonatomic, copy)         NSString           *topicString ;
@property (atomic,strong)           NSMutableArray     *childsList ; // sub articles .
@property (nonatomic,strong)        NSArray            *sequenceListOfChild ;
@property (nonatomic)               int                maxClientSubA_ID ;
@end

@implementation MultyEditCtrller

+ (void)jump2MultyEditCtrllerWithOrginCtrller:(UIViewController *)ctrller
                                 superArticle:(Article *)superArticle
                                     topicStr:(NSString *)topicStr
                                    childList:(NSMutableArray *)childslist
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
    MultyEditCtrller *multyEditCtrller = [story instantiateViewControllerWithIdentifier:@"MultyEditCtrller"] ;
    
    multyEditCtrller.superArticle = superArticle ;
    multyEditCtrller.topicString = topicStr ;

    NSMutableArray *tempChildList = [NSMutableArray array] ;
    if ([[SequenceTB shareInstance] ExistThisSequece:superArticle.client_AID])
    {
        // new sequence .
        NSArray *sequeceList = [CommonFunc getArrayFromCommaString:[[SequenceTB shareInstance] getSequeceStrWithCid:superArticle.client_AID]] ;
        for (NSNumber *number in sequeceList) {
            int sequenceCid = [number intValue] ;
            for (Article *subArticle in childslist) {
                if (sequenceCid == subArticle.client_AID) {
                    [tempChildList addObject:subArticle] ;
                }
            }
        }
        
        childslist = tempChildList ;
    }
    
    multyEditCtrller.childsList = childslist ;

    [multyEditCtrller setHidesBottomBarWhenPushed:YES] ;
    [ctrller.navigationController pushViewController:multyEditCtrller animated:YES] ;
}

+ (void)finishedChoosePhotosWithImgList:(NSArray *)imgList
                           superArticle:(Article *)superArticle
               bigestSubArticleClientID:(int)bigestSubArticleClientID
                               strTopic:(NSString *)topicStr
                                ctrller:(UIViewController *)ctrller
                          originCtrller:(UIViewController *)orgCtrller
{
    
    //  get childs list
    NSMutableArray *subArticleList = [NSMutableArray array] ;
    int flexValue = !bigestSubArticleClientID ? 2 : 1 ; // new self and super article Client ID in DB .
    
    for (ALAsset *asset in imgList)
    {
        UIImage *fullImage = [UIImage fetchFromLibrary:asset] ;
//        UIImage *fullImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]] ;
        
        // create sub article Client ID
        int maxCid = bigestSubArticleClientID ? bigestSubArticleClientID : [[DraftTB shareInstance] getMaxID] ;
        maxCid += flexValue ;
        long long tick = [XTTickConvert getTickWithDate:[NSDate date]] ;
        NSString *picPath = [Article getPicPath:tick aid:maxCid] ;
        
        Article *subArticleTemp = [[Article alloc] initArtWithClientID:maxCid
                                                  superClientArticleID:superArticle.client_AID
                                                            createTime:tick
                                                           realpicPath:picPath
                                                               content:nil
                                                                 title:nil
                                                              topicStr:nil] ;
        
        [subArticleTemp cachePicInLocal:fullImage tick:tick] ;
        
        [subArticleList addObject:subArticleTemp] ;
        flexValue++ ;
    }
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35f];
    [animation setType:kCATransitionFade];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    
    [ctrller dismissViewControllerWithAnim:animation completion:^{
        
        if ([orgCtrller isKindOfClass:[MultyEditCtrller class]])
        {
            [(MultyEditCtrller *)orgCtrller insertSubList:subArticleList] ;
        }
        else
        {
            [MultyEditCtrller jump2MultyEditCtrllerWithOrginCtrller:orgCtrller
                                                       superArticle:superArticle
                                                           topicStr:topicStr
                                                          childList:subArticleList] ;
        }
        
    }] ;
}

//Called This Func When Choose Photos Finished
- (void)insertSubList:(NSArray *)subListWillInsert
{
//    m_fromRowWillInsert
    int resultRow = !self.childsList.count ? 0 : m_fromRowWillInsert + 1 ;
    NSRange range = NSMakeRange(resultRow, [subListWillInsert count]) ;
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range] ;
    [self.childsList insertObjects:subListWillInsert
                         atIndexes:indexSet] ;
    
    [self.table performSelectorOnMainThread:@selector(reloadData)
                                 withObject:nil
                              waitUntilDone:YES] ;
}

- (void)changeImageCallback:(UIImage *)realImage
{
    // clientAid equals 0 when its super article
    if (m_clientAid_respond == self.superArticle.client_AID)
    {
        self.superArticle.realImage = realImage ;
        // local cache .
        [XTFileManager savingPicture:realImage path:[Article getPathInLocal:self.superArticle.realImagePath]] ;
    }
    else
    {
        for (Article *subArticle in self.childsList)
        {
            if (subArticle.client_AID == m_clientAid_respond)
            {
                subArticle.realImage = realImage ;
                // local cache .
                [XTFileManager savingPicture:realImage path:[Article getPathInLocal:subArticle.realImagePath]] ;
                break ;
            }
        }
    }
    
    [self.table reloadData] ;
}

#pragma mark --
#pragma mark - EditPrepareCtrllerDelegate
- (void)editFinishCallBackWithImage:(UIImage *)image
{
    // clientAid equals 0 when its super article
    if (m_clientAid_respond == self.superArticle.client_AID)
    {
        self.superArticle.realImage = image ;
        // local cache .
        [XTFileManager savingPicture:image path:[Article getPathInLocal:self.superArticle.realImagePath]] ;
    }
    else
    {
        for (Article *subArticle in self.childsList)
        {
            if (subArticle.client_AID == m_clientAid_respond)
            {
                subArticle.realImage = image ;
                // local cache .
                [XTFileManager savingPicture:image path:[Article getPathInLocal:subArticle.realImagePath]] ;
                break ;
            }
        }
    }
    
    [self.table reloadData] ;
}


#pragma mark --
#pragma mark - Prop
- (int)maxClientSubA_ID
{
    _maxClientSubA_ID = 0 ;
    
    int tempMaxCid = 0 ;
    for (int i = 0; i < self.childsList.count; i++)
    {
        Article *subArti = self.childsList[i] ;
        if (subArti.client_AID > tempMaxCid) {
            tempMaxCid = subArti.client_AID ;
        }
    }
    
    _maxClientSubA_ID = tempMaxCid ;
    
    return _maxClientSubA_ID ;
}

- (void)setTopicString:(NSString *)topicString
{
    _topicString = topicString ;
    
    if (topicString)
    {
        ArticleTopic *topicTemp = [[ArticleTopic alloc] init] ;
        topicTemp.t_content = topicString ;
        self.superArticle.articleTopicList = @[topicTemp] ;
    }
}

- (NSArray *)sequenceListOfChild
{
    if (!_sequenceListOfChild) {
        _sequenceListOfChild = [[NSArray alloc] init] ;
    }
    
    NSMutableArray *tempList = [NSMutableArray array] ;
    for (Article *subArticle in self.childsList) {
        [tempList addObject:@(subArticle.client_AID)] ;
    }
    _sequenceListOfChild = tempList ;
    
    return _sequenceListOfChild ;
}

#pragma mark --
#pragma mark - setup
- (void)putNavBarItem
{
    UIBarButtonItem *postBt     = [[UIBarButtonItem alloc] initWithTitle:@"发布"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(postBtClickAction)] ;
    UIBarButtonItem *delDraftBt = [[UIBarButtonItem alloc] initWithTitle:@"删除草稿"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(delDraftBtClickAction)] ;
    UIBarButtonItem *gap        = [[UIBarButtonItem alloc] initWithTitle:@"|"
                                                            style:UIBarButtonItemStyleDone
                                                           target:self
                                                           action:nil] ;
    
    self.navigationItem.rightBarButtonItems = ([[DraftTB shareInstance] ExistThisArticle:self.superArticle.client_AID]) ? @[postBt,gap,delDraftBt] : @[postBt] ;
    
    UIBarButtonItem *backBt     = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(backAction)] ;
    self.navigationItem.leftBarButtonItem = backBt ;
}

#pragma mark --
#pragma mark - Action
- (void)postBtClickAction
{
    NSLog(@"发布") ;
    
    [self.table reloadData] ;
    
    if (![self necessaryCondition]) return ;
    
    // super article
    //1.upload Pic
    int picMaxID = [[PicUploadTB shareInstance] getMaxID] + 1 ;
    PicWillUpload *pic = [[PicWillUpload alloc] initWithName:[Article getPicPath:self.superArticle.a_createtime aid:self.superArticle.client_AID]
                                              uploadFinished:NO
                                                       idPic:picMaxID
                                                      userID:G_USER.u_id
                                                        tick:self.superArticle.a_createtime] ;
    pic.path = [Article getPathInLocal:self.superArticle.realImagePath] ;
    [pic cachePicNotLocal:self.superArticle.realImage] ;
    [pic uploadPic] ;
    
    // childs list .
    NSMutableArray *dicList = [NSMutableArray array] ;
    for (Article *subArti in self.childsList)
    {
        picMaxID++ ;
        PicWillUpload *subPic = [[PicWillUpload alloc] initWithName:[Article getPicPath:subArti.a_createtime
                                                                                    aid:subArti.client_AID]
                                                     uploadFinished:NO
                                                              idPic:picMaxID
                                                             userID:G_USER.u_id
                                                               tick:subArti.a_createtime] ;

        subPic.path = [Article getPathInLocal:subArti.realImagePath] ;
        [subPic cachePicNotLocal:subArti.realImage] ;
        [subPic uploadPic] ;
        
        NSDictionary *dicTemp = [NSDictionary dictionaryWithObjectsAndKeys:
                                 subArti.a_content,@"a_content",
                                 [subPic qiNiuPath],@"img",
                                 subArti.a_title,@"a_title",
                                 WORD_NONE_STR,@"a_link",
                                 WORD_NONE_STR,@"a_location",nil] ;
        
        [dicList addObject:dicTemp] ;
        
        [CommonFunc saveImageToLibrary:subArti.realImage] ;
    }
    
    NSString *jsonStr = [XTJson getJsonStr:dicList] ;
    
    NSString *topicStr = [self.superArticle getTopicStr] ;
    
    // Post up to subao server
    [ServerRequest uploadArticleWithContent:self.superArticle.a_content
                                      image:[pic qiNiuPath]
                                      topic:topicStr
                                      title:self.superArticle.a_title
                                 childsItem:jsonStr
                                    success:^(id json) {
                                        
                                        // delete draft .
                                        [self deleteDraft] ;
                                        
                                        ResultParsered *result = [[ResultParsered alloc] initWithDic:json] ;
                                        int articleID = [[result.info objectForKey:@"article_id"] intValue] ;
                                        
                                        // Share
                                        share_articleID = articleID ;
                                        share_topicStr = [self.superArticle getTopicStr] ;
                                        share_content = self.superArticle.a_content ;
                                        
                                        [self shareArticleNow] ;
                                        
                                        // return to home ctrller
                                        [self makeTabBarHidden:NO] ;
                                        [self.tabBarController setSelectedIndex:0] ;
                                        [self dismissViewControllerAnimated:YES completion:^{}] ;
                                        
                                        // Insert In Home
                                        self.superArticle.a_id = articleID ;
                                        self.superArticle.img = [pic qiNiuPath] ;
                                        
                                        [[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_UPLOAD_FINISHED
                                                                                            object:self.superArticle] ;
                                    }
                                       fail:^{
                                           [XTHudManager showWordHudWithTitle:WD_HUD_FAIL_RETRY] ;
                                       }] ;
}

- (BOOL)necessaryCondition
{
    if (![self.superArticle.a_title length])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:NO] ;
            
            [XTHudManager showWordHudWithTitle:WD_HUD_TITLE_NULL delay:1.8] ;
            
            MESuperArticleCell *cell = (MESuperArticleCell *)[self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] ;
            [cell mainTitleAnimateAction] ;
        }) ;
        return NO;
    }
    
    if (![self.childsList count]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [XTHudManager showWordHudWithTitle:WD_HUD_NO_SUB] ;
        }) ;
        return NO;
    }
    
    return YES ;
}

- (void)shareArticleNow
{
    share_content = !share_content ? @"" : share_content ;
    
    // 要跳的链接
    NSString *strUrl = [NSString stringWithFormat:SHARE_DETAIL_URL,share_articleID] ;
    
    // share to weibo   if needed
    if (m_bWeiboSelect)
    {
        m_bWeiboSelect = NO ;
        NSString *strShow = [ShareUtils shareContent:self.superArticle
                                              urlStr:strUrl
                                             isMulty:[self.superArticle isMultyStyle]
                                              isSelf:YES
                                            isWeiXin:NO] ;

        [ShareUtils weiboShareFuncWithContent:strShow
                                        image:self.superArticle.realImage
                                        topic:share_topicStr
                                      ctrller:self] ;
    }
    // share to weixin  if needed
    else if (m_bWeixinSelect)
    {
        m_bWeixinSelect = NO ;
        NSString *wxstrShow = [ShareUtils shareContent:self.superArticle
                                              urlStr:strUrl
                                             isMulty:[self.superArticle isMultyStyle]
                                              isSelf:YES
                                            isWeiXin:YES] ;
        
        [ShareUtils wxFriendShareFuncContent:wxstrShow
                                       image:self.superArticle.realImage
                                       topic:share_topicStr
                                         url:strUrl
                                     ctrller:self] ;
    }
}



- (void)delDraftBtClickAction
{
    NSLog(@"删除草稿") ;
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:nil andMessage:@"确认删除这篇草稿?"] ;
    [alertView addButtonWithTitle:@"删除草稿"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alertView) {
                              [self deleteDraft] ;
                              [self.navigationController popViewControllerAnimated:YES] ;
                              [[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICAITON_FRESH_USER object:nil] ;
                          }] ;
    [alertView addButtonWithTitle:@"取消"
                             type:SIAlertViewButtonTypeDefault
                          handler:nil] ;
    alertView.positionStyle = SIALertViewPositionBottom ;
    [alertView show] ;
}

- (void)deleteDraft
{
    [[DraftTB shareInstance] deleteArticleWithCid:self.superArticle.client_AID] ;
    for (Article *subArticle in self.childsList)
    {
        [[DraftTB shareInstance] deleteArticleWithCid:subArticle.client_AID] ;
    }
}

- (void)backAction
{
    NSLog(@"返回") ;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.table reloadData] ;
    }) ;
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:nil andMessage:nil] ;
    [alertView addButtonWithTitle:@"保存草稿"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              [self saveToDraft] ;
                          }] ;
    [alertView addButtonWithTitle:@"不保存"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alertView) {
                              [self dismissViewControllerAnimated:YES completion:^{
                                  ((AppDelegate *)([UIApplication sharedApplication].delegate)).tabbarCtrller.selectedIndex = 4 ;
                              }] ;
                          }] ;
    [alertView addButtonWithTitle:@"取消"
                             type:SIAlertViewButtonTypeDefault
                          handler:nil] ;
    alertView.positionStyle = SIALertViewPositionBottom ;
    [alertView show] ;
}

- (void)saveToDraft
{
    [self.table reloadData] ;
    
    // tab .
    [self dismissViewControllerAnimated:NO completion:^{
        ((AppDelegate *)([UIApplication sharedApplication].delegate)).tabbarCtrller.selectedIndex = 4 ;
    }] ;
    
    // save super article to DB
    int superAritcleCid = self.superArticle.client_AID ;
    BOOL isThisSuperArticleExist = [[DraftTB shareInstance] ExistThisArticle:superAritcleCid] ;
    if (isThisSuperArticleExist) {
        [[DraftTB shareInstance] updateArticleInDraft:self.superArticle] ;
    } else {
        [[DraftTB shareInstance] insertArticleInDraft:self.superArticle] ;
    }
    
    // save childs to DB
    for (Article *subArtic in self.childsList)
    {
        BOOL isThisSubExist = [[DraftTB shareInstance] ExistThisArticle:subArtic.client_AID] ;
        if (isThisSubExist) {
            [[DraftTB shareInstance] updateArticleInDraft:subArtic] ;
        } else {
            [[DraftTB shareInstance] insertArticleInDraft:subArtic] ;
        }
    }
    
    // save sequence to DB
    NSString *commaStr = [CommonFunc getCommaStringWithArray:self.sequenceListOfChild] ;
    BOOL isThisSequeceExist = [[SequenceTB shareInstance] ExistThisSequece:superAritcleCid] ;
    if (isThisSequeceExist) {
        [[SequenceTB shareInstance] updateSequece:commaStr OfSuper_Cid:superAritcleCid] ;
    }
    else {
        [[SequenceTB shareInstance] insertSequece:commaStr OfSuper_Cid:superAritcleCid] ;
    }
    
    // notification .
    [[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICAITON_FRESH_USER object:nil] ;
}

- (void)setupTable
{
    [_table registerNib:[UINib nibWithNibName:MESUPERARTICLECELL_ID bundle:nil] forCellReuseIdentifier:MESUPERARTICLECELL_ID] ;
    [_table registerNib:[UINib nibWithNibName:MESUBARTICLE_ID bundle:nil] forCellReuseIdentifier:MESUBARTICLE_ID] ;
    [_table registerNib:[UINib nibWithNibName:POSTSHARE_ID bundle:nil] forCellReuseIdentifier:POSTSHARE_ID] ;
    [_table registerNib:[UINib nibWithNibName:MES_ADDCELL_ID bundle:nil] forCellReuseIdentifier:MES_ADDCELL_ID] ;
    
    _table.delegate = self ;
    _table.dataSource = self ;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone ;
    _table.showsVerticalScrollIndicator = NO ;
}

#pragma mark --
#pragma mark - ME Super Article Cell Delegate
//点击话题
- (void)talkButtonPressedWithPreContent:(NSString *)preContent
{
//    self.contentEditing = preContent ;
    [self performSegueWithIdentifier:@"multyedit2select" sender:nil] ;
}
//点击内容
- (void)mesuperArticleContentTextviewPressed
{
    [self performSegueWithIdentifier:@"multy2editContent" sender:self.superArticle] ;
}
//标题
- (void)mainTitleChanged:(NSString *)title
{
    self.superArticle.a_title = title ;
}
//点击图片
- (void)changeImage
{
    m_clientAid_respond = self.superArticle.client_AID ;
    
    [NavCameraCtrller jump2NavCameraCtrllerWithOriginCtrller:self
                                            AndWithTopicName:nil
                                                     AndMode:mode_addSingle
                                            AndSuperAriticle:nil
                                 AndBigestSubArticleClientID:self.maxClientSubA_ID
                                     AndExistSubArticleCount:0] ;
}
//点击图片编辑
- (void)editImage
{
    m_clientAid_respond = self.superArticle.client_AID ;

    [EditPrepareCtrller jump2EditPrepareCtrllerFromCtrller:self
                                                  AndImage:self.superArticle.realImage
                                                 isEditing:YES] ;
}

#pragma mark --
#pragma mark - MESuperAddCellDelegate
- (void)superAddCellAddingBtClick
{
    m_fromRowWillInsert = 0 ;
    
    [NavCameraCtrller jump2NavCameraCtrllerWithOriginCtrller:self
                                            AndWithTopicName:nil
                                                     AndMode:mode_addMulty
                                            AndSuperAriticle:self.superArticle
                                 AndBigestSubArticleClientID:self.maxClientSubA_ID
                                     AndExistSubArticleCount:(int)self.childsList.count] ;
    
    ///--Called This Func When Choose Photos Finished .--///
    ///--insertSubListFromRowBelow:(int)rowWillInsert--///
}

#pragma mark --
#pragma mark - ME Sub Article Cell Delegate
- (void)subArticleTitleTextViewBecomeFirstResponder:(int)row
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:1]
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES] ;
        
    }) ;
}

- (void)subArticleContentTextviewPressed:(int)sub_CLient_A_ID
{
    for (Article *subArti in self.childsList)
    {
        if (subArti.client_AID == sub_CLient_A_ID)
        {
            [self performSegueWithIdentifier:@"multy2editContent" sender:subArti] ;
            break ;
        }
    }
}

- (void)subTitleChanged:(NSString *)title client_aID:(int)sub_CLient_A_ID
{
    for (Article *subArti in self.childsList)
    {
        if (sub_CLient_A_ID == subArti.client_AID)
        {
            subArti.a_title = title ;
            break ;
        }
    }
}

- (void)changeImage:(int)sub_CLient_A_ID
{
    m_clientAid_respond = sub_CLient_A_ID ;
    
    [NavCameraCtrller jump2NavCameraCtrllerWithOriginCtrller:self
                                            AndWithTopicName:nil
                                                     AndMode:mode_addSingle
                                            AndSuperAriticle:nil
                                 AndBigestSubArticleClientID:self.maxClientSubA_ID
                                     AndExistSubArticleCount:0] ;
    
}

- (void)editImage:(int)sub_CLient_A_ID
{
    m_clientAid_respond = sub_CLient_A_ID ;
    
    for (Article *subArticle in self.childsList)
    {
        if (subArticle.client_AID == sub_CLient_A_ID) {
            [EditPrepareCtrller jump2EditPrepareCtrllerFromCtrller:self
                                                          AndImage:subArticle.realImage
                                                         isEditing:YES] ;
            break ;
        }
    }
}

- (void)deleteThisSubArticle:(int)sub_CLient_A_ID
{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:nil andMessage:nil] ;
    [alertView addButtonWithTitle:@"删除"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alertView) {
                              
                              int rowWillDel = 0 ;
                              for (Article *subArti in self.childsList)
                              {
                                  if (subArti.client_AID == sub_CLient_A_ID)
                                  {
                                      [subArti deleteRealImageInLocal] ;
                                      break ;
                                  }
                                  rowWillDel ++ ;
                              }
                              [[DraftTB shareInstance] deleteArticleWithCid:sub_CLient_A_ID] ;
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self.childsList removeObjectAtIndex:rowWillDel] ;
                                  [self.table reloadData] ;
                              }) ;
                              
                          }] ;
    [alertView addButtonWithTitle:@"取消"
                             type:SIAlertViewButtonTypeDefault
                          handler:nil] ;
    alertView.positionStyle = SIALertViewPositionBottom ;
    [alertView show] ;
}

- (void)insertSubArticleBelowRow:(int)row
{
    m_fromRowWillInsert = row ;
    
    if (self.childsList.count >= MAX_SELECT_COUNT) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [XTHudManager showWordHudWithTitle:WD_HUD_SUB_COUNT_OVERFLOW] ;
        }) ;
        
        return ;
    }
    
    [NavCameraCtrller jump2NavCameraCtrllerWithOriginCtrller:self
                                            AndWithTopicName:nil
                                                     AndMode:mode_addMulty
                                            AndSuperAriticle:self.superArticle
                                 AndBigestSubArticleClientID:self.maxClientSubA_ID
                                     AndExistSubArticleCount:(int)self.childsList.count] ;
    
///--Called This Func When Choose Photos Finished--///
///--insertSubListFromRowBelow:(int)rowWillInsert--///
}

- (void)moveUpFromRow:(int)row
{
    [self.childsList exchangeObjectAtIndex:row
                         withObjectAtIndex:row - 1] ;
    [self.table performSelectorOnMainThread:@selector(reloadData)
                                 withObject:nil
                              waitUntilDone:YES] ;
}

- (void)moveDownFromRow:(int)row
{
    [self.childsList exchangeObjectAtIndex:row
                         withObjectAtIndex:row + 1] ;
    [self.table performSelectorOnMainThread:@selector(reloadData)
                                 withObject:nil
                              waitUntilDone:YES] ;
}

#pragma mark --
#pragma mark - EditPreviewCtrlDelegate
- (void)postMultyArticle
{
    [self postBtClickAction] ;
}

#pragma mark --
#pragma mark - EditContentCtrllerDelegate
- (void)sendContentBack:(NSString *)content AndClient_aID:(int)client_aID ;
{
    // super article content .
    if (self.superArticle.client_AID == client_aID)
    {
        self.superArticle.a_content = content ;
    }
    // sub article content
    else
    {
        for (Article *subArti in self.childsList)
        {
            if (subArti.client_AID == client_aID)
            {
                subArti.a_content = content ;
                break ;
            }
        }
    }
    
    [self.table reloadData] ;
}

#pragma mark --
#pragma mark - SelectTalkCtrllerDelegate
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

#pragma mark --
#pragma mark - LIFE
- (void)viewDidLoad
{
    [super viewDidLoad] ;
    // Do any additional setup after loading the view.

    self.myTitle = @"多图编辑发布页" ;
    
    ((AppDelegate *)([UIApplication sharedApplication].delegate)).multyPostCtrller = self ;
    
    [self putNavBarItem] ;
    
    [self setupTable] ;
    
    if ([CommonFunc isFirstMultyEditPage])
    {
        self.guidingStrList = @[@"guiding_multy_title",@"guiding_multy_long"] ;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    [self.navigationController setNavigationBarHidden:NO animated:NO] ;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:0] ;
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
    return 4 ; // super article + sub articlelist + shareBar + previewBt
}

- (NSInteger)tableView:(FMMoveTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // super article
    if (section == 0)
    {
        return (!self.childsList.count) ? 2 : 1 ; // if none sub , add cell appear .
    }
    // sub articlelist
    else if (section == 1)
    {
        return self.childsList.count ;
    }
    // shareBar
    else if (section == 2)
    {
        return 1 ;
    }
    // previewbt
    else if (section == 3)
    {
        return 1 ;
    }
    
    return 0 ;
}

- (UITableViewCell *)tableView:(FMMoveTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section ;
    NSInteger row     = indexPath.row ;
    
    // super article
    if (section == 0)
    {
        if (row == 0) {
            return [self getSuperArticle] ;
        }
        else if (row == 1) {
            return [self getSuperAddingCell] ;
        }
    }
    // sub articlelist
    else if (section == 1)
    {
        return [self getSubArticle:row] ;
    }
    // shareBar
    else if (section == 2)
    {
        return [self getPostShareCell] ;
    }
    // previewbt
    else if (section == 3)
    {
        return [self getPreviewCell] ;
    }
    
    return nil ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section ;
    NSInteger row     = indexPath.row ;
    // super article
    if (section == 0)
    {
        if (row == 0) {
            return 291.0 ;
        }
        else if (row == 1) {
            return 50.0 ;
        }
    }
    // sub articlelist
    else if (section == 1)
    {
        return 234 ;
    }
    // shareBar
    else if (section == 2)
    {
        return 109.0 ;
    }
    // previewbt
    else if (section == 3)
    {
        return 45.0 ;
    }
    return 0.0 ;
}

#pragma mark - Cells
- (MESuperArticleCell *)getSuperArticle
{
    MESuperArticleCell *cell = [_table dequeueReusableCellWithIdentifier:MESUPERARTICLECELL_ID] ;
    if (!cell)
    {
        cell = [_table dequeueReusableCellWithIdentifier:MESUPERARTICLECELL_ID] ;
    }
    cell.delegate = self ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.topicStr = self.topicString ;
    cell.articleSuper = self.superArticle ;
    
    return cell ;
}

- (MESuperAddCell *)getSuperAddingCell
{
    MESuperAddCell *cell = [_table dequeueReusableCellWithIdentifier:MES_ADDCELL_ID] ;
    if (!cell)
    {
        cell = [_table dequeueReusableCellWithIdentifier:MES_ADDCELL_ID] ;
    }
    cell.delegate = self ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    
    return cell ;
}

- (MESubArticleCell *)getSubArticle:(NSInteger)row
{
    MESubArticleCell *cell = [_table dequeueReusableCellWithIdentifier:MESUBARTICLE_ID] ;
    if (!cell) {
        cell = [_table dequeueReusableCellWithIdentifier:MESUBARTICLE_ID] ;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.delegate = self ;
    cell.subArticle = self.childsList[row] ;
    cell.row = (int)row ;
    
    TypeOfSubArticleQueueSection type = type_normal ;
    
    if (self.childsList.count > 1) {
        if (row == 0) {
            type = type_head ;
        }
        else if (row == self.childsList.count - 1) {
            type = type_tail ;
        }
    }
    else {
        type = type_none ;
    }
    
    cell.queueType = type;
    
    return cell ;
}

- (PostShareCell *)getPostShareCell
{
    PostShareCell *cell = [_table dequeueReusableCellWithIdentifier:POSTSHARE_ID] ;
    if (!cell)
    {
        cell = [_table dequeueReusableCellWithIdentifier:POSTSHARE_ID] ;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.delegate = self ;
    
    return cell ;
}

- (UITableViewCell *)getPreviewCell
{
    UITableViewCell *cell = [_table dequeueReusableCellWithIdentifier:@"previewCell"] ;
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"previewCell"] ;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.backgroundColor = COLOR_MAIN ;
    cell.textLabel.text = @"预览" ;
    cell.textLabel.textColor = [UIColor whiteColor] ;
    cell.textLabel.font = [UIFont systemFontOfSize:25.0] ;
    cell.textLabel.textAlignment = NSTextAlignmentCenter ;
    
    return cell ;
}

#pragma mark - Table view delegate

- (BOOL)moveTableView:(FMMoveTableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) // only sub articles can be moved
    {
        return YES ;
    }
    
    return NO ;
}

- (NSIndexPath *)moveTableView:(FMMoveTableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    //	Uncomment these lines to enable moving a row just within it's current section
	if ([sourceIndexPath section] != [proposedDestinationIndexPath section])
    {
		proposedDestinationIndexPath = sourceIndexPath;
	}
    
    return proposedDestinationIndexPath;
}

- (void)moveTableView:(FMMoveTableView *)tableView moveRowFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    Article *subArticle = [self.childsList objectAtIndex:fromIndexPath.row] ;
    [self.childsList removeObjectAtIndex:fromIndexPath.row] ;
    [self.childsList insertObject:subArticle atIndex:toIndexPath.row] ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // previewbt
    if (indexPath.section == 3)
    {
        if (![self necessaryCondition]) return ;

        [self performSegueWithIdentifier:@"multyEdit2multyPreview" sender:nil] ;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *clearView = [[UIView alloc] init] ;
    clearView.backgroundColor = nil ;
    return clearView ;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return LINE_HEIGHT ;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *backView = [[UIView alloc] init] ;
    backView.backgroundColor = nil ;
    return backView ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return LINE_HEIGHT ;
}

#pragma mark --
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"multyedit2select"])
    {
        SelectTalkCtrller *selTalkCtrller = (SelectTalkCtrller *)[segue destinationViewController] ;
        selTalkCtrller.delegate = self ;
    }
    else if ([segue.identifier isEqualToString:@"multy2editContent"])
    {
        EditContentCtrller *editCtrller = (EditContentCtrller *)[segue destinationViewController] ;
        Article *tempArticle = (Article *)sender ;
        editCtrller.article = tempArticle ;
        editCtrller.maxCount = (tempArticle.client_AID == self.superArticle.client_AID) ? 140 : 250 ;
        editCtrller.delegate = self ;
    }
    else if ([segue.identifier isEqualToString:@"multyEdit2multyPreview"])
    {
        EditPreviewCtrl *epCtrller = (EditPreviewCtrl *)[segue destinationViewController] ;
        self.superArticle.childList = self.childsList ;
        epCtrller.articleSuper = self.superArticle ;
        epCtrller.delegate = self ;
    }
}


@end
