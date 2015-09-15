//
//  TopicCateCell.m
//  SuBaoJiang
//
//  Created by TuTu on 15/7/30.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "TopicCateCell.h"
#import "TCateCollectionCell.h"

#define TCateCollectionCell_IDENTIFIER      @"TCateCollectionCell"

@interface TopicCateCell () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *colletionView;
@end

@implementation TopicCateCell

- (void)awakeFromNib
{
    // Initialization code
    _colletionView.delegate = self ;
    _colletionView.dataSource = self ;
    _colletionView.scrollEnabled = NO ;
    _colletionView.backgroundColor = [UIColor whiteColor] ;
    self.backgroundColor = [UIColor whiteColor] ;
    
    // Set up the reuse identifier
    UINib *nib = [UINib nibWithNibName:TCateCollectionCell_IDENTIFIER
                                bundle: [NSBundle mainBundle]];
    [_colletionView registerNib:nib
      forCellWithReuseIdentifier:TCateCollectionCell_IDENTIFIER];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


- (void)setTopicList:(NSArray *)topicList
{
    _topicList = topicList ;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.colletionView reloadData] ;
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
    return [self.topicList count] ;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Set up the reuse identifier
    TCateCollectionCell *cell = [collectionView
                                 dequeueReusableCellWithReuseIdentifier:TCateCollectionCell_IDENTIFIER
                                                           forIndexPath:indexPath] ;
    // load the image for this cell
    cell.topic = _topicList[indexPath.row] ;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float wid = ( APPFRAME.size.width - 13.0 * 2 ) / 3.0 ;
    int resultWidth = (int)wid ;
    return CGSizeMake(resultWidth, HeightForTopicCateCell) ;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"row selected : %@",@(indexPath.row))    ;
    ArticleTopic *topic = _topicList[indexPath.row] ;
    [self.delegate cateCellSelected:topic]  ;
}

@end
