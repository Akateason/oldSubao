








#import <UIKit/UIKit.h>

@protocol ImageScrollViewDelegate <NSObject>
//- (void)wantToPlayTheMovie:(int)vIndex;
- (void)shutDown ;
@end


@interface ImageScrollView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, assign) int indexBeSend; //  current index
@property (nonatomic, assign) id <ImageScrollViewDelegate> delegateImageSV;

- (id)initWithFrame:(CGRect)frame ;
- (void)resetToOrigin ;
@end
