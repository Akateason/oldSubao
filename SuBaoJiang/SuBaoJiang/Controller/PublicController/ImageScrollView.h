








#import <UIKit/UIKit.h>

@protocol ImageScrollViewDelegate <NSObject>
- (void)shutDown ;
@end


@interface ImageScrollView : UIScrollView <UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) int indexBeSend; //  current index
@property (nonatomic, weak) id <ImageScrollViewDelegate> delegateImageSV;

- (id)initWithFrame:(CGRect)frame ;
- (void)resetToOrigin ;
@end
