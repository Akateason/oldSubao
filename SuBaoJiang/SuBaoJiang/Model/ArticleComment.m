//
//  ArticleComment.m
//  SuBaoJiang
//
//  Created by apple on 15/6/5.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "ArticleComment.h"
#import "User.h"
#import "XTTickConvert.h"
#import "DigitInformation.h"

@implementation ArticleComment

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _userCurrent = [[User alloc] initWithDic:dic] ;
        
        _c_id = [[dic objectForKey:@"c_id"] intValue] ;
        _c_content = [dic objectForKey:@"c_content"] ;
        _c_color = [dic objectForKey:@"c_color"] ;
        _c_size = [dic objectForKey:@"c_size"] ;
        _c_position = [dic objectForKey:@"c_position"] ;

        if (![[dic objectForKey:@"c_createtime"] isKindOfClass:[NSNull class]]) {
            _c_createtime = [[dic objectForKey:@"c_createtime"] longLongValue] ;
        }
        
        _is_author = [[dic objectForKey:@"is_author"] boolValue] ;
        
        if (![[dic objectForKey:@"reply_u_id"] isKindOfClass:[NSNull class]]) {
            _reply_u_id = [[dic objectForKey:@"reply_u_id"] intValue] ;
        }
        if (![[dic objectForKey:@"a_id"] isKindOfClass:[NSNull class]]) {
            _a_id = [[dic objectForKey:@"a_id"] intValue] ;
        }
        if (![[dic objectForKey:@"img"] isKindOfClass:[NSNull class]]) {
            _img = [dic objectForKey:@"img"];
        }
        
        
        _reply_u_nickname = [dic objectForKey:@"reply_u_nickname"] ;
        _showStrComment = !_reply_u_id ? _c_content : [NSString stringWithFormat:@"回复%@:%@",_reply_u_nickname,_c_content] ;
    }
    
    return self;
}


- (instancetype)initWithMsgDic:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        if (![[dic objectForKey:@"a_id"] isKindOfClass:[NSNull class]]) {
            _a_id = [[dic objectForKey:@"a_id"] intValue] ;
        }
        if (![[dic objectForKey:@"img"] isKindOfClass:[NSNull class]]) {
            _img = [dic objectForKey:@"img"];
        }
        _c_id = [[dic objectForKey:@"c_id"] intValue] ;
        _c_content = [dic objectForKey:@"msg_content"] ;
        if (![[dic objectForKey:@"msg_sendtime"] isKindOfClass:[NSNull class]]) {
            _c_createtime = [[dic objectForKey:@"msg_sendtime"] longLongValue] ;
        }
    }
    return self;
}


- (instancetype)initWithCommentID:(int)commentID
                   AndWithContent:(NSString *)content
                  AndWithColorStr:(NSString *)colorStr
                   AndWithSizeStr:(NSString *)sizeStr
               AndWithPositionStr:(NSString *)positionStr
                           AndAID:(int)aid
{
    self = [super init];
    if (self)
    {
        _userCurrent = G_USER ;
        
        _c_id = commentID ;
        _c_content = content ;
        _c_color = colorStr ;
        _c_size = sizeStr ;
        _c_position = positionStr ;
        _is_author = YES ;
        _c_createtime = [XTTickConvert getTickWithDate:[NSDate date]] ;
        
        _showStrComment = !_reply_u_id ? _c_content : [NSString stringWithFormat:@"回复%@:%@",_reply_u_nickname,_c_content] ;
        
        _isPostedImmediately = YES ;
        _a_id = aid ;

    }
    
    return self;
}



+ (NSArray *)getCommentListWithDictList:(NSArray *)tempCommentList
{
    NSMutableArray *resultCommentList = [NSMutableArray array] ;
    
    for (NSDictionary *commentDict in tempCommentList)
    {
        ArticleComment *aComment = [[ArticleComment alloc] initWithDic:commentDict] ;
        [resultCommentList addObject:aComment] ;
    }
    
    return resultCommentList ;
}

+ (NSString *)getcolorStrWithEnum:(FLYWORD_COLOR_TYPE)type
{
    
    NSString *colorStr = @"" ;
    
    switch (type) {
        case colorf_white:
        {
            colorStr = @"white" ;
        }
            break;
        case colorf_red:
        {
            colorStr = @"red" ;
        }
            break;
        case colorf_yellow:
        {
            colorStr = @"yellow" ;
        }
            break;
        case colorf_green:
        {
            colorStr = @"green" ;
        }
            break;
        case colorf_blue:
        {
            colorStr = @"blue" ;
        }
            break;
        case colorf_purple:
        {
            colorStr = @"purple" ;
        }
            break;
        default:
            break;
    }
    
    return colorStr ;
}

