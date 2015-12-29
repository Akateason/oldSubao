//
//  ThemeCell.m
//  SuBaoJiang
//
//  Created by apple on 15/6/7.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "ThemeCell.h"
#import "UIImageView+WebCache.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"

static const CGFloat heightForThemesCellInIphone6 = 420.0 ;

@interface ThemeCell () <SGFocusImageFrameDelegate>
{
    SGFocusImageFrame *m_sgfi_bannerView ;
}
@property (weak, nonatomic) IBOutlet UIView *bannerView;

@end

@implementation ThemeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)dealloc
{
    m_sgfi_bannerView.delegate = nil ;
    m_sgfi_bannerView = nil ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setThemesList:(NSArray *)themesList
{
    _themesList = themesList ;
    
    if (!m_sgfi_bannerView) {
        
        int length = (int)themesList.count ;

        NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length + 2] ;
        //添加最后一张图 用于循环
        if (length > 1)
        {
            Themes *tempTheme = [themesList objectAtIndex:length - 1] ;
//            SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:tempTheme.th_content
//                                                                       image:tempTheme.th_img
//                                                                         tag: - 1] ;
            SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTheme:tempTheme] ;
            [itemArray addObject:item];
        }
        
        for (int i = 0; i < length; i++)
        {
            Themes *tempTheme = [themesList objectAtIndex:i];
//            SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:tempTheme.th_content
//                                                                       image:tempTheme.th_img
//                                                                         tag:i] ;
            SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTheme:tempTheme] ;
            [itemArray addObject:item] ;
        }
        //添加第一张图 用于循环
        if (length > 1)
        {
            Themes *tempTheme = [themesList objectAtIndex:0];
//            SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:tempTheme.th_content
//                                                                       image:tempTheme.th_img
//                                                                         tag:length] ;
            SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTheme:tempTheme] ;
            [itemArray addObject:item];
        }
        
        CGRect rect = _bannerView.frame ;
        rect.size.width = APPFRAME.size.width ;
        rect.size.height = [[self class] calculateThemesHeight] ;
        
        m_sgfi_bannerView = [[SGFocusImageFrame alloc] initWithFrame:rect
                                                            delegate:self
                                                          imageItems:itemArray
                                                              isAuto:YES];
        [m_sgfi_bannerView scrollToIndex:0] ;
        
        if (![m_sgfi_bannerView superview]) {
            [self addSubview:m_sgfi_bannerView] ;
        }
    }

}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(size.width, [self calculateThemesHeight]) ;
}

- (CGFloat)calculateThemesHeight
{
    CGFloat ratio = heightForThemesCellInIphone6 / 750.0 ;
    return ratio * APPFRAME.size.width ;
}

+ (CGFloat)calculateThemesHeight
{
    CGFloat ratio = heightForThemesCellInIphone6 / 750.0 ;
    return ratio * APPFRAME.size.width ;
}


#pragma mark --
#pragma mark - SGFocusImageFrameDelegate
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item didSelectPage:(int)index
{
//    NSLog(@"%s \n click===>%@",__FUNCTION__,item.title) ;
//    NSLog(@"click page : %d",index) ;
    
    [self.delegate bannerSelectedTheme:item.atheme] ;
    
//    [self.delegate bannerSelectedTheme:index] ;
}

- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame currentItem:(int)index;
{
//    NSLog(@"%s \n scrollToIndex===>%d",__FUNCTION__,index) ;
}


@end
