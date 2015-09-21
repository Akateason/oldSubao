//
//  UETextViewCell.m
//  subao
//
//  Created by TuTu on 15/9/21.
//  Copyright © 2015年 teason. All rights reserved.
//

#import "UETextViewCell.h"

@interface UETextViewCell () <PlaceHolderTextViewDelegate>

@end

@implementation UETextViewCell

#pragma mark --
#pragma mark - PlaceHolderTextViewDelegate
- (BOOL)returnTVShouldBeginEditing:(UITextView *)tv
{
    return YES ;
}

- (void)didEndEditing:(UITextView *)tv
{
    NSLog(@"did end edit") ;
}

- (BOOL)textView:(UITextView *)tv shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
//        [tv resignFirstResponder] ;
        return NO ;
    }
    return YES ;
}

- (void)textViewDidChange:(UITextView *)tv
{
    
}

#pragma mark --
- (void)awakeFromNib {
    // Initialization code
    
    _textView.backgroundColor = [UIColor whiteColor] ;
    _textView.textColor = [UIColor darkGrayColor] ;
    
    _textView.isWhiteBG = YES ;
    _textView.myDelegate = self ;

}

- (void)layoutSubviews
{
    [super layoutSubviews] ;
    
    _textView.maxWordsRange = (int)self.maxOverFlowCount ;
    _textView.strPlaceHolder = self.strPlaceHolder ;
    [_textView textviewEmpty:!_textView.text.length] ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
