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
#import "SuBaoHeaderView.h"

#define LINE_HEIGHT             0.0f

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
            return [self.articleSuper isMultyStyle] ? [DetailTitleCell calculateHeight:self.articleSuper] : LINE_HEIGHT ;
        }
        // 2. superPic & superContent
        else if (row == 1)
        {
            return [DtSuperCell calculateHeight:self.articleSuper] ;
        }
    }
    // SUB ARTICLEs
    else if ( (section > 0) && (section <= self.articleSuper.childList.count) )
    {
        return [DtSubCell calculateHeightWithArticle:self.articleSuper.childList[section - 1]] ;
    }
    
    return LINE_HEIGHT ;
}

#pragma mark - Table view delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        SuBaoHeaderView *header = (SuBaoHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"SuBaoHeaderView" owner:self options:nil] lastObject] ;
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

- (DetailTitleCell *)getDetailTitleCell
{
    static  NSString  *CellIdentiferId = @"DetailTitleCell";
    DetailTitleCell * cell = [_table dequeueReusableCellWithIdentifier:CellIdentiferId] ;
    if (!cell)
    {
        [_table registerNib:[UINib nibWithNibName:CellIdentiferId bundle:nil] forCellReuseIdentifier:CellIdentiferId];
        cell = [_table dequeueReusableCellWithIdentifier:CellIdentiferId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.article = self.articleSuper ;
    return cell ;
}

- (DtSuperCell *)getDtSuperCell
{
    static  NSString  *CellIdentiferId = @"DtSuperCell";
    DtSuperCell * cell = [_table dequeueReusableCellWithIdentifier:CellIdentiferId] ;
    if (!cell)
    {
        [_table registerNib:[UINib nibWithNibName:CellIdentiferId bundle:nil] forCellReuseIdentifier:CellIdentiferId];
        cell = [_table dequeueReusableCellWithIdentifier:CellIdentiferId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.article = self.articleSuper ;
    cell.isflywordShow = NO ;
    return cell ;
}

- (DtSubCell *)getDtSubCell:(Article *)subArticle
{
    static  NSString  *CellIdentiferId = @"DtSubCell";
    DtSubCell * cell = [_table dequeueReusableCellWithIdentifier:CellIdentiferId] ;
    if (!cell)
    {
        [_table registerNib:[UINib nibWithNibName:CellIdentiferId bundle:nil] forCellReuseIdentifier:CellIdentiferId];
        cell = [_table dequeueReusableCellWithIdentifier:CellIdentiferId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.subArticle = subArticle ;
    cell.isflywordShow = NO ;
    return cell ;
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
