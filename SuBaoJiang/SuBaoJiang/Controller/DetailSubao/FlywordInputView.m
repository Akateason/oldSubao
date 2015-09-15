//
//  FlywordInputView.m
//  SuBaoJiang
//
//  Created by apple on 15/6/4.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "FlywordInputView.h"
#import "PCStackMenu.h"
#import "User.h"

@interface FlywordInputView ()

@property (weak, nonatomic) IBOutlet UIView *contentBorderView;
@property (weak, nonatomic) IBOutlet UILabel *lb_content;

@property (weak, nonatomic) IBOutlet UIButton *bt_color;
@property (weak, nonatomic) IBOutlet UIButton *bt_size;

@property (weak, nonatomic) IBOutlet UIButton *bt_bg; //background

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *color_h_constant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *size_h_constant;

@end

@implementation FlywordInputView

- (NSString *)placeHolderString
{
    return (!_userReply) ? WORD_LABEL_PLACEHOLDER : [NSString stringWithFormat:@"回复%@:",_userReply.u_nickname] ;
}

// reset to origin
- (void)resetToOrigin
{
    _userReply = nil ;
    _flyword = nil ;
    _lb_content.text = [self placeHolderString] ;
}

- (void)awakeFromNib
{
    self.backgroundColor = COLOR_ALERT_BACK ;
    
    _lb_content.font = [UIFont systemFontOfSize:FONT_SIZE_MIDDLE] ;
    _lb_content.textColor = [UIColor whiteColor] ;
    _lb_content.text = [self placeHolderString] ;
    
    _contentBorderView.backgroundColor = nil ;
    _contentBorderView.layer.borderColor  = [UIColor whiteColor].CGColor ;
    _contentBorderView.layer.borderWidth = 1.0f ;
}

#pragma mark --
- (void)setUserReply:(User *)userReply
{
    _userReply = userReply ;
    
    self.flyword = self.flyword ;
}


#pragma mark - setter flyword
- (void)setFlycolor:(UIColor *)flycolor
{
    _flycolor = flycolor ;

    _lb_content.textColor = flycolor ;
}

- (void)setFlyfont:(UIFont *)flyfont
{
    _flyfont = flyfont ;
    
    _lb_content.font = flyfont ;
}

- (void)setFlyword:(NSString *)flyword
{
    _flyword = flyword ;

    NSString *strShow = @"" ;
    strShow = (!self.userReply) ? flyword : [NSString stringWithFormat:@"回复%@:%@",self.userReply.u_nickname,flyword] ;

    if (!flyword.length) {
        strShow = [self placeHolderString] ;
    }
    
    _lb_content.text = strShow ;
}

#pragma mark --
#pragma mark - getter flyword
- (UIColor *)getFlycolor
{
    if (!_flycolor) {
        _flycolor = [UIColor whiteColor] ;
    }
    return _flycolor ;
}
- (UIFont *)getFlyfont
{
    if (!_flyfont) {
        _flyfont = [UIFont systemFontOfSize:FONT_SIZE_MIDDLE] ;
    }
    return _flyfont ;
}


#pragma mark --
#pragma mark - set buttons positions
- (void)setButtonsHeight:(float)height
{
    _color_h_constant.constant = height ;
    _size_h_constant.constant = height ;
}

#pragma mark --
#pragma mark - Buttons Actions
- (IBAction)colorsBtPressedAction:(id)sender
{
    NSArray *imgList = [NSArray arrayWithObjects:
     [UIImage imageNamed:@"color_purple"],
     [UIImage imageNamed:@"color_blue"],
     [UIImage imageNamed:@"color_green"],
     [UIImage imageNamed:@"color_yellow"],
     [UIImage imageNamed:@"color_red"],
     [UIImage imageNamed:@"color_white"],
     nil] ;
    imgList = [[imgList reverseObjectEnumerator] allObjects] ;
    
    NSArray *strList = [NSArray arrayWithObjects: @"紫色",@"蓝色",@"绿色",@"黄色",@"红色",@"白色",nil] ;
    strList = [[strList reverseObjectEnumerator] allObjects] ;
    
    [PCStackMenu showStackMenuWithTitles:strList
                              withImages:imgList
                            atStartPoint:CGPointMake(_bt_color.frame.origin.x + _bt_color.frame.size.width + 8, _bt_color.frame.origin.y - 5)
                                  inView:self
                              itemHeight:35
                           menuDirection:PCStackMenuDirectionClockWiseUp
                            onSelectMenu:^(NSInteger selectedMenuIndex) {
                                
                                NSLog(@"menu index : %d", selectedMenuIndex) ;
//                                FLYWORD_COLOR_TYPE type = 5 - selectedMenuIndex ;
                                FLYWORD_COLOR_TYPE type = selectedMenuIndex ;
                                UIImage *colorBack = [ArticleComment getUIImageOfColorWithEnum:type] ;
                                [_bt_color setImage:colorBack forState:UIControlStateNormal] ;
                                
                                self.typecolor = type ;
                                self.flycolor = [ArticleComment getUIColorWithEnum:type] ;
                            }];

}

- (IBAction)sizeBtPressedAction:(id)sender
{
    
    [PCStackMenu showStackMenuWithTitles:[NSArray arrayWithObjects: @"大号",@"中等",@"小号",nil]
                              withImages:[NSArray arrayWithObjects:
                                          [UIImage imageNamed:@"size_large"],
                                          [UIImage imageNamed:@"size_middle"],
                                          [UIImage imageNamed:@"size_small"],
                                          nil]
                            atStartPoint:CGPointMake(_bt_size.frame.origin.x + _bt_size.frame.size.width + 8, _bt_size.frame.origin.y - 5)
                                  inView:self
                              itemHeight:35
                           menuDirection:PCStackMenuDirectionClockWiseUp
                            onSelectMenu:^(NSInteger selectedMenuIndex) {
                                NSLog(@"menu index : %d", selectedMenuIndex) ;
                                FLYWORD_SIZE_TYPE type = 1 - selectedMenuIndex ;
                                //NSLog(@"type : %d",type) ;
                                UIImage *sizeBack = [ArticleComment getUIImageOfSizeWithEnum:type] ;
                                [_bt_size setImage:sizeBack forState:UIControlStateNormal] ;
                                
                                self.typesize = type ;
                                self.flyfont = [ArticleComment getUIFontWithEnum:type] ;
                            }];
    
}

- (IBAction)backgroundPressedAction:(id)sender
{
    [self.delegate resignWordSendViewAndKeyBoard] ;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
