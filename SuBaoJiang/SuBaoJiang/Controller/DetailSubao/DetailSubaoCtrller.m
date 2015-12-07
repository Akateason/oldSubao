//
//  DetailSubaoCtrller.m
//  SuBaoJiang
//
//  Created by apple on 15/6/2.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "DetailSubaoCtrller.h"
#import "NSObject+MKBlockTimer.h"
#import "SuBaoHeaderView.h"
#import "WordSendView.h"
#import "FlywordInputView.h"
#import "ServerRequest.h"
#import "ArticleTopic.h"
#import "PraisedController.h"
#import "UserCenterController.h"
#import "UMSocial.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "NavLogCtller.h"
#import "ShareAlertV.h"
#import "CommonFunc.h"
#import "SIAlertView.h"
#import "NSString+Extend.h"
#import "HomeController.h"
#import "ShareUtils.h"
#import "DetailTitleCell.h"
#import "DtSuperCell.h"
#import "DtSubCell.h"
#import "DtOperationCell.h"
#import "ReplyCell.h"
#import "SaveAlbumnCtrller.h"

#define SIZE_OF_PAGE                            50

#define TAG_ACSHEET_DEL_ART                     88871
#define TAG_ACSHEET_DEL_CMT                     88872
#define TAG_ACSHEET_REPORT                      88873

#define LINE_HEIGHT                             0.0f

#define OBSERVER_KEY_PATH_CURRENT_ARTICLE       @"OBSERVER_KEY_PATH_CURRENT_ARTICLE"

@interface DetailSubaoCtrller ()<UITableViewDataSource,UITableViewDelegate,FlywordInputViewDelegate,WordSendViewDelegate,SuBaoHeaderViewDelegate,RootTableViewDelegate,ReplyCellDelegate,ShareAlertVDelegate,DtOperationCellDelegate,DtSuperCellDelegate,DtSubCellDelegate>
{
    BOOL                keyBoardIsUp        ;
    BOOL                bSwitchFlyword      ; // BarrageView Switcher DEFAULT IS TRUE
    int                 m_lastCommentID     ;
    NSInteger           m_rowWillDelete     ; // delete cmt ;
    
// Share switch
    BOOL                m_bWeiboSelect      ;
    BOOL                m_bWeixinSelect     ;
    BOOL                m_bWxTimelineSelect ;
    
//  FirstTime
    BOOL                isFirstTime         ;
    
    UILabel             *t_Label            ;
}
//UIs
@property (weak, nonatomic) IBOutlet RootTableView      *table          ;
@property (nonatomic,strong)         WordSendView       *wordView       ;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flex_bottom    ;

@property (weak, nonatomic) IBOutlet UIView   *navBg;
@property (weak, nonatomic) IBOutlet UIButton *btNav_Like;
@property (weak, nonatomic) IBOutlet UIButton *btNav_Share;

//Attrs
@property (nonatomic,strong)         UIImage            *cacheImage     ;
@property (nonatomic,strong)         Article            *articleSuper   ;
@property (nonatomic)                BOOL               isMultiType     ;
@property (nonatomic)                int                focusOn_aid     ; // 针对哪一篇文章的评论 , 分子主 (默认为主文章)
@property (nonatomic,strong)         NSArray            *allPhotoList   ; // exist if multy type

@property (nonatomic,strong)         NSMutableArray     *allComments    ; // all comments in super and sub articles

@property (nonatomic)                CGRect             fromRect ;
@property (nonatomic,strong)         UIImage            *imgArticleSend ;
@property (nonatomic,strong)         UIImageView        *imgAnimateView ;

@end

@implementation DetailSubaoCtrller

#pragma mark --
#pragma mark - Public
+ (void)jump2DetailSubaoCtrller:(UIViewController *)ctrller
               AndWithArticleID:(int)aID 
{
    [self jump2DetailSubaoCtrller:ctrller
                 AndWithArticleID:aID
                 AndWithCommentID:0] ;
}

+ (void)jump2DetailSubaoCtrller:(UIViewController *)ctrller
               AndWithArticleID:(int)aID
               AndWithCommentID:(int)commentID
{
    [self jump2DetailSubaoCtrller:ctrller
                 AndWithArticleID:aID
                 AndWithCommentID:commentID
                         FromRect:CGRectZero
                          imgSend:nil] ;
}

+ (void)jump2DetailSubaoCtrller:(UIViewController *)ctrller
               AndWithArticleID:(int)aID
               AndWithCommentID:(int)commentID
                       FromRect:(CGRect)fromRect
                        imgSend:(UIImage *)imgSend
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
    DetailSubaoCtrller *detailCtrller = [story instantiateViewControllerWithIdentifier:@"DetailSubaoCtrller"] ;
    
    detailCtrller.superArticleID = aID ;
    detailCtrller.replyCommentID = commentID ;
    detailCtrller.fromRect = fromRect ;
    detailCtrller.imgArticleSend = imgSend ;
    if ([ctrller isKindOfClass:[HomeController class]]) {
        detailCtrller.homeCtrller = (HomeController *)ctrller ;
    }
    
    [detailCtrller setHidesBottomBarWhenPushed:YES] ;
    [ctrller.navigationController pushViewController:detailCtrller animated:NO] ;
}

- (void)imageSendAnimation
{
    if (!self.imgArticleSend)
    {
//        [XTAnimation animationPushRight:self.view] ;
    }
    else
    {
        // image Send animation .
        [self imgAnimateView] ;

        [UIView animateWithDuration:QUICKLY_ANIMATION_DURATION
                         animations:^{
                             CGFloat yFlex = self.isMultiType ? 48.0f + 52.0f : 48.0f ;
                             self.imgAnimateView.frame = CGRectMake(0, yFlex, APPFRAME.size.width, APPFRAME.size.width) ;
                             self.toRect = self.imgAnimateView.frame ;
                         } completion:^(BOOL finished) {
                             if (finished) {
                                 self.imgAnimateView.hidden = YES ;
                             }
                         }] ;
    }
}

