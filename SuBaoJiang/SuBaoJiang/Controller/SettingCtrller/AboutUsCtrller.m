//
//  AboutUsCtrller.m
//  SuBaoJiang
//
//  Created by apple on 15/6/23.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "AboutUsCtrller.h"
#import "LogoAboutCell.h"
#import "AboutCell.h"

#define LogoAboutID         @"LogoAboutCell"
#define AboutCellID         @"AboutCell"

@interface AboutUsCtrller ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;
@end

@implementation AboutUsCtrller

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.myTitle = @"关于我们页" ;
    
    
    
    _table.delegate     = self ;
    _table.dataSource   = self ;
    _table.separatorColor = COLOR_TABLE_SEP ;
    _table.backgroundColor = COLOR_BACKGROUND ;
    [self.table registerNib:[UINib nibWithNibName:LogoAboutID bundle:nil] forCellReuseIdentifier:LogoAboutID];
    [self.table registerNib:[UINib nibWithNibName:AboutCellID bundle:nil] forCellReuseIdentifier:AboutCellID] ;
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
    return 2 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1 ;
    }
    else if (section == 1)
    {
        return 2 ;
    }
    
    return 0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = (int)indexPath.section ;
    int row     = (int)indexPath.row ;
    
    if (!section)
    {
        LogoAboutCell *cell = [tableView dequeueReusableCellWithIdentifier:LogoAboutID] ;
        if (!cell)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:LogoAboutID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        return cell;
    }
    else
    {
        AboutCell *cell = [tableView dequeueReusableCellWithIdentifier:AboutCellID] ;
        if (!cell)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:AboutCellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        if (row == 0)
        {
            cell.lb.text = @"用户协议" ;
        }
        else if (row == 1)
        {
            cell.lb.text = @"功能介绍" ;
        }
        return cell;
    }
    
    return nil ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.section) {
        return 174.0f ;
    }
    return 48.0 ;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = (int)indexPath.section ;
    int row     = (int)indexPath.row ;
    
    if (!section) return ;
    
    switch (row) {
        case 0:
        {
            //用户协议
            [self performSegueWithIdentifier:@"about2agree" sender:nil] ;
        }
            break;
        case 1:
        {
            //功能介绍
            [self performSegueWithIdentifier:@"about2Intro" sender:nil] ;
        }
            break;
        default:
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *back = [[UIView alloc] init] ;
    back.backgroundColor = nil ;
    return back ;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1 ;
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
    return 1 ;
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