+ (UIImage *)getUIImageOfColorWithEnum:(FLYWORD_COLOR_TYPE)type
{
    NSString *colorStr = [self getcolorStrWithEnum:type] ;
    colorStr = [@"color_" stringByAppendingString:colorStr] ;

    return [UIImage imageNamed:colorStr] ;
}

+ (UIColor *)getUIColorWithEnum:(FLYWORD_COLOR_TYPE)type
{
    UIColor *tempColor = [UIColor whiteColor] ;
    
    switch (type) {
        case colorf_white:
        {
            tempColor = [UIColor whiteColor] ;
        }
            break;
        case colorf_red:
        {
            tempColor = COLOR_FW_RED ;
        }
            break;
        case colorf_yellow:
        {
            tempColor = COLOR_FW_YELLOW ;
        }
            break;
        case colorf_green:
        {
            tempColor = COLOR_FW_GREEN ;
        }
            break;
        case colorf_blue:
        {
            tempColor = COLOR_FW_BLUE ;
        }
            break;
        case colorf_purple:
        {
            tempColor = COLOR_FW_PURPLE ;
        }
            break;
        default:
            break;
    }
    
    return tempColor ;
}

+ (FLYWORD_COLOR_TYPE)getColorTypeWithStr:(NSString *)colorStr 
{
    FLYWORD_COLOR_TYPE type ;
    
    if ([colorStr isEqualToString:@"white"]) {
        type = colorf_white ;
    }
    else if ([colorStr isEqualToString:@"red"]) {
        type = colorf_red ;
    }
    else if ([colorStr isEqualToString:@"green"]) {
        type = colorf_green ;
    }
    else if ([colorStr isEqualToString:@"yellow"]) {
        type = colorf_yellow ;
    }
    else if ([colorStr isEqualToString:@"blue"]) {
        type = colorf_blue ;
    }
    else if ([colorStr isEqualToString:@"purple"]) {
        type = colorf_purple ;
    }
    
    return type ;
}

+ (NSString *)getSizeStrWithFlywordEnum:(FLYWORD_SIZE_TYPE)type
{
    NSString *strSize = @"" ;
    switch (type) {
        case sizef_small:
        {
            strSize = @"small" ;
        }
            break;
        case sizef_middle:
        {
            strSize = @"middle" ;
        }
            break;
        case sizef_large:
        {
            strSize = @"large" ;
        }
            break;
        default:
            break;
    }

    return strSize ;
}

+ (UIImage *)getUIImageOfSizeWithEnum:(FLYWORD_SIZE_TYPE)type
{
    NSString *sizeStr = [self getSizeStrWithFlywordEnum:type] ;
    sizeStr = [@"size_" stringByAppendingString:sizeStr] ;
    
    return [UIImage imageNamed:sizeStr] ;
}

+ (UIFont *)getUIFontWithEnum:(FLYWORD_SIZE_TYPE)type
{
    UIFont *tempFont = [UIFont systemFontOfSize:FONT_SIZE_MIDDLE] ;
    
    switch (type) {
        case sizef_small:
        {
            tempFont = [UIFont systemFontOfSize:FONT_SIZE_SMALL] ;
        }
            break;
        case sizef_middle:
        {
            tempFont = [UIFont systemFontOfSize:FONT_SIZE_MIDDLE] ;
        }
            break;
        case sizef_large:
        {
            tempFont = [UIFont systemFontOfSize:FONT_SIZE_LARGE] ;
        }
            break;
        default:
            break;
    }
    
    return tempFont ;
}

+ (FLYWORD_SIZE_TYPE)getFontTypeWithStr:(NSString *)sizeStr
{
    FLYWORD_SIZE_TYPE type ;
    if ([sizeStr isEqualToString:@"small"])
    {
        type = sizef_small ;
    }
    else if ([sizeStr isEqualToString:@"middle"])
    {
        type = sizef_middle ;
    }
    else if ([sizeStr isEqualToString:@"large"])
    {
        type = sizef_large ;
    }
    
    return type ;
}

@end
