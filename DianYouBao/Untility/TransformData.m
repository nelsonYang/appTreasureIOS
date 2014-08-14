//
//  TransformData.m
//  WeiLe
//
//  Created by linger on 16/07/13.
//  Copyright (c) 2013年 Fujian Yidinghuo Network Technology Co; ltd. All rights reserved.
//

#import "TransformData.h"
#import "Base64.h"
#import "JSONKit.h"
#import "Encryption.h"
#import "CommonParam.h"
#import "NSDictionary+Helper.h"

@implementation TransformData

+ (NSMutableDictionary *)transformData:(int)encrypType dict:(NSDictionary *)dict
{
    id data = [dict objectForKey:@"data"];
    switch (encrypType) {
        case 0:
            {
                 return data;
            }
            break;
        case 1:
            {
                if ([data isKindOfClass:[NSString class]]) {
                    NSString *encryptStr = (NSString *)data;
                    if (encryptStr.length >0) {
                        NSData *base64Decode = [encryptStr base64DecodedData];
                        NSData *encryptData = [base64Decode AES256DecryptWithKey:[CommonParam sharedInstance].key];
                        return [encryptData objectFromJSONData];
                    }
                }
                else
                {
                    return nil;
                }
           
            
            }
            break;
        default:
                return nil;
            break;
    }
    return nil;
}

@end
