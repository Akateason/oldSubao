//
//  ArticleComment.h
//  SuBaoJiang
//
//  Created by apple on 15/6/5.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FONT_SIZE_SMALL         16.0f
#define FONT_SIZE_MIDDLE        20.0f
#define FONT_SIZE_LARGE         26.0f

typedef enum {
    colorf_white = 0 ,  //DEFAULT
    colorf_red ,
    colorf_yellow ,
    colorf_green ,
    colorf_blue ,
    colorf_purple
} FLYWORD_COLOR_TYPE ;

typedef enum {
    sizef_small = -1,
    sizef_middle ,      //DEFAULT
    sizef_large ,
} FLYWORD_SIZE_TYPE ;  // -1, 0 ,1

@class User ;

@interface ArticleComment : NSObject

@property (nonatomic,strong)    User        *userCurrent ;

@property (nonatomic)           int         c_id ;
@property (nonatomic,copy)      NSString    *c_content ;
@property (nonatomic,copy)      NSString    *c_color ;
@property (nonatomic,copy)      NSString    *c_size ;
@property (nonatomic,copy)      NSString    *c_position ;
@property (nonatomic)           long long   c_createtime ;
@property (nonatomic)           BOOL        is_author ;

@property (nonatomic)           int         reply_u_id ;
@property (nonatomic)           int         a_id ;
@property (nonatomic,copy)      NSString    *img ;

//ADD20150717 BEGIN
@property (nonatomic,copy)      NSString    *reply_u_nickname ;
@property (nonatomic,copy)      NSString    *showStrComment ;
//ADD20150717 END

//ADD20150720 BEGIN
@property (nonatomic)           BOOL        isPostedImmediately ; // controlling fly word's border show or not . DEFAULT is NO .
//ADD20150720 END

#pragma mark --
- (instancetype)initWithDic:(NSDictionary *)dic ;
- (instancetype)initWithMsgDic:(NSDictionary *)dic ;

+ (NSArray *)getCommentListWithDictList:(NSArray *)tempCommentList ;

- (instancetype)initWithCommentID:(int)commentID
                   AndWithContent:(NSString *)content
                  AndWithColorStr:(NSString *)colorStr
                   AndWithSizeStr:(NSString *)sizeStr
               AndWithPositionStr:(NSString *)positionStr
                           AndAID:(int)aid ;
#pragma mark --
+ (NSString *)getcolorStrWithEnum:(FLYWORD_COLOR_TYPE)type ;
+ (UIImage *)getUIImageOfColorWithEnum:(FLYWORD_COLOR_TYPE)type ;
+ (UIColor *)getUIColorWithEnum:(FLYWORD_COLOR_TYPE)type ;
+ (FLYWORD_COLOR_TYPE)getColorTypeWithStr:(NSString *)colorStr ;

#pragma mark --
+ (NSString *)getSizeStrWithFlywordEnum:(FLYWORD_SIZE_TYPE)type ;
+ (UIImage *)getUIImageOfSizeWithEnum:(FLYWORD_SIZE_TYPE)type ;
+ (UIFont *)getUIFontWithEnum:(FLYWORD_SIZE_TYPE)type ;
+ (FLYWORD_SIZE_TYPE)getFontTypeWithStr:(NSString *)sizeStr ;

@end
