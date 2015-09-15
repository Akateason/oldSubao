//
//  MyPraisedCell.m
//  SuBaoJiang
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "MyPraisedCell.h"
#import "PraisedCollectionCell.h"
#import "UserCenterController.h"

@interface MyPraisedCell ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MyPraisedCell

- (void)awakeFromNib {
    // Initialization code
    _collectionView.delegate = self ;
    _collectionView.dataSource = self ;
    _collectionView.scrollEnabled = NO ;
    _collectionView.backgroundColor = COLOR_BACKGROUND ;
    
    // Set up the reuse identifier
    UINib *nib = [UINib nibWithNibName:@"PraisedCollectionCell" bundle: [NSBundle mainBundle]];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:@"PraisedCollectionCell"];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPraiseList:(NSMutableArray *)praiseList
{
    _praiseList = praiseList ;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_collectionView reloadData] ;
    }) ;
}

#pragma mark --
#pragma mark - collection dataSourse
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1 ;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_praiseList count] ; // 限制数量
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Set up the reuse identifier
    PraisedCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"PraisedCollectionCell" forIndexPath:indexPath];
    
    // load the image for this cell
    cell.praise = _praiseList[indexPath.row] ;
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float h = ( APPFRAME.size.width - 12 ) / 2 ;
    
    return CGSizeMake(h, h + 40);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    collectionView.userInteractionEnabled = NO ;
    
    NSLog(@"row : %@",@(indexPath.row)) ;
    ArticlePraise *praise = _praiseList[indexPath.row] ;
    [self.delegate jump2Article:praise.a_id] ;
    collectionView.userInteractionEnabled = YES ;
}

#pragma mark -- calculate height
+ (CGFloat)calculateHeightWithPraiseList:(NSMutableArray *)list
{
    NSUInteger countNum = (list.count % 2 == 0) ? list.count / 2 : list.count / 2 + 1 ;
    float h = ( APPFRAME.size.width - 12.0 ) / 2 ;
    h += 44.0 ;
    
    return h * countNum + 44.0 ;
}

@end