- (void)startReverseAnmation
{
    [self.homeCtrller reverseImageSendAnimationWithRect:self.toRect] ;
}

#pragma mark --
#pragma mark - Initialization
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(UIKeyboardDidChange:)
                                                     name:UIKeyboardWillChangeFrameNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self ];
}

#pragma mark --
#pragma mark - notification
- (void)keyboardWillShow:(NSNotification *)notification
{
    keyBoardIsUp = YES ;
    [self showFlyBack:keyBoardIsUp] ;
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];

    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];

    [UIView animateWithDuration:duration animations:^{
        CGRect bottomViewFrame = self.wordView.frame ;
        bottomViewFrame.origin.y = self.view.frame.size.height - bottomViewFrame.size.height;
        self.wordView.frame = bottomViewFrame ;
    }];
    
    keyBoardIsUp = NO;
    [self showFlyBack:keyBoardIsUp] ;
}

- (void)UIKeyboardDidChange:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect tfContainRect = self.wordView.frame ;

    tfContainRect.origin.y = self.view.frame.size.height - endKeyboardRect.size.height - tfContainRect.size.height;
    
    [UIView animateWithDuration:duration animations:^{

        self.wordView.frame = tfContainRect;
        
        float theHeight = self.wordView.frame.origin.y - self.wordView.frame.size.height - 5.0f ;

        [self setflywordPropertyButtonsHeight:theHeight] ;
        
    }];
}

#pragma mark -- setup
- (void)setupSth
{
    _table.delegate = self ;
    _table.dataSource = self ;
    _table.separatorColor = COLOR_TABLE_SEP ;
    _table.hideHudForShowNothing = YES ;
//    _table.separatorStyle = UITableViewCellSeparatorStyleNone ;
    _table.rootDelegate = self ;
    
    // long press gesture
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(handleLongPressAtComment:)] ;
    lpgr.minimumPressDuration = 1.0f ;
    [_table addGestureRecognizer:lpgr] ;
    
    self.navBg.backgroundColor = nil ;
}

#pragma mark -- long press on commet
- (void)handleLongPressAtComment:(UILongPressGestureRecognizer *)longPressRecognizer
{
    if (longPressRecognizer.state != UIGestureRecognizerStateBegan) return ; // except multiple pressed it !
    
    CGPoint p = [longPressRecognizer locationInView:_table] ;
    NSIndexPath *indexPath = [_table indexPathForRowAtPoint:p] ;
    
    // replyLists
    if (indexPath.section != self.articleSuper.childList.count + 2) return ; // ONLY CMT CAN BE PRESSED .
    
    NSInteger row = indexPath.row ;
    NSLog(@"long press on commt at row %ld", (long)row) ;
    
    ArticleComment *cmt = (ArticleComment *)self.allComments[row] ;
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:nil
                                                     andMessage:nil] ;

    // when pressed my commet
    if (G_USER.u_id == cmt.userCurrent.u_id)
    {
        //删除
        [alertView addButtonWithTitle:WD_DELETE
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  [self deleteMyCommentWithRow:row] ;
        }] ;
    }
    else
    // press others
    {
        //回复
        [alertView addButtonWithTitle:WD_REPLY
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  [self replyWithCmt:cmt] ;
                              }];
    }
    
    //复制
    [alertView addButtonWithTitle:WD_COPY
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              
                              UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                              pasteboard.string = cmt.c_content ;
                              
                              [self performSelector:@selector(showHud:) withObject:WD_HUD_COPY_SUCCESS afterDelay:0.5] ;
                          }];
    //举报
    [alertView addButtonWithTitle:WD_REPORT
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              [ServerRequest reportWithType:mode_User contentID:cmt.userCurrent.u_id success:^(id json) {
                                  [self performSelector:@selector(showHud:) withObject:WD_HUD_REPORT_FINISHED afterDelay:0.5] ;
                              } fail:nil] ;
                          }];
    
    [alertView addButtonWithTitle:WD_CANCEL
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alertView) {
                          }];
    
    alertView.positionStyle = SIALertViewPositionBottom ;
    [alertView show];
}

- (void)note2DetailReply
{
    if (self.replyCommentID && isFirstTime)
    {
        for (ArticleComment *cmt in self.allComments)
        {
            if (self.replyCommentID == cmt.c_id)
            {
                [self replyWithCmt:cmt] ;
                break ;
            }
        }
    }
}

- (void)putNavBarItem
{
    bSwitchFlyword = YES ;
    
    UIBarButtonItem *switchButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fw_hide"] style:UIBarButtonItemStylePlain target:self action:@selector(switchButtonPressedAction:)] ;
    self.navigationItem.rightBarButtonItem = switchButton ;
}

#pragma mark --
#pragma mark -- Actions
- (void)switchButtonPressedAction:(id)sender
{
    bSwitchFlyword = !bSwitchFlyword ;
    
    UIBarButtonItem *item = (UIBarButtonItem *)sender ;
    NSString *imgStr = !bSwitchFlyword ? @"fw_show" : @"fw_hide" ;
    [item setImage:[UIImage imageNamed:imgStr]] ;
    
    NSString *hudStr = bSwitchFlyword ? WD_HUD_FLYWORD_OPEN : WD_HUD_FLYWORD_CLOSE ;
    [XTHudManager showWordHudWithTitle:hudStr] ;
    
    [self.table reloadData] ;
}

- (IBAction)navLikeAction:(id)sender
{
    [self hasPraised:!self.btNav_Like.selected] ;
}

- (IBAction)navShareAction:(id)sender
{
    [self clickShareCallBack] ;
}

#pragma mark --
#pragma mark - fly word view setup
- (void)showFlyBack:(BOOL)bShow
{
    if (![self.wordView.flywordInputView superview])
    {
        [self.view addSubview:self.wordView.flywordInputView] ;
        self.wordView.flywordInputView.frame = APPFRAME ;
        self.wordView.flywordInputView.delegate = self ;
    }
    
    if (bShow)
    {
        [self.view bringSubviewToFront:self.wordView] ;
        self.wordView.flywordInputView.hidden = NO ;
    }
    else
    {
        self.wordView.flywordInputView.hidden = YES ;
    }
}

