//
//  UserCenterController.m
//  SuBaoJiang
//
//  Created by apple on 15/6/9.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "UserCenterController.h"
#import "User.h"
#import "Article.h"
#import "MyPraisedCell.h"
#import "ArticlePraise.h"
#import "MySubaoCell.h"
#import "ArticleComment.h"
#import "MyCommentsCell.h"
#import "DetailSubaoCtrller.h"
#import "NavLogCtller.h"
#import "CommonFunc.h"
#import "SettingCtrller.h"
#import "XTSegment.h"
#import "DraftTB.h"
#import "MultyEditCtrller.h"
#import "XHPathCover.h"
#import "UIImageView+WebCache.h"
#import "UIImage+AddFunction.h"
#import "NotificationCenterHeader.h"
#import "PublicEnum.h"

#define SIZE_OF_PAGE    10
#define KVO_THE_USER    @"KVO_THE_USER"

@interface UserCenterController () <TeaSegmentDelegate,MyCellDelegate,UserInfoViewDelegate>
{
    BOOL                _reloadingHead      ;

    BOOL                _reloadingFoot      ;

    BOOL                isOther ;
    
    MODE_SEG_SEL        m_currentMode ; // 当前segment, 切换的点
        
    //我的速报
    int                 m_lastSubaoID ;
    NSMutableArray      *m_subaoList ;
    
    //我的评论
    int                 m_lastCmtID ;
    NSMutableArray      *m_commentList ;
    
    //我的赞过
    int                 m_lastPraisedID ;
    NSMutableArray      *m_praiseList ;
    
    UIButton            *m_btSetting ;
}

@property (weak, nonatomic) IBOutlet RootTableView *table;
@property (nonatomic,strong) XHPathCover *pathCover;

@property (nonatomic,strong) XTSegment  *segment ;
@property (nonatomic,strong) NSArray    *segList ;

@property (nonatomic,strong) User       *theUser ; // 设置为看别人, 不设置为自己
@end


@implementation UserCenterController

#pragma mark -- public
+ (void)jump2UserCenterCtrller:(UIViewController *)ctrller
                     AndUserID:(int)uid
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
    UserCenterController *userCtrller = [story instantiateViewControllerWithIdentifier:@"UserCenterController"] ;
    
    userCtrller.userID = uid ;
    userCtrller.noBottom = YES ;
    [userCtrller setHidesBottomBarWhenPushed:YES] ;
    [ctrller.navigationController pushViewController:userCtrller animated:YES] ;
}

#pragma mark -- initialization
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userHasChanged)
                                                     name:NSNOTIFICATION_USER_CHANGE
                                                   object:nil] ;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(uploadFinished)
                                                     name:NSNOTIFICATION_UPLOAD_FINISHED
                                                   object:nil] ;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshTable)
                                                     name:NSNOTIFICAITON_FRESH_USER
                                                   object:nil] ;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshTable)
                                                     name:NSNOTIFICATION_DELETE_MY_ARTICLE
                                                   object:nil] ;
    }
    
    return self ;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}

// notification
- (void)userHasChanged
{
    //我的速报
    @synchronized(m_subaoList)
    {
        m_lastSubaoID = 0 ;
        [m_subaoList removeAllObjects] ;
    }
    
    //我的评论
    @synchronized(m_commentList)
    {
        m_lastCmtID = 0 ;
        [m_commentList removeAllObjects] ;
    }
    
    //我的赞过
    @synchronized(m_praiseList)
    {
        m_lastPraisedID = 0 ;
        [m_praiseList removeAllObjects] ;
    }
    
//    [self.table pulldownManually] ;
    [self _refreshing] ;
}

- (void)uploadFinished
{
//    [self.table pulldownManually] ;
    [self _refreshing] ;
}

- (void)refreshTable
{
//    [self.table pulldownManually] ;
    [self _refreshing] ;
}

#pragma mark - Properties
- (void)setUserID:(int)userID
{
    _userID = userID ;
    
    isOther = (_userID != G_USER.u_id) ? YES : NO ;
    if (isOther) _segment = nil ;
}

