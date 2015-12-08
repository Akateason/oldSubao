//
//  PraisedController.m
//  SuBaoJiang
//
//  Created by apple on 15/6/8.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "PraisedController.h"
#import "UserSimpleCell.h"
#import "ArticlePraise.h"
#import "UserCenterController.h"


#define SIZE_OF_PAGE    20


@interface PraisedController ()
{
    int                 m_lastPraisedID ;
    NSMutableArray      *m_praisedList ;
    
}
@property (weak, nonatomic) IBOutlet RootTableView *table;

@end

@implementation PraisedController


- (void)setup
{
    _table.delegate = self ;
    _table.dataSource = self ;
//    _table.separatorStyle = UITableViewCellSeparatorStyleNone ;
    _table.backgroundColor = COLOR_BACKGROUND ;
    _table.xt_Delegate = self ;
    _table.estimatedRowHeight = 60.0f ;
    _table.rowHeight          = UITableViewAutomaticDimension ;
    _table.separatorColor     = COLOR_TABLE_SEP ;
    _table.separatorInset     = UIEdgeInsetsMake(0, 30, 0, 0) ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myTitle = @"赞过的总数页" ;
    
    [self setup] ;
    
    m_praisedList = [NSMutableArray array] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --
#pragma mark - get from server
- (BOOL)getPraiseInfoWithPullUpOrDown:(BOOL)bUpDown
{
    if (bUpDown) {
        m_lastPraisedID = 0;
    }
    
    ResultParsered *result = [ServerRequest getPraisedInfoWithArticleID:_articleID AndWithSinceID:0 AndWithMaxID:m_lastPraisedID AndWithCount:SIZE_OF_PAGE] ;
    if (!result) {
        return NO ;
    }
    
    return [self parserResult:result getNew:bUpDown] ;
}


- (BOOL)parserResult:(ResultParsered *)result
              getNew:(BOOL)bGetNew
{
    if (bGetNew)
    {
        [m_praisedList removeAllObjects] ;
    }
    
    int praiseCount = [[result.info objectForKey:@"article_praise_count"] intValue] ;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.title = [NSString stringWithFormat:@"%d人赞过",praiseCount] ; // 点赞总数
    }) ;

    NSArray *tempArticleList = [result.info objectForKey:@"article_praise"];
    if (!tempArticleList.count) return NO ;
    for (NSDictionary *articleDic in tempArticleList)
    {
        ArticlePraise *praise = [[ArticlePraise alloc] initWithDict:articleDic] ;
        [m_praisedList addObject:praise] ;
    }
    
    m_lastPraisedID = ((ArticlePraise *)[m_praisedList lastObject]).ao_id ;
    
    return YES ;
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
    return [m_praisedList count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString  *CellIdentiferId = @"UserSimpleCell";
    UserSimpleCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId] ;
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:CellIdentiferId bundle:nil] forCellReuseIdentifier:CellIdentiferId];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.praise = m_praisedList[indexPath.row] ;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f ;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticlePraise *praise = m_praisedList[indexPath.row] ;
    
    [UserCenterController jump2UserCenterCtrller:self AndUserID:praise.user.u_id] ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *backView = [[UIView alloc] init] ;
    backView.backgroundColor = nil ;

    return backView ;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0f ;
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

#pragma mark -- RootTableViewDelegate
- (void)loadNewData
{
    [self getPraiseInfoWithPullUpOrDown:YES] ;
}

- (void)loadMoreData
{
    [self getPraiseInfoWithPullUpOrDown:NO] ;
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
