//
//  WordSendView.m
//  SuBaoJiang
//
//  Created by apple on 15/6/3.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "WordSendView.h"
#import "User.h"
#import "DigitInformation.h"

@interface WordSendView ()<UITextViewDelegate>

@end

@implementation WordSendView

- (void)resetToOrigin
{
    self.comment = nil ;
    _textView.text = @"" ;
    _lb_placeholder.text = WORD_LABEL_PLACEHOLDER ;
    [_flywordInputView resetToOrigin] ;
}

- (void)awakeFromNib
{
    [super awakeFromNib] ;
    
    UIView *upline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPFRAME.size.width, 0.5)] ;
    upline.backgroundColor = COLOR_TABLE_SEP ;
    [self addSubview:upline] ;
    
    _textView.layer.cornerRadius = CORNER_RADIUS_ALL ;
    _textView.font = [UIFont systemFontOfSize:14.0f] ;
    _textView.backgroundColor = nil ;
    _textView.delegate = self ;
    _textView.textColor = [UIColor darkGrayColor] ;
    
    _lb_placeholder.layer.cornerRadius = CORNER_RADIUS_ALL ;
    _lb_placeholder.backgroundColor = COLOR_FLY_BACK ;
    _lb_placeholder.layer.masksToBounds = YES ;
    _lb_placeholder.font = [UIFont systemFontOfSize:14.0f] ;
    _lb_placeholder.text = WORD_LABEL_PLACEHOLDER ;
    
}

#pragma mark --
#pragma mark - ACTIONS
- (IBAction)btSendPressedAction:(id)sender
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(sendCommentAction) object:nil];
    [self performSelector:@selector(sendCommentAction) withObject:nil afterDelay:0.2f];
}

- (void)sendCommentAction
{
    if (![_textView.text length]) return ;
    NSLog(@"发送") ;
    NSString *colorStr = [ArticleComment getcolorStrWithEnum:_flywordInputView.typecolor] ;
    NSString *sizeStr = [ArticleComment getSizeStrWithFlywordEnum:_flywordInputView.typesize] ;
    [self.delegate sendCommentButtonPressedCallWithContent:_textView.text AndWithColorStr:colorStr AndWithSizeStr:sizeStr AndWithPositionStr:@""] ;
}

- (void)reloadPlaceHolder
{
    if (![_textView.text isEqualToString:@""])
    {
        _lb_placeholder.text = @"" ;
    }
    
    if ([_textView.text isEqualToString:@""])
    {
        _lb_placeholder.text = [_flywordInputView placeHolderString] ;
    }
}

#pragma mark --
#pragma mark - textview delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (!G_TOKEN || !G_USER.u_id) {
        [self.delegate goToLogin] ;
        return NO ;
    }
    
    return YES ;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ( [text isEqualToString:@"\n"] )
    {
        [self btSendPressedAction:nil] ;
        return NO ;
    }
    
    return YES ;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length)
    {
        _lb_placeholder.text = @"" ;
    }
    else
    {
        _lb_placeholder.text = [_flywordInputView placeHolderString] ;
    }
    
    if (textView.text.length > 140)
    {
        NSLog(@"超过字数, 140") ;
    }
    
    [_flywordInputView setFlyword:textView.text] ;
}

#pragma mark --
#pragma mark - Properties
- (void)setComment:(ArticleComment *)comment
{
    _comment = comment ;
    
    self.flywordInputView.userReply = comment.userCurrent ;
    
    [self reloadPlaceHolder] ;
}


- (FlywordInputView *)flywordInputView
{
    if (!_flywordInputView)
    {
        _flywordInputView = (FlywordInputView *)[[[NSBundle mainBundle] loadNibNamed:@"FlywordInputView" owner:self options:nil] lastObject] ;
    }
    
    return _flywordInputView ;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
