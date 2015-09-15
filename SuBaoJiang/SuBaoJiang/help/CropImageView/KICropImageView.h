//
//  KICropImageView.h
//  Kitalker
//
//  Created by 杨 烽 on 12-8-9.
//
//

#import <UIKit/UIKit.h>
#import "UIImage+KIAdditions.h"

@class KICropImageMaskView;

@interface KICropImageView : UIView <UIScrollViewDelegate>
- (void)setUserInterfaced:(BOOL)bUserinterface ;
- (void)setImage:(UIImage *)image;
- (void)setCropSize:(CGSize)size;
- (UIImage *)cropImage;
@end

@interface KICropImageMaskView : UIView
{
    @private
    CGRect  _cropRect;
}
- (void)setCropSize:(CGSize)size;
- (CGSize)cropSize;
@end