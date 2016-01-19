//
//  EditPreviewCtrl.m
//  subao
//
//  Created by apple on 15/8/27.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "EditPreviewCtrl.h"
#import "DetailTitleCell.h"
#import "DtSuperCell.h"
#import "DtSubCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "HomeUserTableHeaderView.h"
#import "DigitInformation.h"


#define LINE_HEIGHT             0.0f
#define HeaderIdentifier    @"HomeUserTableHeaderView"


@interface EditPreviewCtrl () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet RootTableView *table;
@end

@implementation EditPreviewCtrl

// 发布.
- (IBAction)postBtClickedAction:(id)sender
{
    [self.delegate postMultyArticle] ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myTitle = @"多图结果预览页" ;
    
    [self setupSth] ;
    
    self.articleSuper.userCurrent = G_USER ;
}

- (void)setupSth
{
    _table.delegate = self ;
    _table.dataSource = self ;
    _table.separatorColor = COLOR_TABLE_SEP ;
    
    [_table registerNib:[UINib nibWithNibName:CellId_DetailTitleCell bundle:nil] forCellReuseIdentifier:CellId_DetailTitleCell];
    [_table registerNib:[UINib nibWithNibName:CellId_DtSuperCell bundle:nil] forCellReuseIdentifier:CellId_DtSuperCell];
    [_table registerNib:[UINib nibWithNibName:CellId_DtSubCell bundle:nil] forCellReuseIdentifier:CellId_DtSubCell];
    
    [_table registerNib:[UINib nibWithNibName:HeaderIdentifier bundle:nil] forHeaderFooterViewReuseIdentifier:HeaderIdentifier] ;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --
#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    // superArticle + childArticleList
    return 1 + self.articleSuper.childList.count ;
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

    return 0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section   = indexPath.section ;
    NSInteger row       = indexPath.row ;
    
    // SUPER ARTICLE ;
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
            return [self.articleSuper isMultyStyle] ?
            [tableView fd_heightForCellWithIdentifier:CellId_DetailTitleCell cacheByIndexPath:indexPath configuration:^(DetailTitleCell *cell) {
                [self configureDetailTitleCell:cell] ;
            }] :
            LINE_HEIGHT ;
        }
        // 2. superPic & superContent
        else if (row == 1)
        {
            return [tableView fd_heightForCellWithIdentifier:CellId_DtSuperCell cacheByIndexPath:indexPath configuration:^(DtSuperCell *cell) {
                [self configureDtSuperCell:cell] ;
            }] ;
        }
    }
    // SUB ARTICLEs ;
    else if ( (section > 0) && (section <= self.articleSuper.childList.count) )
    {
        return [tableView fd_heightForCellWithIdentifier:CellId_DtSubCell configuration:^(DtSubCell *cell) {
            [self configureDtSubCell:cell subArticle:self.articleSuper.childList[section - 1]] ;
        }] ;
    }
    
    return LINE_HEIGHT ;
}

#pragma mark - Table view delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        HomeUserTableHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifier] ;
        header.delegate = self ;
        header.article = self.articleSuper ;
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

static NSString * const CellId_DetailTitleCell = @"DetailTitleCell";
- (DetailTitleCell *)getDetailTitleCell
{
    DetailTitleCell * cell = [_table dequeueReusableCellWithIdentifier:CellId_DetailTitleCell] ;
    if (!cell) {
        cell = [_table dequeueReusableCellWithIdentifier:CellId_DetailTitleCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    [self configureDetailTitleCell:cell] ;
    return cell ;
}

- (void)configureDetailTitleCell:(DetailTitleCell *)cell
{
    cell.fd_enforceFrameLayout = YES ;
    cell.article = self.articleSuper ;
}

static NSString * const CellId_DtSuperCell = @"DtSuperCell";
- (DtSuperCell *)getDtSuperCell
{
    DtSuperCell * cell = [_table dequeueReusableCellWithIdentifier:CellId_DtSuperCell] ;
    if (!cell) {
        cell = [_table dequeueReusableCellWithIdentifier:CellId_DtSuperCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    [self configureDtSuperCell:cell] ;
    cell.isflywordShow = NO ;
    return cell ;
}

- (void)configureDtSuperCell:(DtSuperCell *)cell
{
    cell.fd_enforceFrameLayout = YES ;
    cell.article = self.articleSuper ;
}

static NSString * const CellId_DtSubCell = @"DtSubCell";
- (DtSubCell *)getDtSubCell:(Article *)subArticle
{
    DtSubCell * cell = [_table dequeueReusableCellWithIdentifier:CellId_DtSubCell] ;
    if (!cell)
    {
        cell = [_table dequeueReusableCellWithIdentifier:CellId_DtSubCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    [self configureDtSubCell:cell subArticle:subArticle] ;
    cell.isflywordShow = NO ;
    return cell ;
}

- (void)configureDtSubCell:(DtSubCell *)cell subArticle:(Article *)subArticle
{
    cell.fd_enforceFrameLayout = YES ;
    cell.subArticle = subArticle ;
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
