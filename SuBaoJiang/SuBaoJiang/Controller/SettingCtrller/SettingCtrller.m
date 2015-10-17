//
//  SettingCtrller.m
//  SuBaoJiang
//
//  Created by apple on 15/6/23.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "SettingCtrller.h"
#import "CommonFunc.h"
#import "BindInfoCell.h"
#import "SettingKVCell.h"
#import "XTFileManager.h"
#import "SDImageCache.h"
#import "RaiseFirstCtrller.h"
#import "SIAlertView.h"
#import "NotificationCenterHeader.h"

@interface SettingCtrller ()
@property (nonatomic,copy)           NSString    *strVersion ;
//@property (nonatomic)                CGFloat     cacheNum ;
@property (weak, nonatomic) IBOutlet UITableView *table;
@end

@implementation SettingCtrller

- (NSString *)strVersion
{
    if (!_strVersion) {
        _strVersion = [CommonFunc getVersionStrOfMyAPP] ;
    }
    return _strVersion ;
}

/*
- (CGFloat)cacheNum
{
    if (_cacheNum == -1) {
        return 0 ;
    }
    
    if (!_cacheNum)
    {
        //    cache
        NSString *homePath = NSHomeDirectory() ;
        NSString *path = [homePath stringByAppendingPathComponent:PATH_IMG_CACHE] ;
        CGFloat f = [XTFileManager folderSizeAtPath3:path] ;
        _cacheNum = f / 1024.0 / 1024.0 ;
    }
    
    return _cacheNum ;
}
*/

- (void)setupTable
{
    _table.delegate = self ;
    _table.dataSource = self ;
    _table.separatorColor = COLOR_TABLE_SEP ;
    _table.backgroundColor = COLOR_BACKGROUND ;
    
    [self.table registerNib:[UINib nibWithNibName:@"BindInfoCell" bundle:nil] forCellReuseIdentifier:@"BindInfoCell"];
    [self.table registerNib:[UINib nibWithNibName:@"SettingKVCell" bundle:nil] forCellReuseIdentifier:@"SettingKVCell"] ;
}


- (void)setupExitButton
{
    if (!G_TOKEN) return ;
    
    UIButton *button = [UIButton buttonWithType:0] ;
    [button setTitle:@"退出登录" forState:UIControlStateNormal] ;
    button.backgroundColor = COLOR_MAIN ;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    [button addTarget:self action:@selector(exitLoginBtPressedAction:) forControlEvents:UIControlEventTouchUpInside] ;
    CGRect rect = CGRectZero ;
    CGFloat height = 40.0f ;
    rect.size = CGSizeMake(APPFRAME.size.width / 4 * 3, height) ;
    button.frame = rect ;
    button.center = CGPointMake(APPFRAME.size.width / 2, APPFRAME.size.height - height - NAVIGATIONBAR_HEIGHT - STATUSBAR_HEIGHT) ;
    button.layer.cornerRadius = CORNER_RADIUS_ALL ;
    [_table addSubview:button] ;
}

- (void)exitLoginBtPressedAction:(UIButton *)button
{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:nil
                                                     andMessage:WD_EXIT_CURRENT_ACCOUNT] ;
    [alertView addButtonWithTitle:WD_EXIT_YES
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              
                              // exit log
                              [CommonFunc exitLog] ;
                              // post to Notification center
                              [[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_USER_CHANGE object:nil] ;
                              // pop to index view ctrller
                              [self.navigationController popToRootViewControllerAnimated:YES] ;
                              
                          }];
    [alertView addButtonWithTitle:WD_EXIT_NO
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alertView) {
                              //NSLog(@"cancel Clicked");
                          }];
    
    alertView.positionStyle = SIALertViewPositionBottom ;
    [alertView show];

}

#pragma mark --
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myTitle = @"设置页" ;
    
    [self setupTable] ;
    [self setupExitButton] ;
//    [self cacheNum] ;
}

#pragma mark -- clearCacheClickedAction
- (void)clearCacheClickedAction
{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:nil
                                                     andMessage:WD_QUESTION_CLEAN_CACHE] ;
    [alertView addButtonWithTitle:WD_CORRECT
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              //NSLog(@"清空缓存");
                              [self performSelectorInBackground:@selector(cleanPictureCache) withObject:nil] ;
                              [XTHudManager showWordHudWithTitle:WD_CLEAN_CACHE_SUCCESS] ;
                          }];
    [alertView addButtonWithTitle:WD_CANCEL
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alertView) {
                              //NSLog(@"cancel Clicked");
                          }];

    alertView.positionStyle = SIALertViewPositionBottom ;
    [alertView show];
}

- (void)cleanPictureCache
{
    [[SDImageCache sharedImageCache] clearDisk] ;
    [[SDImageCache sharedImageCache] cleanDisk] ;
    [[SDImageCache sharedImageCache] clearMemory] ;
    
//    self.cacheNum = -1 ;
    
    [self performSelectorOnMainThread:@selector(freshTable)
                           withObject:nil
                        waitUntilDone:YES] ;
}

- (void)freshTable
{
    [_table reloadData] ;
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
    return 3 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1 ;
    }
    else if (section == 1)
    {
        return 2 ; // 检查更新, 清理缓存
    }
    else if (section == 2)
    {
        return 3 ; // 关于我们, 意见反馈, 给我们打分
    }
    
    return 0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = (int)indexPath.section ;
    int row     = (int)indexPath.row ;
    
    if (!section)
    {
        static NSString  *bindCId = @"BindInfoCell";
        BindInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:bindCId] ;
        if (!cell)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:bindCId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        return cell;
    }
    else
    {
        static NSString  *kvCid = @"SettingKVCell";
        SettingKVCell *cell = [tableView dequeueReusableCellWithIdentifier:kvCid] ;
        if (!cell)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:kvCid];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        
        if (section == 1)
        {
            if (row == 0) {
                cell.key = @"当前版本" ;
                cell.value = [NSString stringWithFormat:@"v%@",self.strVersion] ;
                cell.canBeSelected = NO ;
            } else if (row == 1) {
                cell.key = @"清理缓存" ;
//                cell.value = [NSString stringWithFormat:@"%.2fMB",self.cacheNum] ;
            }
        }
        else if (section == 2)
        {
            if (row == 0) {
                cell.key = @"关于我们" ;
            } else if (row == 1) {
                cell.key = @"意见反馈" ;
            }
            else if (row == 2) {
                cell.key = @"给我们打分" ;
            }
        }
        
        return cell;
    }

      return nil ;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40 ;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = (int)indexPath.section ;
    int row     = (int)indexPath.row ;
    
    if (section == 1) {
        if (row == 0) {
            //@"检查更新" ;
            return ;
        } else if (row == 1) {
            //@"清理缓存" ;
            [self clearCacheClickedAction] ;
        }
    }
    else if (section == 2)
    {
        if (row == 0)
        {
            //@"关于我们" ; 2
            [self performSegueWithIdentifier:@"setting2about" sender:nil] ;
        }
        else if (row == 1)
        {
            //@"意见反馈" ;
            [self performSegueWithIdentifier:@"setting2opinion" sender:nil] ;
        }
        else if (row == 2)
        {
            //@"给我们打分" ;
            [CommonFunc scoringMyApp] ;
        }
    }
}

#define HEIGHT_FLEX_HEAD_FOOT   20.0
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *back = [[UIView alloc] init] ;
    back.backgroundColor = nil ;
    
    return back ;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEIGHT_FLEX_HEAD_FOOT ;
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




#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [segue.destinationViewController setHidesBottomBarWhenPushed:YES] ;
}
*/

@end
