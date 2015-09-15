//
//  PostMainCell.m
//  SuBaoJiang
//
//  Created by apple on 15/6/26.
//  Copyright (c) 2015年 teason. All rights reserved.
//




#import "PostMainCell.h"
#import <CoreText/CoreText.h>
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"

@interface PostMainCell () <PlaceHolderTextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *lb_wordsNum;
@property (weak, nonatomic) IBOutlet UIButton *bt_talk;
@property (weak, nonatomic) IBOutlet UIView *bgview_btTalk;
@property (weak, nonatomic) IBOutlet UIButton *bt_clearTopic;
@end

@implementation PostMainCell

@synthesize topicStr = _topicStr ;

- (void)showKeyboard
{
    [_textview becomeFirstResponder] ;
}

- (void)hideKeyboard
{
    [_textview resignFirstResponder] ;
}

- (void)setTopicStr:(NSString *)topicStr
{
    _topicStr = topicStr ;
    
    _bt_clearTopic.hidden = (!topicStr) ? YES : NO ;
    
    NSString *strShow = !topicStr ? TEXT_NO_TOPIC : [NSString stringWithFormat:@"#%@#",topicStr] ;
    [_bt_talk setTitle:strShow forState:0] ;
    
    UIColor *color = COLOR_MAIN ;
    [_bt_talk setTitleColor:color forState:0] ;
}

- (NSString *)topicStr
{
    return _topicStr ;
}

//添加话题
- (IBAction)btTalkPressedAction:(id)sender
{
    [self hideKeyboard] ;
    [self.delegate talkButtonPressedWithPreContent:self.textview.text] ;
}
//删除话题
- (IBAction)btClearTopicPressedAction:(id)sender
{
    [self setTopicStr:nil] ;
    _bt_clearTopic.hidden = YES ;
}

- (void)setImage:(UIImage *)image
{
    _image = image ;
    
    _img.image = image ;
}

- (void)awakeFromNib
{
    // Initialization code
    _img.contentMode = UIViewContentModeScaleAspectFit ;
    
    _textview.backgroundColor = [UIColor whiteColor] ;
    _textview.textColor = [UIColor darkGrayColor] ;
    _textview.isWhiteBG = YES ;
    _textview.maxWordsRange = MAX_WORDS_LENGTH ;
    _textview.strPlaceHolder = @"快来分享~" ;
    _textview.myDelegate = self ;
    
    _bt_talk.backgroundColor = [UIColor clearColor] ;
    _bgview_btTalk.layer.cornerRadius = _bgview_btTalk.frame.size.height / 2 ;
    _bgview_btTalk.backgroundColor = COLOR_HEADER_BACK ;
    
    [_bt_clearTopic setTitleColor:COLOR_MAIN forState:0] ;
    _bt_clearTopic.hidden = YES ;
    [self setTopicStr:nil] ;
}

#pragma mark --
#pragma mark - PlaceHolderTextViewDelegate
- (BOOL)returnTVShouldBeginEditing:(UITextView *)tv
{
    return YES ;
}

- (void)didEndEditing:(UITextView *)tv
{
}

- (BOOL)textView:(UITextView *)tv shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    [self showWordNumberLabelWithLengh:(int)_textview.text.length] ;
    return YES ;
}

- (void)textViewDidChange:(UITextView *)tv
{
    [self showWordNumberLabelWithLengh:(int)tv.text.length] ;
}

#pragma mark -- show word Number Label
- (void)showWordNumberLabelWithLengh:(int)length
{
    _lb_wordsNum.attributedText = [self getAttributedWordsWithLength:length] ;
}

#pragma mark - public
+ (NSDictionary *)getStyle
{
    return  @{ @"light" : [UIColor lightGrayColor] ,
               @"red"   : COLOR_MAIN ,
               @"small" : [UIFont systemFontOfSize:12.0f]
               } ;
}

- (NSAttributedString *)getAttributedWordsWithLength:(int)length
{
    NSString *strAttri = (length > MAX_WORDS_LENGTH) ? [NSString stringWithFormat:@"<small><red>%d</red><light> / %d</light></small>",length,MAX_WORDS_LENGTH] : [NSString stringWithFormat:@"<small><light>%d / %d</light></small>",length,MAX_WORDS_LENGTH] ;
    return [strAttri attributedStringWithStyleBook:[[self class] getStyle]] ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
