//
//  SaveAlbumnCtrller.m
//  subao
//
//  Created by apple on 15/8/14.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "SaveAlbumnCtrller.h"
#import "CommonFunc.h"
#import "SDImageCache.h"
#import "HorizonTable.h"


@interface SaveAlbumnCtrller () <HorizonTableDelegate>
@property (nonatomic,strong) HorizonTable       *hTable ;
@property (nonatomic,strong) UILabel            *lb_pageInfo ;
@property (nonatomic,strong) UIButton           *btFinish ;
@property (nonatomic,strong) UIButton           *btSave ;
@property (nonatomic,strong) UIImage            *currentImage ;
@end

@implementation SaveAlbumnCtrller

#pragma mark --
#pragma mark - HorizonTableDelegate <NSObject>
- (void)scrolledFinish:(NSInteger)index
{
    //    NSLog(@"index : %ld",(long)index) ;
    self.lb_pageInfo.text = [self getPageScrolledInfomation] ;
}

- (NSString *)getPageScrolledInfomation
{
    return [NSString stringWithFormat:@"%@/%@",@(self.hTable.currentIndex+1),@(self.imgUrlsList.count)] ;
}

#pragma mark --
#pragma mark - Prop
- (UIImage *)currentImage
{
    NSString *imgUrlStr = self.imgUrlsList[self.hTable.currentIndex] ;

    _currentImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imgUrlStr
                                                               withCacheWidth:APPFRAME.size.width] ;
    
    return _currentImage ;
}

- (HorizonTable *)hTable
{
    if (!_hTable)
    {
        _hTable = [[HorizonTable alloc] initWithFrame:APPFRAME
                                      andWithDataList:self.imgUrlsList] ;
        _hTable.myDelegate = self ;
        if (![_hTable superview])
        {
            [self.view addSubview:_hTable] ;
        }
        
        [self btFinish] ;
        [self btSave] ;
        [self lb_pageInfo] ;
    }
    
    return _hTable ;
}

- (UILabel *)lb_pageInfo
{
    if (!_lb_pageInfo) {
        _lb_pageInfo = [[UILabel alloc] init] ;
        _lb_pageInfo.text = [self getPageScrolledInfomation] ;
        _lb_pageInfo.textColor = [UIColor whiteColor] ;
        CGRect rectPage = CGRectZero ;
        rectPage.size = CGSizeMake(100, 30) ;
        _lb_pageInfo.textAlignment = NSTextAlignmentCenter ;
        _lb_pageInfo.frame = rectPage ;
        _lb_pageInfo.center = CGPointMake(APPFRAME.size.width / 2, 25.0) ;
        if (![_lb_pageInfo superview]) {
            [self.view addSubview:_lb_pageInfo] ;
        }
    }
    
    return _lb_pageInfo ;
}

- (UIButton *)btFinish
{
    if (!_btFinish)
    {
        _btFinish = [[UIButton alloc] init] ;
        [_btFinish setTitle:@"完成" forState:0] ;
        [_btFinish setTitleColor:[UIColor whiteColor] forState:0] ;
        _btFinish.titleLabel.font = [UIFont systemFontOfSize:15.0] ;
        _btFinish.layer.borderColor = [UIColor whiteColor].CGColor ;
        _btFinish.layer.borderWidth = 1.0f ;
        _btFinish.layer.cornerRadius = CORNER_RADIUS_ALL ;
        
        CGRect btFrame = CGRectZero ;
        btFrame.size.width = 57.0 ;
        btFrame.size.height = 29.0 ;
        btFrame.origin.x = APPFRAME.size.width - btFrame.size.width * 2 - 22.0 * 3 ;
        btFrame.origin.y = APPFRAME.size.height - 55.0 ;
        
        _btFinish.frame = btFrame ;
        
        [_btFinish addTarget:self action:@selector(finishBtPressedAction) forControlEvents:UIControlEventTouchUpInside] ;
        
        if (![_btFinish superview]) {
            [self.view addSubview:_btFinish] ;
        }
    }
    
    return _btFinish ;
}

- (UIButton *)btSave
{
    if (!_btSave)
    {
        _btSave = [[UIButton alloc] init] ;
        [_btSave setTitle:@"保存" forState:0] ;
        [_btSave setTitleColor:[UIColor whiteColor] forState:0] ;
        _btSave.layer.borderColor = [UIColor whiteColor].CGColor ;
        _btSave.layer.borderWidth = 1.0f ;
        _btSave.layer.cornerRadius = CORNER_RADIUS_ALL ;
        _btSave.titleLabel.font = [UIFont systemFontOfSize:15.0] ;
        
        CGRect btFrame = CGRectZero ;
        btFrame.size.width = 57.0 ;
        btFrame.size.height = 29.0 ;
        btFrame.origin.x = APPFRAME.size.width - btFrame.size.width * 1 - 22.0 * 1 ;
        btFrame.origin.y = APPFRAME.size.height - 55.0 ;
        
        _btSave.frame = btFrame ;
        
        [_btSave addTarget:self action:@selector(saveBtPressedAction) forControlEvents:UIControlEventTouchUpInside] ;
        
        if (![_btSave superview]) {
            [self.view addSubview:_btSave] ;
        }
    }
    
    return _btSave ;
}

- (void)setImgUrlsList:(NSArray *)imgUrlsList
{
    _imgUrlsList = imgUrlsList ;
    
    [self.hTable reloadData] ;
}

#pragma mark --
#pragma mark - Actions
- (void)finishBtPressedAction
{
    NSLog(@"finish") ;
    
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (void)saveBtPressedAction
{
    NSLog(@"save") ;
    
    [CommonFunc saveImageToLibrary:self.currentImage] ;
}


#pragma mark --
#pragma mark - Life
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myTitle = @"多图图片保存页" ;

//    [self hTable] ;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    [self.navigationController setNavigationBarHidden:YES animated:NO] ;
    [[UIApplication sharedApplication] setStatusBarHidden:YES] ;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
    
    [self.navigationController setNavigationBarHidden:NO animated:NO] ;
    [[UIApplication sharedApplication] setStatusBarHidden:NO] ;
}

- (void)didReceiveMemoryWarning
{
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
