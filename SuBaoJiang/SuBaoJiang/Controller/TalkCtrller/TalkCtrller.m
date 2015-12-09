//
//  TalkCtrller.m
//  SuBaoJiang
//
//  Created by apple on 15/6/12.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "TalkCtrller.h"
#import "Acategory.h"
#import "ArticleTopic.h"
#import "TopicCell.h"
#import "TopicHeader.h"
#import "HomeController.h"

#define SIZE_OF_PAGE    20
#define NONE_HEIGHT     1.0f

@interface TalkCtrller () <RootTableViewDelegate>
{
    NSMutableArray *m_topicList ;
    
    int            m_currentPage ;
}
@property (weak, nonatomic) IBOutlet RootTableView *table;

@end

@implementation TalkCtrller

- (void)setTc_topicType:(TalkCtrller_TopicType)tc_topicType
{
    _tc_topicType = tc_topicType ;
    
    if (tc_topicType == type_suExperience)
    {
        self.title = @"速体验合辑" ;
    }
}

- (void)setAcate:(Acategory *)acate
{
    _acate = acate ;
    
    self.title = acate.ac_content ;
}

- (void)setup
{
    _table.delegate         = self ;
    _table.dataSource       = self ;
    _table.backgroundColor  = COLOR_BACKGROUND ;
    _table.xt_Delegate     = self ;
    
    _table.separatorColor   = COLOR_TABLE_SEP ;
    _table.separatorInset   = UIEdgeInsetsMake(0, 26, 0, 0) ;
}

- (void)setupDataSource
{
    m_topicList     = [NSMutableArray array] ;
    
    m_currentPage   = 1 ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.myTitle = @"话题列表页" ;

    // initial
    [self setup] ;
    [self setupDataSource] ;
    
    [XTAnimation animationPushRight:self.view] ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --
#pragma mark - parser
- (BOOL)parserResult:(ResultParsered *)result
              getNew:(BOOL)bGetNew
{
    if (bGetNew)
    {
        [m_topicList removeAllObjects] ;
        m_currentPage = 1 ;
    }
    
    //  Get topics
    NSArray *tempTopicList = nil ;
    if (self.acate.ac_id)
    {
        //话体分类
        tempTopicList = (NSArray *)result.info ;
    }
    else
    {
        //速体验, 普通
        tempTopicList = [result.info objectForKey:@"topics"] ;
    }
    
    if (!tempTopicList.count) return NO ;

    for (NSDictionary *topicDic in tempTopicList) {
        ArticleTopic *topic = [[ArticleTopic alloc] initWithDict:topicDic] ;
        [m_topicList addObject:topic] ;
    }
    
    return YES ;
}

- (BOOL)getTopicsAndCatagoriesFromServerWithPullUpDown:(BOOL)bUpDown
{
    if (bUpDown) m_currentPage = 1 ;
    
    ResultParsered *result ;
    if (self.acate.ac_id)
    { //话体分类
        result = [ServerRequest getTopicByCate:self.acate.ac_id
                                          page:m_currentPage
                                         count:SIZE_OF_PAGE] ;
    }
    else
    {
        //速体验, 普通
        int t_cate = (self.tc_topicType == type_suExperience) ? 1 : 0 ;

        result = [ServerRequest getAllTopicListAndCataWithCate:t_cate
                                                          page:m_currentPage
                                                         count:SIZE_OF_PAGE] ;
    }
    

    if (!result) {
        return NO;
    }
    
    BOOL bHas = [self parserResult:result getNew:bUpDown] ;
    
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
    return  1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [m_topicList count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString  *CellIdentiferId = @"TopicCell";
    TopicCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId] ;
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:CellIdentiferId bundle:nil] forCellReuseIdentifier:CellIdentiferId];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.topic = m_topicList[indexPath.row] ;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [XTAnimation smallBigBestInCell:cell] ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0f ;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleTopic *topic = m_topicList[indexPath.row] ;
    [HomeController jumpToTopicHomeCtrller:topic originCtrller:self] ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.tc_topicType != type_default)
    {
        UIView *backView = [[UIView alloc] init] ;
        backView.backgroundColor = nil ;
        return backView ;
    }
    
    TopicHeader *header = (TopicHeader *)[[[NSBundle mainBundle] loadNibNamed:@"TopicHeader" owner:self options:nil] lastObject] ;
    header.title = @"热门" ;
    return header ;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.tc_topicType != type_default) return NONE_HEIGHT ;

    return 34.0f ;
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

#pragma mark -- RootTableViewDelegate
- (void)loadNewData
{
    m_currentPage = 1 ;
    [self getTopicsAndCatagoriesFromServerWithPullUpDown:YES] ;
}

- (void)loadMoreData
{
    m_currentPage ++ ;
    [self getTopicsAndCatagoriesFromServerWithPullUpDown:NO] ;
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