- (User *)theUser
{
    if (!isOther) {
        _theUser = G_USER ;
    }
    
    return _theUser ;
}

- (NSArray *)segList
{
    _segList = (isOther) ? @[@"速报"] : @[@"速报",@"我的评论",@"喜欢"] ;

    return _segList ;
}

#define MENU_HEIGHT 44.0

- (XTSegment *)segment
{
    if (!_segment)
    {
        CGRect rect = CGRectZero ;
        rect.size = CGSizeMake(APPFRAME.size.width, MENU_HEIGHT) ;

        _segment = [[XTSegment alloc] initWithDataList:self.segList imgBg:[UIImage imageNamed:@"btBase"] height:MENU_HEIGHT normalColor:[UIColor darkTextColor] selectColor:COLOR_MAIN font:[UIFont systemFontOfSize:13.0]] ;
        _segment.delegate = self ;
        _segment.frame = rect ;
        _segment.backgroundColor = [UIColor whiteColor];
    }
    
    return _segment ;
}

#pragma mark - UserInfoViewDelegate
- (void)userInfoTappedBackground
{
    if ( (!G_TOKEN || !G_USER.u_id) && (_noBottom == NO) ) {
        [NavLogCtller modalLogCtrllerWithCurrentController:self] ;
    }
}

- (void)editBtClick
{
    [self performSegueWithIdentifier:@"user2useredit" sender:nil] ;
}

#pragma mark - My Cell Delegate ( MySubao MyComments Mypraised )
- (void)jump2Article:(int)a_id
{
    NSLog(@"aID : %d",a_id) ;
    [DetailSubaoCtrller jump2DetailSubaoCtrller:self AndWithArticleID:a_id] ;
}

- (void)clickDraft:(int)super_cid
{
    NSLog(@"super_cid : %d",super_cid) ;
    Article *superArticle = [[DraftTB shareInstance] getSuperArticleWithCLientID:super_cid] ;
    NSMutableArray *childsList = [[DraftTB shareInstance] getSubArticlesWithSuperArticleCLientID:super_cid] ;
    [MultyEditCtrller jump2MultyEditCtrllerWithOrginCtrller:self
                                               superArticle:superArticle
                                                   topicStr:[superArticle getTopicStr]
                                                  childList:childsList] ;
}

#pragma mark - TeaSegmentDelegate
- (void)clickSegmentWith:(int)index
{
    NSLog(@"click : %d",index) ;
    
    m_currentMode = index ;
    
    BOOL bSub = (m_currentMode == mode_MY_SUBAO) && [m_subaoList count] ;
    BOOL bCmt = (m_currentMode == mode_MY_COMMENT) && [m_commentList count] ;
    BOOL bPra = (m_currentMode == mode_MY_PRAISED) && [m_praiseList count] ;
    
    if (bSub || bCmt || bPra)
    {
        [_table reloadData] ;
    }
    else
    {
//        [_table pulldownManually] ;
        [self _refreshing] ;
    }
    
}

