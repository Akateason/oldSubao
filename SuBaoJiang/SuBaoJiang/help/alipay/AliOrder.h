//
//  AliOrder.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-24.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//


#define ALI_PARTNER     @"2088511341854165"
#define ALI_SELLER      @"payment@jingubang.com"
#define ALI_PRIVATEKEY  @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAL2GYZcbnxoQ2Bsjy4/UhU+LzoO8OD3aqs8j+2UHYqDM05j3Ytq9g8NQdeKpXVbTgCahWvEfbSRtgmFZsuvTsAjp7uDtRgeZ+RfKxt6LmCB6PJGt2kfD+SUu+ksETnfj2ua6L0Gv01yQG3eHU4a+fQcV1ppjSyt1agfvoQLasmMNAgMBAAECgYEAi31bWGcY+4tIMvlueka1c213qpeeYVAOhXR7M8lyutzmI+B4Hnx7fQY8LX3v19bErCn4EB3MK5J58oKdYFqmZTMNvxubNoeK6FOfuth94Vw6eAsSmvIJYrVXrb7TGzSW0SbomnRR/2JFbC46ydJA10myw+U756+YcRsgfgEydjUCQQD09m+ztiJiLkZEFZvuyUyctW5MnY6/XkFxFtpBLcSd4gmbnhDoSENxFeDbvZ9A4JoP/GiZ5Cwt2+tpPRQthPxTAkEAxhB9MOjPBh5TMqJi8vP1ZuNnsBchc93Wfv0uP3Kn/dRGuJ/4NtH1R3sUi+f6EkxYgHUFy0r1eWP07H7KyNY3HwJADA7dbME4bBDPEKbnqBdsmAIuTcMrtavUGNcBI1g3Z3Yq9ugO+QAloblr+iUZY74ql0Lbe0fKDO/YZLPG/H6hVQJAC2+YSuKmUWwe0aWeoPiFCtPGgNxVCiOc5ugna3JrULSZAL/7zO6CgwYQQaO7RKMz2PboxrwlQEUNNzp66u2zcQJBAKmLYDgPS3GAVwMgbk43XQ3NerxmGnwq311pSGYZN8mvd2CXoySQx+bzt/08BmY6OiMRdxKwFPM4bvc/Lo2rAQE="


#import <Foundation/Foundation.h>
//#import "Payment.h"

@interface AliOrder : NSObject

@property(nonatomic, copy) NSString * partner;
@property(nonatomic, copy) NSString * seller;
@property(nonatomic, copy) NSString * tradeNO;
@property(nonatomic, copy) NSString * productName;
@property(nonatomic, copy) NSString * productDescription;
@property(nonatomic, copy) NSString * amount;
@property(nonatomic, copy) NSString * notifyURL;

@property(nonatomic, copy) NSString * service;
@property(nonatomic, copy) NSString * paymentType;
@property(nonatomic, copy) NSString * inputCharset;
@property(nonatomic, copy) NSString * itBPay;
@property(nonatomic, copy) NSString * showUrl;


@property(nonatomic, copy) NSString * rsaDate;//可选
@property(nonatomic, copy) NSString * appID;//可选

@property(nonatomic, readonly) NSMutableDictionary * extraParams;


//- (instancetype)initWithPayment:(Payment *)payment ;


@end
