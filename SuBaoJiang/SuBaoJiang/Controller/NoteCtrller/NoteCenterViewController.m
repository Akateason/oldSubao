//
//  NoteCenterViewController.m
//  SuBaoJiang
//
//  Created by apple on 15/7/31.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "NoteCenterViewController.h"
#import "NoteAlamCell.h"
#import "AppDelegate.h"
#import "AppDelegateInitial.h"
#import "NoteInfoCell.h"
#import "Msg.h"
#import "NoteViewController.h"
#import "MyWebController.h"
#import "HomeController.h"
#import "DetailSubaoCtrller.h"

#define NONE_HEIGHT                 0.0f
#define SIZE_OF_PAGE                50

#define IDENTIFIER_NoteAlamCell     @"NoteAlamCell"
#define IDENTIFIER_NoteInfoCell     @"NoteInfoCell"

static const CGFloat HeightForNoteAlarmCell = 77.0f ;

@interface NoteCenterViewController () <UITableViewDataSource,UITableViewDelegate,RootTableViewDelegate>
{
    int savingNewMsgCount ; //save latest cmt count
    int savingNewNotCount ; //save latest sys count
    
    int m_hasNewMsg ;
    int m_hasNewPra ;
    int m_hasNewNot ;
    
    int m_lastMsgID ; //  save lase id ;
}
@property (weak, nonatomic) IBOutlet RootTableView  *table ;
@property (nonatomic)                int            M_tabBarItemCount ;
@property (nonatomic,strong)         NSMutableArray *noteList ;
@end

@implementation NoteCenterViewController

#pragma mark -- Public
- (void)clearSavingCount
{
    savingNewMsgCount = 0 ;
    savingNewNotCount = 0 ;
}

+ (void)updateAlreadyReadMsglist:(NSArray *)msglist
                            mode:(MODE_NOTE)mode
{
    NSMutableArray *readList = [[NSMutableArray alloc] initWithCapacity:1] ;
    
    if (!msglist.count) return ;
    
    for ( int i = 0 ; i < msglist.count ; i++ )
    {
        Msg *msgTemp = msglist[i] ;
        if (msgTemp.msg_status == 0)
        {
            // get unread list
            NSString *str = [NSString stringWithFormat:@"%d",msgTemp.msg_id] ;
            [readList addObject:str] ;
        }
    }
    
    if (!readList.count) return ;
    
    [ServerRequest readMsg:readList msgType:mode success:^(id json) {
        ResultParsered *result = [[ResultParsered alloc] initWithDic:json] ;
        if (!result.errCode)
        {
            NSLog(@"read update success") ;
        }
    } fail:^{
        NSLog(@"read update fail") ;
    }] ;
}

#pragma mark - Property
- (void)setM_tabBarItemCount:(int)M_tabBarItemCount
{
    _M_tabBarItemCount = M_tabBarItemCount ;
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = M_tabBarItemCount ;
    
    NSString *countStr = (!M_tabBarItemCount) ? nil : [NSString stringWithFormat:@"%d",M_tabBarItemCount] ;
    self.navigationController.tabBarItem.badgeValue = countStr ;
}

- (NSMutableArray *)noteList
{
    if (!_noteList) {
        _noteList = [NSMutableArray array] ;
    }
    
    return _noteList ;
}

#pragma mark - Initial
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        ((AppDelegate *)[UIApplication sharedApplication].delegate).noteCenterCtrller = self ;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userChange) name:NSNOTIFICATION_USER_CHANGE object:nil] ;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backgroundFetch:) name:NSNOTIFICATION_BG_FETCH_NOTES object:nil] ;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBadgeInRunloop:) name:NSNOTIFICATION_RUNLOOP_NOTES object:nil] ;
        
        [self changeTabbarItemsBadgeFromServer] ;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}

#pragma mark - Notification center call back
// user change
- (void)userChange
{
    [self changeTabbarItemsBadgeFromServer] ;
}

// backgroundFetch
- (void)backgroundFetch:(NSNotification *)notification
{
    [self showForFetchWithCompletionHandler:notification.object] ;
}

- (void)showForFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [ServerRequest getNoReadMsgCountSuccess:^(id json) {
        ResultParsered *result = [[ResultParsered alloc] initWithDic:json] ;
        [self setTabbarUI:result] ;
        [self setNoteCountInTable:result] ;
        [self setLocalRemote:result] ;
        
        completionHandler(UIBackgroundFetchResultNewData) ;
    } fail:^{
        completionHandler(UIBackgroundFetchResultFailed) ;
    }] ;
}


