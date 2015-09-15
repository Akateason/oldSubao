//
//  KICropImageView.m
//  Kitalker
//
//  Created by 杨 烽 on 12-8-9.
//
//

#import "KICropImageView.h"

@interface KICropImageView ()

@property (nonatomic,strong)    UIScrollView        *scrollView;
@property (nonatomic,strong)    UIImageView         *imageView;
@property (nonatomic,strong)    KICropImageMaskView *maskView;
@property (nonatomic,strong)    UIImage             *image;
@property (nonatomic)           UIEdgeInsets        imageInset;
@property (nonatomic)           CGSize              cropSize;

@end

@implementation KICropImageView

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self.scrollView setFrame:self.bounds];
    [self.maskView setFrame:self.bounds];
    
    if (CGSizeEqualToSize(_cropSize, CGSizeZero))
    {
        [self setCropSize:CGSizeMake(100, 100)];
    }
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil)
    {
        _scrollView = [[UIScrollView alloc] init] ;
        [_scrollView setDelegate:self] ;
        [_scrollView setBounces:NO] ;
        [_scrollView setShowsHorizontalScrollIndicator:NO] ;
        [_scrollView setShowsVerticalScrollIndicator:NO] ;
        
        if (![_scrollView superview]) {
            [self addSubview:_scrollView] ;
        }
    }
    
    return _scrollView;
}

- (UIImageView *)imageView
{
    if (_imageView == nil)
    {
        _imageView = [[UIImageView alloc] init];
        [self.scrollView addSubview:_imageView];
    }
    
    return _imageView;
}

- (KICropImageMaskView *)maskView
{
    if (_maskView == nil)
    {
        _maskView = [[KICropImageMaskView alloc] init];
        [_maskView setBackgroundColor:[UIColor clearColor]];
        [_maskView setUserInteractionEnabled:NO];

        if (![_maskView superview])
        {
            [self addSubview:_maskView];
            [self bringSubviewToFront:_maskView];
        }
    }
    
    return _maskView;
}

- (void)setUserInterfaced:(BOOL)bUserinterface
{
    self.scrollView.userInteractionEnabled = bUserinterface ;
}

- (void)setImage:(UIImage *)image
{
    if (image != _image)
    {
        [_image release];
        _image = nil;
        _image = [image retain];
    }
    
    [self.imageView setImage:_image];
    
//    self.scrollView.userInteractionEnabled = (_image.size.width != _image.size.height) ;
    
    [self updateZoomScale];
}

- (void)updateZoomScale
{
    CGFloat width  = _image.size.width  ;
    CGFloat height = _image.size.height ;
    
    [self.imageView setFrame:CGRectMake(0, 0, width, height)] ;
    
    CGFloat xScale = _cropSize.width / width;
    CGFloat yScale = _cropSize.height / height;
    CGFloat min = MAX(xScale, yScale);
    CGFloat max = min + 3.0;
    
//    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
//    {
//        max = 1.0 / [[UIScreen mainScreen] scale];
//    }
//    
//    if (min > max && min != 1.0) {
//        min = max;
//    }
    
    [self.scrollView setMinimumZoomScale:min];
    [self.scrollView setMaximumZoomScale:max+3.0];

    self.scrollView.zoomScale = min ;
//    [[self scrollView] setZoomScale:min animated:NO];
}

- (void)setCropSize:(CGSize)size
{
    _cropSize = size;
    
//    [self updateZoomScale];
    
    CGFloat width = _cropSize.width;
    CGFloat height = _cropSize.height;
    
    CGFloat x = (CGRectGetWidth(self.bounds) - width) / 2;
    CGFloat y = (CGRectGetHeight(self.bounds) - height) / 2;

    [(KICropImageMaskView *)self.maskView setCropSize:_cropSize];
    
    CGFloat top = y;
    CGFloat left = x;
    CGFloat right = CGRectGetWidth(self.bounds)- width - x;
    CGFloat bottom = CGRectGetHeight(self.bounds)- height - y;
    _imageInset = UIEdgeInsetsMake(top, left, bottom, right);
    
    [self.scrollView setContentInset:_imageInset];
    
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
}

- (UIImage *)cropImage
{
    CGFloat zoomScale = self.scrollView.zoomScale;
    
    CGFloat offsetX = self.scrollView.contentOffset.x;
    CGFloat offsetY = self.scrollView.contentOffset.y;
    CGFloat aX = offsetX>=0 ? offsetX+_imageInset.left : (_imageInset.left - ABS(offsetX));
    CGFloat aY = offsetY>=0 ? offsetY+_imageInset.top  : (_imageInset.top - ABS(offsetY)) ;
    
    aX = aX / zoomScale;
    aY = aY / zoomScale;
    
    CGFloat aWidth =  MAX(_cropSize.width / zoomScale, _cropSize.width);
    CGFloat aHeight = MAX(_cropSize.height / zoomScale, _cropSize.height);
    
//#ifdef DEBUG
    NSLog(@"%f--%f--%f--%f", aX, aY, aWidth, aHeight);
//#endif
    
    UIImage *image = [_image cropImageWithX:aX y:aY width:aWidth height:aHeight];
    image = [image resizeToWidth:_cropSize.width height:_cropSize.height];

    return image;
}

#pragma UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)dealloc
{
    [_scrollView release];
    _scrollView = nil;
    [_imageView release];
    _imageView = nil;
    [_maskView release];
    _maskView = nil;
    [_image release];
    _image = nil;
    
    [super dealloc];
}

@end

#pragma KISnipImageMaskView

#define kMaskViewBorderWidth 1.0f

@implementation KICropImageMaskView

- (void)setCropSize:(CGSize)size
{
    CGFloat x = (CGRectGetWidth(self.bounds) - size.width) / 2;
    CGFloat y = (CGRectGetHeight(self.bounds) - size.height) / 2;
    _cropRect = CGRectMake(x, y, size.width, size.height);
    
    [self setNeedsDisplay];
}

- (CGSize)cropSize
{
    return _cropRect.size;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 0.85);
    CGContextFillRect(ctx, self.bounds);
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor lightGrayColor].CGColor);
    CGContextStrokeRectWithWidth(ctx, _cropRect, kMaskViewBorderWidth);
    
    CGContextClearRect(ctx, _cropRect);
}

@end
