//
//  HomeController.m
//  SuBaoJiang
//
//  Created by apple on 15/6/2.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "HomeController.h"
#import "HomeCell.h"
#import "SuBaoHeaderView.h"
#import "MyNavCtrller.h"
#import "Article.h"
#import "Themes.h"
#import "ThemeCell.h"
#import "DetailSubaoCtrller.h"
#import "ArticleTopic.h"
#import "NavTitleView.h"
#import "UserCenterController.h"
#import "PostSubaoCtrller.h"
#import "NavLogCtller.h"
#import "MyWebController.h"
#import "MyTabbarCtrller.h"
#import "SEintroCell.h"
#import "NavCameraCtrller.h"
#import "CommonFunc.h"
#import "UIImageView+WebCache.h"
#import "NotificationCenterHeader.h"

#define SIZE_OF_PAGE        20

#define NONE_HEIGHT         0.0f

#define HEIGHT_bt_go2post               43.0
#define WIDTH_bt_go2post                150.0

#define ThemeCellID         @"ThemeCell"
#define HomeCellID          @"HomeCell"
#define SEintroCellID       @"SEintroCell"


@interface HomeController () <UITableViewDataSource,UITableViewDelegate,SuBaoHeaderViewDelegate,RootTableViewDelegate,RootTableViewFinished,HomeCellDelegate,ThemeCellDelegate,MyTabbarCtrllerDelegate,SEintroCellDelegate>
{
    BOOL                bSwitchFlyword      ; // 弹幕开关   DEFAULT IS TRUE
    UIBarButtonItem     *m_switchButton     ;
    
    BOOL                bMoveToTop          ;
    
    long long           m_lastUpdateTime    ; // 首页最新的updateTime && 话题页
    
    BOOL                m_isFirstTime       ; // default is false ; if false -> firsttime
}

@property (weak, nonatomic) IBOutlet RootTableView *table;
@property (weak, nonatomic) IBOutlet NavTitleView  *titleView;
@property (nonatomic,strong)         UIButton      *bt_go2post ;
@property (atomic, strong)  NSMutableArray         *m_articleList ; // 文章 datasource
@property (atomic, strong)  NSMutableArray         *m_themesList  ; // 主题list

@property (nonatomic)        CGRect                fromRect ;
@property (nonatomic,strong) UIImage               *imgTempWillSend ;

@end

@implementation HomeController

@synthesize m_articleList = _m_articleList ,
            m_themesList  = _m_themesList  ;

#pragma mark - Public
+ (void)jumpToTopicHomeCtrller:(ArticleTopic *)topic
                 originCtrller:(UIViewController *)ctrller
{
    [self jumpToTopicHomeCtrller:topic originCtrller:ctrller animated:NO] ;
}

+ (void)jumpToTopicHomeCtrller:(ArticleTopic *)topic
                 originCtrller:(UIViewController *)ctrller
                      animated:(BOOL)animated
{
    
    NSArray *ctrllersInNav = [ctrller.navigationController viewControllers] ;
    
    if (!ctrllersInNav || !ctrllersInNav.count) return ;
    
    [ctrllersInNav enumerateObjectsUsingBlock:^(UIViewController *tempCtrl, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([tempCtrl isKindOfClass:[HomeController class]])
        {
            HomeController *homeTempCtrl = (HomeController *)tempCtrl ;
            if (topic.t_id == homeTempCtrl.topicID) {
                [ctrller.navigationController popToViewController:homeTempCtrl animated:YES] ;
                *stop = YES ;
            }
        }
    }] ;
    
    BOOL isKindOfTopicCtrller = [ctrller isKindOfClass:[HomeController class]] ;
    if (isKindOfTopicCtrller) { // current ctrller is Topic
        BOOL isSameTopic = ((HomeController *)ctrller).topic.t_id == topic.t_id ;
        if (isSameTopic) { // same Topic Not Jump
            return ;
        }
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO] ;
    [ctrller.navigationController setNavigationBarHidden:NO animated:NO] ;
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
    HomeController *homeCtrller = [story instantiateViewControllerWithIdentifier:@"HomeController"] ;
    homeCtrller.topic = topic ;
    [homeCtrller setHidesBottomBarWhenPushed:YES] ;
    homeCtrller.tabBarController.tabBar.hidden = YES ;
    [ctrller.navigationController pushViewController:homeCtrller
                                            animated:animated] ;
}

