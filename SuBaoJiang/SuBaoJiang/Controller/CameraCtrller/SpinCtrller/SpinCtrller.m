//
//  SpinCtrller.m
//  subao
//
//  Created by apple on 15/8/5.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "SpinCtrller.h"
#import "UIImage+AddFunction.h"

@interface SpinCtrller ()
{
    int     spinCount  ;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UIView *bottomBar;
@end

@implementation SpinCtrller

- (IBAction)cancelButtonClickedAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil] ;
}

- (IBAction)saveButtonClickedAction:(id)sender
{
    [self.delegate spinFinished:_imgView.image] ;
    [self dismissViewControllerAnimated:YES completion:nil] ;
}

- (IBAction)spinAction:(id)sender
{
    spinCount++ ;
    
    _imgView.image = [UIImage image:_imgView.image
                       rotation:UIImageOrientationRight] ;
    
    [XTAnimation animationEaseIn:_imgView] ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myTitle = @"旋转页" ;
    
    self.imgView.image = self.imgBringIn ;
    
    [self setup] ;
}

- (void)setup
{
    // img get
//    _imgView.backgroundColor = [UIColor whiteColor] ;
    _imgView.image = self.imgBringIn ;
    
    // image content mode
    _imgView.contentMode = UIViewContentModeScaleAspectFit ;
    
    // image rect
    _imgView.translatesAutoresizingMaskIntoConstraints = YES ;
    
    CGFloat sideFlex = 10.0f ;
    CGRect rectImage = CGRectZero ;
    CGFloat length = APPFRAME.size.width - sideFlex * 2 ;
    rectImage.size = CGSizeMake(length, length) ;
    _imgView.frame = rectImage ;
    CGFloat y = (APPFRAME.size.height - self.bottomBar.frame.size.height - self.topBar.frame.size.height) / 2.0 ;
    _imgView.center = CGPointMake(APPFRAME.size.width / 2.0 , y + self.topBar.frame.size.height) ;
    // NSLog(@"_img frame : %@",NSStringFromCGRect(_img.frame)) ;
    
    // bg color
    self.view.backgroundColor = COLOR_IMG_EDITOR_BG ;
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