- (void)setflywordPropertyButtonsHeight:(float)height
{
    [self.wordView.flywordInputView setButtonsHeight:height] ;
}

#pragma mark --
#pragma mark - Properties
- (UIImageView *)imgAnimateView
{
    if (!_imgAnimateView) {
        _imgAnimateView = [[UIImageView alloc] initWithImage:self.imgArticleSend] ;
        _imgAnimateView.frame = self.fromRect ;
        _imgAnimateView.contentMode = UIViewContentModeScaleAspectFit ;
        if (![_imgAnimateView superview]) {
            [self.view addSubview:_imgAnimateView] ;
        }
    }
    
    return _imgAnimateView ;
}

- (NSMutableArray *)allComments
{
    if (!_allComments)
    {
        _allComments = [NSMutableArray array] ;
        
        if (self.isMultiType)
        {
            _allComments = self.articleSuper.articleCommentList ; // cmts in super article
            
            [self.articleSuper.childList enumerateObjectsUsingBlock:^(Article *subArticle, NSUInteger idx, BOOL * _Nonnull stop) {
                [_allComments addObjectsFromArray:subArticle.articleCommentList] ;
            }] ;
            
            NSArray *resultList = [_allComments sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                ArticleComment *cmt1 = obj1 ;
                ArticleComment *cmt2 = obj2 ;
                NSComparisonResult result = [@(cmt1.c_createtime) compare:@(cmt2.c_createtime)] ;
                return result == NSOrderedAscending ;
            }] ;
            
            _allComments = [NSMutableArray arrayWithArray:resultList] ;
        }
        else
        {
            _allComments = self.articleSuper.articleCommentList ;
        }
    }
    
    return _allComments ;
}

- (NSArray *)allPhotoList
{
    if (!_allPhotoList && self.isMultiType) {
        NSMutableArray *templist = [NSMutableArray array] ;
        
        [self.articleSuper.childList enumerateObjectsUsingBlock:^(Article *subArticle, NSUInteger idx, BOOL * _Nonnull stop) {
            [templist addObject:subArticle.img] ;
        }] ;
        
        [templist insertObject:self.articleSuper.img atIndex:0] ;
        _allPhotoList = templist ;
    }
    
    return _allPhotoList ;
}

- (int)focusOn_aid
{
    if (!_focusOn_aid)
    {
        _focusOn_aid = self.superArticleID ;
    }
    
    return _focusOn_aid ;
}

- (void)setArticleSuper:(Article *)articleSuper
{
    _articleSuper = articleSuper ;

    // multitype
    self.isMultiType = [articleSuper isMultyStyle] ;
    // bt nav like
    if (self.isMultiType) self.btNav_Like.selected = articleSuper.has_praised ;

    // reload table
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.table reloadData] ;
    }) ;
    
    // get last id
    [self getlastCommentID] ;
    // cache image for share
    [self cacheImage] ;
    // From note
    [self note2DetailReply] ;
    
    // guiding .
    if (self.isMultiType && [CommonFunc isFirstDetailPage])
    {
        self.guidingStrList = @[@"guiding_detail"] ;
    }
}

- (void)setIsMultiType:(BOOL)isMultiType
{
    _isMultiType = isMultiType ;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.flex_bottom.constant = 48.0f ;
        self.wordView.hidden = NO ;
        
        self.navBg.hidden = NO ;
        self.btNav_Like.hidden = !isMultiType ;
        self.btNav_Share.hidden = !isMultiType ;
        if (isMultiType) self.btNav_Share.hidden = !G_BOOL_OPEN_APPSTORE ;
        
    }) ;
    
    if (!isMultiType && !t_Label)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            t_Label = [[UILabel alloc] init] ;
            CGRect rect = t_Label.frame ;
            rect.size = self.navBg.frame.size ;
            rect.origin = CGPointZero ;
            t_Label.frame = rect ;
            t_Label.text = @"速报详情" ;
            t_Label.textColor = [UIColor whiteColor] ;
            t_Label.font = [UIFont boldSystemFontOfSize:17.0] ;
            t_Label.textAlignment = NSTextAlignmentCenter ;
            
            if (![t_Label superview])
            {
                [self.navBg addSubview:t_Label] ;
            }
        }) ;
    }
}

- (void)setSuperArticleID:(int)superArticleID
{
    _superArticleID = superArticleID ;
    
    [ServerRequest getArticleDetailWithArticleID:superArticleID
                                         Success:^(id json)
    {
        
        ResultParsered *result = [[ResultParsered alloc] initWithDic:json] ;
        Article *arti = [[Article alloc] initWithDict:result.info] ;
        self.articleSuper = arti ;

        dispatch_async(dispatch_get_main_queue(), ^{
            self.table.hidden = NO ;
            [self imageSendAnimation] ;
        }) ;
        
    } fail:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [XTHudManager showWordHudWithTitle:WD_HUD_FAIL_RETRY] ;
            self.table.hidden = NO ;
            self.navBg.hidden = YES ;
            
            self.wordView.hidden = YES ;
            _flex_bottom.constant = 0.0 ;
        }) ;
        
    }] ;
}

- (WordSendView *)wordView
{
    if (!_wordView)
    {
        _wordView = (WordSendView *)[[[NSBundle mainBundle] loadNibNamed:@"WordSendView" owner:self options:nil] lastObject] ;
        
        _wordView.delegate = self ;
        
        _wordView.backgroundColor = [UIColor whiteColor] ;
        
        CGRect frame = CGRectZero ;
        frame.origin.x = 0.0f ;
        frame.origin.y = APPFRAME.size.height - 48.0f - NAVIGATIONBAR_HEIGHT - STATUSBAR_HEIGHT ;
        frame.size.width = APPFRAME.size.width ;
        frame.size.height = 48.0f ;
        _wordView.frame = frame ;
        
        if (![_wordView superview])
        {
            [self.view addSubview:_wordView] ;
        }
    }
    
    return _wordView ;
}

