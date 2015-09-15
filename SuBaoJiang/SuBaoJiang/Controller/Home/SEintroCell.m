//
//  SEintroCell.m
//  SuBaoJiang
//
//  Created by TuTu on 15/7/31.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "SEintroCell.h"
#import "UIImageView+WebCache.h"
#import "ThemeCell.h"
#import "CommonFunc.h"

@interface SEintroCell ()
@property (weak, nonatomic) IBOutlet UIImageView *img;
@end

@implementation SEintroCell

- (void)setStrImg:(NSString *)strImg
{
    _strImg = strImg ;
    
    [_img sd_setImageWithURL:[NSURL URLWithString:strImg]
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       if (cacheType == SDImageCacheTypeNone) {
                           [self.delegate topicDetailImageFetchingFinished] ;
                       }
     }] ;
}

- (void)awakeFromNib
{
    // Initialization code
    self.img.backgroundColor = COLOR_BACKGROUND ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

+ (CGFloat)calculateHeightWithPicKeys:(NSString *)picKeys
{
    CGFloat height = [ThemeCell calculateThemesHeight]  ; // default value .

    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:picKeys
                                                                     withCacheWidth:APPFRAME.size.width] ;
    if (!cacheImage) return height ;
    
    height = APPFRAME.size.width * cacheImage.size.height / cacheImage.size.width ;
    
    return height ;
}

@end
