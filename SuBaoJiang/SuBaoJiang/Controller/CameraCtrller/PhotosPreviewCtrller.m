//
//  MultyPreviewCtrller.m
//  subao
//
//  Created by apple on 15/8/19.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "PhotosPreviewCtrller.h"
#import "MultyPicNavBar.h"
#import "MultyPicChooseBar.h"
#import "HorizonTable.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "Article.h"
#import "DraftTB.h"
#import "XTTickConvert.h"
#import "MultyEditCtrller.h"

@interface PhotosPreviewCtrller () <MultyPicNavBarDelegate,MultyPicChooseBarDelegate,HorizonTableDelegate>
//UIs
@property (nonatomic,strong)   MultyPicNavBar     *navBar ;
@property (nonatomic,strong)   MultyPicChooseBar  *choosePicBar ;
@property (nonatomic,strong)   HorizonTable       *hTable ;
//Attrs
@property (nonatomic,strong)   NSMutableArray     *choosenIndexList ; // TRUE OR FALSE , CHOOSEN OR NOT
@property (nonatomic,strong)   NSMutableArray     *resultImgList ;

@end

@implementation PhotosPreviewCtrller

#pragma mark --
#pragma mark - MultyPicNavBarDelegate
- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (void)selectPressed:(BOOL)choosen
{
    NSInteger currentPage = self.hTable.currentIndex ;

    [self.choosenIndexList replaceObjectAtIndex:currentPage withObject:@(choosen)] ;
    NSLog(@"self.choosenIndexList : %@",self.choosenIndexList) ;

    self.choosePicBar.count = [self getChoosenCount] ;
}

- (int)getChoosenCount
{
    int result = 0 ;
    for (NSNumber *number in self.choosenIndexList) if ([number intValue] > 0) result++ ;
    return result ;
}

#pragma mark --
#pragma mark - Prop
- (NSMutableArray *)resultImgList
{
    _resultImgList = [NSMutableArray array] ;
    
    int index = 0 ;
    for (NSNumber *number in self.choosenIndexList)
    {
        if ([number intValue] == 1) {
            ALAsset *asset = (ALAsset *)self.imgAssetList[index] ;
            [_resultImgList addObject:asset] ;
        }
        index++ ;
    }
    
    return _resultImgList ;
}

#pragma mark --
#pragma mark - MultyPicChooseBarDelegate
- (void)finishBtClicked
{
    NSLog(@"self.choosenIndexList : %@",self.choosenIndexList) ;
    
    if (!self.resultImgList.count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [XTHudManager showWordHudWithTitle:WD_HUD_POST_MUTI_PHOTO] ;
        }) ;
        return ;
    }
    
    [MultyEditCtrller finishedChoosePhotosWithImgList:self.resultImgList
                                         superArticle:self.articleSuper
                             bigestSubArticleClientID:self.bigestLastArticleClientID
                                             strTopic:self.topicStr
                                              ctrller:self
                                        originCtrller:self.orginCtrller] ;
}


#pragma mark --
#pragma mark - HorizonTableDelegate <NSObject>
- (void)scrolledFinish:(NSInteger)index
{
    self.navBar.isChoosen = [self currentChoosen] ;
}

- (BOOL)currentChoosen
{
    return [self.choosenIndexList[self.hTable.currentIndex] boolValue] ;
}

#pragma mark --
#pragma mark - Prop
- (void)setImgAssetList:(NSMutableArray *)imgAssetList
{
    _imgAssetList = imgAssetList ;
    
    self.choosenIndexList = [NSMutableArray array] ;
    for (int index = 0; index < imgAssetList.count; index++)
    {
        [self.choosenIndexList addObject:@(1)] ; // all set TRUE
    }
}

- (HorizonTable *)hTable
{
    if (!_hTable)
    {
        _hTable = [[HorizonTable alloc] initWithFrame:APPFRAME
                                      andWithDataList:self.imgAssetList] ;
        _hTable.myDelegate = self ;
        if (![_hTable superview])
        {
            [self.view addSubview:_hTable] ;
        }
    }
    
    return _hTable ;
}

- (MultyPicNavBar *)navBar
{
    if (!_navBar)
    {
        CGRect recNavBar = CGRectZero ;
        recNavBar.size.width = APPFRAME.size.width ;
        recNavBar.size.height = NAVIGATIONBAR_HEIGHT + STATUSBAR_HEIGHT ;
        _navBar = [[MultyPicNavBar alloc] initWithFrame:recNavBar] ;
        _navBar.delegate = self ;
        if (![_navBar superview])
        {
            [self.view addSubview:_navBar] ;
        }
    }
    
    return _navBar ;
}

- (MultyPicChooseBar *)choosePicBar
{
    if (!_choosePicBar)
    {
        CGRect barRect = CGRectZero ;
        barRect.size.width = APPFRAME.size.width ;
        barRect.size.height = 45.0f ;
        barRect.origin.y = APPFRAME.size.height - 45.0f ;
        _choosePicBar = [[MultyPicChooseBar alloc] initWithFrame:barRect] ;
        _choosePicBar.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6] ;
        _choosePicBar.delegate = self ;
        [_choosePicBar previewStyle] ;
        _choosePicBar.count = self.imgAssetList.count ;
        if (![_choosePicBar superview])
        {
            [self.view addSubview:_choosePicBar] ;
        }
    }
    
    return _choosePicBar ;
}

#pragma mark --
#pragma mark - Life
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myTitle = @"相册多图预览页" ;
    [self hTable] ;
    [self navBar] ;
    [self choosePicBar] ;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    [self.navigationController setNavigationBarHidden:YES animated:NO] ;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:0] ;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
    
    [self.navigationController setNavigationBarHidden:NO animated:NO] ;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:0] ;
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
