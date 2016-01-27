
//
//  NoteViewController.m
//  SuBaoJiang
//
//  Created by apple on 15/6/16.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "NoteViewController.h"
#import "DetailSubaoCtrller+TaskModuleTransition.h"
#import "Article.h"
#import "UserCenterController.h"
#import "AppDelegate.h"
#import "CommonFunc.h"
#import "NavNoteCtrller.h"
#import "NoteCenterViewController.h"
#import "MyCmtCell.h"

#define IDENTIFIER_MYCMTCELL        @"MyCmtCell"

#define NONE_HEIGHT                 1.0f
#define SIZE_OF_PAGE                20

@interface NoteViewController () <UITableViewDataSource,UITableViewDelegate,RootTableViewDelegate>
{
    NSInteger m_lastMsgID ;
}
@property (nonatomic,strong)         NSMutableArray *m_msgList ;
@property (weak, nonatomic) IBOutlet RootTableView *table;

@end

@implementation NoteViewController

- (void)setType:(TYPE_NoteAlam)type
{
    _type = type ;
    
    switch (type) {
        case typeComment:
        {
            self.title      = @"评论" ;
            self.myTitle    = @"消息中心-对我的评论页" ;
        }
            break;
        case typePraise:
        {
            self.title      = @"喜欢" ;
            self.myTitle    = @"消息中心-对我的喜欢页" ;
        }
            break;
        default:
            break;
    }
}

- (NSMutableArray *)m_msgList
{
    if (!_m_msgList) {
        _m_msgList = [NSMutableArray array] ;
    }
    return _m_msgList ;
}

#pragma mark -- Initial
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(note2User:) name:NSNOTIFICATION_NOTE_2_USER object:nil] ;
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}

// note 2 User notification
- (void)note2User:(NSNotification *)notification
{
    int uID = [[notification object] intValue] ;
    
    [UserCenterController jump2UserCenterCtrller:self AndUserID:uID] ;
}

// note 2 Detail notification
- (void)note2SuBaoDetail:(NSDictionary *)tempDiction
{
    NSDictionary *dicSend = tempDiction ;
    int a_id = [[dicSend objectForKey:@"a_id"] intValue];
    int c_id = [[dicSend objectForKey:@"c_id"] intValue] ;
    NSLog(@"aID : %d",a_id) ;
    [DetailSubaoCtrller jump2DetailSubaoCtrller:self
                               AndWithArticleID:a_id
                               AndWithCommentID:c_id] ;    
}

#pragma mark -- initialization
- (void)setup
{
    _table.delegate         = self ;
    _table.dataSource       = self ;
    _table.backgroundColor  = COLOR_BACKGROUND ;
    _table.separatorColor   = COLOR_TABLE_SEP ;
    _table.xt_Delegate     = self ;
    
    [_table registerNib:[UINib nibWithNibName:IDENTIFIER_MYCMTCELL bundle:nil] forCellReuseIdentifier:IDENTIFIER_MYCMTCELL];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setup] ;
    [XTAnimation animationPushRight:self.view] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --
#pragma mark - parser Home Info
- (BOOL)parserResult:(ResultParsered *)result
              getNew:(BOOL)bGetNew
{
    if (bGetNew) {
        [self.m_msgList removeAllObjects] ;
    }
    
    //1 get cmt list
    switch (self.type)
    {
        case typeComment:
        {
            NSArray *tempList = [result.info objectForKey:@"comments_item"] ;
            if (!tempList.count) return NO ;
            for (NSDictionary *cDic in tempList)
            {
                Msg *cmt = [[Msg alloc] initWithDic:cDic] ;
                [self.m_msgList addObject:cmt] ;
            }
        }
            break;
        case typePraise:
        {
            NSArray *tempList = [result.info objectForKey:@"praises_item"] ;
            if (!tempList.count) return NO ;
            for (NSDictionary *cDic in tempList)
            {
                Msg *cmt = [[Msg alloc] initWithDic:cDic] ;
                [self.m_msgList addObject:cmt] ;
            }
        }
            break;
        default:
            break;
    }
    
    //2 get last cmt id
    m_lastMsgID = ((Msg *)[self.m_msgList lastObject]).msg_id ;
    
    MODE_NOTE mode = (TYPE_NoteAlam)self.type ;
    [NoteCenterViewController updateAlreadyReadMsglist:self.m_msgList
                                                  mode:mode] ;
    
    return YES ;
}

- (BOOL)getMsgCmtFromServerWithPullUpDown:(BOOL)bUpDown
{
    if (bUpDown) {
        m_lastMsgID = 0;
    }
    
    ResultParsered *result ;
    switch (self.type)
    {
        case typeComment:
        {
            result = [ServerRequest getMsgCommentMaxID:m_lastMsgID
                                                 count:SIZE_OF_PAGE] ;
        }
            break;
        case typePraise:
        {
            result = [ServerRequest getMsgPraiseMaxID:m_lastMsgID
                                                Count:SIZE_OF_PAGE] ;
        }
            break;
        default:
            break;
    }
    
    if (!result) return NO;
    
    BOOL bHas = [self parserResult:result
                            getNew:bUpDown] ;
    
    if (!bUpDown && !bHas) {
        return NO ;
    }
    
    return YES   ;
}


#pragma mark --
#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.m_msgList count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    long row = indexPath.row ;
    MyCmtCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_MYCMTCELL] ;
    if (!cell)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_MYCMTCELL];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.msg = self.m_msgList[row] ;
    
    switch (self.type)
    {
        case typeComment:
        {
            cell.bNoteCmt = YES ;
        }
            break;
            
        case typePraise:
        {
            cell.bNoteCmt = NO ;

        }
            break;
        default:
            break;
    }
    
    return cell ;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MyCmtCell calculateHeightWithCmt:((Msg *)self.m_msgList[indexPath.row]).msg_content] ;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Msg *msg = self.m_msgList[indexPath.row] ;
    
    NSDictionary *tempDiction = nil ;
    switch (self.type)
    {
        case typeComment:
        {
            tempDiction = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:msg.a_id],@"a_id",[NSNumber numberWithInt:msg.c_id],@"c_id",nil] ;
        }
            break;
        case typePraise:
        {
            tempDiction = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:msg.a_id],@"a_id",nil] ;
        }
            break;
        default:
            break;
    }
    
    [self note2SuBaoDetail:tempDiction] ;
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [XTAnimation smallBigBestInCell:cell] ;
}

#pragma mark -- RootTableViewDelegate
- (void)loadNewData
{
    [self getMsgCmtFromServerWithPullUpDown:YES];
}

- (void)loadMoreData
{
    [self getMsgCmtFromServerWithPullUpDown:NO] ;
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
