//
//  SEcontainerCell.m
//  SuBaoJiang
//
//  Created by TuTu on 15/7/29.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "SEcontainerCell.h"
#import "SEMCollectionCell.h"
#import "XTAnimation.h"

#define SEMCollectionCell_IDENTIFIER    @"SEMCollectionCell"

@interface SEcontainerCell () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end
@implementation SEcontainerCell

- (void)awakeFromNib
{
    // Initialization code
    _collectionView.delegate = self ;
    _collectionView.dataSource = self ;
    _collectionView.scrollEnabled = NO ;
    _collectionView.backgroundColor = COLOR_BACKGROUND ;
    
    // Set up the reuse identifier
    UINib *nib = [UINib nibWithNibName:SEMCollectionCell_IDENTIFIER
                                bundle: [NSBundle mainBundle]];
    [_collectionView registerNib:nib
      forCellWithReuseIdentifier:SEMCollectionCell_IDENTIFIER];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTopicList:(NSMutableArray *)topicList
{
    _topicList = topicList ;
    
    if (topicList.count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_collectionView reloadData] ;
        }) ;        
    }
}

#pragma mark --
#pragma mark - collection dataSourse
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1 ;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_topicList count] ;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Set up the reuse identifier
    SEMCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SEMCollectionCell_IDENTIFIER
                                                                        forIndexPath:indexPath] ;
    
    // load the image for this cell
    cell.topic = _topicList[indexPath.row] ;
   
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float h = ( APPFRAME.size.width - 12.0 * 3 ) / 2.0 ;
    
    return CGSizeMake(h, h + 55.0) ;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"semc row selected : %@",@(indexPath.row))   ;
    ArticleTopic *topic = _topicList[indexPath.row]     ;
    [self.delegate clickTopicInTheContainer:topic]      ;
}

#pragma mark -- calculate height
+ (CGFloat)calculateHeightWithTopicList:(NSArray *)list 
{
    if (!list.count) return 0.0 ;
    NSUInteger countNum = (list.count % 2 == 0) ? (list.count / 2) : (list.count / 2 + 1) ;
    CGFloat h = ( APPFRAME.size.width - 12.0 * 3 ) / 2.0 ;
    h += ( 12.0 + 55.0 ) ;
    CGFloat result = h * countNum + 7.0 ;
//    NSLog(@"listNUm  : %@",@(list.count)) ;
//    NSLog(@"countNum : %@",@(countNum))   ;
//    NSLog(@"res Height : %@",@(result))   ;
    
    return result ;
}

@end