- (void)reverseImageSendAnimationWithRect:(CGRect)toRect
{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:toRect] ;
    imgView.image = self.imgTempWillSend ;
    [self.view addSubview:imgView] ;
    
    [UIView animateWithDuration:QUICKLY_ANIMATION_DURATION
                     animations:^{
                         
                         imgView.frame = self.fromRect ;
                         
                     } completion:^(BOOL finished) {
                         if (finished) {
                             [imgView removeFromSuperview] ;
                         }
                     }] ;
        
}

#pragma mark -
- (UIButton *)bt_go2post
{
    if (!_bt_go2post)
    {
        _bt_go2post = [[UIButton alloc] init] ;
        [_bt_go2post addTarget:self
                        action:@selector(btPostTopicClickAction)
              forControlEvents:UIControlEventTouchUpInside] ;
    }
    
    if (![_bt_go2post superview])
    {
        _bt_go2post.frame = CGRectMake(0, 0, WIDTH_bt_go2post, HEIGHT_bt_go2post) ;
        _bt_go2post.center = CGPointMake(APPFRAME.size.width / 2, self.view.frame.size.height - 25.0 - HEIGHT_bt_go2post / 2.0 - STATUSBAR_HEIGHT - NAVIGATIONBAR_HEIGHT) ;
        [self.view addSubview:_bt_go2post] ;
    }
    
    return _bt_go2post ;
}

- (void)btPostTopicClickAction
{
    [NavCameraCtrller jump2NavCameraCtrllerWithOriginCtrller:self
                                            AndWithTopicName:self.topic.t_content] ;
}

- (void)setTopic:(ArticleTopic *)topic
{
    _topic = topic ;
    
    self.topicID = topic.t_id ;
}

- (void)setTopicID:(int)topicID
{
    _topicID = topicID ;

    // post button type
    if (topicID) {
        // ADD 2 Post Button
        switch (_topic.t_cate) {
            case t_cate_type_default:
            {
                [self.bt_go2post setImage:[UIImage imageNamed:@"bt_postTopic_normal"]
                                 forState:0] ;
            }
                break;
            case t_cate_type_suExperience:
            {
                [self.bt_go2post setImage:[UIImage imageNamed:@"bt_postTopic_suExperience"]
                                 forState:0] ;
            }
                break;
            default:
                break;
        }
    }
}

- (void)setM_articleList:(NSMutableArray *)m_articleList
{
    _m_articleList = m_articleList ;
}

- (NSMutableArray *)m_articleList
{
    if (!_m_articleList)
    {
        _m_articleList = [NSMutableArray array] ;
    }
    return _m_articleList ;
}

- (void)setM_themesList:(NSMutableArray *)m_themesList
{
    _m_themesList = m_themesList ;
}

- (NSMutableArray *)m_themesList
{
    if (!_m_themesList) {
        _m_themesList = [NSMutableArray array] ;
    }
    return _m_themesList ;
}

#pragma mark -
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteArticleSuccessed:) name:NSNOTIFICATION_DELETE_MY_ARTICLE object:nil] ;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadArticleFinished:) name:NSNOTIFICATION_UPLOAD_FINISHED object:nil] ;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(freshTableWithArticle:) name:NSNOTIFICATION_ARTICLE_REFRESH object:nil] ;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userChanged) name:NSNOTIFICATION_USER_CHANGE object:nil] ;
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;    
}

#pragma mark -- Notificaiton center

- (void)userChanged
{
    [self.table pulldownManually] ;
}

- (void)deleteArticleSuccessed:(NSNotification *)notification
{
    Article *articleDelete = [notification object] ;
    
    int index = 0 ;
    for (Article *tempArti in self.m_articleList)
    {
        if (tempArti.a_id == articleDelete.a_id)
        {
            [self.m_articleList removeObjectAtIndex:index] ;
            break ;
        }
        index ++ ;
    }
    
    m_lastUpdateTime = ((Article *)[self.m_articleList lastObject]).a_updatetime ;
    [_table reloadData] ;
}