- (void)resetWordViewFrame
{
    CGRect frame = CGRectZero ;
    frame.origin.x = 0.0f ;
    frame.origin.y = APPFRAME.size.height - 48.0f - NAVIGATIONBAR_HEIGHT - STATUSBAR_HEIGHT ;
    frame.size.width = APPFRAME.size.width ;
    frame.size.height = 48.0f ;
    self.wordView.frame = frame ;
}

- (UIImage *)cacheImage
{
    if (!_cacheImage)
    {
        _cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.articleSuper.img
                                                                 withCacheWidth:APPFRAME.size.width] ;
    }
    
    return _cacheImage ;
}

#pragma mark -- Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title   = @"速报详情" ;
    self.myTitle = @"速报详情页" ;
    
    isFirstTime = YES ;
    self.table.hidden = YES ;
    self.navBg.hidden = YES ;
    self.btNav_Share.hidden = !G_BOOL_OPEN_APPSTORE ;
    
    [self setupSth] ;
    [self wordView] ;
    [self putNavBarItem] ;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated] ;

    if (!isFirstTime) return ;
    
    [self resetWordViewFrame] ;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;

    isFirstTime = NO ;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_ARTICLE_REFRESH
                                                        object:self.articleSuper] ;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if ([self.view window] == nil)
    {
        // Add code to preserve data stored in the views that might be .
        // needed later .
        self.allPhotoList = nil ;
        self.allComments = nil ;
        
        // Add code to clean up other strong references to the view in .
        // the view hierarchy .
        self.wordView = nil ;
        self.imgAnimateView = nil ;
        self.cacheImage = nil ;
        self.imgArticleSend = nil ;
        self.table = nil ;
        self.view = nil ;
    }
}

#pragma mark --
#pragma mark - parser
- (BOOL)getFromServer
{
    ResultParsered *result = [ServerRequest getArticleDetailWithArticleID:self.superArticleID] ;

    dispatch_async(dispatch_get_main_queue(), ^{
        self.table.hidden = NO ;
    }) ;
    
    if (!result) return NO ;
    
    BOOL bHas = [self parserResult:result] ;

    return bHas ;
}

- (BOOL)parserResult:(ResultParsered *)result
{
    self.articleSuper = [[Article alloc] initWithDict:result.info] ;
    
    [self getlastCommentID] ;
    
    return YES ;
}

- (BOOL)getMoreComment
{
    ResultParsered *result = [ServerRequest getCommentWithArticleID:self.superArticleID
                                                     AndWithSinceID:0
                                                       AndWithMaxID:m_lastCommentID
                                                       AndWithCount:SIZE_OF_PAGE] ;
    if (!result) return NO ;
    
    NSArray *moreCommentList = [ArticleComment getCommentListWithDictList:[result.info objectForKey:@"article_comments"]] ;
    if (!moreCommentList.count) return NO ;
    
    NSMutableArray *resultList = [NSMutableArray arrayWithArray:self.allComments] ;
    [resultList addObjectsFromArray:moreCommentList] ;
    self.allComments = resultList ;
    [self getlastCommentID] ;
    
    return YES ;
}

- (void)getlastCommentID
{
    m_lastCommentID = ((ArticleComment *)[self.allComments lastObject]).c_id ;
}

#pragma mark -- RootTableViewDelegate
- (BOOL)doSthWhenfreshingHeader
{
    return [self getFromServer]  ;
}

- (BOOL)doSthWhenfreshingFooter
{
    return [self getMoreComment] ;
}

#pragma mark --
#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_table rootTableScrollDidScroll:scrollView] ;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.isMultiType) [self controlBottomBarShowOrNot] ;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.isMultiType) [self controlBottomBarShowOrNot] ;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_table rootTableScrollDidEndDragging:scrollView] ;
    
    if (self.isMultiType && !decelerate) [self controlBottomBarShowOrNot] ;
}

- (void)controlBottomBarShowOrNot
{
//    NSArray *visibleIndexPath = [_table indexPathsForVisibleRows] ;
//    BOOL existReplyCell = NO ;
//    for (NSIndexPath *indexPath in visibleIndexPath)
//    {
//        if (indexPath.section >= self.articleSuper.childList.count + 1)
//        {
//            existReplyCell = YES ;
//            break ;
//        }
//    }
    
    _flex_bottom.constant = 48.0f ;
    self.wordView.hidden = NO ;
}

#pragma mark --
#pragma mark - ios8 table view seperator line full screen
- (void)viewDidLayoutSubviews
{
    if ([self.table respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.table setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)] ;
    }
    
    if ([self.table respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.table setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)] ;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero] ;
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero] ;
    }
}

