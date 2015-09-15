//
//  XTlineSpaceLabel.m
//  subao
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "XTlineSpaceLabel.h"
#import<CoreText/CoreText.h>

#define MAX_HEIGHT_LENGTH   2000

@interface XTlineSpaceLabel()

@property (nonatomic,strong) NSAttributedString        *attributedString ;
@property (nonatomic,strong) NSDictionary *attributes ;
@property (nonatomic,strong) NSMutableParagraphStyle   *paragraph ;

@end

@implementation XTlineSpaceLabel

@synthesize linesSpacing = _linesSpacing ;

- (id)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame])
    {
        self.linesSpacing = 7.0 ;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        self.linesSpacing = 7.0 ;
    }
    
    return self;
}

- (void)setLinesSpacing:(long)linesSpacing
{
    _linesSpacing = linesSpacing ;
    
    [self paragraph] ;
    _paragraph.lineSpacing = linesSpacing ;
}

- (NSMutableParagraphStyle *)paragraph
{
    if (!_paragraph)
    {
        _paragraph = [[NSMutableParagraphStyle alloc ] init] ;
        _paragraph.alignment = NSTextAlignmentLeft ;
        _paragraph.lineSpacing = self.linesSpacing ;
    }
    
    return _paragraph ;
}

- (NSDictionary *)attributes
{
    if (!_attributes)
    {
        _attributes = @{
                        NSForegroundColorAttributeName : self.textColor ,
                         NSParagraphStyleAttributeName : self.paragraph ,
                                   NSFontAttributeName : [UIFont systemFontOfSize:14]
                        } ;
    }
    
    return _attributes ;
}

- (NSAttributedString *)attributedString
{
    _attributedString = [[NSAttributedString alloc] initWithString:self.text attributes:self.attributes] ;

    self.attributedText = _attributedString ;
    
    return _attributedString ;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    [self attributedString] ;
}

+ (int)getAttributedStringHeightWidthValue:(int)width content:(NSString *)content attributes:(NSDictionary *)attribute
{
    int total_height = 0 ;
    
    CGSize size = [content boundingRectWithSize:CGSizeMake(width, MAX_HEIGHT_LENGTH)
                                              options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                           attributes:attribute context:nil].size;
    
//    NSLog(@"content : %@",content) ;
    
    total_height = size.height ;
    
    return total_height ;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
