//
//  MESubArticleCell.m
//  subao
//
//  Created by apple on 15/8/21.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "MESubArticleCell.h"
#import "PlaceHolderTextView.h"

@interface MESubArticleCell () <PlaceHolderTextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *upSec;
@property (weak, nonatomic) IBOutlet UIView *downSec;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet PlaceHolderTextView *tv_title;
@property (weak, nonatomic) IBOutlet PlaceHolderTextView *tv_content;
@property (weak, nonatomic) IBOutlet UIButton *bt_moveUp;
@property (weak, nonatomic) IBOutlet UIButton *bt_moveDown;
@end

@implementation MESubArticleCell

#pragma mark --
#pragma mark - FMTableViewCell
- (void)prepareForMoveSnapshot
{
    // Should be implemented by subclasses if needed
    self.layer.borderColor = COLOR_MULTY_CELL_BORD.CGColor ;
    self.layer.borderWidth = 2.0f ;
}
#pragma mark --
#pragma mark - Property
- (void)setSubArticle:(Article *)subArticle
{
    _subArticle = subArticle ;
    
    _imgView.image   = subArticle.realImage ;
    _tv_title.text   = subArticle.a_title ;
    _tv_content.text = subArticle.a_content ;
}


- (void)setQueueType:(TypeOfSubArticleQueueSection)queueType
{
    _queueType = queueType ;
    
    switch (queueType)
    {
        case type_normal:
        {
            _bt_moveDown.hidden = NO ;
            _bt_moveUp.hidden = NO ;
        }
            break;
        case type_head:
        {
            _bt_moveDown.hidden = NO ;
            _bt_moveUp.hidden = YES ;
        }
            break;
        case type_tail:
        {
            _bt_moveDown.hidden = YES ;
            _bt_moveUp.hidden = NO ;
        }
            break;
        default:
            break;
    }
}

#pragma mark --
#pragma mark - Action
- (IBAction)editPictureBtPressed:(id)sender
{
    [self.delegate editImage:self.subArticle.client_AID] ;
}

- (IBAction)moveUpBtClickAction:(id)sender
{
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.alpha = 0.25 ;
                     } completion:^(BOOL finished) {
                         [self.delegate moveUpFromRow:self.row] ;
                     }] ;
}

- (IBAction)moveDownBtClickAction:(id)sender
{
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.alpha = 0.25 ;
                     } completion:^(BOOL finished) {
                         [self.delegate moveDownFromRow:self.row] ;
                     }] ;
}

- (IBAction)deleteBtClickAction:(id)sender
{
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.alpha = 0.25 ;
    } completion:^(BOOL finished) {
        [self.delegate deleteThisSubArticle:self.subArticle.client_AID] ;
        self.alpha = 1.0 ;
    }] ;
}

- (IBAction)addBtClickAction:(id)sender
{
    [self.delegate insertSubArticleBelowRow:self.row] ;
}

#pragma mark --
#pragma mark - Setup
- (void)layoutSubviews
{
    [super layoutSubviews] ;
    self.layer.borderWidth = 0.0f ;
}

- (void)awakeFromNib
{
    // Initialization code
    
    _upSec.backgroundColor = [UIColor whiteColor] ;
    _downSec.backgroundColor = [UIColor whiteColor] ;
    
    UIView *middleLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPFRAME.size.width, ONE_PIXEL_VALUE)] ;
    middleLine.backgroundColor = COLOR_TABLE_SEP ;
    [_downSec addSubview:middleLine] ;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTap:)] ;
    _imgView.userInteractionEnabled = YES ;
    [_imgView addGestureRecognizer:tapGesture] ;
    
    _tv_title.strPlaceHolder = @"请添加二级标题..." ;
    _tv_title.maxWordsRange = 20 ;
    _tv_title.myDelegate = self ;
    _tv_title.layer.borderWidth = ONE_PIXEL_VALUE ;
    _tv_title.layer.borderColor = COLOR_BORDER_GRAY.CGColor ;
    _tv_title.backgroundColor = COLOR_BG_POSTCELL ;
    
    _tv_content.strPlaceHolder = @"快来添加更多文字哟~" ;
    _tv_content.maxWordsRange = 250 ;
    _tv_content.myDelegate = self ;
    _tv_content.isWhiteBG = YES ;
    _tv_content.backgroundColor = [UIColor whiteColor] ;
}

- (void)imgTap:(UITapGestureRecognizer *)tap
{
    _imgView.userInteractionEnabled = NO;
    [self performSelector:@selector(changeThisImage)
               withObject:nil
               afterDelay:0.5];
}

- (void)changeThisImage
{
    _imgView.userInteractionEnabled = YES ;
    NSLog(@"changeThisImage sub article") ;
    [self.delegate changeImage:self.subArticle.client_AID] ;
}

#pragma mark --
#pragma mark - PlaceHolderTextViewDelegate
- (BOOL)returnTVShouldBeginEditing:(UITextView *)tv
{
    if (tv == _tv_title)
    {
        [self.delegate subArticleTitleTextViewBecomeFirstResponder:self.row] ;
        return YES ;
    }
    else if (tv == _tv_content)
    {
        [self.delegate subArticleContentTextviewPressed:self.subArticle.client_AID] ;
        return NO ;
    }
    
    return NO ;
}

- (void)didEndEditing:(UITextView *)tv
{
    if (tv == _tv_title) {
        self.subArticle.a_title = tv.text ;
        [self.delegate subTitleChanged:tv.text client_aID:self.subArticle.client_AID] ;
    }
}

- (BOOL)textView:(UITextView *)tv shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (tv == _tv_title) {
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
    if (![_tv_title isExclusiveTouch])
    {
        [_tv_title resignFirstResponder] ;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