#pragma mark --
#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    // superArticle + childArticleList + operation Infomation + replyLists
    return 1 + self.articleSuper.childList.count + 1 + 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // superArticle
    if (section == 0)
    {
        return 2 ; // title + superPic & superContent ;
    }
    // subArticle
    else if ( (section > 0) && (section <= self.articleSuper.childList.count) )
    {
        return 1 ; // subArticle
    }
    // operation Infomation
    else if (section == self.articleSuper.childList.count + 1)
    {
        return 1 ;
    }
    // replyLists
    else if (section == self.articleSuper.childList.count + 2)
    {
        return [self.allComments count] ;
    }
    
    return 0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section   = indexPath.section ;
    NSInteger row       = indexPath.row ;
    
    // SUPER ARTICLE
    if (section == 0)
    {
        // 1. title IF EXIST
        if (row == 0)
        {
            return [self.articleSuper isMultyStyle] ? [self getDetailTitleCell] : [self getEmptyCell] ;
        }
        // 2. superPic & superContent
        else if (row == 1)
        {
            return [self getDtSuperCell] ;
        }
    }
    // SUB ARTICLEs
    else if ( (section > 0) && (section <= self.articleSuper.childList.count) )
    {
        return [self getDtSubCell:self.articleSuper.childList[section - 1]] ;
    }
    // operation Infomation
    else if (section == self.articleSuper.childList.count + 1)
    {
        return [self getDtOperationCell] ;
    }
    // replyLists
    else if (section == self.articleSuper.childList.count + 2)
    {
        return [self getReplyCell:row] ;
    }
    
    return nil ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section   = indexPath.section ;
    NSInteger row       = indexPath.row ;
    
    // SUPER ARTICLE ;
    if (section == 0)
    {
        // 1. title
        if (row == 0)
        {
            return [self.articleSuper isMultyStyle] ? [DetailTitleCell calculateHeight:self.articleSuper] : LINE_HEIGHT ;
        }
        // 2. superPic & superContent
        else if (row == 1)
        {
            return [DtSuperCell calculateHeight:self.articleSuper] ;
        }
    }
    // SUB ARTICLEs
    else if ( (section > 0) && (section <= self.articleSuper.childList.count) )
    {
        return [DtSubCell calculateHeightWithArticle:self.articleSuper.childList[section - 1]] ;
    }
    // operation Infomation
    else if (section == self.articleSuper.childList.count + 1)
    {
        NSString *strAttriComment = [self.articleSuper isMultyStyle] ? [self.articleSuper getTopicStr] : [self.articleSuper getStrCommentContent] ;
        
        return [DtOperationCell calculateHeightWithCmtStr:strAttriComment] ;
    }
    // replyLists
    else if (section == self.articleSuper.childList.count + 2)
    {
        NSString *strCmt = ((ArticleComment *)self.allComments[indexPath.row]).showStrComment ;
        
        return [ReplyCell calculateHeightWithCmtStr:strCmt] ;
    }
    
    return LINE_HEIGHT ;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section   = indexPath.section ;
    NSInteger row       = indexPath.row ;
    
    // replyLists
    if (section != self.articleSuper.childList.count + 2) return ;
    
    ArticleComment *cmt = (ArticleComment *)self.allComments[row] ;
    
    if (G_USER.u_id == cmt.userCurrent.u_id) return ; // return when pressed cmt posted by myself ;
    
    [self replyWithCmt:cmt] ;
}

- (void)replyWithCmt:(ArticleComment *)cmt
{
    // click user head and answer
    self.wordView.hidden = NO ;
    self.wordView.comment = cmt ;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.wordView.textView becomeFirstResponder] ;
    }) ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        SuBaoHeaderView *header = (SuBaoHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"SuBaoHeaderView" owner:self options:nil] lastObject] ;
        header.article = self.articleSuper ;
        header.delegate = self ;
        return header ;
    }
    
    UIView *clearView = [[UIView alloc] init] ;
    clearView.backgroundColor = nil ;
    return clearView ;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 48.0f ;
    }
    
    return LINE_HEIGHT ;
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
    return LINE_HEIGHT ;
}

#pragma mark --
#pragma mark - Cells
- (UITableViewCell *)getEmptyCell
{
    UITableViewCell *cell = [_table dequeueReusableCellWithIdentifier:@"nil"] ;
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nil"];
    }
    return cell ;
}

- (DetailTitleCell *)getDetailTitleCell
{
    static  NSString  *CellIdentiferId = @"DetailTitleCell";
    DetailTitleCell * cell = [_table dequeueReusableCellWithIdentifier:CellIdentiferId] ;
    if (!cell)
    {
        [_table registerNib:[UINib nibWithNibName:CellIdentiferId bundle:nil] forCellReuseIdentifier:CellIdentiferId];
        cell = [_table dequeueReusableCellWithIdentifier:CellIdentiferId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.article = self.articleSuper ;
    return cell ;
}

- (DtSuperCell *)getDtSuperCell
{
    static  NSString  *CellIdentiferId = @"DtSuperCell";
    DtSuperCell *cell = [_table dequeueReusableCellWithIdentifier:CellIdentiferId] ;
    if (!cell)
    {
        [_table registerNib:[UINib nibWithNibName:CellIdentiferId bundle:nil] forCellReuseIdentifier:CellIdentiferId];
        cell = [_table dequeueReusableCellWithIdentifier:CellIdentiferId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;

    if (self.articleSuper != nil) {
        cell.article = self.articleSuper ;
        cell.allCommentsList = self.allComments ;
    }
    
    cell.isflywordShow = bSwitchFlyword ;
    cell.delegate = self ;
    
    return cell ;
}

- (DtSubCell *)getDtSubCell:(Article *)subArticle
{
    static NSString *CellIdentiferId = @"DtSubCell";
    DtSubCell * cell = [self.table dequeueReusableCellWithIdentifier:CellIdentiferId] ;
    if (!cell)
    {
        [self.table registerNib:[UINib nibWithNibName:CellIdentiferId bundle:nil] forCellReuseIdentifier:CellIdentiferId] ;
        cell = [self.table dequeueReusableCellWithIdentifier:CellIdentiferId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.subArticle = subArticle ;
    cell.delegate = self ;
    cell.isflywordShow = bSwitchFlyword ;
    return cell ;
}

- (DtOperationCell *)getDtOperationCell
{
    static  NSString  *CellIdentiferId = @"DtOperationCell";
    DtOperationCell * cell = [_table dequeueReusableCellWithIdentifier:CellIdentiferId] ;
    if (!cell)
    {
        [_table registerNib:[UINib nibWithNibName:CellIdentiferId bundle:nil] forCellReuseIdentifier:CellIdentiferId];
        cell = [_table dequeueReusableCellWithIdentifier:CellIdentiferId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.superArticle = self.articleSuper ;
    cell.delegate = self ;
    
    return cell ;
}

- (ReplyCell *)getReplyCell:(NSInteger)row
{
    static  NSString  *CellIdentiferId = @"ReplyCell";
    ReplyCell * cell = [_table dequeueReusableCellWithIdentifier:CellIdentiferId] ;
    if (!cell)
    {
        [_table registerNib:[UINib nibWithNibName:CellIdentiferId bundle:nil] forCellReuseIdentifier:CellIdentiferId];
        cell = [_table dequeueReusableCellWithIdentifier:CellIdentiferId];
    }
    cell.delegate = self ;
    cell.comment = self.allComments[row] ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    return cell;
}

// After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
// Not called for edit actions using UITableViewRowAction - the action's handler will be invoked instead
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // replyLists
    if (indexPath.section != self.articleSuper.childList.count + 2) return ;
    
    // commit delete cmt
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        m_rowWillDelete = indexPath.row ;
        
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:nil
                                                         andMessage:WD_DEL_CMT] ;
        
        [alertView addButtonWithTitle:WD_CORRECT
                                 type:SIAlertViewButtonTypeDestructive
                              handler:^(SIAlertView *alertView) {
                                  [self delCmt] ;
                              }];
        
        [alertView addButtonWithTitle:WD_CANCEL
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  //NSLog(@"cancel Clicked");
                              }];
        
        alertView.positionStyle = SIALertViewPositionBottom ;
        [alertView show];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != self.articleSuper.childList.count + 2) {
        return UITableViewCellEditingStyleNone ;
    }
    
    // section have to in reply cells
    ArticleComment *cmt = self.allComments[indexPath.row] ;
    BOOL bMyCmt = ( cmt.userCurrent.u_id == G_USER.u_id ) ;
    
    return bMyCmt ? UITableViewCellEditingStyleDelete : UITableViewCellEditingStyleNone ;
}

#pragma mark --
#pragma mark - DtSuperCellDelegate - DtSubCellDelegate
- (void)selectedTheImageWithAritcleID:(int)a_id
{
//    if (![self.articleSuper isMultyStyle]) return ;
    
    self.focusOn_aid = a_id ;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.wordView.textView becomeFirstResponder] ;
        
        if (self.wordView.hidden) {
            self.wordView.hidden = NO ;
        }
    }) ;
}

- (void)imgDownloadFinished
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.table reloadData] ;
    }) ;
}

