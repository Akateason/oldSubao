//
//  AliOrder.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-24.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "AliOrder.h"







@implementation AliOrder

- (NSString *)description
{
    NSMutableString * discription = [NSMutableString string];
    if (self.partner) {
        [discription appendFormat:@"partner=\"%@\"", self.partner];
    }
    
    if (self.seller) {
        [discription appendFormat:@"&seller_id=\"%@\"", self.seller];
    }
    if (self.tradeNO) {
        [discription appendFormat:@"&out_trade_no=\"%@\"", self.tradeNO];
    }
    if (self.productName) {
        [discription appendFormat:@"&subject=\"%@\"", self.productName];
    }
    
    if (self.productDescription) {
        [discription appendFormat:@"&body=\"%@\"", self.productDescription];
    }
    if (self.amount) {
        [discription appendFormat:@"&total_fee=\"%@\"", self.amount];
    }
    if (self.notifyURL) {
        [discription appendFormat:@"&notify_url=\"%@\"", self.notifyURL];
    }
    
    if (self.service) {
        [discription appendFormat:@"&service=\"%@\"",self.service];//mobile.securitypay.pay
    }
    if (self.paymentType) {
        [discription appendFormat:@"&payment_type=\"%@\"",self.paymentType];//1
    }
    
    if (self.inputCharset) {
        [discription appendFormat:@"&_input_charset=\"%@\"",self.inputCharset];//utf-8
    }
    if (self.itBPay) {
        [discription appendFormat:@"&it_b_pay=\"%@\"",self.itBPay];//30m
    }
    if (self.showUrl) {
        [discription appendFormat:@"&show_url=\"%@\"",self.showUrl];//m.alipay.com
    }
    if (self.rsaDate) {
        [discription appendFormat:@"&sign_date=\"%@\"",self.rsaDate];
    }
    if (self.appID) {
        [discription appendFormat:@"&app_id=\"%@\"",self.appID];
    }
    for (NSString * key in [self.extraParams allKeys]) {
        [discription appendFormat:@"&%@=\"%@\"", key, [self.extraParams objectForKey:key]];
    }
    return discription;
}




/*
- (instancetype)initWithPayment:(Payment *)payment
{
    self = [super init];
    if (self)
    {

        _partner            = ALI_PARTNER                                                         ;
        _seller             = ALI_SELLER                                                          ;
        
        _tradeNO            = payment.ordersCode     ; //订单ID（由商家自行制定）
        _productName        = payment.subject        ; //商品标题
        _productDescription = payment.subject        ; //商品描述
        
#pragma mark ----- 暂时价格 -----
        //商品价格 暂时设为1分.
        _amount             = [NSString stringWithFormat:@"%.2f",payment.price];          //sumPrice //@"0.01" ;
#pragma mark ----- 暂时价格 -----
        
        //回调URL
        _notifyURL          = payment.notifyUrl ;
        
        _service            = @"mobile.securitypay.pay" ;
        _paymentType        = @"1"                      ;
        _inputCharset       = @"utf-8"                  ;
        _itBPay             = @"30m"                    ;
        _showUrl            = @"m.alipay.com"           ;
        
    }
    
    return self;
}
*/

@end
