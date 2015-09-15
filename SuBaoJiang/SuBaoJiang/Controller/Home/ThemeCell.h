//
//  ThemeCell.h
//  SuBaoJiang
//
//  Created by apple on 15/6/7.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Themes.h"

@protocol ThemeCellDelegate <NSObject>
- (void)bannerSelectedTheme:(int)indexSelected ;
@end

@interface ThemeCell : UITableViewCell
@property (nonatomic,strong) id <ThemeCellDelegate> delegate ;
@property (nonatomic,strong) NSArray *themesList ;
+ (CGFloat)calculateThemesHeight ;
@end