- (void)uploadArticleFinished:(NSNotification *)notification
{
    Article *artiInsert = [notification object] ;
    [self.m_articleList insertObject:artiInsert atIndex:0] ;

    if (self.m_articleList.count == 1) {
        return ;
    }
    
    [_table insertSections:[NSIndexSet indexSetWithIndex:1]
          withRowAnimation:UITableViewRowAnimationFade] ;
    
    [_table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                  atScrollPosition:UITableViewScrollPositionNone
                          animated:YES] ;
}

- (void)freshTableWithArticle:(NSNotification *)notification
{
    Article *artiTemp = [notification object] ;
    
    int index = 0 ;
    for (Article *arti in self.m_articleList)
    {
        if (arti.a_id == artiTemp.a_id)
        {
            [self.m_articleList replaceObjectAtIndex:index
                                          withObject:artiTemp] ;
            [_table reloadSections:[NSIndexSet indexSetWithIndex:index + 1]
                  withRowAnimation:UITableViewRowAnimationNone] ;
            break ;
        }
        index ++ ;
    }
}

#pragma mark -- MyTabbarCtrllerDelegate
- (void)doubleTapedHomePage
{
    if (!self.m_articleList.count) return ;

    bMoveToTop = YES ;

    [self.table pulldownManually] ;
    [self.navigationController setNavigationBarHidden:NO animated:YES] ;
    [[UIApplication sharedApplication] setStatusBarHidden:NO] ;
}

#pragma mark -- SEintroCellDelegate
// need to calculate height in super controller .
- (void)topicDetailImageFetchingFinished
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0] ;
        [self tableView:self.table heightForRowAtIndexPath:indexPath] ;
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0] ;
        [_table reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone] ;
    }) ;
}

#pragma mark -- HomeCellDelegate
- (void)goToLogin
{
    [NavLogCtller modalLogCtrllerWithCurrentController:self] ;
}

- (void)topicSelected:(ArticleTopic *)topic
{
    [HomeController jumpToTopicHomeCtrller:topic originCtrller:self animated:YES] ;
}

#pragma mark -- ThemeCellDelegate
- (void)bannerSelectedTheme:(Themes *)theme
{
    switch (theme.themeCate)
    {
        case mode_advertise:
        case mode_activity :
        {
            MyWebController *webCtrller = [[MyWebController alloc] init] ;
            webCtrller.urlStr = theme.th_href ;
            [webCtrller setHidesBottomBarWhenPushed:YES] ;
            [self.navigationController pushViewController:webCtrller animated:YES] ;
        }
            break;
        case mode_topic :
        {
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
            HomeController *homeCtrller = [story instantiateViewControllerWithIdentifier:@"HomeController"] ;
            homeCtrller.topicID = theme.t_id ;
            [homeCtrller setHidesBottomBarWhenPushed:YES] ;
            [self.navigationController pushViewController:homeCtrller animated:YES] ;
        }
            break ;
        default:
            break;
    }
}

#pragma mark -- setup
- (void)setup
{
        [_table registerNib:[UINib nibWithNibName:ThemeCellID bundle:nil]
     forCellReuseIdentifier:ThemeCellID] ;
        [_table registerNib:[UINib nibWithNibName:HomeCellID bundle:nil]
     forCellReuseIdentifier:HomeCellID] ;
        [_table registerNib:[UINib nibWithNibName:SEintroCellID bundle:nil]
     forCellReuseIdentifier:SEintroCellID] ;
    
    _table.delegate = self ;
    _table.dataSource = self ;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone ;
    _table.backgroundColor = COLOR_BACKGROUND ;
    _table.rootDelegate = self ;
    _table.rootFinished = self ;
    _table.hideHudForShowNothing = YES ;
}

#pragma mark --
- (void)putNavBarItem
{
    bSwitchFlyword = YES ;

    m_switchButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fw_hide"]
                                                      style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:@selector(switchButtonPressedAction:)] ;
    
    self.navigationItem.rightBarButtonItem = m_switchButton ;
}

- (void)switchButtonPressedAction:(id)sender
{
    bSwitchFlyword = !bSwitchFlyword ;
    
    NSString *imgStr = !bSwitchFlyword ? @"fw_show" : @"fw_hide" ;
    [m_switchButton setImage:[UIImage imageNamed:imgStr]] ;
    
    NSString *hudStr = bSwitchFlyword ? WD_HUD_FLYWORD_OPEN : WD_HUD_FLYWORD_CLOSE ;
    [XTHudManager showWordHudWithTitle:hudStr] ;
    
    [_table reloadData] ;
}

