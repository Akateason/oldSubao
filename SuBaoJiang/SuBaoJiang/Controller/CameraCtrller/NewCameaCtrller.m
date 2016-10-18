//
//  NewCameaCtrller.m
//  SuBaoJiang
//
//  Created by apple on 15/6/24.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "NewCameaCtrller.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "CHTCollectionViewWaterfallLayout.h"
#import "PostSubaoCtrller.h"
#import "NavLogCtller.h"
#import "CameraGroupCtrller.h"
#import "EditPrepareCtrller.h"
#import "MultyPicChooseBar.h"
#import "PhotosPreviewCtrller.h"
#import "Article.h"
#import "MultyEditCtrller.h"
#import "DraftTB.h"
#import "XTTickConvert.h"
#import "CommonFunc.h"
#import "UIImage+AddFunction.h"
#import "AlbumOperation.h"

#define COLUMN_NUMBER       3
#define COLUMN_FLEX         3.0

static long photoCount = 0 ;

@interface NewCameaCtrller () <CHTCollectionViewDelegateWaterfallLayout,UICollectionViewDataSource,UICollectionViewDelegate,CameraGroupCtrllerDelegate,MultyPicChooseBarDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    CGSize      m_collectionSize ;
}
@property  (nonatomic, strong) ALAssetsLibrary          *assetsLibrary ;

@property  (nonatomic, strong) NSMutableArray           *imageList ; // data source
@property  (nonatomic, strong) NSMutableArray           *multySelectedImageList ;
@property  (nonatomic, strong) NSMutableArray           *resultImgList ;

@property  (strong, nonatomic) UICollectionView         *collectionView ;
@property  (nonatomic, strong) MultyPicChooseBar        *choosePicBar ;

@property  (nonatomic, strong) NSOperationQueue         *operationQueue ;

@end

@implementation NewCameaCtrller

@synthesize fetchMode = _fetchMode ;

#pragma mark --
#pragma mark - Initialization
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(uploadFinished:)
                                                     name:NSNOTIFICATION_UPLOAD_FINISHED
                                                   object:nil] ;
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}

- (void)uploadFinished:(NSNotification *)notification
{
    [self.imageList removeAllObjects] ;
    [self getAllPictures] ;
}

#pragma mark --
#pragma mark - MultyPicChooseBarDelegate
- (void)previewBtClicked
{
    if (!self.resultImgList.count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [XTHudManager showWordHudWithTitle:WD_HUD_POST_MUTI_PHOTO] ;
        }) ;
        return ;
    }
    
    [self performSegueWithIdentifier:@"camera2multypreview" sender:nil] ;
}

- (void)finishBtClicked
{
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
#pragma mark - CameraGroupCtrllerDelegate
- (void)selectAlbumnGroup:(ALAssetsGroup *)group
{
    [self.imageList removeAllObjects] ;
    [self.multySelectedImageList removeAllObjects] ;
    
    photoCount = 0 ;
    [self showImgAssetsInGroup:group] ;
}

#pragma mark --
#pragma mark - Actions
- (IBAction)btCameraGroupClickAction:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"camea2groupCamera" sender:nil] ;
}

#pragma mark --
#pragma mark - Properties
- (void)setFetchMode:(Mode_SingleOrMultiple)fetchMode
{
    _fetchMode = fetchMode ;
    
    if (fetchMode == mode_multip || fetchMode == mode_addMulty)
    {
        [self multySelectedImageList] ;
    }
    
    [self collectionView] ;
    [self choosePicBar] ;
}

- (Mode_SingleOrMultiple)fetchMode
{
    if (!_fetchMode)
    {
      _fetchMode = mode_single ; // default is single ;
    }
    
    return _fetchMode ;
}

- (ALAssetsLibrary *)assetsLibrary
{
    if (!_assetsLibrary) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init] ;
    }
    return _assetsLibrary ;
}

/*
- (PHFetchResult *)allPhotosFetchResult
{
    if (!_allPhotosFetchResult) {
        PHFetchOptions *options = [[PHFetchOptions alloc] init] ;
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate"
                                                                           ascending:NO]] ; // descending .
        _allPhotosFetchResult = [PHAsset fetchAssetsWithOptions:options] ;
    }
    return _allPhotosFetchResult ;
}

- (PHCachingImageManager *)cachingImgManager
{
    if (!_cachingImgManager) {
        _cachingImgManager = [[PHCachingImageManager alloc] init] ;
    }
    return _cachingImgManager ;
}
*/