- (void)setup
{
    self.myTable = _table ;
    _table.delegate = self ;
    _table.dataSource = self ;

    _table.separatorStyle = UITableViewCellSeparatorStyleNone ;
    _table.backgroundColor = COLOR_BACKGROUND ;
//    _table.rootDelegate = self ;
    
    _table.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - NavBar Item SETTING
- (void)putNavBarItem
{
    m_btSetting = [UIButton buttonWithType:UIButtonTypeCustom];
    m_btSetting.frame = CGRectMake(0, 0, 40, 40);
    [m_btSetting setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [m_btSetting addTarget:self action:@selector(settingPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settintBt  = [[UIBarButtonItem alloc] initWithCustomView:m_btSetting] ;
    self.navigationItem.rightBarButtonItem = settintBt ;
    
//    m_settintBt = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(settingPressed)] ;
//    self.navigationItem.rightBarButtonItem = m_settintBt ;
}

- (void)settingPressed
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
    SettingCtrller *settingCtrller = [story instantiateViewControllerWithIdentifier:@"SettingCtrller"] ;
    [settingCtrller setHidesBottomBarWhenPushed:YES] ;
    [self.navigationController pushViewController:settingCtrller animated:NO] ;
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view

    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.myTitle = @"用户个人主页" ;
    
    [self setup] ;
    
    if (!_noBottom)
    {
        [self putNavBarItem] ;
    }
    self.tabBarController.tabBar.hidden = _noBottom ;
    
    m_currentMode   = mode_MY_SUBAO ;
    
    m_subaoList     = [NSMutableArray array] ;
    m_commentList   = [NSMutableArray array] ;
    m_praiseList    = [NSMutableArray array] ;
    
    [self _refreshing] ;
    
    _pathCover = [[XHPathCover alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(APPFRAME), 230)];
    _pathCover.userObj = self.theUser ;
    [self fetchUserHead] ;
    _pathCover.isZoomingEffect = YES ;
    self.table.tableHeaderView = self.pathCover ;
    _pathCover.infoView.delegate = self ;
    
    __weak UserCenterController *wself = self ;
    [_pathCover setHandleRefreshEvent:^{
        [wself _refreshing] ;
    }];
    
    [_pathCover animateStart] ;

}

- (void)fetchUserHead
{
    if (!self.theUser.u_id)
    {
        [_pathCover setBackgroundImage:nil] ;
        return ;
    }
    
    UIImage *headImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.theUser.u_headpic
                                                                    withCacheWidth:APPFRAME.size.width] ;
    if (!headImage)
    {
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.theUser.u_headpic]
                                                              options:0
                                                             progress:nil
                                                            completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                                [self makeBlurOn:image] ;
                                                            }] ;
    }
    else {
        [self makeBlurOn:headImage] ;
    }
}

- (void)makeBlurOn:(UIImage *)orgImage
{
    UIImage *imgBack = [orgImage blur] ;
    
    [_pathCover setBackgroundImage:imgBack] ;
}


