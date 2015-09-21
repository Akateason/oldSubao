//
//  UEWriteCtrller.m
//  subao
//
//  Created by TuTu on 15/9/21.
//  Copyright © 2015年 teason. All rights reserved.
//

#import "UEWriteCtrller.h"
#import "UETextViewCell.h"
#import "UESelectCell.h"
#import "NSString+Extend.h"

#define NONE_HEIGHT     1.0f  

@interface UEWriteCtrller () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;
- (void)rightBarbuttonItemOn ;
@end

@implementation UEWriteCtrller

#pragma mark --
- (void)setType:(MODE_TypeOfUserInfo)type
{
    _type = type ;
    
    switch (type)
    {
        case type_userName:
        {
            self.title = @"昵称" ;
            [self rightBarbuttonItemOn] ;
        }
            break;
        case type_sex:
        {
            self.title = @"性别" ;
        }
            break;
        case type_description:
        {
            self.title = @"简介" ;
            [self rightBarbuttonItemOn] ;
        }
            break;
        default:
            break;
    }
}



#pragma mark --
- (void)setup
{
    _table.delegate = self ;
    _table.dataSource = self ;
    _table.backgroundColor = COLOR_BACKGROUND ;
}

- (void)rightBarbuttonItemOn
{
    UIBarButtonItem *barbuttonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(finishButtonAction)] ;
    self.navigationItem.rightBarButtonItem = barbuttonItem ;
}

- (void)finishButtonAction
{
//    NSLog(@"完成了呀") ;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0] ;
    UETextViewCell *cell = (UETextViewCell *)[self.table cellForRowAtIndexPath:indexPath] ;
    NSString *resultStr = cell.textView.text ;
    resultStr = [resultStr minusReturnStr] ;
    
    switch (self.type) {
        case type_userName:
        {
            self.userInfoWillChange.u_nickname = resultStr ;
        }
            break;
        case type_description:
        {
            self.userInfoWillChange.u_description = resultStr ;
        }
            break;
        default:
            break;
    }
    
    [self.navigationController popViewControllerAnimated:YES] ;
    [self.delegate sendMyUserInfoBack:self.userInfoWillChange] ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setup] ;
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
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.type == type_sex) ? 2 : 1 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    long row = indexPath.row ;
    if (self.type == type_sex) {
        return [self useUESelectCell:row] ;
    }
    else {
        return [self useUETextViewCell] ;
    }
    
    return nil ;
}

- (UETextViewCell *)useUETextViewCell
{
    static NSString *cellIdentifier = @"UETextViewCell" ;
    UETextViewCell * cell = [_table dequeueReusableCellWithIdentifier:cellIdentifier] ;
    if (!cell)
    {
        cell = [_table dequeueReusableCellWithIdentifier:cellIdentifier] ;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    switch (self.type)
    {
        case type_userName:
        {
            cell.strPlaceHolder = @"请输入昵称" ;
            cell.maxOverFlowCount = 20 ;
            cell.textView.text = self.userInfoWillChange.u_nickname ;

        }
            break;
        case type_description:
        {
            cell.strPlaceHolder = @"请输入您的个人简介" ;
            cell.maxOverFlowCount = 250 ;
            cell.textView.text = self.userInfoWillChange.u_description ;

        }
            break;
        default:
            break;
    }
    return cell ;
}

- (UESelectCell *)useUESelectCell:(long)row
{
    static NSString *cellIdentifier = @"UESelectCell" ;
    UESelectCell *cell = [_table dequeueReusableCellWithIdentifier:cellIdentifier] ;
    if (!cell)
    {
        cell = [_table dequeueReusableCellWithIdentifier:cellIdentifier] ;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.row = row ;
//    cell.delegate = self ;
    
    return cell ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    long row = indexPath.row ;
    if (self.type == type_sex) {
        return 55.0f ;
    }
    else {
        return 200.0f ;
    }
    
    return 0.0f ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    long row = indexPath.row ;
    if (self.type == type_sex)
    {
        NSLog(@"choose row : %ld",row) ;
        self.userInfoWillChange.gender = (int)(row+1) ;
        
        [self.navigationController popViewControllerAnimated:YES] ;
        [self.delegate sendMyUserInfoBack:self.userInfoWillChange] ;
    }
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
