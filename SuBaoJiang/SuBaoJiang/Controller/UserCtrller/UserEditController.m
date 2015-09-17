//
//  UserEditController.m
//  subao
//
//  Created by TuTu on 15/9/16.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "UserEditController.h"
#import "UEHeadPicCell.h"
#import "UETextfieldCell.h"
#import "UEchoosenCell.h"

#define NONE_HEIGHT                     1.0

#define CELL_ID_UEHeadPicCell           @"UEHeadPicCell"
#define CELL_ID_UETextfieldCell         @"UETextfieldCell"
#define CELL_ID_UEchoosenCell           @"UEchoosenCell"

@interface UserEditController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation UserEditController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myTitle = @"编辑个人资料" ;
    
    [self setup] ;
    
}

- (void)setup
{
    _table.delegate = self ;
    _table.dataSource = self ;
    
    _table.backgroundColor = COLOR_BACKGROUND ;
    
    [self.table registerNib:[UINib nibWithNibName:CELL_ID_UEHeadPicCell bundle:nil]
     forCellReuseIdentifier:CELL_ID_UEHeadPicCell] ;
    
    [self.table registerNib:[UINib nibWithNibName:CELL_ID_UETextfieldCell bundle:nil]
     forCellReuseIdentifier:CELL_ID_UETextfieldCell] ;
    
    [self.table registerNib:[UINib nibWithNibName:CELL_ID_UEchoosenCell bundle:nil]
     forCellReuseIdentifier:CELL_ID_UEchoosenCell] ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 4 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    long row = indexPath.row ;
    
    if (row == 0) { // 头像
        return [self useUEHeadCell] ;
    }
    else if (row == 1) { // 用户名
        return [self useUETextfieldCell] ;
    }
    else if (row == 2) { // 性别
        return [self useUEchooseCell] ;
    }
    else if (row == 3) { // 简介
        return [self useUETextfieldCell] ;
    }
    
    return nil ;
}

- (UEHeadPicCell *)useUEHeadCell
{
    UEHeadPicCell * cell = [_table dequeueReusableCellWithIdentifier:CELL_ID_UEHeadPicCell] ;
    if (!cell)
    {
        cell = [_table dequeueReusableCellWithIdentifier:CELL_ID_UEHeadPicCell] ;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
//    cell.delegate = self ;
    return cell;
}

- (UETextfieldCell *)useUETextfieldCell
{
    UETextfieldCell * cell = [_table dequeueReusableCellWithIdentifier:CELL_ID_UETextfieldCell] ;
    if (!cell)
    {
        cell = [_table dequeueReusableCellWithIdentifier:CELL_ID_UETextfieldCell] ;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
//    cell.delegate = self ;
    return cell;
}

- (UEchoosenCell *)useUEchooseCell
{
    UEchoosenCell *cell = [_table dequeueReusableCellWithIdentifier:CELL_ID_UEchoosenCell] ;
    if (!cell)
    {
        cell = [_table dequeueReusableCellWithIdentifier:CELL_ID_UEchoosenCell] ;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    //    cell.delegate = self ;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    long row = indexPath.row ;
    if (row == 0) { // 头像
        return 85.0f ;
    }
    else if (row == 1) { // 用户名
        return 55.0f ;
    }
    else if (row == 2) { // 性别
        return 55.0f ;
    }
    else if (row == 3) { // 简介
        return 100.0f ;
    }
    
    return 0 ;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
