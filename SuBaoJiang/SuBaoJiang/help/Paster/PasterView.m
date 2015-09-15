//
//  PasterView.m
//  Paster
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "PasterView.h"

#define PASTER_SLIDE        150.0
#define FLEX_SLIDE          15.0
#define BT_SLIDE            30.0
#define BORDER_LINE_WIDTH   1.0


@interface PasterView ()

@property (nonatomic,strong) UIImageView    *imgContentView ;
@property (nonatomic,strong) UIButton       *btDelete ;
@property (nonatomic,strong) UIImageView    *resizingControl;

@property (nonatomic) CGFloat minWidth;
@property (nonatomic) CGFloat minHeight;
@property (nonatomic) CGFloat deltaAngle;
@property (nonatomic) CGPoint prevPoint;

@property (nonatomic) CGPoint touchStart;

@end

@implementation PasterView


- (void)remove
{
    [self removeFromSuperview] ;
    [self.delegate removePaster:self.pasterID] ;
}

#pragma mark -- Initial
- (instancetype)initWithBgView:(PasterStageView *)bgView
                      pasterID:(int)pasterID
                           img:(UIImage *)img
{
    self = [super init];
    if (self)
    {
        self.pasterID = pasterID ;
        self.imagePaster = img ;
        
        
        [self setupWithBGFrame:bgView.frame] ;
        [self imgContentView] ;
        [self btDelete] ;
        [self resizingControl] ;
        [bgView addSubview:self] ;
        self.isOnFirst = YES ;
    }
    return self;
}


- (void)setFrame:(CGRect)newFrame
{
    [super setFrame:newFrame];
    
    CGRect rect = CGRectZero ;
    CGFloat sliderContent = PASTER_SLIDE - FLEX_SLIDE * 2 ;
    rect.origin = CGPointMake(FLEX_SLIDE, FLEX_SLIDE) ;
    rect.size = CGSizeMake(sliderContent, sliderContent) ;
    self.imgContentView.frame = rect ;
    
    self.imgContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}


- (void)resizeTranslate:(UIPanGestureRecognizer *)recognizer
{
    if ([recognizer state] == UIGestureRecognizerStateBegan)
    {
        self.prevPoint = [recognizer locationInView:self];
        [self setNeedsDisplay];
    }
    else if ([recognizer state] == UIGestureRecognizerStateChanged)
    {
        // preventing from the picture being shrinked too far by resizing
        if (self.bounds.size.width < self.minWidth || self.bounds.size.height < self.minHeight)
        {
            self.bounds = CGRectMake(self.bounds.origin.x,
                                     self.bounds.origin.y,
                                     self.minWidth + 1 ,
                                     self.minHeight + 1);
            self.resizingControl.frame =CGRectMake(self.bounds.size.width-BT_SLIDE,
                                                   self.bounds.size.height-BT_SLIDE,
                                                   BT_SLIDE,
                                                   BT_SLIDE);
            self.prevPoint = [recognizer locationInView:self];
        }
        // Resizing
        else
        {
            CGPoint point = [recognizer locationInView:self];
            float wChange = 0.0, hChange = 0.0;
            
            wChange = (point.x - self.prevPoint.x);
            float wRatioChange = (wChange/(float)self.bounds.size.width);
            
            hChange = wRatioChange * self.bounds.size.height;
            
            if (ABS(wChange) > 50.0f || ABS(hChange) > 50.0f)
            {
                self.prevPoint = [recognizer locationOfTouch:0 inView:self];
                return;
            }
            
            self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y,
                                     self.bounds.size.width + (wChange),
                                     self.bounds.size.height + (hChange));
            
            self.resizingControl.frame = CGRectMake(self.bounds.size.width-BT_SLIDE,
                                                   self.bounds.size.height-BT_SLIDE,
                                                   BT_SLIDE, BT_SLIDE);
            
            self.prevPoint = [recognizer locationOfTouch:0 inView:self];
        }
        
        /* Rotation */
        float ang = atan2([recognizer locationInView:self.superview].y - self.center.y,
                          [recognizer locationInView:self.superview].x - self.center.x);
        
        float angleDiff = self.deltaAngle - ang;

        self.transform = CGAffineTransformMakeRotation(-angleDiff);
        
        [self setNeedsDisplay];
    }
    else if ([recognizer state] == UIGestureRecognizerStateEnded)
    {
        self.prevPoint = [recognizer locationInView:self];
        [self setNeedsDisplay];
    }
}

- (void)setImagePaster:(UIImage *)imagePaster
{
    _imagePaster = imagePaster ;
    
    self.imgContentView.image = imagePaster ;
}


- (void)setupWithBGFrame:(CGRect)bgFrame
{
    CGRect rect = CGRectZero ;
    rect.size = CGSizeMake(PASTER_SLIDE, PASTER_SLIDE) ;
    self.frame = rect ;
    self.center = CGPointMake(bgFrame.size.width / 2, bgFrame.size.height / 2) ;
    self.backgroundColor = nil ;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)] ;
    [self addGestureRecognizer:tapGesture] ;

    UIPinchGestureRecognizer *pincheGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)] ;
    [self addGestureRecognizer:pincheGesture] ;

    UIRotationGestureRecognizer *rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)] ;
    [self addGestureRecognizer:rotateGesture] ;
    
    self.userInteractionEnabled = YES ;
    
    self.minWidth   = self.bounds.size.width*0.5;
    self.minHeight  = self.bounds.size.height*0.5;
  
    self.deltaAngle = atan2(self.frame.origin.y+self.frame.size.height - self.center.y,
                            self.frame.origin.x+self.frame.size.width - self.center.x);

}