#pragma mark - SuBaoHeaderViewDelegate
- (void)clickUserHead:(int)userID
{
    [UserCenterController jump2UserCenterCtrller:self
                                       AndUserID:userID] ;
}

#pragma mark --
#pragma mark - Life
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone ;    
    
    // initial
    [self setup] ;
    [self putNavBarItem] ;
    [self bt_go2post] ;
    
    // topic status
    if (_topic != nil)
    {
        _titleView.titleStr = _topic.t_content ;
        [XTAnimation animationPushRight:self.view] ;
        self.myTitle = @"话题详情页" ;
    }
    // home status
    else
    {
        self.myTitle = @"首页" ;
        
        //1 update App Version
        if (!_topic && !m_isFirstTime) {
            m_isFirstTime = YES ;
            [CommonFunc updateLatestVersion] ;
        }
        
        //2 tabbar ctrller - double tap Homepage tabbarItem Delegate
        ((MyTabbarCtrller *)(self.tabBarController)).homePageDelegate = self ;
    }
    
    [self.table pulldownManually] ;
    
    if ([CommonFunc isFirstHomePage])
    {
        self.guidingStrList = @[@"guiding_homePage"] ;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if ([self.view window] == nil)
    {
        // Add code to preserve data stored in the views that might be
        // needed later.
        self.m_articleList = nil ;
        self.m_themesList = nil ;
        
        // Add code to clean up other strong references to the view in
        // the view hierarchy.
        m_switchButton = nil ;
        self.bt_go2post = nil ;
        self.view = nil ;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES] ;
    [[UIApplication sharedApplication] setStatusBarHidden:NO] ;
}


#pragma mark --
#pragma mark - parser Home Info
- (BOOL)parserResult:(ResultParsered *)result
              getNew:(BOOL)bGetNew
{
    @synchronized (self.m_articleList)
    {
        result.info = [result.info objectForKey:@"items"] ;
        //1 get article
        NSArray *tempArticleList = [[result.info objectForKey:@"articles"] objectForKey:@"article_list"] ;
        if (!tempArticleList.count) return NO ;
        if (bGetNew) {
            [self.m_articleList removeAllObjects] ;
        }
        
        NSMutableArray *tempMutableList = [NSMutableArray array] ;
        for (NSDictionary *articleDic in tempArticleList) {
            Article *arti = [[Article alloc] initWithDict:articleDic] ;
            [tempMutableList addObject:arti] ;
        }
        self.m_articleList = [NSMutableArray arrayWithArray:[self.m_articleList arrayByAddingObjectsFromArray:tempMutableList]] ;
        
        m_lastUpdateTime = ((Article *)[self.m_articleList lastObject]).a_updatetime ;
    }

    @synchronized (self.m_themesList)
    {
        //2 get themes
        if (!bGetNew) return YES ;
        
        NSArray *tempThemesList = [result.info objectForKey:@"themes"] ;
        if (!tempThemesList.count) return NO ;
        [self.m_themesList removeAllObjects] ;
        for (NSDictionary *themeDic in tempThemesList)
        {
            Themes *theme = [[Themes alloc] initWithDic:themeDic] ;
            [self.m_themesList addObject:theme] ;
        }
    }
    
    return YES ;
}

- (BOOL)getHomeInfoFromServerWithPullUpDown:(BOOL)bUpDown
{
    if (bUpDown) m_lastUpdateTime = 0;
    
    ResultParsered *result = [ServerRequest getHomePageInfoResultWithSinceID:0
                                                                    AndMaxID:m_lastUpdateTime
                                                                    AndCount:SIZE_OF_PAGE] ;
    
    BOOL bHas = [self parserResult:result getNew:bUpDown] ;
    self.table.isNetSuccess = (self.m_articleList.count > 0) ; // show No Network
    
    if ( (bUpDown && !bHas) || (!bUpDown && !bHas) ) return NO ;
    
    return YES   ;
}

