








#import <UIKit/UIKit.h>

@protocol ImageScrollViewDelegate <NSObject>
- (void)shutDown ;
@end


@interface ImageScrollView : UIScrollView <UIScrollViewDelegate>
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, assign) int indexBeSend; //  current index
@property (nonatomic, assign) id <ImageScrollViewDelegate> delegateImageSV;

- (id)initWithFrame:(CGRect)frame ;
- (void)resetToOrigin ;
@end