- (void)tap:(UITapGestureRecognizer *)tapGesture
{
    NSLog(@"tap paster become first respond") ;
    self.isOnFirst = YES ;
    [self.delegate makePasterBecomeFirstRespond:self.pasterID] ;
}

- (void)handlePinch:(UIPinchGestureRecognizer *)pinchGesture
{
    self.isOnFirst = YES ;
    [self.delegate makePasterBecomeFirstRespond:self.pasterID] ;
    
    self.transform = CGAffineTransformScale(self.transform, pinchGesture.scale, pinchGesture.scale) ;
    pinchGesture.scale = 1 ;
}

- (void)handleRotation:(UIRotationGestureRecognizer *)rotateGesture
{
    self.isOnFirst = YES ;
    [self.delegate makePasterBecomeFirstRespond:self.pasterID] ;
    
    self.transform = CGAffineTransformRotate(self.transform, rotateGesture.rotation) ;
    rotateGesture.rotation = 0 ;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.isOnFirst = YES ;
    [self.delegate makePasterBecomeFirstRespond:self.pasterID] ;

    UITouch *touch = [touches anyObject];
    self.touchStart = [touch locationInView:self.superview];
}

- (void)translateUsingTouchLocation:(CGPoint)touchPoint
{
    CGPoint newCenter = CGPointMake(self.center.x + touchPoint.x - self.touchStart.x,
                                    self.center.y + touchPoint.y - self.touchStart.y);
    self.center = newCenter;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(self.resizingControl.frame, touchLocation))
    {
        return;
    }
    
    CGPoint touch = [[touches anyObject] locationInView:self.superview];
    [self translateUsingTouchLocation:touch];
    self.touchStart = touch;
}

#pragma mark -- Properties
- (void)setIsOnFirst:(BOOL)isOnFirst
{
    _isOnFirst = isOnFirst ;
    
    self.btDelete.hidden = !isOnFirst ;
    self.resizingControl.hidden = !isOnFirst ;
    self.imgContentView.layer.borderWidth = isOnFirst ? BORDER_LINE_WIDTH : 0.0f ;
    
    if (isOnFirst)
    {
        NSLog(@"pasterID : %d is On",self.pasterID) ;
    }
}

- (UIImageView *)imgContentView
{
    if (!_imgContentView)
    {
        CGRect rect = CGRectZero ;
        CGFloat sliderContent = PASTER_SLIDE - FLEX_SLIDE * 2 ;
        rect.origin = CGPointMake(FLEX_SLIDE, FLEX_SLIDE) ;
        rect.size = CGSizeMake(sliderContent, sliderContent) ;
        
        _imgContentView = [[UIImageView alloc] initWithFrame:rect] ;
        _imgContentView.backgroundColor = nil ;
        
        _imgContentView.layer.borderColor = [UIColor whiteColor].CGColor ;
        _imgContentView.layer.borderWidth = BORDER_LINE_WIDTH ;
        
        if (![_imgContentView superview])
        {
            [self addSubview:_imgContentView] ;
        }
    }
    
    return _imgContentView ;
}

- (UIImageView *)resizingControl
{
    if (!_resizingControl)
    {
        _resizingControl = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-BT_SLIDE,
                                                                            self.frame.size.height-BT_SLIDE,
                                                                            BT_SLIDE,
                                                                            BT_SLIDE)];
        _resizingControl.userInteractionEnabled = YES;
//  _resizingControl.image = [UIImage imageNamed:@"ZDStickerView.bundle/ZDBtn2.png.png"] ;
        _resizingControl.backgroundColor = [UIColor redColor] ;
        UIPanGestureRecognizer *panResizeGesture = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(resizeTranslate:)] ;
        [_resizingControl addGestureRecognizer:panResizeGesture] ;
       
        if (![_resizingControl superview]) {
            [self addSubview:_resizingControl] ;
        }
    }
    
    return _resizingControl ;
}


- (UIButton *)btDelete
{
    if (!_btDelete)
    {
        CGRect btRect = CGRectZero ;
        btRect.size = CGSizeMake(BT_SLIDE, BT_SLIDE) ;
        _btDelete = [[UIButton alloc] initWithFrame:btRect] ;
        [_btDelete addTarget:self action:@selector(btDeletePressed:) forControlEvents:UIControlEventTouchUpInside] ;
        [self addSubview:_btDelete] ;
        
        _btDelete.backgroundColor = [UIColor whiteColor] ;
        [_btDelete setTitle:@"删除" forState:UIControlStateNormal] ;
        [_btDelete setTitleColor:[UIColor blackColor] forState:UIControlStateNormal] ;
        _btDelete.titleLabel.font = [UIFont systemFontOfSize:12.0] ;
    }
    
    return _btDelete ;
}

- (void)btDeletePressed:(UIButton *)btDel
{
    NSLog(@"btDel") ;
    [self remove] ;
}

//- (void)btOriginalAction
//{
//    [self.delegate clickOriginalButton] ;
//}

@end