- (NSMutableArray *)imageList
{
    if (!_imageList) {
        _imageList = [@[] mutableCopy] ;
    }
    return _imageList ;
}

- (NSMutableArray *)multySelectedImageList
{
    if (!_multySelectedImageList) {
        _multySelectedImageList = [@[] mutableCopy] ;
    }
    return _multySelectedImageList ;
}

- (NSMutableArray *)resultImgList
{
    _resultImgList = [@[] mutableCopy] ;
    
    for (NSNumber *number in self.multySelectedImageList)
    {
        ALAsset *asset = (ALAsset *)self.imageList[[number intValue]] ;
        [_resultImgList addObject:asset] ;
    }
    
    return _resultImgList ;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        // Config layout
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init] ;
        layout.columnCount = COLUMN_NUMBER ;
        layout.sectionInset = UIEdgeInsetsMake(COLUMN_FLEX, COLUMN_FLEX, COLUMN_FLEX, COLUMN_FLEX) ;
//        layout.headerHeight = COLUMN_FLEX ;
//        layout.footerHeight = 0 ;
        layout.minimumColumnSpacing = COLUMN_FLEX ;
        layout.minimumInteritemSpacing = COLUMN_FLEX ;
        
        CGRect rect = self.view.bounds ;
        rect.size.height -= (self.fetchMode == mode_multip || self.fetchMode == mode_addMulty) ? 45.0f : 0.0f ;
        _collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout] ;
        
        static NSString *cellIDentifierAlbum = @"AlbumnCell" ;
        UINib *nib = [UINib nibWithNibName:cellIDentifierAlbum bundle:[NSBundle mainBundle]] ;
        [_collectionView registerNib:nib
          forCellWithReuseIdentifier:cellIDentifierAlbum] ;
        
        _collectionView.delegate = self ;
        _collectionView.dataSource = self ;
        _collectionView.scrollEnabled = YES ;
        _collectionView.backgroundColor = COLOR_BACKGROUND ;
        _collectionView.showsVerticalScrollIndicator = YES ;
        
        if (![_collectionView superview]) {
            [self.view addSubview:_collectionView] ;
        }
    }
    
    return _collectionView ;
}

- (MultyPicChooseBar *)choosePicBar
{
    if (self.fetchMode == mode_single || self.fetchMode == mode_addSingle) return nil ;
    
    if (!_choosePicBar)
    {
        CGRect barRect = CGRectZero ;
        barRect.size.width = APPFRAME.size.width ;
        barRect.size.height = 45.0f ;
        barRect.origin.y = self.collectionView.frame.size.height + self.collectionView.frame.origin.y ;
        _choosePicBar = [[MultyPicChooseBar alloc] initWithFrame:barRect] ;
        _choosePicBar.delegate = self ;
        
        if (![_choosePicBar superview])
        {
            [self.view addSubview:_choosePicBar] ;
        }
    }
    
    return _choosePicBar ;
}

- (NSOperationQueue *)operationQueue
{
    if (!_operationQueue) {
        _operationQueue = [[NSOperationQueue alloc] init] ;
        _operationQueue.maxConcurrentOperationCount = 15 ;
    }
    return _operationQueue ;
}

#pragma mark --
#pragma mark - setup
- (void)putNavBarItem
{
    UIBarButtonItem *backBt = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(backDismiss)] ;
    self.navigationItem.leftBarButtonItem = backBt ;
}
- (void)backDismiss
{
    [self.navigationController dismissViewControllerAnimated:YES
                                                  completion:nil] ;
}

#pragma mark --
#pragma mark - Function .
- (void)getAllPictures
{
    // enumerate groups In assetsLibrary way .
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                      usingBlock:^(ALAssetsGroup *group, BOOL *stop)
    {
        [self showImgAssetsInGroup:group] ;
    } failureBlock:^(NSError *error) {
        NSLog(@"Enumerate the asset groups failed.");
        [_collectionView reloadData] ;
    }] ;
}

