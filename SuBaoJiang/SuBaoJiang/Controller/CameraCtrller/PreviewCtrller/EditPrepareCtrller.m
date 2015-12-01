//
//  CuttingCtrller.m
//  subao
//
//  Created by apple on 15/8/4.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "EditPrepareCtrller.h"
#import <PhotoEditFramework/PhotoEditFramework.h>
#import "UIImage+AddFunction.h"
#import "SpinCtrller.h"
#import "CutCtrller.h"
#import "PasterCtrller.h"
#import "PostSubaoCtrller.h"

@interface EditPrepareCtrller () <SpinCtrllerDelegate,CutCtrllerDelegate,PasterCtrllerDelegate>
//UIs
@property (strong, nonatomic) UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIView *bottomBar;
@property (weak, nonatomic) IBOutlet UIView *topBar;
//Attrs
@property (nonatomic,strong) UIImage *currentImageCache ;
@property (nonatomic,strong) UIImage *whiteSideImageCache ;
@end

@implementation EditPrepareCtrller

@synthesize currentImageCache = _currentImageCache ;

#pragma mark --
#pragma mark - Public
+ (void)jump2EditPrepareCtrllerFromCtrller:(UIViewController *)ctrller
                                  AndImage:(UIImage *)imageResource
                                 isEditing:(BOOL)isEdit
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
    EditPrepareCtrller *editCtrller = [story instantiateViewControllerWithIdentifier:@"EditPrepareCtrller"] ;
    editCtrller.imgSend = imageResource ;
    editCtrller.isEditingPicture = isEdit ;
    editCtrller.delegate = (id <EditPrepareCtrllerDelegate>)ctrller ;
    [ctrller.navigationController pushViewController:editCtrller animated:YES] ;
}

#pragma mark --
#pragma mark - delegate 
#pragma mark - SpinCtrllerDelegate
- (void)spinFinished:(UIImage *)imageFinished
{
    self.currentImageCache = imageFinished ;
}

#pragma mark - CutCtrllerDelegate
- (void)cuttingFinished:(UIImage *)imageFinished
{
    self.currentImageCache = imageFinished ;
}

#pragma mark - PasterCtrllerDelegate
- (void)pasterAddFinished:(UIImage *)imageFinished
{
    self.currentImageCache = imageFinished ;
}

#pragma mark --
#pragma mark - Properties
- (void)setImgSend:(UIImage *)imgSend
{
    _imgSend = imgSend ;
//    _imgSend = [imgSend imageCompressForSize:imgSend targetSize:CGSizeMake(640, 640)] ;
}

- (UIImageView *)imgView
{
    if (!_imgView)
    {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectZero] ;
        _imgView.image = self.imgSend ;
        
        if (![_imgView superview])
        {
            [self.view addSubview:_imgView] ;
        }
    }
    
    return _imgView ;
}

- (void)setCurrentImageCache:(UIImage *)currentImageCache
{
    _currentImageCache = currentImageCache ;
    
    self.imgView.image = currentImageCache ;
}

- (UIImage *)currentImageCache
{
    if (!_currentImageCache) {
        _currentImageCache = self.imgSend ;
    }
    
    return _currentImageCache ;
}

- (UIImage *)whiteSideImageCache
{
    _whiteSideImageCache = [UIImage getImageFromView:self.imgView] ;
    
    return _whiteSideImageCache ;
}

#pragma mark - Actions
- (IBAction)btCancelClickAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)btNextStepAction:(id)sender
{
    NSLog(@" finished edition for picture ") ;
//    UIImage *resultImage = self.currentImageCache ;
    UIImage *resultImage = self.whiteSideImageCache ;
    
    // 完成 .
    if (!self.isEditingPicture)
    {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
        PostSubaoCtrller *postCtrller = [story instantiateViewControllerWithIdentifier:@"PostSubaoCtrller"] ;
        postCtrller.topicString = self.topicStr ;
        postCtrller.imageSend = resultImage ;
        [self.navigationController pushViewController:postCtrller animated:YES] ;
    }
    else
    {
        [self.delegate editFinishCallBackWithImage:resultImage] ;
        [self.navigationController popViewControllerAnimated:YES] ;
    }
}

- (IBAction)btSpinAction:(id)sender
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
    SpinCtrller *spinCtrller = [story instantiateViewControllerWithIdentifier:@"SpinCtrller"] ;
    spinCtrller.delegate = self ;
    spinCtrller.imgBringIn = self.currentImageCache ;
    [self presentViewController:spinCtrller animated:YES completion:nil] ;
}

