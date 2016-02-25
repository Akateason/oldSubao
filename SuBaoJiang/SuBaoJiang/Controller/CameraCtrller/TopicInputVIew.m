//
//  TopicInputVIew.m
//  SuBaoJiang
//
//  Created by apple on 15/7/2.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "TopicInputVIew.h"
#import "XTHudManager.h"

#define MAX_WORDS_LENGTH    15

@implementation TopicInputVIew

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        
    }
    return self;
}

- (void)dealloc
{
}

- (void)hideKeyboard
{
    if ([_textfield isFirstResponder]) {
        [_textfield resignFirstResponder] ;
    }
}

- (void)awakeFromNib
{
    // Initialization code
    self.backgroundColor = COLOR_INPUTBORDER ;
    _bgView.backgroundColor = [UIColor whiteColor] ;
    _lb_symbol.textColor = COLOR_MAIN ;
    _textfield.tintColor = COLOR_MAIN ;
    _textfield.backgroundColor = [UIColor whiteColor] ;
    _textfield.delegate = self ;
    
    [self.textfield addTarget:self
                       action:@selector(myTextFieldChanged:)
             forControlEvents:UIControlEventEditingChanged];    
}



#pragma mark --
#pragma mark - textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text length] > MAX_WORDS_LENGTH)
    {
        [XTHudManager showWordHudWithTitle:WD_WORDS_OVERFLOW] ;
        return NO ;
    }
//    [self.delegate newTopicConfirmed:textField.text] ;
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self.delegate newTopicConfirmed:@""] ;
    
    return YES ;
}

- (void)myTextFieldChanged:(UITextField *)tf
{
    NSLog(@"myTextFieldChanged") ;
    
    [self.delegate newTopicConfirmed:tf.text] ;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
