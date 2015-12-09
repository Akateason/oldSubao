//
//  MySubaoCell.m
//  SuBaoJiang
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "MySubaoCell.h"
#import "Article.h"
#import "UIImageView+WebCache.h"
#import "SubaoCollectionCell.h"
#import "UserCenterController.h"
#import "CHTCollectionViewWaterfallLayout.h"

#define COLUMN_NUMBER 2
#define COLUMN_WIDTH 145.0

@interface MySubaoCell ()<UICollectionViewDataSource,UICollectionViewDelegate,CHTCollectionViewDelegateWaterfallLayout>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MySubaoCell

- (void)setSubaoList:(NSArray *)subaoList
{
    _subaoList = subaoList ;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_collectionView reloadData] ;
    }) ;
}

- (void)awakeFromNib {
    // Initialization code

    
    UINib *nib = [UINib nibWithNibName:@"SubaoCollectionCell" bundle: [NSBundle mainBundle]];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:@"SubaoCollectionCell"];

    
    //config layout
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 4, 0, 4);
    layout.headerHeight = 0;
    layout.footerHeight = 0;
    layout.minimumColumnSpacing = 4;
    layout.minimumInteritemSpacing = 4;


    _collectionView.collectionViewLayout = layout ;

    _collectionView.delegate = self ;
    _collectionView.dataSource = self ;
    _collectionView.scrollEnabled = NO ;
    _collectionView.backgroundColor = COLOR_BACKGROUND ;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark --
#pragma mark - collection dataSourse
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1 ;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_subaoList count] ; // 限制数量
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    @synchronized (_subaoList)
    {
        NSInteger row = indexPath.row ;
        // Set up the reuse identifier
        SubaoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"SubaoCollectionCell" forIndexPath:indexPath];
        // load the image for this cell
        cell.article = _subaoList[row] ;
        
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self class] calculateWithArticle:(Article *)(_subaoList[indexPath.row])] ;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    collectionView.userInteractionEnabled = NO ;
    
    NSLog(@"row : %ld",(long)indexPath.row) ;
    
    Article *arit = _subaoList[indexPath.row] ;
    if (arit.isUploaded) {
        [self.delegate jump2Article:arit.a_id] ;
    }
    else {
        [self.delegate clickDraft:arit.client_AID] ;
    }
    
    
    collectionView.userInteractionEnabled = YES ;
}

#pragma mark -- calculate size
+ (CGSize)calculateWithArticle:(Article *)arti
{
    float imgH = ( APPFRAME.size.width - 12 ) / 2 ;
    
    UIFont *font = [UIFont systemFontOfSize:12.0f];
    CGSize size = CGSizeMake(imgH - 8*2,200) ;
    
    BOOL isMulty = [arti isMultyStyle] ;
    NSString *strShow = isMulty ? arti.a_title : arti.a_content ;
    
    CGSize labelsize = [strShow boundingRectWithSize:size
                                             options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                          attributes:@{NSFontAttributeName:font}
                                             context:nil].size ;    
    
    CGFloat wdH ;
    if (labelsize.height < 37) {
        wdH = 40 ;
    } else {
        wdH = 40 - 37 + labelsize.height;
    }
    
    return CGSizeMake(imgH, imgH + wdH);
}

#pragma mark -- calculate height
+ (CGFloat)calculateHeightWithList:(NSArray *)list
{
    CGFloat firH = 0.0 ;
    CGFloat secH = 0.0 ;
    CGFloat flex = 6.0 ;
    
    for (int index = 0; index < list.count; index++)
    {
        Article *arti = (Article *)list[index] ;
        if (index % 2 == 0)
        {
            //first
            firH += ( [[self class] calculateWithArticle:arti].height + flex );
        }
        else
        {
            //second
            secH += ( [[self class] calculateWithArticle:arti].height + flex );
        }
    }
    
    return (firH >= secH) ? firH : secH ;
}




@end
