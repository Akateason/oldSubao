//
//  SelectTalkCtrller.m
//  SuBaoJiang
//
//  Created by apple on 15/6/26.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "SelectTalkCtrller.h"
#import "TopicCell.h"
#import "TopicHeader.h"
#import "ArticleTopic.h"
#import "TopicInputVIew.h"

#define SIZE_OF_PAGE    20
#define NONE_HEIGHT     1.0f

@interface SelectTalkCtrller ()<UITableViewDelegate,UITableViewDataSource,RootTableViewDelegate,TopicInputVIewDelegate>
{
    NSMutableArray *m_topicList ;
    
    BOOL           bCreateOrSelect ; // default is NO --> select , YES -- > create
    
    int            m_currentPage ;
    
    TopicHeader    *header ;
}
@property (weak, nonatomic) IBOutlet    UIView          *upView ;
@property (weak, nonatomic) IBOutlet    RootTableView   *table ;
@property (nonatomic, strong)           TopicInputVIew  *topicInputVIew ;
@property (nonatomic, strong)           NSArray         *myTopicList ;

@end

@implementation SelectTalkCtrller
@synthesize myTopicList = _myTopicList ;

- (NSArray *)myTopicList
{
    if (!_myTopicList) {
        _myTopicList = [NSArray array] ;
    }
    
    return _myTopicList ;
}

//- (void)setMyTopicList:(NSArray *)myTopicList
//{
//    _myTopicList = myTopicList ;
//}

- (TopicInputVIew *)topicInputVIew
{
    if (!_topicInputVIew)
    {
        _topicInputVIew = [[[NSBundle mainBundle] loadNibNamed:@"TopicInputVIew" owner:self options:nil] lastObject] ;
        _topicInputVIew.delegate = self ;
        if (![_topicInputVIew superview])
        {
            [self.upView addSubview:_topicInputVIew] ;
        }
    }
    return _topicInputVIew ;
}

- (void)setup
{
    _table.delegate = self ;
    _table.dataSource = self ;
    _table.backgroundColor = COLOR_BACKGROUND ;
    _table.xt_Delegate = self ;
    _table.separatorColor = COLOR_TABLE_SEP ;
    _table.separatorInset = UIEdgeInsetsMake(0, 26, 0, 0) ;
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

    self.myTitle = @"发布时话题选择页" ;
    
    [self setupDataSource] ;
    [self setup] ;
    
    [self topicInputVIew] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --
#pragma mark - parser
- (BOOL)parserResult:(ResultParsered *)result
              getNew:(BOOL)bGetNew
{
    if (bGetNew) {
        [m_topicList removeAllObjects] ;
        m_currentPage = 1 ;
    }
    
    // get topics
    NSArray *tempTopicList = [result.info objectForKey:@"topics"] ;
    if (!tempTopicList.count) return NO ;
    
    for (NSDictionary *topicDic in tempTopicList)
    {
        ArticleTopic *topic = [[ArticleTopic alloc] initWithDict:topicDic] ;
        [m_topicList addObject:topic] ;
    }
    
    return YES ;
}

- (BOOL)getTopicsAndCatagoriesFromServerWithPullUpDown:(BOOL)bUpDown
{
    m_currentPage = bUpDown ? 1 : (m_currentPage + 1) ;

    ResultParsered *result = [ServerRequest getAllTopicListAndCataWithCate:0
                                                                      page:m_currentPage
                                                                     count:SIZE_OF_PAGE] ;
    if (!result) return NO ;
    
    BOOL bHas = [self parserResult:result getNew:bUpDown] ;
    
    if (!bUpDown && !bHas) return NO ;
    
    return YES ;
}

#pragma mark -- RootTableViewDelegate
- (void)loadNewData
{
    [self getTopicsAndCatagoriesFromServerWithPullUpDown:YES] ;
}

- (void)loadMoreData
{
    [self getTopicsAndCatagoriesFromServerWithPullUpDown:NO] ;
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
    @synchronized(self.myTopicList) {
        return bCreateOrSelect ? [self.myTopicList count] : [m_topicList count] ;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentiferId = @"TopicCell";
    TopicCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId] ;
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:CellIdentiferId bundle:nil] forCellReuseIdentifier:CellIdentiferId];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    
    @synchronized(self.myTopicList) {
        cell.topic = bCreateOrSelect ? self.myTopicList[indexPath.row] : m_topicList[indexPath.row] ;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0f ;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *strTopicContent = (bCreateOrSelect) ? ((ArticleTopic *)self.myTopicList[indexPath.row]).t_content : ((ArticleTopic *)m_topicList[indexPath.row]).t_content ;

    NSLog(@"select topic : %@",strTopicContent) ;
    [self.delegate talkContentSelected:strTopicContent] ;
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!header) {
        header = (TopicHeader *)[[[NSBundle mainBundle] loadNibNamed:@"TopicHeader" owner:self options:nil] lastObject] ;
    }
    header.title = bCreateOrSelect ? @"相关" : @"热门" ;
    
    return header ;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 34.0f ;
}

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

#pragma mark -- TopicInputViewDelegate
- (void)newTopicConfirmed:(NSString *)topicStr
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(dosth:) object:topicStr] ;
    [self performSelector:@selector(dosth:) withObject:topicStr afterDelay:0.5f] ;
}

- (void)dosth:(NSString *)topicStr
{
    if (!_topicInputVIew.textfield.text.length)
    {
        bCreateOrSelect = NO ;
        self.myTopicList = @[] ;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_table reloadData] ;
        }) ;
        return ;
    }
    
    bCreateOrSelect = [_topicInputVIew.textfield.text length] ;
    
    ArticleTopic *topicCustom = [[ArticleTopic alloc] initEmptyTopicWithContent:topicStr] ;
    
    if (!bCreateOrSelect) return ;
    
    self.myTopicList = @[topicCustom] ;
    
    // Search topic list
    [ServerRequest searchTalkListWithContent:topicStr page:1 count:50 success:^(id json)
     {
         ResultParsered *result = [[ResultParsered alloc] initWithDic:json] ;
         NSArray *searchList = [ArticleTopic getTopicListWithDictList:[result.info objectForKey:@"topics"]] ;
         [self operateNewTopicList:searchList topicStr:topicStr] ;
         
     } fail:nil] ;
}

- (void)operateNewTopicList:(NSArray *)searchList
                   topicStr:(NSString *)topicStr
{
    BOOL hasSame = NO ;
    
    if ([searchList count])
    {
        for (ArticleTopic *topi in searchList) {
            if ([topi.t_content isEqualToString:topicStr])
            {
                hasSame = YES ;
                break ;
            }
        }
    }
    
    if (hasSame) {
        self.myTopicList = searchList ;
    } else {
//            [m_myTopicList addObjectsFromArray:searchList] ;
        if ([searchList count]) {
            self.myTopicList = [self.myTopicList arrayByAddingObjectsFromArray:searchList] ;
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_table reloadData] ;
    }) ;
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
