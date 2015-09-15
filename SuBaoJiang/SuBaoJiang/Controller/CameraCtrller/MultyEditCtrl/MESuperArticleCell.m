//
//  MESuperArticleCell.m
//  subao
//
//  Created by apple on 15/8/20.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "MESuperArticleCell.h"
#import "PlaceHolderTextView.h"
#import "Article.h"
#import "XTAnimation.h"

#define TEXT_NO_TOPIC           @"#添加话题#"


@interface MESuperArticleCell () <PlaceHolderTextViewDelegate>
@property (weak, nonatomic) IBOutlet PlaceHolderTextView *tv_mainTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet PlaceHolderTextView *tv_content;
@property (weak, nonatomic) IBOutlet UIButton *bt_talk;
@property (weak, nonatomic) IBOutlet UIView *bgview_btTalk;
@property (weak, nonatomic) IBOutlet UIButton *bt_clearTopic;
@end

@implementation MESuperArticleCell

- (void)mainTitleAnimateAction
{
    [XTAnimation shakeRandomDirectionWithDuration:0.35 AndWithView:_tv_mainTitle] ;
}

- (void)setArticleSuper:(Article *)articleSuper
{
    _articleSuper = articleSuper ;
    
    _tv_mainTitle.text = articleSuper.a_title ;
    _tv_content.text = articleSuper.a_content ;
    _imgView.image = articleSuper.realImage ;

}

- (void)setTopicStr:(NSString *)topicStr
{
    _topicStr = topicStr ;
    
    _bt_clearTopic.hidden = (!topicStr || ![topicStr length]) ? YES : NO ;
    
    NSString *strShow = (!topicStr || ![topicStr length]) ? TEXT_NO_TOPIC : [NSString stringWithFormat:@"#%@#",topicStr] ;
    [_bt_talk setTitle:strShow forState:0] ;
    
    UIColor *color = COLOR_MAIN ;
    [_bt_talk setTitleColor:color forState:0] ;
}

//编辑图片
- (IBAction)editPictureAction:(id)sender
{
    [self.delegate editImage] ;
}

//添加话题
- (IBAction)btTalkPressedAction:(id)sender
{
    [_tv_mainTitle resignFirstResponder] ;
    [self.delegate talkButtonPressedWithPreContent:self.tv_content.text] ;
}
//删除话题
- (IBAction)btClearTopicPressedAction:(id)sender
{
    [self setTopicStr:nil] ;
    _bt_clearTopic.hidden = YES ;
}

- (void)awakeFromNib
{
    // Initialization code
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTap:)] ;
    _imgView.userInteractionEnabled = YES ;
    [_imgView addGestureRecognizer:tapGesture] ;
    
    _tv_mainTitle.strPlaceHolder = @"请添加封面标题..." ;
    _tv_mainTitle.maxWordsRange = 20 ;
    _tv_mainTitle.myDelegate = self ;
    _tv_mainTitle.layer.borderWidth = ONE_PIXEL_VALUE ;
    _tv_mainTitle.layer.borderColor = COLOR_BORDER_GRAY.CGColor ;
    
    _tv_content.strPlaceHolder = @"快来添加更多文字哟~" ;
    _tv_content.maxWordsRange = 140 ;
    _tv_content.myDelegate = self ;
    _tv_content.isWhiteBG = YES ;
    _tv_content.backgroundColor = [UIColor whiteColor] ;

    _bt_talk.backgroundColor = [UIColor clearColor] ;
    _bgview_btTalk.layer.cornerRadius = _bgview_btTalk.frame.size.height / 2 ;
    _bgview_btTalk.backgroundColor = COLOR_HEADER_BACK ;
    [_bt_clearTopic setTitleColor:COLOR_MAIN forState:0] ;
    
    _bt_clearTopic.hidden = YES ;
    [self setTopicStr:nil] ;
}

- (void)imgTap:(UITapGestureRecognizer *)tap
{
    // NSLog(@"tap") ;
    _imgView.userInteractionEnabled = NO;
    [self performSelector:@selector(changeThisImage)
               withObject:nil
               afterDelay:0.5];
}

- (void)changeThisImage
{
    _imgView.userInteractionEnabled = YES ;
    NSLog(@"changeThisImage") ;
    [self.delegate changeImage] ;
}

#pragma mark --
#pragma mark - PlaceHolderTextViewDelegate
- (BOOL)returnTVShouldBeginEditing:(UITextView *)tv
{
    if (tv == _tv_mainTitle)
    {
        return YES ;
    }
    else if (tv == _tv_content)
    {
        [self.delegate mesuperArticleContentTextviewPressed] ;
        return NO ;
    }
    
    return NO ;
}

- (void)didEndEditing:(UITextView *)tv
{
    self.articleSuper.a_title = tv.text ;
    [self.delegate mainTitleChanged:tv.text] ;
}

- (BOOL)textView:(UITextView *)tv shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (tv == _tv_mainTitle)
    {
        if ([text isEqualToString:@"\n"])
        {
            [tv resignFirstResponder] ;
            return NO ;
        }
    }
    return YES ;
}

- (void)textViewDidChange:(UITextView *)tv
{
    
}

#pragma mark - touchesEnded withEvent
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![_tv_mainTitle isExclusiveTouch])
    {
        [_tv_mainTitle resignFirstResponder] ;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
