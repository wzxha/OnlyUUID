//
//  OnlyUUID.h
//  OnlyUUID
//
//  Created by WzxJiang on 16/10/12.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OnlyUUID : NSObject

+ (NSString *)uuid;

@end


@interface OnlyKeyChain : NSObject

+ (void)save:(NSString *)service
        data:(id)data;

+ (id)load:(NSString *)service;

+ (void)deleteKey:(NSString *)service;

@end
