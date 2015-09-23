





#import "DigitInformation.h"
#import "Reachability.h"
#import "YXSpritesLoadingView.h"
#import "NSObject+MKBlockTimer.h"
#import "ServerRequest.h"
#import "XTFileManager.h"
#import "CommonFunc.h"
#import "Acategory.h"

static DigitInformation *instance ;
static int timeCount = 0 ;

@implementation DigitInformation

+ (DigitInformation *)shareInstance
{
    if (instance == nil) {
        instance = [[[self class] alloc] init];
    }
    return instance;
}


#pragma mark --
#pragma mark - Setter

#pragma mark --
#pragma mark - Getter
- (NSString *)g_token
{
    if (!_g_token)
    {
        NSString *homePath = NSHomeDirectory() ;
        NSString *path     = [homePath stringByAppendingPathComponent:PATH_TOKEN_SAVE] ;
        if ([XTFileManager is_file_exist:path])
        {
            NSString *token = [XTFileManager getObjUnarchivePath:path] ;
            _g_token        = token ;
            NSLog(@"token : %@",token) ;
        }
        else
        {
            NSLog(@"未登录") ;
        }
    }
    
    return _g_token ;
}

- (User *)g_currentUser
{
    if (!_g_currentUser) {
        ResultParsered *result = [ServerRequest getMyIndexPersonalInfo] ;
        if (!result) return nil ;
        _g_currentUser = [[User alloc] initWithDic:result.info] ;
    }
    
    return _g_currentUser ;
}

- (BOOL)g_openAPPStore
{
// --- test BEGIN --- //
// --- Update In PrefixHeader.pch if necessary --- //
    if (DEVELOPER_MODE_SWITCHER) return YES ;
// --- Update In PrefixHeader.pch if necessary --- //
// --- test END --- //
    
    if (!_g_openAPPStore && !timeCount)
    {
        timeCount++ ;
        
//        CGFloat vers = [CommonFunc getVersionOfMyAPP] ;
        NSString *verstionStr = [CommonFunc getVersionStrOfMyAPP] ;
        ResultParsered *result = [ServerRequest getCheckSwitchWithCurrentAppVersion:verstionStr] ;
        if (!result) return NO ;
        _g_openAPPStore = [[result.info objectForKey:@"switch"] boolValue] ;
    }
    
    return _g_openAPPStore ;
}


#define KEY_UUID            @"uuid"

- (NSString *)uuid
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _uuid = [userDefaults objectForKey:KEY_UUID] ;
    if (!_uuid)
    {
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        //    NSString *uuid = (NSString *)CFUUIDCreateString(kCFAllocatorDefault,uuidRef) ;
        _uuid = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault,uuidRef)) ;
        [userDefaults setObject:_uuid forKey:KEY_UUID];
    }
    
    return _uuid ;
}


#define BUCKECT     @"social"
- (NSString *)token_QiNiuUpload
{
    ResultParsered *result = [ServerRequest getQiniuTokenWithBuckect:BUCKECT] ;
    if (!result.errCode)
    {
        // Success
        _token_QiNiuUpload = [result.info objectForKey:@"uptoken"] ;
    }
    else
    {
        // Fail
        return nil ;
    }
        
    return _token_QiNiuUpload ;
}

- (NSArray *)cateColors
{
    if (!_cateColors)
    {
        _cateColors = [[NSArray alloc] init] ;
        
        NSMutableArray *list = [NSMutableArray array] ;
        ResultParsered *result = [ServerRequest getCateTypeColor] ;
        for (NSDictionary *tempDic in (NSArray *)result.info)
        {
            Acategory *acate = [[Acategory alloc] initWithDic:tempDic] ;
            [list addObject:acate] ;
        }
        _cateColors = list ;
    }
    
    return _cateColors ;
}

@end