// run loop when app active
- (void)changeBadgeInRunloop:(NSNotification *)notification
{
    ResultParsered *result = notification.object ;
    [self setTabbarUI:result] ;
    [self setNoteCountInTable:result] ;
}

- (void)changeTabbarItemsBadgeFromServer
{
    [ServerRequest getNoReadMsgCountSuccess:^(id json) {
        
        ResultParsered *result = [[ResultParsered alloc] initWithDic:json] ;
        [self setTabbarUI:result] ;
        [self setNoteCountInTable:result] ;
        
    } fail:^{}] ;
}

- (void)setup
{
    _table.delegate         = self ;
    _table.dataSource       = self ;
    _table.backgroundColor  = COLOR_BACKGROUND ;
    _table.separatorColor   = COLOR_TABLE_SEP ;
    _table.separatorInset   = UIEdgeInsetsMake(0, 22.0, 0, 0) ;

    _table.rootDelegate     = self ;
    
    [_table registerNib:[UINib nibWithNibName:IDENTIFIER_NoteAlamCell bundle:nil] forCellReuseIdentifier:IDENTIFIER_NoteAlamCell];
    
    [_table registerNib:[UINib nibWithNibName:IDENTIFIER_NoteInfoCell bundle:nil] forCellReuseIdentifier:IDENTIFIER_NoteInfoCell];
}

#pragma mark -- UIs
- (void)setNoteCountInTable:(ResultParsered *)result
{
    m_hasNewMsg = [[result.info objectForKey:@"has_new_message"] intValue] ;
    m_hasNewPra = [[result.info objectForKey:@"has_new_praise"] intValue] ;
    m_hasNewNot = [[result.info objectForKey:@"has_new_notice"] intValue] ;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_table reloadData] ;
    }) ;
}

- (int)setTabbarUI:(ResultParsered *)result
{
    self.M_tabBarItemCount = [[result.info objectForKey:@"count_msg"] intValue] ;
    
    return self.M_tabBarItemCount ;
}

- (void)setLocalRemote:(ResultParsered *)result
{
    // has new comment msg to user .
    if (m_hasNewMsg && m_hasNewMsg != savingNewMsgCount)  //  hold times .
    {
        UILocalNotification *localNofify = [[UILocalNotification alloc] init];
        localNofify.alertBody = [NSString stringWithFormat:@"有%d条新的评论哟,快去看看吧~",m_hasNewMsg] ;
        localNofify.soundName = UILocalNotificationDefaultSoundName ;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNofify] ;
        
        savingNewMsgCount = m_hasNewMsg ;
    }
    
    // has new system msg to user .
    if (m_hasNewNot && m_hasNewNot != savingNewNotCount)  //  hold times .
    {
        UILocalNotification *localNofify = [[UILocalNotification alloc] init] ;
        NSString *msg_content = [result.info objectForKey:@"msg_content"] ;
        localNofify.alertBody = msg_content ;
        localNofify.soundName = UILocalNotificationDefaultSoundName ;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNofify] ;
        
        savingNewNotCount = m_hasNewNot ;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.myTitle = @"消息中心页" ;

    [self setup] ;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    if (!G_TOKEN)
    {
        [XTHudManager showWordHudWithTitle:WD_NOT_LOGIN] ;
    }
    
    [self changeTabbarItemsBadgeFromServer] ;
    [self.table pulldownManually] ;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
    
    if (m_hasNewNot)
    {
        self.M_tabBarItemCount -= m_hasNewNot ;
        m_hasNewNot = 0 ;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --
#pragma mark - parser System Note
- (BOOL)parserResult:(ResultParsered *)result
              getNew:(BOOL)bGetNew
{
    if (bGetNew) {
        [self.noteList removeAllObjects] ;
    }
    
    //1 get sys list
    NSArray *tempList = [result.info objectForKey:@"system_item"] ;
    if (!tempList.count) return NO ;
    for (NSDictionary *tDic in tempList)
    {
        Msg *cmt = [[Msg alloc] initWithDic:tDic] ;
        [self.noteList addObject:cmt] ;
    }
    
    //2 get last sys id
    m_lastMsgID = ((Msg *)[self.noteList lastObject]).msg_id ;
    
    [[self class] updateAlreadyReadMsglist:self.noteList
                                      mode:mode_sys] ;
    
    return YES ;
}

- (BOOL)getMsgCmtFromServerWithPullUpDown:(BOOL)bUpDown
{
    if (bUpDown) {
        m_lastMsgID = 0;
    }
    
    ResultParsered *result = [ServerRequest getMsgSystemMaxID:m_lastMsgID
                                                        Count: SIZE_OF_PAGE] ;
    
    if (!result) return NO;
    BOOL bHas = [self parserResult:result
                            getNew:bUpDown] ;

    if (!bUpDown && !bHas) return NO ;
    
    return YES   ;
}


#pragma mark --
#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0)
    {
        return 2 ; // 评论 + 赞 ;
    }
    else if (section == 1)
    {
        return [self.noteList count] ; //通知
    }
    
    return 0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    long section = indexPath.section ;
    long row     = indexPath.row ;
    
    if (section == 0)
    {
        return [self noteAlarmCellWithRow:row] ;
    }
    else if (section == 1)
    {
        return [self noteInfoCellWithRow:row] ;
    }
    
    return nil ;
}