- (void)_refreshing
{
    if (_reloadingHead || _reloadingFoot) {
        return ;
    }
    _reloadingHead = YES ;
    // refresh your data sources
    __weak UserCenterController *wself = self ;
    dispatch_queue_t requestQueue = dispatch_queue_create("UserRequestqueue", NULL) ;
    dispatch_async(requestQueue, ^{
        [wself getInfoWithPullUpDown:YES] ;
        
        [_pathCover stopRefresh] ;

        dispatch_async(dispatch_get_main_queue(), ^{
            
            _pathCover.userObj = wself.theUser ;
            [wself fetchUserHead] ;
            [wself.pathCover stopRefresh] ;
            [wself.table reloadData] ;
            
            _reloadingHead = NO ;
            
        }) ;
    }) ;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    if (!G_TOKEN) {
        [XTHudManager showWordHudWithTitle:WD_NOT_LOGIN] ;
    }
    
    
    [self.navigationController setNavigationBarHidden:NO animated:NO] ;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated] ;
    
    if (m_btSetting != nil)
    {
        CABasicAnimation *animate = [XTAnimation horizonRotationWithDuration:0.65
                                                                      degree:65
                                                                   direction:1
                                                                 repeatCount:1] ;
        [m_btSetting.layer addAnimation:animate forKey:@"rollSetting"] ;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- parsel
- (BOOL)parserResult:(ResultParsered *)result
              getNew:(BOOL)bGetNew
{
    switch (m_currentMode)
    {
        case mode_MY_SUBAO:
        {
            return [self runSubao:result With:bGetNew] ;
        }
            break;
        case mode_MY_COMMENT:
        {
            return [self runCmt:result With:bGetNew] ;
        }
            break;
        case mode_MY_PRAISED:
        {
            return [self runPraise:result With:bGetNew] ;
        }
            break;
        default:
            break;
    }
    
    return NO ;
}

- (BOOL)runSubao:(ResultParsered *)result
            With:(BOOL)bGetNew
{
    @synchronized (m_subaoList)
    {
        if (bGetNew)
        {
            [m_subaoList removeAllObjects] ;
        }
        
        if (isOther)
        {
            self.theUser = [[User alloc] initWithDic:[result.info objectForKey:@"user"]] ;
        }
        
        //1 get subao list
        NSArray *tempSubaoList = [result.info objectForKey:@"artiles"] ;
        if (!tempSubaoList.count) return NO ;
        for (NSDictionary *aDic in tempSubaoList) {
            Article *art = [[Article alloc] initWithDict:aDic] ;
            [m_subaoList addObject:art] ;
        }
        //2 get last subao id
        m_lastSubaoID = ((Article *)[m_subaoList lastObject]).a_id ;
        //3 get draft if get new and owner .
        if (bGetNew && !isOther)
        {
            NSArray *draftList = [[DraftTB shareInstance] getAllNotUploadedSuperArticles] ;
            m_subaoList = [NSMutableArray arrayWithArray:[draftList arrayByAddingObjectsFromArray:m_subaoList]] ;
        }
        
        return YES ;
    }
}

- (BOOL)runCmt:(ResultParsered *)result
          With:(BOOL)bGetNew
{
    @synchronized (m_commentList)
    {
        if (bGetNew) {
            [m_commentList removeAllObjects] ;
        }
        //1 get cmt list
        NSArray *tempCmtList = [result.info objectForKey:@"comments"] ;
        if (!tempCmtList.count) return NO ;
        for (NSDictionary *cDic in tempCmtList) {
            ArticleComment *cmt = [[ArticleComment alloc] initWithDic:cDic] ;
            [m_commentList addObject:cmt] ;
        }
        //2 get last cmt id
        m_lastCmtID = ((ArticleComment *)[m_commentList lastObject]).c_id ;
        
        return YES ;
    }
}

- (BOOL)runPraise:(ResultParsered *)result
             With:(BOOL)bGetNew
{
    @synchronized (m_praiseList)
    {
        if (bGetNew) {
            [m_praiseList removeAllObjects] ;
        }
        //1 get praise list
        NSArray *tempPraiseList = [result.info objectForKey:@"praises"] ;
        if (!tempPraiseList.count) return NO ;
        for (NSDictionary *pDic in tempPraiseList) {
            ArticlePraise *artiP = [[ArticlePraise alloc] initWithDict:pDic] ;
            [m_praiseList addObject:artiP] ;
        }
        //2 get last praise id
        m_lastPraisedID = ((ArticlePraise *)[m_praiseList lastObject]).ao_id ;
        
        return YES ;
    }
}

- (BOOL)getInfoWithPullUpDown:(BOOL)bUpDown
{
    if (bUpDown){
        switch (m_currentMode)
        {
            case mode_MY_SUBAO:
            {
                m_lastSubaoID = 0 ;
            }
                break;
            case mode_MY_COMMENT:
            {
                m_lastCmtID = 0 ;
            }
                break;
            case mode_MY_PRAISED:
            {
                m_lastPraisedID = 0;
            }
                break;
            default:
                break;
        }
    }
    
    ResultParsered *result ;
    
    switch (m_currentMode) {
        case mode_MY_SUBAO:
        {
            if (isOther) {
                result = [ServerRequest getOtherHomePageWithUserID:_userID AndWithMaxID:m_lastSubaoID AndWithCount:SIZE_OF_PAGE] ;
            } else {
                result = [ServerRequest getMySuBaoAndWithSinceID:0 AndWithMaxID:m_lastSubaoID AndWithCount:SIZE_OF_PAGE] ;
            }
        }
            break;
        case mode_MY_COMMENT:
        {
            result = [ServerRequest getMyCommentWithSinceID:0 AndWithMaxID:m_lastCmtID AndWithCount:SIZE_OF_PAGE] ;
        }
            break;
        case mode_MY_PRAISED:
        {
            result = [ServerRequest getMyPraisedWithSinceID:0 AndWithMaxID:m_lastPraisedID AndWithCount:SIZE_OF_PAGE] ;
        }
            break;
        default:
            break;
    }
    
    if (!result) return NO ;
    BOOL bHas = [self parserResult:result getNew:bUpDown] ;

    if (!bUpDown && !bHas) {
        return NO ;
    }
    
    return YES ;
}


#pragma mark --
#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1 ; //content ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (m_currentMode)
    {
        case mode_MY_SUBAO:
        {
            return [self useSubaoCell] ;
        }
            break;
        case mode_MY_COMMENT:
        {
            return [self useCommentCell] ;
        }
            break;
        case mode_MY_PRAISED:
        {
            return [self usePraiseCell] ;
        }
            break;
        default:
            break;
    }
    
    return nil ;
}

