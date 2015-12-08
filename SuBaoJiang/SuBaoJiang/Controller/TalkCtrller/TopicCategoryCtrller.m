//
//  TopicCategoryCtrller.m
//  SuBaoJiang
//
//  Created by TuTu on 15/7/30.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "TopicCategoryCtrller.h"
#import "TopicCateCell.h" 
#import "ArticleTopic.h"
#import "Acategory.h"
#import "TopicHeader.h"
#import "TalkCtrller.h"
#import "HomeController.h"


#define NONE_HEIGHT                     1.0
#define SIZE_OF_PAGE                    20

#define IDENTIFIER_TopicCateCell        @"TopicCateCell"

@interface TopicCategoryCtrller () <RootTableViewDelegate,UITableViewDataSource,UITableViewDelegate,TopicHeaderDelegate,TopicCateCellDelegate>
{
    int m_currentPage ;
}
@property (weak, nonatomic) IBOutlet RootTableView  *table;
@property (strong, nonatomic) NSMutableArray *topicCateList ;
@end

@implementation TopicCategoryCtrller

#pragma mark - property
- (NSMutableArray *)topicCateList
{
    if (!_topicCateList) {
        _topicCateList = [NSMutableArray array] ;
    }
    
    return _topicCateList ;
}

#pragma mark - initial
- (void)setup
{
    self.myTable            = _table ;
    _table.delegate         = self ;
    _table.dataSource       = self ;
    _table.xt_Delegate     = self ;
    _table.backgroundColor  = COLOR_BACKGROUND ;
    _table.separatorStyle   = UITableViewCellSeparatorStyleNone ;
    
    [_table registerNib:[UINib nibWithNibName:IDENTIFIER_TopicCateCell bundle:nil]
 forCellReuseIdentifier:IDENTIFIER_TopicCateCell] ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myTitle = @"话题分类页" ;

    [self setup] ;
    
    [XTAnimation animationPushRight:self.view] ;

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
        [self.topicCateList removeAllObjects] ;
        m_currentPage = 1 ;
    }
    
    //Get topics
    NSArray *tempCateList = (NSArray *)result.info ;
    if (!tempCateList.count) return NO ;
    for (NSDictionary *tempDic in tempCateList)
    {
        Acategory *aCate = [[Acategory alloc] initWithDic:tempDic] ;
        [self.topicCateList addObject:aCate] ;
    }
    
    return YES ;
}

- (BOOL)getTopicsAndCatagoriesFromServerWithPullUpDown:(BOOL)bUpDown
{
    if (bUpDown) m_currentPage = 1 ;
    
    ResultParsered *result = [ServerRequest getTopicByCate:-1
                                                      page:m_currentPage
                                                     count:SIZE_OF_PAGE] ;
    if (!result) return NO;
    
    BOOL bHas = [self parserResult:result
                            getNew:bUpDown] ;
    
    if (!bUpDown && !bHas) return NO ;
    
    return YES   ;
}

#pragma mark --
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

#pragma mark --
#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.topicCateList count] ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopicCateCell * cell = [_table dequeueReusableCellWithIdentifier:IDENTIFIER_TopicCateCell] ;
    if (!cell)
    {
        cell = [_table dequeueReusableCellWithIdentifier:IDENTIFIER_TopicCateCell];
    }
    
    cell.topicList = ((Acategory *)self.topicCateList[indexPath.section]).topicList ;
    cell.delegate = self ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HeightForTopicCateCell ;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TopicHeader *header = (TopicHeader *)[[[NSBundle mainBundle] loadNibNamed:@"TopicHeader"
                                                                        owner:self
                                                                      options:nil] lastObject] ;
    header.isCateOrDefault = YES ;
    header.title = ((Acategory *)self.topicCateList[section]).ac_content ;
    header.acate = ((Acategory *)self.topicCateList[section]) ;
    header.delegate = self ;
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

#pragma mark - TopicHeaderDelegate
- (void)seeMoreButtonClicked:(Acategory *)acate
{
    // ac_id ;
    [self performSegueWithIdentifier:@"cate2topic" sender:acate] ;
}

#pragma mark - TopicCateCellDelegate
- (void)cateCellSelected:(ArticleTopic *)topic
{
    [HomeController jumpToTopicHomeCtrller:topic
                             originCtrller:self] ;
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"cate2topic"])
    {
        TalkCtrller *talkCtrller = (TalkCtrller *)[segue destinationViewController] ;
        talkCtrller.tc_topicType = type_category ;
        talkCtrller.acate = sender ;
    }
    
}


@end
