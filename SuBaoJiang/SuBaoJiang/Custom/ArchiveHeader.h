//
//  ArchiveHeader.h
//  SuBaoJiang
//
//  Created by apple on 15/7/13.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#ifndef SuBaoJiang_ArchiveHeader_h
#define SuBaoJiang_ArchiveHeader_h


/*
 * SAVE token FILE
 **/
#define PATH_TOKEN_SAVE             @"Documents/tokenArchive.archive"

/*
 * SAVE Bind mode
 Archive NSNumber ;
 mode_weibo      = 1 ,
 mode_weixin     = 2
 **/
#define PATH_BIND_SAVE              @"Documents/bindArchive.archive"

/*
 ** SDWebImageCache
 */
#define PATH_IMG_CACHE              @"Library/Caches/com.hackemist.SDWebImageCache.default"

/*
 ** SETTING IMG SIZE  0智能,1高质量,2普通
 */
#define PATH_SETTING_IMG_SIZE       @"Documents/settingImgMode.archive"

/*
 *  SQLITEPATH 
 */
#define SQLITEPATH                  @"subaojiang.sqlite"

#endif