#pragma mark --
#pragma mark - parser Topic Detail Info
- (BOOL)parserTopicResult:(ResultParsered *)result
                   getNew:(BOOL)bGetNew
{
    if (bGetNew) [self.m_articleList removeAllObjects] ;
    
    //1 get Topic
    self.topic = [[ArticleTopic alloc] initWithDict:[result.info objectForKey:@"topics"]] ;
    //2 get topic str
    dispatch_async(dispatch_get_main_queue(), ^{
        _titleView.titleStr = [result.info objectForKey:@"topic"] ;
    }) ;
    
    @synchronized (self.m_articleList)
    {
        //3 Get article
        NSArray *tempArticleList = [result.info objectForKey:@"articles"] ;
        if (!tempArticleList.count) return NO ;
        for (NSDictionary *articleDic in tempArticleList) {
            Article *arti = [[Article alloc] initWithDict:articleDic] ;
            [self.m_articleList addObject:arti] ;
        }
        m_lastUpdateTime = ((Article *)[self.m_articleList lastObject]).a_updatetime ;
    }

    return YES ;
}

- (BOOL)getTopicDetailFromServerWithPullUpDown:(BOOL)bUpDown
{
    if (bUpDown) m_lastUpdateTime = 0 ;
    
    ResultParsered *result = [ServerRequest getArticleWithTopicID:_topicID
                                                   AndWithSinceID:0
                                                     AndWithMaxID:m_lastUpdateTime
                                                     AndWithCount:SIZE_OF_PAGE] ;
    if (!result) return NO ;
    
    BOOL bHas = [self parserTopicResult:result
                                 getNew:bUpDown] ;
    
    if (!bUpDown && !bHas) return NO ;
    
    return YES   ;
}

#pragma mark --
#pragma mark -- RootTableViewDelegate
- (BOOL)doSthWhenfreshingHeader
{
    BOOL bSuccess = (!_topicID) ? [self getHomeInfoFromServerWithPullUpDown:YES] : [self getTopicDetailFromServerWithPullUpDown:YES] ;
    return bSuccess ;
}

- (BOOL)doSthWhenfreshingFooter
{
    BOOL hasNew = (!_topicID) ? [self getHomeInfoFromServerWithPullUpDown:NO] : [self getTopicDetailFromServerWithPullUpDown:NO] ;
    return hasNew ;
}

- (void)headerRefreshFinished
{
    if (bMoveToTop && self.m_articleList.count)
    {
        bMoveToTop = NO ;
        [self.table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES] ;
    }
}

- (void)footerRefreshFinished
{
}

#pragma mark --
#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    @synchronized (self.m_articleList)
    {
        return self.m_articleList.count + 1 ;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1 ;
}

- (UITableViewCell *)getEmptyCell
{
    UITableViewCell *cell = [_table dequeueReusableCellWithIdentifier:@"nil"] ;
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nil"];
    }
    
    return cell ;
}