- (IBAction)btCuttingAction:(id)sender
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
    CutCtrller *cutCtrller = [story instantiateViewControllerWithIdentifier:@"CutCtrller"] ;
    cutCtrller.delegate = self ;
    cutCtrller.imgBringIn = self.currentImageCache ;
    cutCtrller.whiteSideImg = self.whiteSideImageCache ;
    [self presentViewController:cutCtrller animated:YES completion:nil] ;
}

- (IBAction)filterAction:(id)sender
{
    UIImage *resultImage = self.whiteSideImageCache ; // self.currentImageCache ;
    [self pPushPGEditSDKControllerWithImage:resultImage] ;
}

- (IBAction)pasterAction:(id)sender
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
    PasterCtrller *pasterCtrller = [story instantiateViewControllerWithIdentifier:@"PasterCtrller"] ;
    pasterCtrller.delegate = self ;
    pasterCtrller.imageWillHandle = self.currentImageCache ;
    [self presentViewController:pasterCtrller animated:YES completion:nil] ;
}

#pragma mark --
#pragma mark - camera360 sdk
- (void)pPushPGEditSDKControllerWithImage:(UIImage *)originalSizeImage
{
    pg_edit_sdk_controller *editCtl = nil ;
    {
        //构建编辑对象    Construct edit target
        pg_edit_sdk_controller_object *obje = [[pg_edit_sdk_controller_object alloc] init] ;
        {
            //输入原图  Input original
            obje.pCSA_fullImage = originalSizeImage ;
        }
        editCtl = [[pg_edit_sdk_controller alloc] initWithEditObject:obje
                                                        withDelegate:self] ;
        
    }
    NSAssert(editCtl, @"Error");
    if (editCtl)
    {
        [self presentViewController:editCtl animated:YES completion:^{}] ;
    }
}

- (void)dgPhotoEditingViewControllerDidCancel:(UIViewController *)pController
                          withClickSaveButton:(BOOL)isClickSaveBtn
{
    [self dismissViewControllerAnimated:YES completion:^{}] ;
}

- (void)dgPhotoEditingViewControllerDidFinish:(UIViewController *)pController
                                       object:(pg_edit_sdk_controller_object *)pOjbect
{
    //获取效果小图    Obtain effect thumbnail
    UIImage *image = [UIImage imageWithData:pOjbect.pOutEffectDisplayData];
    NSAssert(image, @" ") ;
    
    //获取效果大图    Obtain effect large image
    UIImage *imageOri = [UIImage imageWithData:pOjbect.pOutEffectOriData] ;
    NSAssert(imageOri, @" ") ;
    self.currentImageCache = imageOri ;
    
    [self dismissViewControllerAnimated:YES completion:^{}] ;
}

- (void)dgPhotoEditingViewControllerShowLoadingView:(UIView *)view
{
    [YXSpritesLoadingView showWithText:@"" andShimmering:NO andBlurEffect:NO] ;
}

- (void)dgPhotoEditingViewControllerHideLoadingView:(UIView *)view
{
    [YXSpritesLoadingView dismiss] ;
}

#pragma mark - Life
- (void)setup
{
    CGFloat sideFlex = 10.0f ;
    CGRect rectImage = CGRectZero ;
    CGFloat length = APPFRAME.size.width - sideFlex * 2 ;
    rectImage.size = CGSizeMake(length, length) ;
    self.imgView.frame = rectImage ;
    CGFloat y = (APPFRAME.size.height - self.bottomBar.frame.size.height - self.topBar.frame.size.height) / 2.0 ;
    self.imgView.center = CGPointMake(APPFRAME.size.width / 2.0 , y + self.topBar.frame.size.height) ;

    // img get
    self.imgView.backgroundColor = [UIColor whiteColor] ;
    // image content mode
    self.imgView.contentMode = UIViewContentModeScaleAspectFit ;
    // bg color
    self.view.backgroundColor = COLOR_IMG_EDITOR_BG ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myTitle = @"图片编辑首页" ;
    
    // setup
    [self setup] ;
    
    // middle line
    CGFloat width_bt = APPFRAME.size.width / 4.0 ;
    for (int i = 0; i < 3; i++) {
        UIView *line = [[UIView alloc] init] ;
        line.backgroundColor = COLOR_IMG_EDITOR_BG ;
        line.frame = CGRectMake(width_bt * (i + 1), 0.0, 1.0, _bottomBar.frame.size.height) ;
        [_bottomBar addSubview:line] ;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    [self.navigationController setNavigationBarHidden:YES animated:NO] ;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:0] ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
