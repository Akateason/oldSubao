//
//  ReuseCellContent.m
//  AlbumScrollView
//
//  Created by apple on 15/7/7.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "ReuseCellContent.h"
#import "ImageScrollView.h"
#import "UIImageView+WebCache.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ReuseCellContent ()
{
    ImageScrollView *imgScrollView ;
}
@end

@implementation ReuseCellContent
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGRect rect = CGRectZero ;
        rect.size = frame.size ;
        imgScrollView = [[ImageScrollView alloc] initWithFrame:rect] ;
        [self addSubview:imgScrollView] ;
    }
    return self;
}

- (void)setDataObj:(id)dataObj
{
    _dataObj = dataObj ;
    
    [imgScrollView resetToOrigin] ;
    
//    if (self.type == mode_imgUrl)
    if ([dataObj isKindOfClass:[NSString class]])
    {
        [imgScrollView.imageView sd_setImageWithURL:[NSURL URLWithString:dataObj]] ;
    }
//    else if (self.type == mode_asset)
    else if ([dataObj isKindOfClass:[ALAsset class]])
    {
        CGImageRef orgImage = [[(ALAsset *)dataObj defaultRepresentation] fullScreenImage] ;
        imgScrollView.imageView.image = [UIImage imageWithCGImage:orgImage] ;
        imgScrollView.backgroundColor = COLOR_IMG_EDITOR_BG ;
        imgScrollView.imageView.backgroundColor = COLOR_IMG_EDITOR_BG ;
        imgScrollView.imageView.frame = imgScrollView.frame ;
    }
    
}

@end