- (void)showImgAssetsInGroup:(ALAssetsGroup *)group
{
    // sum count in group
    photoCount = [group numberOfAssets] ;
    
    if (!photoCount) [_collectionView reloadData] ;
    
    // enumerate assets
    [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        // get asset
        NSString* assetType = [result valueForProperty:ALAssetPropertyType] ;
        if ([assetType isEqualToString:ALAssetTypePhoto])
        {
            [self.imageList addObject:result] ;
            
            if (photoCount == self.imageList.count) {
                [_collectionView reloadData] ;
                *stop = YES ;
            }
            else if ([self.imageList count] % 30 == 0)
            {
                [_collectionView reloadData] ;
            }
        } ;
    }] ;
}

#pragma mark - Multy Picture selected
- (BOOL)thisPhotoIsSelectedWithRow:(NSInteger)row
{
    __block BOOL bHas = NO ;
    [self.multySelectedImageList enumerateObjectsUsingBlock:^(NSNumber *number, NSUInteger idx, BOOL * _Nonnull stop) {
        int selectedRow = [self.multySelectedImageList[idx] intValue] ;
        if (selectedRow == row) {
            bHas = YES ;
            *stop = YES  ;
        }
    }] ;
    return bHas ;
}

#pragma mark --
#pragma mark - Life
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [ALAssetsLibrary disableSharedPhotoStreamsSupport]; // 开启 Photo Stream 容易导致 exception
    
    self.myTitle = @"相册照相页" ;
    float collectionSlider = ( APPFRAME.size.width - COLUMN_FLEX * ((float)COLUMN_NUMBER + 1) ) / (float)COLUMN_NUMBER ;
    m_collectionSize = CGSizeMake(collectionSlider, collectionSlider) ;
    
    [self putNavBarItem] ;

    [self multySelectedImageList] ;
    [self imageList] ;
    [self getAllPictures] ;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
 
    [self makeTabBarHidden:NO] ;
    [self.navigationController setNavigationBarHidden:NO] ;
    [[UIApplication sharedApplication] setStatusBarHidden:NO
                                            withAnimation:0] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --
#pragma mark - collection dataSourse
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1 ;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.fetchMode == mode_single || self.fetchMode == mode_addSingle) {
        return [self.imageList count] + 1 ;
    }
    else {
        return [self.imageList count] ;
    }
    
    return 0 ;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row ;
    
    // Set up the reuse identifier
    AlbumnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AlbumnCell"
                                                                 forIndexPath:indexPath] ;
    cell.bTakePhoto = NO ;
    cell.fetchMode = self.fetchMode ;
    
    if (self.fetchMode == mode_single || self.fetchMode == mode_addSingle) // single
    {
        if (!row)
        {
            cell.bTakePhoto = YES ;
            return cell ;
        }
    }
    else // multy
    {
        cell.picSelected = [self thisPhotoIsSelectedWithRow:row] ;
    }
    
    return cell ;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(AlbumnCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row ;
    
    if (self.fetchMode == mode_single || self.fetchMode == mode_addSingle) // single
    {
        if (!row) return ;
        
        ALAsset *asset = (ALAsset *)self.imageList[row - 1] ;
//        cell.asset = asset ;
        AlbumOperation *operation = [[AlbumOperation alloc] initWithAsset:asset
                                                                indexPath:indexPath
                                                               completion:^(UIImage *resultImage) {
            cell.img.image = resultImage ;
        }];
        [self.operationQueue addOperation:operation] ;
    }
    else // multy
    {
        ALAsset *asset = (ALAsset *)self.imageList[row] ;
//        cell.asset = asset ;
        AlbumOperation *operation = [[AlbumOperation alloc] initWithAsset:asset
                                                                indexPath:indexPath
                                                               completion:^(UIImage *resultImage) {
            cell.img.image = resultImage ;
        }];
        [self.operationQueue addOperation:operation] ;
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return m_collectionSize ;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row ;
    NSNumber *numRow = [NSNumber numberWithInteger:row] ;
    NSLog(@"ROW : %@",numRow) ;
    
//    if (!G_TOKEN || !G_USER.u_id)
//    {
//        [NavLogCtller modalLogCtrllerWithCurrentController:self] ;        
//        return ;
//    }
    
    if (self.fetchMode == mode_single || self.fetchMode == mode_addSingle)
    {
        if (!row)
        {
            NSLog(@"OPEN CAMERA") ;
            [self openCamera] ;
            return ;
        }
        
        ALAsset *asset = self.imageList[row - 1] ;
        UIImage *image = [UIImage fetchFromLibrary:asset] ;
        [self go2CuttingVC:image] ;
    }
    else
    {
        if ([self thisPhotoIsSelectedWithRow:row])
        {
            [self.multySelectedImageList removeObject:numRow] ;
        }
        else
        {
            int maxCount = MAX_SELECT_COUNT - self.existedSubArticleCount ;
            
            if (self.multySelectedImageList.count >= maxCount)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [XTHudManager showWordHudWithTitle:WD_HUD_SUB_COUNT_OVERFLOW] ;
                    NSLog(@"%d more release",maxCount) ;
                }) ;
                return ;
            }
            [self.multySelectedImageList addObject:numRow] ;
        }
        
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]] ;
        [self.choosePicBar setCount:self.multySelectedImageList.count] ;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self cancelNotVisibleOperationsInQueue] ;
}