- (NoteInfoCell *)noteInfoCellWithRow:(long)row
{
    NoteInfoCell *cell = [_table dequeueReusableCellWithIdentifier:IDENTIFIER_NoteInfoCell] ;
    if (!cell)
    {
        cell = [_table dequeueReusableCellWithIdentifier:IDENTIFIER_NoteInfoCell] ;
    }
    cell.msg = self.noteList[row] ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;

    return cell ;
}

- (NoteAlamCell *)noteAlarmCellWithRow:(long)row
{
    NoteAlamCell *cell = [_table dequeueReusableCellWithIdentifier:IDENTIFIER_NoteAlamCell] ;
    if (!cell)
    {
        cell = [_table dequeueReusableCellWithIdentifier:IDENTIFIER_NoteAlamCell];
    }
    
    TYPE_NoteAlam typeAlarm = row + 1 ;
    
    switch (typeAlarm)
    {
        case typeComment:
        {
            cell.noteCount = m_hasNewMsg ;
        }
            break;
        case typePraise:
        {
            cell.noteCount = m_hasNewPra ;
        }
            break;
        default:
            break;
    }
    
    cell.type = typeAlarm ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    
    return cell ;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [XTAnimation smallBigBestInCell:cell] ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return HeightForNoteAlarmCell ;
    }
    else if (indexPath.section == 1)
    {
        return [NoteInfoCell calculateHeightWithMsg:self.noteList[indexPath.row]] ;
    }
    
    return 0.0f ;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    long row = indexPath.row ;

    if (indexPath.section == 0)
    {
        TYPE_NoteAlam typeNote = row + 1 ;
        
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
        NoteViewController *noteCtrller = [story instantiateViewControllerWithIdentifier:@"NoteViewController"] ;
        noteCtrller.type = typeNote ;
        [noteCtrller setHidesBottomBarWhenPushed:YES] ;
        [self.navigationController pushViewController:noteCtrller animated:NO] ;
    }
    else
    {
        Msg *systemMsg = self.noteList[row] ;
        if (!systemMsg.msg_skipType) return ;
        
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
        
        switch (systemMsg.msg_skipType) {
            case mode_advertise:
            case mode_activity:
            {
                MyWebController *webCtrller = [[MyWebController alloc] init] ;
                webCtrller.urlStr = systemMsg.msg_value ;
                [webCtrller setHidesBottomBarWhenPushed:YES] ;
                [self.navigationController pushViewController:webCtrller animated:YES] ;
            }
                break;
            case mode_topic:
            {
                HomeController *homeCtrller = [story instantiateViewControllerWithIdentifier:@"HomeController"] ;
                homeCtrller.topicID = [systemMsg.msg_value intValue] ;
                [homeCtrller setHidesBottomBarWhenPushed:YES] ;
                [self.navigationController pushViewController:homeCtrller animated:NO] ;
            }
                break;
            case mode_detail:
            {
                int a_id = [systemMsg.msg_value intValue] ;
                [DetailSubaoCtrller jump2DetailSubaoCtrller:self AndWithArticleID:a_id] ;
            }
                break;
            default:
                break;
        }
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

#pragma mark --
#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.table rootTableScrollDidScroll:scrollView] ;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.table rootTableScrollDidEndDragging:scrollView] ;
}

#pragma mark -- RootTableViewDelegate
- (BOOL)doSthWhenfreshingHeader
{
    return [self getMsgCmtFromServerWithPullUpDown:YES];
}

- (BOOL)doSthWhenfreshingFooter
{
    return [self getMsgCmtFromServerWithPullUpDown:NO] ;
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"noteCenter2noteDetail"])
    {
        NoteViewController *noteVC = (NoteViewController *)[segue destinationViewController] ;
        noteVC.type = [sender integerValue] ;
    }
    
    [[segue destinationViewController] setHidesBottomBarWhenPushed:YES] ;
}
*/


@end
