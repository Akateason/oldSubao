//
//  TopicHeader.m
//  SuBaoJiang
//
//  Created by apple on 15/6/12.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "TopicHeader.h"
#import "ArticleTopic.h"


@interface TopicHeader ()

@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UIButton *bt_seeMore;

@end

@implementation TopicHeader

- (IBAction)seeMoreAction:(id)sender
{
    NSLog(@"查看更多") ;
    [self.delegate seeMoreButtonClicked:self.acate] ;
}

- (void)awakeFromNib
{
    self.backgroundColor = COLOR_HEADER_BACK ;
    
    [_bt_seeMore setTitleColor:COLOR_HOME_LIGHT_WORDS
                      forState:0] ;
    _bt_seeMore.hidden = YES ;
}

- (void)setTitle:(NSString *)title
{
    _title = title ;
    
    _lb_title.text = title ;
}

- (void)setIsCateOrDefault:(BOOL)isCateOrDefault
{
    _isCateOrDefault = isCateOrDefault ;
    
    _lb_title.textColor = isCateOrDefault ?  COLOR_MAIN : COLOR_HOME_LIGHT_WORDS ;
    _bt_seeMore.hidden  = !isCateOrDefault ;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
