//
//  MultyPicChooseBar.h
//  subao
//
//  Created by apple on 15/8/18.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MultyPicChooseBarDelegate <NSObject>
@optional
- (void)previewBtClicked ;
@required
- (void)finishBtClicked ;
@end

@interface MultyPicChooseBar : UIView
@property (nonatomic) NSInteger count ;
@property (nonatomic,strong) id <MultyPicChooseBarDelegate> delegate ;
- (instancetype)initWithFrame:(CGRect)frame ;
- (void)previewStyle ;
@end
