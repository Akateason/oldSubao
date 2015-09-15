//
//  CameraGroupCtrller.m
//  SuBaoJiang
//
//  Created by apple on 15/7/15.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "CameraGroupCtrller.h"
#import "CameraGroupCell.h"

#define CAMERAGROUP_CID        @"CameraGroupCell"
#define LINE_HEIGHT            1.0f

@interface CameraGroupCtrller () <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray  *m_listGroup ;
}
@property (weak, nonatomic) IBOutlet UITableView *table ;
@end

@implementation CameraGroupCtrller

#pragma mark -- setup
- (void)setupTable
{
    m_listGroup = [[NSMutableArray alloc] initWithCapacity:1] ;
    
    [_table registerNib:[UINib nibWithNibName:CAMERAGROUP_CID bundle:nil] forCellReuseIdentifier:CAMERAGROUP_CID] ;
    
    _table.delegate = self ;
    _table.dataSource = self ;
    _table.separatorColor = COLOR_TABLE_SEP ;
}

- (void)setupGroups
{
    // enumerate groups
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop)
     {
         if (!group) return ;

         [m_listGroup addObject:group] ;
         [_table reloadData] ;
         
     } failureBlock:^(NSError *error) {
         NSLog(@"Enumerate the asset groups failed.");
         [_table reloadData] ;
     }] ;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myTitle = @"我的相簿页" ;
    
    [self setupTable] ;
    [self setupGroups] ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --
#pragma mark - ios8 table view seperator line full screen
- (void)viewDidLayoutSubviews
{
    if ([self.table respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.table setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.table respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.table setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark --
#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_listGroup count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CameraGroupCell * cell = [tableView dequeueReusableCellWithIdentifier:CAMERAGROUP_CID] ;
    if (!cell)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CAMERAGROUP_CID] ;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.group = m_listGroup[indexPath.row] ;
    return cell ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78.0f ;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController popViewControllerAnimated:YES] ;
    [self.delegate selectAlbumnGroup:m_listGroup[indexPath.row]] ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *clearView = [[UIView alloc] init] ;
    clearView.backgroundColor = nil ;
    return clearView ;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return LINE_HEIGHT ;
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
    return LINE_HEIGHT ;
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
