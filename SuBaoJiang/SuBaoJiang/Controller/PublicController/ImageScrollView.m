

#import "ImageScrollView.h"

#define MAX_ZOOM    2.0
#define MIN_ZOOM    1.0
#define FLEX_SIDE   5.0

@implementation ImageScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.maximumZoomScale = MAX_ZOOM;
        self.minimumZoomScale = MIN_ZOOM;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator   = NO;
        self.backgroundColor = [UIColor blackColor] ;
        [self imageView] ;
        
        self.delegate = self;

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        
        [tap requireGestureRecognizerToFail:doubleTap];
    }
    
    return self;
}


- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
//        _imageView.backgroundColor = [UIColor blackColor] ;
        
        _imageView.frame = [self originFrame] ;
        
        if (![_imageView superview]) {
            [self addSubview:_imageView];
        }
    }
    
    return _imageView ;
}

- (CGRect)originFrame
{
    CGRect myRect = self.bounds ;
    float flex = FLEX_SIDE ;
    return  CGRectMake(0 + flex, 0 + flex, myRect.size.width - flex * 2, myRect.size.height - flex * 2);
}

- (void)resetToOrigin
{
    [self setZoomScale:1 animated:NO];
    self.imageView.frame = [self originFrame] ;
}

#pragma mark - UIScrollView Delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

#pragma mark - Touch Action
- (void)tap:(UITapGestureRecognizer *)tapGetrue {
    NSLog(@"单击");
    [self.delegateImageSV shutDown] ;//shut down
}

- (void)doubleTap:(UITapGestureRecognizer *)tapGesture
{
    //photo
    if (self.zoomScale >= MAX_ZOOM) {
        [self setZoomScale:1 animated:YES];
    }else {
        CGPoint point = [tapGesture locationInView:self];
        [self zoomToRect:CGRectMake(point.x - 40, point.y - 40, 80, 80) animated:YES];
    }
}


@end