//长按子图,保存图片
- (void)longPressedCallback:(Article *)article
{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:nil
                                                     andMessage:WD_PICTURE_SAVE] ;
    
    [alertView addButtonWithTitle:WD_CORRECT
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alertView) {
                              UIImage *picWillSave = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:article.img withCacheWidth:APPFRAME.size.width] ;
                              [CommonFunc saveImageToLibrary:picWillSave] ;
                          }] ;
    
    [alertView addButtonWithTitle:WD_CANCEL
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              // NSLog(@"cancel Clicked");
                          }] ;
    
    alertView.positionStyle = SIALertViewPositionBottom ;
    
    [alertView show] ;
}

#pragma mark - SuBaoHeaderViewDelegate - ReplyCellDelegate
- (void)clickUserHead:(int)userID
{
    [UserCenterController jump2UserCenterCtrller:self
                                       AndUserID:userID] ;
}

#pragma mark - DtOperationCellDelegate
// 标签点击
- (void)topicSelected:(ArticleTopic *)topic
{
    [HomeController jumpToTopicHomeCtrller:topic
                             originCtrller:self] ;
}

// 去登陆 (多处公用此回调) wordSendViewDelegate,DetailCellDelegate
- (void)goToLogin
{
    [NavLogCtller modalLogCtrllerWithCurrentController:self] ;
}

// 更多点赞人
- (void)moreLikersPressedWithArticleID:(int)articleID
{
    [self performSegueWithIdentifier:@"detail2Praised"
                              sender:[NSNumber numberWithInt:articleID]] ;
}

// 分享
- (void)clickShareCallBack
{
    ShareAlertV *shareAlert = [[ShareAlertV alloc] initWithController:self] ;
    shareAlert.aDelegate = self ;
}

#pragma mark - ShareAlertVDelegate
- (void)clickIndex:(NSInteger)index
{
    // share call back
    switch (index)
    {
        case 0:
        {
            //@"保存图片" ;
            [self savingPhoto] ;
        }
            break;
        case 1:
        {
            //@"新浪微博" ;
            m_bWeiboSelect = YES ;
        }
            break;
        case 2:
        {
            //@"微信" ;
            m_bWeixinSelect = YES ;
        }
            break;
        case 3:
        {
            //@"朋友圈" ;
            m_bWxTimelineSelect = YES ;
        }
            break;
        default:
            break;
    }
    
    if (index != 0)
    {
        [self shareWithArticleID:self.articleSuper.a_id] ;
    }
}

- (void)savingPhoto
{
    if (self.isMultiType)
    {
        [self performSegueWithIdentifier:@"detail2savePhoto"
                                  sender:self.allPhotoList] ;
    }
    else
    {
        [CommonFunc saveImageToLibrary:self.cacheImage] ;
    }
}

- (void)shareWithArticleID:(int)a_id
{
    [self cacheImage] ;
    
    // topicStr
    NSString *topicStr = (self.articleSuper.articleTopicList.count) ? ((ArticleTopic *)[self.articleSuper.articleTopicList firstObject]).t_content : nil ;
    
    // 要跳的链接
    NSString *strUrl = [NSString stringWithFormat:SHARE_DETAIL_URL,a_id] ;
    
    // share to weibo       if needed
    if (m_bWeiboSelect)
    {
        NSString *strShow = [ShareUtils shareContent:self.articleSuper
                                              urlStr:strUrl
                                             isMulty:self.isMultiType
                                              isSelf:self.articleSuper.is_author
                                            isWeiXin:NO] ;
        
        [ShareUtils weiboShareFuncWithContent:strShow
                                        image:self.cacheImage
                                        topic:topicStr
                                      ctrller:self] ;
    }
    
    NSString *wxstrShow = [ShareUtils shareContent:self.articleSuper
                                          urlStr:strUrl
                                         isMulty:self.isMultiType
                                          isSelf:self.articleSuper.is_author
                                        isWeiXin:NO] ;

    // share to weixin      if needed
    if (m_bWeixinSelect)
        [ShareUtils weixinShareFuncContent:wxstrShow
                                     image:self.cacheImage
                                     topic:topicStr
                                       url:strUrl
                                   ctrller:self] ;
    
    // share to wxfriend    if needed
    if (m_bWxTimelineSelect)
        [ShareUtils wxFriendShareFuncContent:wxstrShow
                                       image:self.cacheImage
                                       topic:topicStr
                                         url:strUrl
                                     ctrller:self] ;
    
    // clear
    m_bWeiboSelect = NO ;
    m_bWeixinSelect = NO ;
    m_bWxTimelineSelect = NO ;
}

