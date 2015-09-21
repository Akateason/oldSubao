//
//  UserEditController.m
//  subao
//
//  Created by TuTu on 15/9/16.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "UserEditController.h"
#import "UEHeadPicCell.h"
#import "UEKeyValCell.h"
#import "User.h"
#import "SDImageCache.h"
#import "SDWebImageDownloader.h"
#import "UEWriteCtrller.h"
#import "SIAlertView.h"
#import "PicWillUpload.h"
#import "XTTickConvert.h"
#import "NotificationCenterHeader.h"

#define NONE_HEIGHT                     1.0

#define CELL_ID_UEHeadPicCell           @"UEHeadPicCell"
#define CELL_ID_UEKeyValCell            @"UEKeyValCell"

@interface UserEditController () <UITableViewDataSource,UITableViewDelegate,UEWriteCtrllerDelegate>
@property (nonatomic,strong) User *userOwner ;
@property (nonatomic,strong) UIImage *originUserHeadPic ;
@property (weak, nonatomic) IBOutlet UITableView *table;
@end

@implementation UserEditController

@synthesize userOwner = _userOwner , originUserHeadPic = _originUserHeadPic ;

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [self.userOwner addObserver:self forKeyPath:@"u_headpic" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil] ;
        [self.userOwner addObserver:self forKeyPath:@"u_nickname" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil] ;
        [self.userOwner addObserver:self forKeyPath:@"u_description" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil] ;
        [self.userOwner addObserver:self forKeyPath:@"gender" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil] ;
        
    }
    return self;
}

- (void)dealloc
{
    [self.userOwner removeObserver:self forKeyPath:@"u_headpic" context:nil] ;
    [self.userOwner removeObserver:self forKeyPath:@"u_nickname" context:nil] ;
    [self.userOwner removeObserver:self forKeyPath:@"u_description" context:nil] ;
    [self.userOwner removeObserver:self forKeyPath:@"gender" context:nil] ;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"u_headpic"] || [keyPath isEqualToString:@"u_nickname"] || [keyPath isEqualToString:@"u_description"] || [keyPath isEqualToString:@"gender"])
    {
        // 输出改变前的值
        NSLog(@"old is %@",[change objectForKey:@"old"]);
        // 输出改变后的值
        NSLog(@"new is %@",[change objectForKey:@"new"]);
        
        [self updateUserToServer] ;
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context] ;
    }
}

- (void)updateUserToServer
{
    NSLog(@"update user info") ;
    
    [ServerRequest updateUserInfo:self.userOwner success:^(id json) {
        NSLog(@"json : %@",json) ;
    } fail:^{
        NSLog(@"fail ?!") ;
    }] ;
    
    G_USER =  self.userOwner ;
    [[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICAITON_FRESH_USER object:nil] ;
}

#pragma mark --
#pragma mark -
- (User *)userOwner
{
    if (!_userOwner) {
        _userOwner = G_USER ;
    }
    
    return _userOwner ;
}

- (void)setOriginUserHeadPic:(UIImage *)originUserHeadPic
{
    _originUserHeadPic = originUserHeadPic ;
    
    PicWillUpload *pic = [[PicWillUpload alloc] initNewWithUserID:self.userOwner.u_id tick:[XTTickConvert getTickWithDate:[NSDate date]]] ;
    self.userOwner.u_headpic = [pic qiNiuPath] ;
    [pic cachePic:originUserHeadPic] ;
}

- (UIImage *)originUserHeadPic
{
    if (!_originUserHeadPic) {
        _originUserHeadPic = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.userOwner.u_headpic
                                                                        withCacheWidth:54.0f] ;
    }
    
    return _originUserHeadPic ;
}

#pragma mark --
#pragma mark - UEWriteCtrllerDelegate
- (void)sendMyUserInfoBack:(User *)userInfo
{
    self.userOwner = userInfo ; //  update server or not depends on User's KVO valueChanged or not .
    
    [self.table reloadData] ;
}

#pragma mark --
#pragma mark -
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
    
    [self.table registerNib:[UINib nibWithNibName:CELL_ID_UEKeyValCell bundle:nil]
     forCellReuseIdentifier:CELL_ID_UEKeyValCell] ;
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
        return [self useUEchooseCellWithKey:@"昵称" val:self.userOwner.u_nickname] ;
    }
    else if (row == 2) { // 性别
        return [self useUEchooseCellWithKey:@"性别" val:[self.userOwner getUserSex]] ;
    }
    else if (row == 3) { // 简介
        return [self useUEchooseCellWithKey:@"简介" val:self.userOwner.u_description] ;
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
    cell.picHead = self.originUserHeadPic ;
//    cell.delegate = self ;
    return cell ;
}

- (UEKeyValCell *)useUEchooseCellWithKey:(NSString *)key val:(NSString *)value
{
    UEKeyValCell *cell = [_table dequeueReusableCellWithIdentifier:CELL_ID_UEKeyValCell] ;
    if (!cell)
    {
        cell = [_table dequeueReusableCellWithIdentifier:CELL_ID_UEKeyValCell] ;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.strKey = key ;
    cell.strVal = value ;
    return cell ;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    long row = indexPath.row ;
    if (row == 0) { // 头像
        [self CameraActionPressed] ;
    }
    else if (row == 1) { // 用户名
        [self performSegueWithIdentifier:@"userInfoEdit2userEditWrite" sender:@(type_userName)] ;
    }
    else if (row == 2) { // 性别
        [self performSegueWithIdentifier:@"userInfoEdit2userEditWrite" sender:@(type_sex)] ;
    }
    else if (row == 3) { // 简介
        [self performSegueWithIdentifier:@"userInfoEdit2userEditWrite" sender:@(type_description)] ;
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


#pragma mark --
#pragma mark - CameraActionPressed
- (void)CameraActionPressed
{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:nil andMessage:nil] ;
    [alertView addButtonWithTitle:@"取消" type:SIAlertViewButtonTypeDestructive handler:nil] ;
    [alertView addButtonWithTitle:@"拍照" type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alertView){
        [self startCameraControllerFromViewController:self
                                        usingDelegate:self];
    }] ;
    [alertView addButtonWithTitle:@"本地相册" type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alertView){
        [self startAlbum] ;
    }] ;
    alertView.positionStyle = SIALertViewPositionBottom ;
    [alertView show] ;
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate
{
    // here, check the device is available  or not
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)|| (controller == nil)) return NO;
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = YES;
    cameraUI.delegate = delegate;
    [controller presentViewController:cameraUI animated:YES completion:^{}];
    
    return YES;
}
- (void)startAlbum
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}

#pragma mark --
#pragma mark - imagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.originUserHeadPic = [info objectForKey: @"UIImagePickerControllerEditedImage"];
    //UIImagePickerControllerOriginalImage
    //UIImagePickerControllerEditedImage
    //m_imageNeedsToDisplay = [UIImage fixOrientation:m_imageNeedsToDisplay];
    
    UEHeadPicCell *headcell = (UEHeadPicCell *)[self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] ;
    headcell.picHead = self.originUserHeadPic;
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"head geted") ;
    }];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"userInfoEdit2userEditWrite"])
    {
        UEWriteCtrller *writeCtrller = (UEWriteCtrller *)[segue destinationViewController] ;
        writeCtrller.type = [sender integerValue] ;
        writeCtrller.userInfoWillChange = self.userOwner ;
        writeCtrller.delegate = self ;
    }
}


@end
