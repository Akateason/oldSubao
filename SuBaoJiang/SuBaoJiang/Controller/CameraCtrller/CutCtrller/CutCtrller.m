//
//  CutCtrller.m
//  subao
//
//  Created by apple on 15/8/5.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "CutCtrller.h"
#import "KICropImageView.h"
#import "UIImage+AddFunction.h"

@interface CutCtrller ()
{
    @private
    BOOL isReleaseSquarePicture ;
}
@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UIView *bottomBar;
@property (nonatomic,strong) KICropImageView *cropImageView;
@property (nonatomic,strong) UIImage *squareImage ;
@end

@implementation CutCtrller

#pragma mark - Prop
- (UIImage *)squareImage
{
    if (!_squareImage)
    {
//        _squareImage = [UIImage squareImageFromImage:self.imgBringIn
//                                        scaledToSize:MIN(self.imgBringIn.size.width, self.imgBringIn.size.height)] ;
        _squareImage = self.whiteSideImg ;
    }
    return _squareImage ;
}

#pragma mark - Actions
- (IBAction)cancelClickAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil] ;
}

- (IBAction)saveClickAction:(id)sender
{
    [self.delegate cuttingFinished: isReleaseSquarePicture ? self.squareImage : [_cropImageView cropImage]] ;
    [self dismissViewControllerAnimated:YES completion:nil] ;
}

- (IBAction)btCutClickAction:(id)sender
{
    UIButton *btCutting = sender ;
    btCutting.selected = !btCutting.selected ;

    isReleaseSquarePicture = btCutting.selected ;
    
    if (btCutting.selected)
    {
        // 正方
        [self refreshCrop:self.squareImage bUserInterface:NO] ;
    }
    else
    {
        // 原
        [self refreshCrop:self.imgBringIn bUserInterface:YES] ;
    }
    
    NSLog(@"isReleaseSquarePicture : %d",isReleaseSquarePicture) ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myTitle = @"裁剪页" ;
    
    [self refreshCrop:self.imgBringIn bUserInterface:YES] ;
}


- (void)refreshCrop:(UIImage *)image
     bUserInterface:(BOOL)bUserInterface
{
    [_cropImageView removeFromSuperview] ;
    _cropImageView = nil ;
    
    CGFloat sideFlex = 10.0f ;
    CGFloat length = APPFRAME.size.width - sideFlex * 2 ;
    
    CGRect cropRect = CGRectZero ;
    cropRect.origin.x = 0 ;
    cropRect.origin.y = self.topBar.frame.size.height ;
    cropRect.size.width = APPFRAME.size.width ;
    cropRect.size.height = APPFRAME.size.height - self.topBar.frame.size.height - self.bottomBar.frame.size.height ;
    
    _cropImageView = [[KICropImageView alloc] initWithFrame:cropRect] ;

    [_cropImageView setCropSize:CGSizeMake(length, length)] ;
    [_cropImageView setImage:image] ;
    [_cropImageView setUserInterfaced:bUserInterface] ;
    
    [self.view addSubview:_cropImageView] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