- (void)cancelNotVisibleOperationsInQueue
{
    NSArray *allOperations = [self.operationQueue operations] ; // operation
    NSArray *visibleIndexPaths = [self.collectionView indexPathsForVisibleItems] ; // indexpaths
   
    NSMutableArray *tempNotVisibleOperations = [@[] mutableCopy] ;
    [allOperations enumerateObjectsUsingBlock:^(AlbumOperation *operation, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![visibleIndexPaths containsObject:operation.indexPath]) {
            [tempNotVisibleOperations addObject:operation] ;
        }
    }] ;
    
    NSArray *NotVisibleOperations = tempNotVisibleOperations ;
    [NotVisibleOperations enumerateObjectsUsingBlock:^(AlbumOperation *operation, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger row = operation.indexPath.row ;
        if (self.fetchMode == mode_single || self.fetchMode == mode_addSingle) {
            // single
            if (row) [operation cancel] ;
        }
        else {
            // multy
            [operation cancel] ;
        }
    }] ;
    
}

#pragma mark --
#pragma mark - Open camera TuSDK
- (void)openCamera
{
    [self startCameraControllerFromViewController:self
                                    usingDelegate:self] ;
}

- (BOOL) startCameraControllerFromViewController:(UIViewController*) controller
                                   usingDelegate:(id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate
{
    // here, check the device is available  or not
    BOOL bFail = ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] || !delegate || !controller ;
    if (bFail) return NO ;
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init] ;
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera ;
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    //cameraUI.allowsEditing = YES ;
    cameraUI.delegate = delegate ;
    [controller presentViewController:cameraUI
                             animated:YES
                           completion:^{}] ;
    return YES ;
}

#pragma mark --
#pragma mark - imagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *imageFromCamera = [info objectForKey:UIImagePickerControllerOriginalImage] ;
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 [self go2CuttingVC:imageFromCamera] ;
                                 [CommonFunc saveImageToLibrary:imageFromCamera hud:NO] ;
    }] ;
}

- (void)go2CuttingVC:(UIImage *)imageResult
{
    if (self.fetchMode == mode_single)
    {
        [self performSegueWithIdentifier:@"camera2Preview" sender:imageResult] ;
    }
    else if (self.fetchMode == mode_addSingle)
    {
        [self dismissViewControllerAnimated:YES completion:^{
            [(MultyEditCtrller *)self.orginCtrller changeImageCallback:imageResult] ;
        }] ;
    }
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"camea2groupCamera"])
    {
        CameraGroupCtrller *groupCtrller = (CameraGroupCtrller *)[segue destinationViewController] ;
        groupCtrller.delegate = self ;
        groupCtrller.assetsLibrary = self.assetsLibrary ;
    }
    else if ([segue.identifier isEqualToString:@"camera2Preview"])
    {
        EditPrepareCtrller *cuttingCtrller = (EditPrepareCtrller *)[segue destinationViewController] ;
        cuttingCtrller.imgSend = (UIImage *)sender ;
        cuttingCtrller.topicStr = self.topicStr ;
    }
    else if ([segue.identifier isEqualToString:@"camera2multypreview"])
    {
        PhotosPreviewCtrller *multyPreviewCtrller = (PhotosPreviewCtrller *)[segue destinationViewController] ;
        multyPreviewCtrller.imgAssetList = self.resultImgList ;
        multyPreviewCtrller.fetchMode    = self.fetchMode ;
        multyPreviewCtrller.articleSuper = self.articleSuper ;
        multyPreviewCtrller.orginCtrller = self.orginCtrller ;
        multyPreviewCtrller.topicStr     = self.topicStr ;
    }
}


@end