- (ThemeCell *)getThemeCell
{
    ThemeCell * cell = [_table dequeueReusableCellWithIdentifier:ThemeCellID] ;
    if (!cell)
    {
        cell = [_table dequeueReusableCellWithIdentifier:ThemeCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.themesList = self.m_themesList ;
    cell.delegate = self ;

    return cell ;
}

- (SEintroCell *)getSEintroCell
{
    SEintroCell *cell = [_table dequeueReusableCellWithIdentifier:SEintroCellID] ;
    if (!cell)
    {
        cell = [_table dequeueReusableCellWithIdentifier:SEintroCellID] ;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.strImg = self.topic.t_detail ;
    cell.delegate = self ;
    
    return cell ;
}

- (HomeCell *)getHomeCellWithIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section ;
    HomeCell * cell = [_table dequeueReusableCellWithIdentifier:HomeCellID] ;
    if (!cell)
    {
        cell = [_table dequeueReusableCellWithIdentifier:HomeCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    @synchronized (self.m_articleList) {
        cell.article = (Article *)self.m_articleList[section - 1] ;
    }
    cell.isflywordShow = bSwitchFlyword ;
    cell.delegate = self ;
    
    return cell ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.section)
    {
        if (self.m_themesList.count)
        {
            return [self getThemeCell] ;
        }
        else if (self.topic && ![self.topic.t_detail isEqualToString:@""])
        {
            return [self getSEintroCell] ;
        }
        else
        {
            return [self getEmptyCell] ; // empty
        }
    }
    else if (indexPath.section > 0)
    {
        return [self getHomeCellWithIndexPath:indexPath] ;
    }
    
    return nil ;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.topicID) {
        [self.table loadFooterInTableWillDisplayCellWithCurrentIndexRowOrSection:indexPath.section
                                                                       ListCount:self.m_articleList.count + 1] ;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section ;
    if (!section)
    {
        if (self.m_themesList.count)
        {
            return [ThemeCell calculateThemesHeight] ;
        }
        else if (self.topic && ![self.topic.t_detail isEqualToString:@""])
        {
            CGFloat height = [SEintroCell calculateHeightWithPicKeys:self.topic.t_detail] ;
            NSLog(@"dHeight : %@",@(height)) ;
            return height ;
        }
        else
        {
            return NONE_HEIGHT ;
        }        
    }
    
    @synchronized (self.m_articleList) {
        Article  *currentArticle    = (Article *)self.m_articleList[section - 1] ;
        NSString *strAttriComment   = [currentArticle getStrCommentContent] ;
        return [HomeCell calculateHomeCellHeight:strAttriComment] ;
    }
    
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = (int)indexPath.section ;
    if (!section) return ;
    
    @synchronized (self.m_articleList)
    {
        Article *articleTemp = self.m_articleList[section - 1] ;
        CGRect rectTableView = [tableView rectForRowAtIndexPath:indexPath] ;
        CGRect rectInView = [tableView convertRect:rectTableView toView:self.view] ;
        self.imgTempWillSend = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:articleTemp.img
                                                                          withCacheWidth:APPFRAME.size.width] ;

        self.fromRect = CGRectMake(0, rectInView.origin.y, APPFRAME.size.width , APPFRAME.size.width) ;
        
        [DetailSubaoCtrller jump2DetailSubaoCtrller:self
                                   AndWithArticleID:articleTemp.a_id
                                   AndWithCommentID:0
                                           FromRect:self.fromRect
                                            imgSend:self.imgTempWillSend
         ] ;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!section) {
        UIView *empty = [[UIView alloc] init] ;
        empty.backgroundColor = nil ;
        return empty ;
    }
    
    SuBaoHeaderView *header = (SuBaoHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"SuBaoHeaderView" owner:self options:nil] lastObject] ;
    @synchronized (self.m_articleList) {
        header.article = self.m_articleList[section - 1] ;
    }
    header.delegate = self ;
    return header ;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return (!section) ? NONE_HEIGHT : 48.0f ;
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

#pragma mark --
#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_table rootTableScrollDidScroll:scrollView] ;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.topicID != 0) [self hidePostButton] ; // HIDE POST BUTTON
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.topicID != 0) {
        [self showPostButtonIfNeccessary] ; // SHOW POST BUTTON
        
        return ; // BREAK IN topic ctrller
    }
    
    if ( IS_IOS_VERSION(7.1) )   //   Unsupport  7.0
    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.tabBarController.tabBar.hidden = NO ;
//        }) ;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
    [_table rootTableScrollDidEndDragging:scrollView] ;
    
    if (self.topicID != 0)
    {
        if (!decelerate) {
            [self showPostButtonIfNeccessary] ; // SHOW POST BUTTON
        }
        
        return ; // BREAK IN topic ctrller
    }
    
    //  hidden or show nav and tab  BARs .
    if ( IS_IOS_VERSION(7.1) )   //   Unsupport  7.0
    {
        CGFloat flex = 0.0 ;
        CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
        
        if (translation.y > flex)
        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone] ;
//                [self.navigationController setNavigationBarHidden:NO animated:YES] ;
//                self.tabBarController.tabBar.hidden = NO ;
//            }) ;
        }
//        else if (translation.y < - flex)
        else
        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [[UIApplication sharedApplication] setStatusBarHidden:decelerate withAnimation:UIStatusBarAnimationNone] ;
//                [self.navigationController setNavigationBarHidden:decelerate animated:YES] ;
//                self.tabBarController.tabBar.hidden = decelerate ;
//            }) ;
        }
        
    }
}

- (void)hidePostButton
{
    [UIView animateWithDuration:0.35
                     animations:^{
        self.bt_go2post.alpha = 0.25 ;
    }] ;
}

- (void)showPostButtonIfNeccessary
{
    if (self.bt_go2post.alpha != 1.0)
    {
        [UIView animateWithDuration:0.35 animations:^{
            self.bt_go2post.alpha = 1.0 ;
        }] ;
    }
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