// 删除当前文章
- (void)deleteMyArticle
{
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:nil
                                                     andMessage:WD_DEL_SUBAO] ;
    [alertView addButtonWithTitle:WD_CORRECT
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alertView) {
                              [self delArticle] ;
                          }];
    [alertView addButtonWithTitle:WD_CANCEL
                             type:SIAlertViewButtonTypeDefault
                          handler:nil];
    
    alertView.positionStyle = SIALertViewPositionBottom ;
    [alertView show];
}

// 举报
- (void)reportCallBack
{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:nil
                                                     andMessage:nil] ; //WD_REPORT_TITLE
    [alertView addButtonWithTitle:WD_REPORT_ARTICLE
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              [self reportActionWithMode:mode_Article] ;
                          }];
    [alertView addButtonWithTitle:WD_REPORT_USER
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              [self reportActionWithMode:mode_User] ;
                          }];
    [alertView addButtonWithTitle:WD_CANCEL
                             type:SIAlertViewButtonTypeDestructive
                          handler:nil];
    
    alertView.positionStyle = SIALertViewPositionBottom ;
    [alertView show];
}

// 已经点赞
- (void)hasPraised:(BOOL)hasPraised
{
    self.articleSuper.has_praised = hasPraised ;
    self.btNav_Like.selected = hasPraised ;
    
    [ServerRequest praiseThisArticle:self.articleSuper.a_id
                         AndWithBool:hasPraised
                             Success:^(id json) {
                                 
                                 ResultParsered *result = [[ResultParsered alloc] initWithDic:json] ;
                                 NSLog(@"message : %@",result.message) ;
                                 NSInteger  section = self.articleSuper.childList.count + 1 ;
                                 NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:section] ;
                                 DtOperationCell *cell = (DtOperationCell *)[_table cellForRowAtIndexPath:indexpath] ;
                                 [cell getNewPraiseWithisLiked:hasPraised] ;
                                 
                             } fail:nil] ;
    
}

- (void)delArticle
{
    [ServerRequest deleteMyArticleWithA_id:self.superArticleID success:^(id json) {
        ResultParsered *result = [[ResultParsered alloc] initWithDic:json] ;
        if (!result.errCode)
        {
            // NSLog(@"删除成功") ;
            // 跳回去,删除数据源,并刷新
            [XTHudManager showWordHudWithTitle:WD_DELETE_SUCCESS] ;
            
            [self.navigationController popViewControllerAnimated:YES] ;
            [[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_DELETE_MY_ARTICLE object:self.articleSuper] ;
        }
        else
        {
            NSLog(@"err code %@ : %@",@(result.errCode),result.message) ;
        }
    } fail:^{
        [XTHudManager showWordHudWithTitle:WD_HUD_FAIL_RETRY] ;
    }] ;

}

- (void)delCmt
{
    [self deleteMyCommentWithRow:m_rowWillDelete] ;
}

- (void)deleteMyCommentWithRow:(NSInteger)row
{
    ArticleComment *cmtWillDelete = self.allComments[row] ;
    NSInteger sectionReply = self.articleSuper.childList.count + 2 ;
    
    [self.allComments removeObjectAtIndex:row] ;
    
    if (self.isMultiType)
    {
        [self.articleSuper.childList enumerateObjectsUsingBlock:^(Article *subArticle, NSUInteger idx, BOOL * _Nonnull stopArt) {
            if (subArticle.a_id == cmtWillDelete.a_id) {
                [subArticle.articleCommentList enumerateObjectsUsingBlock:^(ArticleComment *cmt, NSUInteger idxCmt, BOOL * _Nonnull stopCmt) {
                    if (cmt.c_id == cmtWillDelete.c_id) {
                        [subArticle.articleCommentList removeObjectAtIndex:idxCmt] ;
                       
                        *stopCmt = YES ;
                    }
                }] ;

                *stopArt = YES ;
            }
        }] ;
        
    }
    else
    {
        [self.articleSuper.articleCommentList removeObject:cmtWillDelete] ;
    }

    [_table deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:sectionReply]] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [ServerRequest deleteMyCmt:cmtWillDelete.c_id
                       Success:^(id json) {
                           
                           ResultParsered *result = [[ResultParsered alloc] initWithDic:json] ;
                           NSLog(@"err code %@ : %@",@(result.errCode),result.message) ;
                           
                           self.articleSuper.article_comments_count-- ;
                           
                           [_table reloadData] ;
                           
                       } fail:^{
                           [XTHudManager showWordHudWithTitle:WD_HUD_FAIL_RETRY] ;
                       }] ;

}

- (void)reportActionWithMode:(MODE_TYPE_REPORT)reportMode
{
    // 0 举报作品 , 1 举报用户
//    MODE_TYPE_REPORT reportMode = index + 1;
    int contentID ;
    switch (reportMode)
    {
        case mode_Article:
        {
            contentID = self.articleSuper.a_id ;
        }
            break;
        case mode_User:
        {
            contentID = self.articleSuper.userCurrent.u_id ;
        }
            break;
        default:
            break;
    }
    
    [ServerRequest reportWithType:reportMode
                        contentID:contentID
                          success:^(id json)
    {
        [self performSelector:@selector(showHud:)
                   withObject:WD_HUD_REPORT_FINISHED
                   afterDelay:0.5] ;
    } fail:nil] ;
    
}

- (void)showHud:(NSString *)content
{
    [XTHudManager showWordHudWithTitle:content
                                  delay:2.0] ;
}

