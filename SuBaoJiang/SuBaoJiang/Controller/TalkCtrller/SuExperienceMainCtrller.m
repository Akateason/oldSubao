//
//  SuExperienceMainCtrller.m
//  SuBaoJiang
//
//  Created by apple on 15/7/28.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "SuExperienceMainCtrller.h"
#import "SEMchooseCell.h"
#import "SEcontainerCell.h"
#import "ArticleTopic.h"
#import "TalkCtrller.h"
#import "TopicCategoryCtrller.h"
#import "HomeController.h"

#define NONE_HEIGHT                     1.0
#define SIZE_OF_PAGE                    50

#define SEMChoose_HEIGHT                63.0

#define IDENTIFIER_SEMCHOOSECELL        @"SEMchooseCell"
#define IDENTIFIER_SEMCONTAINERCELL     @"SEcontainerCell"

@interface SuExperienceMainCtrller () <RootTableViewDelegate,UITableViewDataSource,UITableViewDelegate,SEcontainerCellDelegate,SEMchooseCellDelegate>
{
    int m_currentPage ;
}
@property (weak, nonatomic) IBOutlet    RootTableView   *table;
@property (copy, nonatomic)             NSMutableArray  *topicList ;
@end

@implementation SuExperienceMainCtrller

#pragma mark - property
- (NSMutableArray *)topicList
{
    if (!_topicList) {
        _topicList = [NSMutableArray array] ;
    }
    
    return _topicList ;
}

#pragma mark - initial
- (void)setup
{
    self.myTable            = _table ;
    _table.delegate         = self ;
    _table.dataSource       = self ;
    _table.xt_Delegate     = self ;
    _table.backgroundColor  = COLOR_BACKGROUND ;
    _table.separatorColor   = COLOR_TABLE_SEP ;
    
    [_table registerNib:[UINib nibWithNibName:IDENTIFIER_SEMCHOOSECELL bundle:nil]
 forCellReuseIdentifier:IDENTIFIER_SEMCHOOSECELL] ;
    [_table registerNib:[UINib nibWithNibName:IDENTIFIER_SEMCONTAINERCELL bundle:nil]
 forCellReuseIdentifier:IDENTIFIER_SEMCONTAINERCELL] ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self setup] ;
    
    self.myTitle = @"速体验首页" ;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        SEMchooseCell *scell = (SEMchooseCell *)[self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] ;
        [scell animationForIcon] ;
    }) ;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated] ;
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
    if (bGetNew) {
        [self.topicList removeAllObjects] ;
        m_currentPage = 1 ;
    }
    
    //Get topics
    NSArray *tempTopicList = [result.info objectForKey:@"topics"] ;
    if (!tempTopicList.count) return NO ;
    
    for (NSDictionary *topicDic in tempTopicList) {
        ArticleTopic *topic = [[ArticleTopic alloc] initWithDict:topicDic] ;
        [self.topicList addObject:topic] ;
    }
    
    return YES ;
}

- (BOOL)getTopicsAndCatagoriesFromServerWithPullUpDown:(BOOL)bUpDown
{
    if (bUpDown) m_currentPage = 1 ;
    
    ResultParsered *result = [ServerRequest getAllTopicListAndCataWithCate:0
                                                                      page:m_currentPage
                                                                     count:SIZE_OF_PAGE] ;
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
    return  2 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (!indexPath.section) ? [self semChooseCell] : [self seContainerCell] ;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
//        SEMchooseCell *scell = (SEMchooseCell *)cell ;
//        [scell animationForIcon] ;
//    }
}

- (SEMchooseCell *)semChooseCell
{
    SEMchooseCell * cell = [_table dequeueReusableCellWithIdentifier:IDENTIFIER_SEMCHOOSECELL] ;
    if (!cell)
    {
        cell = [_table dequeueReusableCellWithIdentifier:IDENTIFIER_SEMCHOOSECELL];
    }
    cell.delegate = self ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    
    return cell;
}

- (SEcontainerCell *)seContainerCell
{
    SEcontainerCell *cell = [_table dequeueReusableCellWithIdentifier:IDENTIFIER_SEMCONTAINERCELL] ;
    if (!cell)
    {
        cell = [_table dequeueReusableCellWithIdentifier:IDENTIFIER_SEMCONTAINERCELL];
    }
    cell.topicList = self.topicList ;
    cell.delegate = self ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.section) return SEMChoose_HEIGHT ;

    return [SEcontainerCell calculateHeightWithTopicList:self.topicList] ;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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


#pragma mark - SEMchooseCellDelegate
/*
 * @param : buttonIndex 0-->速体验合计,1-->话题分类
**/
- (void)clickChooseButtonIndex:(int)buttonIndex
{
    if (buttonIndex == 0) {
        // 速体验合集
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
        TalkCtrller *talkCtrl = [story instantiateViewControllerWithIdentifier:@"TalkCtrller"] ;
        talkCtrl.tc_topicType = type_suExperience ;
        [talkCtrl setHidesBottomBarWhenPushed:YES] ;
        [self.navigationController pushViewController:talkCtrl
                                             animated:NO] ;
    } else {
        // 话题分类
//        [self performSegueWithIdentifier:@"sem2topicCate" sender:nil] ;
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
        TopicCategoryCtrller *topicCateCtrl = [story instantiateViewControllerWithIdentifier:@"TopicCategoryCtrller"] ;
        [topicCateCtrl setHidesBottomBarWhenPushed:YES] ;
        [self.navigationController pushViewController:topicCateCtrl
                                             animated:NO] ;
    }
}


#pragma mark - SEcontainerCellDelegate
- (void)clickTopicInTheContainer:(ArticleTopic *)topic
{
    [HomeController jumpToTopicHomeCtrller:topic
                             originCtrller:self] ;
}

/*
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"suExMain2topic"])
    {
        // 速体验合集
        TalkCtrller *talkCtrller = (TalkCtrller *)[segue destinationViewController] ;
        talkCtrller.tc_topicType = type_suExperience ;
    }
    
    [segue.destinationViewController setHidesBottomBarWhenPushed:YES] ;
}
*/

@end
