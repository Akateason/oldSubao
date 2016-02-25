//
//  PasterCtrller.m
//  subao
//
//  Created by apple on 15/8/5.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "PasterCtrller.h"
#import "XTPasterStageView.h"
#import "XTPasterView.h"
#import "PasterManagement.h"
#import "SDImageCache.h"
#import "PasterChooseCollectionCell.h"

static NSString *kPasterChooseCollectionCellName  = @"PasterChooseCollectionCell" ;

@interface PasterCtrller () <UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

// UIs
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewPasters ;
@property (strong, nonatomic)        XTPasterStageView *stageView ;
@property (weak, nonatomic) IBOutlet UIView            *topBar ;
// Attrs
@property (nonatomic,copy)           NSArray           *pasterList ;

@end

@implementation PasterCtrller

#pragma mark - Property
- (NSArray *)pasterList
{
    if (!_pasterList) {
        _pasterList = [[PasterManagement shareInstance] allPastersList] ;
    }
    return _pasterList ;
}

#pragma mark - Actions
- (IBAction)backButtonClickedAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil] ;
}

- (IBAction)nextButtonClickedAction:(id)sender
{
    UIImage *imgResult = [_stageView doneEdit] ;
    [self.delegate pasterAddFinished:imgResult] ;
    [self dismissViewControllerAnimated:YES completion:nil] ;
}

#pragma mark - Life cycle
- (void)setup
{
    CGFloat sideFlex = 10.0f ;
    CGRect rectImage = CGRectZero ;
    CGFloat length = APPFRAME.size.width - sideFlex * 2 ;
    rectImage.size = CGSizeMake(length, length) ;
    CGFloat y = (APPFRAME.size.height - self.collectionViewPasters.frame.size.height - length) ;
    rectImage.origin.x = sideFlex ;
    rectImage.origin.y = y ;
    
    _stageView = [[XTPasterStageView alloc] initWithFrame:rectImage] ;
    _stageView.originImage = self.imageWillHandle ;
    _stageView.backgroundColor = [UIColor whiteColor] ;
    [self.view addSubview:_stageView] ;
    
    self.view.backgroundColor = COLOR_IMG_EDITOR_BG ;
    
    [self.view bringSubviewToFront:self.topBar] ;
}

- (void)dealloc
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myTitle = @"贴纸页" ;
    [self setup] ;
    
    UINib *nib = [UINib nibWithNibName:kPasterChooseCollectionCellName bundle: [NSBundle mainBundle]];
    [_collectionViewPasters registerNib:nib forCellWithReuseIdentifier:kPasterChooseCollectionCellName];
    
    self.collectionViewPasters.dataSource = self ;
    self.collectionViewPasters.delegate = self ;
}

#pragma mark --
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.pasterList.count ;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PasterChooseCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPasterChooseCollectionCellName forIndexPath:indexPath] ;
    cell.aPaster = self.pasterList[indexPath.row] ;
    
    return cell ;
}

#pragma mark --
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Paster *paster = self.pasterList[indexPath.row] ;
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:paster.url withCacheWidth:640] ;
    if (!image) return ;
    [_stageView addPasterWithImg:image] ;
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