- (MySubaoCell *)useSubaoCell
{
    static  NSString  *CellIdentiferId = @"MySubaoCell";
    MySubaoCell * cell = [_table dequeueReusableCellWithIdentifier:CellIdentiferId] ;
    if (!cell)
    {
        [_table registerNib:[UINib nibWithNibName:CellIdentiferId bundle:nil] forCellReuseIdentifier:CellIdentiferId];
        cell = [_table dequeueReusableCellWithIdentifier:CellIdentiferId];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.subaoList = m_subaoList ;
    cell.delegate = self ;
    return cell;
}

- (MyCommentsCell *)useCommentCell
{
    static  NSString  *CellIdentiferId = @"MyCommentsCell";
    MyCommentsCell *cell = [_table dequeueReusableCellWithIdentifier:CellIdentiferId] ;
    if (!cell)
    {
        [_table registerNib:[UINib nibWithNibName:CellIdentiferId bundle:nil] forCellReuseIdentifier:CellIdentiferId];
        cell = [_table dequeueReusableCellWithIdentifier:CellIdentiferId];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.cmtList = m_commentList ;
    cell.delegate = self ;
    return cell;
}

- (MyPraisedCell *)usePraiseCell
{
    static  NSString  *CellIdentiferId = @"MyPraisedCell";
    MyPraisedCell * cell = [_table dequeueReusableCellWithIdentifier:CellIdentiferId] ;
    if (!cell)
    {
        [_table registerNib:[UINib nibWithNibName:CellIdentiferId bundle:nil] forCellReuseIdentifier:CellIdentiferId];
        cell = [_table dequeueReusableCellWithIdentifier:CellIdentiferId];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.praiseList = m_praiseList ;
    cell.delegate = self ;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (m_currentMode)
    {
        case mode_MY_SUBAO:
        {
            return [MySubaoCell calculateHeightWithList:m_subaoList] ;
        }
            break;
        case mode_MY_COMMENT:
        {
            return [MyCmtCell calculateTableSumHeightWith:m_commentList] ;
        }
            break;
        case mode_MY_PRAISED:
        {
            return [MyPraisedCell calculateHeightWithPraiseList:m_praiseList] ;
        }
            break;
        default:
            break;
    }
    
    return 1 ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.segment ;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return MENU_HEIGHT ;
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
    return 1.0f ;
}

#pragma mark --
#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_pathCover scrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_pathCover scrollViewDidEndDragging:scrollView willDecelerate:decelerate];

    [self loadMoreWithScrollView:scrollView] ;
}

- (void)loadMoreWithScrollView:(UIScrollView *)scrollView
{
    if (_reloadingHead || _reloadingFoot) return ; // protect loading only once . if in loading break
    
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize contentsize = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    CGFloat currentOffset = offset.y + bounds.size.height - inset.bottom;
    CGFloat maximumOffset = contentsize.height;
    
    if (contentsize.height <= bounds.size.height) return ;
    
    CGFloat alarmDistance = 0 ;
    
    if (maximumOffset <= currentOffset + alarmDistance)
    {
        [self loadMoreAction];
    }
}

- (void)loadMoreAction
{
    _reloadingFoot = YES ;
    
    dispatch_queue_t queue = dispatch_queue_create("LoadMore", NULL) ;
    dispatch_async(queue, ^{
        BOOL b = [self getInfoWithPullUpDown:NO] ;
        if (b)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.table reloadData] ;
                _reloadingFoot = NO ;
            }) ;
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [XTHudManager showWordHudWithTitle:WD_HUD_NOMORE delay:1.0] ;
                _reloadingFoot = NO ;
            }) ;
        }
    }) ;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [_pathCover scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_pathCover scrollViewWillBeginDragging:scrollView];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [segue.destinationViewController setHidesBottomBarWhenPushed:YES] ;
}


@end