#pragma mark --
#pragma mark - WordSendViewDelegate
- (BOOL)sendCommentButtonPressedCallWithContent:(NSString *)content
                                AndWithColorStr:(NSString *)colorStr
                                 AndWithSizeStr:(NSString *)sizeStr
                             AndWithPositionStr:(NSString *)positionStr
{
    // post to server
    NSUInteger lengthReply = [content length] ;
    
    if (lengthReply > 140)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [XTHudManager showWordHudWithTitle:WD_WORDS_OVERFLOW] ;
        }) ;
        return NO ;
    }
    else if (lengthReply == 0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [XTHudManager showWordHudWithTitle:WD_WORDS_SHOULD_HAS] ;
        }) ;
        return NO ;
    }
    
    //  Minus All Space charactor
    content = [content minusSpaceStr] ;
    
    //  Judge comment or reply
    if (!self.wordView.comment)
    {
        // comment
        [ServerRequest createCommentsForArticle:self.focusOn_aid
                                 AndWithContent:content
                                   AndWithColor:colorStr
                                    AndWithSize:sizeStr
                                AndWithPosition:positionStr
                                        Success:^(id json)
        {
            
            [self dealResultJson:json
                         content:content
                        colorStr:colorStr
                         sizeStr:sizeStr
                     positionStr:positionStr
                             Aid:self.focusOn_aid
                         isReply:NO] ;
            
        } fail:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [XTHudManager showWordHudWithTitle:WD_HUD_FAIL_RETRY] ;
            }) ;
        }] ;
    }
    else
    {
        // reply
        [ServerRequest replyCommetWithCmtID:self.wordView.comment.c_id
                             AndWithContent:content
                               AndWithColor:colorStr
                                AndWithSize:sizeStr
                            AndWithPosition:positionStr
                                    Success:^(id json)
        {
            
            [self dealResultJson:json
                         content:content
                        colorStr:colorStr
                         sizeStr:sizeStr
                     positionStr:positionStr
                             Aid:self.wordView.comment.a_id
                         isReply:YES] ;
            
        } fail:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [XTHudManager showWordHudWithTitle:WD_HUD_FAIL_RETRY] ;
            }) ;
        }] ;
    }
    
    return YES ; // synic result return ;
}

- (void)dealResultJson:(NSDictionary *)json
               content:(NSString *)content
              colorStr:(NSString *)colorStr
               sizeStr:(NSString *)sizeStr
           positionStr:(NSString *)positionStr
                   Aid:(int)replyToAid
               isReply:(BOOL)isReply
{
    ResultParsered *result = [[ResultParsered alloc] initWithDic:json] ;

    [self updateCommentSuccessWithResult:result
                                 content:content
                                colorStr:colorStr
                                 sizeStr:sizeStr
                             positionStr:positionStr
                                     Aid:replyToAid
                                 isReply:isReply] ;

}

- (void)updateCommentSuccessWithResult:(ResultParsered *)result
                               content:(NSString *)content
                              colorStr:(NSString *)colorStr
                               sizeStr:(NSString *)sizeStr
                           positionStr:(NSString *)positionStr
                                   Aid:(int)aid
                               isReply:(BOOL)isReply
{
    int cmtID = [[result.info objectForKey:@"c_id"] intValue] ;
    
    // show in view
    NSString *showContentStr = (!self.wordView.comment) ? content : [NSString stringWithFormat:@"回复%@:%@",self.wordView.comment.userCurrent.u_nickname,content] ;
    
    showContentStr = [showContentStr minusReturnStr] ;
    
    ArticleComment *cmt = [[ArticleComment alloc] initWithCommentID:cmtID
                                                     AndWithContent:showContentStr
                                                    AndWithColorStr:colorStr
                                                     AndWithSizeStr:sizeStr
                                                 AndWithPositionStr:positionStr
                                                             AndAID:aid] ;
    
    if (self.isMultiType)
    {
        [self.allComments insertObject:cmt atIndex:0] ;
    }
    
    // insert new comt in sub article
    if (self.focusOn_aid != self.superArticleID)
    {
        [self.articleSuper.childList enumerateObjectsUsingBlock:^(Article *subArticle, NSUInteger idx, BOOL * _Nonnull stop) {
            if (subArticle.a_id == self.focusOn_aid)
            {
                [subArticle.articleCommentList insertObject:cmt atIndex:0] ;
                subArticle.article_comments_count++ ;
                *stop = YES ;
            }
        }] ;
    }
    // insert new comt in super article
    else
    {
        [self.articleSuper.articleCommentList insertObject:cmt atIndex:0] ;
    }

    // insert new reply in sub article
    if (isReply)
    {
        [self.articleSuper.childList enumerateObjectsUsingBlock:^(Article *subArticle, NSUInteger idx, BOOL * _Nonnull stop) {
            if (subArticle.a_id == aid)
            {
                [subArticle.articleCommentList insertObject:cmt atIndex:0] ;
                subArticle.article_comments_count++ ;
                *stop = YES ;
            }
        }] ;
        
    }
    
    self.articleSuper.article_comments_count++ ;
    
    // fresh last number
    [self getlastCommentID] ;
    
    self.focusOn_aid = 0 ;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // reload table
        [self.table reloadData] ;
        // resign keyboards
        [self.wordView.textView resignFirstResponder] ;
        // reset to origin
        [self.wordView resetToOrigin] ;

    }) ;

}

#pragma mark --
#pragma mark - FlywordInputViewDelegate
- (void)resignWordSendViewAndKeyBoard
{
    self.wordView.comment = nil ;
    [self.wordView.textView resignFirstResponder] ;
    
    if (self.isMultiType) [self controlBottomBarShowOrNot] ;
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"detail2Praised"])
    {
        PraisedController *praiseCtrller = (PraisedController *)[segue destinationViewController] ;
        praiseCtrller.articleID = [sender intValue] ;
    }
    else if ([segue.identifier isEqualToString:@"detail2savePhoto"])
    {
        SaveAlbumnCtrller *albumCtrller = (SaveAlbumnCtrller *)[segue destinationViewController] ;
        albumCtrller.imgUrlsList = sender ;
    }
}

@end
