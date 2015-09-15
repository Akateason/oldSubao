//
//  EGORefreshTableFooterView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGORefreshTableFooterView.h"
#import "ColorsHeader.h"
//#import <AKATeasonFramework/AKATeasonFramework.h>
#import "XTAnimation.h"
#import "XTTickConvert.h"

#define FLIP_ANIMATION_DURATION 0.18f


@interface EGORefreshTableFooterView (Private)
- (void)setState:(EGOPullRefreshState)aState;
@end

@implementation EGORefreshTableFooterView

@synthesize delegate = _delegate ;

#define HEIGHT_FLEX             10.f

- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor  {
    if((self = [super initWithFrame:frame])) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = COLOR_BACKGROUND ;
        
		CALayer *layer = [CALayer layer];
        //modify by shenjx begin
        float width = 40.0f ;
        layer.frame = CGRectMake( (APPFRAME.size.width - width) / 2 , 10, width, width);
         //modify by shenjx end
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:@"logoPink"].CGImage;
		
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
        
		[self setState:EGOOPullRefreshNormal];
    }
	
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame arrowImageName:@"logoNew" textColor:[UIColor colorWithRed:163.0/255.0 green:163.0/255.0 blue:163.0/255.0 alpha:1.0]] ;
}

#pragma mark -
#pragma mark Setters
- (void)refreshLastUpdatedDate {
//	
//	if ([_delegate respondsToSelector:@selector(egoRefreshTableFooterDataSourceLastUpdated:)]) {
//		
//		NSDate *date = [_delegate egoRefreshTableFooterDataSourceLastUpdated:self];
//		
//		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
//		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
////		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
////		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//
//        NSString *lastUpdated = NSLocalizedString(@"上次更新", @"");
//		_lastUpdatedLabel.text = [NSString stringWithFormat:@"%@ %@",lastUpdated, [dateFormatter stringFromDate:date]];
//		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
//		[[NSUserDefaults standardUserDefaults] synchronize];
//		
//	} else {
//		
//		_lastUpdatedLabel.text = nil;
//		
//	}
}

- (void)setState:(EGOPullRefreshState)aState{
	
	switch (aState) {
		case EGOOPullRefreshPulling:
        {
            CATransform3D rotationTransform  = CATransform3DMakeRotation( (M_PI / 180.0) * 180.0, 0, 0, 0.5);
            CABasicAnimation* animation ;
            animation                     = [CABasicAnimation animationWithKeyPath:@"transform"];
            animation.toValue             = [NSValue valueWithCATransform3D:rotationTransform];
            animation.duration            = FLIP_ANIMATION_DURATION;
            animation.autoreverses        = NO;
            animation.cumulative          = YES;
            animation.removedOnCompletion = YES;
            animation.fillMode            = kCAFillModeForwards;
            animation.repeatCount         = 2;
            [_arrowImage addAnimation:animation forKey:nil];
            
            [XTAnimation animationTransformWithLayer:_arrowImage] ;

        }
			break;
		case EGOOPullRefreshNormal:
        {
			if (_state == EGOOPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
                [CATransaction commit];
			}
			
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.transform = CATransform3DIdentity;
            [CATransaction commit];

            
			[self refreshLastUpdatedDate];
        }
			break;
            
		case EGOOPullRefreshLoading:
        {
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			[CATransaction commit];
        }
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {	
    float offY          = scrollView.contentOffset.y;
    float contentHeight = scrollView.contentSize.height;
    float boundsHeight  = scrollView.bounds.size.height;
	if (_state == EGOOPullRefreshLoading)
    {
        //modify by shenjx begin
        
		//在下拉刷新时中，若正在loading,滚动视图，若继续下拉，则应该只让向下偏移65单位；若向上滚动，则应该可以继续往下看，相应的偏移值就应该减小（但不能小过60），否则有可能看不到最下面一行的数据
        //在上拉加载时，若正在loading，若继续上拉，则应该只让向上偏移65个单位，若向下滚动，则应该可以继续网上看，相应的偏移值应该变小（但不能小过60），否则有可能看不到最上面一行数据
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);//滚动过程中当前偏移
        offset = MIN(offset, 60);
//		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
        scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0f, offset, 0.0f);
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoRefreshTableFooterDataSourceIsLoading:)]) {
			_loading = [_delegate egoRefreshTableFooterDataSourceIsLoading:self];
		}
		//
        double d = contentHeight - boundsHeight < 0?0:contentHeight - boundsHeight;
        if (_state == EGOOPullRefreshPulling &&
            offY < d + 65 &&
            offY > d &&
            !_loading)
        {
			[self setState:EGOOPullRefreshNormal];
		}
        else if (_state == EGOOPullRefreshNormal &&
                 offY > d + 65
                 && !_loading)
            {
			[self setState:EGOOPullRefreshPulling];
		}
		
        if (scrollView.contentInset.bottom != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
	}
	
}


- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView
{
     //modify by shenjx begin
    float offY          = scrollView.contentOffset.y;
    float contentHeight = scrollView.contentSize.height;
    float boundsHeight  = scrollView.bounds.size.height;
	BOOL _loading       = NO;
	if ([_delegate respondsToSelector:@selector(egoRefreshTableFooterDataSourceIsLoading:)]) {
		_loading = [_delegate egoRefreshTableFooterDataSourceIsLoading:self];
	}
	//if (scrollView.contentOffset.y <= - 65.0f && !_loading)
    int d = contentHeight - boundsHeight > 0 ? contentHeight - boundsHeight : 0;
	if (offY >= (d + 65) && !_loading)
    {
		
		if ([_delegate respondsToSelector:@selector(egoRefreshTableFooterDidTriggerRefresh:)]) {
			[_delegate egoRefreshTableFooterDidTriggerRefresh:self];
		}
		  
		[self setState:EGOOPullRefreshLoading];
      
       
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
        
        //当表里的内容高度小于表格高度时，上拉刷新时，提示是看不到的,故需要做如下处理
        int f = contentHeight - boundsHeight ;
		//scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        if (f < 0)
        {
            CGRect rect = self.frame;
            self.frame = CGRectMake(rect.origin.x, rect.origin.y - 60, rect.size.width, rect.size.height);
        }
        else
        {
            scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0f, 60.0f, 0.0f);
        }
        	
     //modify by shenjx end    
		[UIView commitAnimations];
		
	}
	
}


- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:EGOOPullRefreshNormal];
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate=nil;
//	_activityView = nil;
//	_statusLabel = nil;
	_arrowImage = nil;
//	_lastUpdatedLabel = nil;
    [super dealloc];
}


@end
