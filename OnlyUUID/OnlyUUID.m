//
//  OnlyUUID.m
//  OnlyUUID
//
//  Created by WzxJiang on 16/10/12.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import "OnlyUUID.h"

@implementation OnlyUUID

NSString * const KEY_CHAIN_ONLY_UUID = @"KEY_CHAIN_ONLY_UUID";

+ (NSString *)uuid {
    NSString * load_uuid = [OnlyKeyChain load:KEY_CHAIN_ONLY_UUID];
    if (load_uuid.length <= 0) {
        load_uuid = [[NSUUID UUID] UUIDString];
        // I think in this place and the need to compare the server is the only
        [OnlyKeyChain save:KEY_CHAIN_ONLY_UUID data:load_uuid];
    }
    return load_uuid;
}

@end


#import <Security/Security.h>

@implementation OnlyKeyChain

+ (void)save:(NSString *)service data:(id)data {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

+ (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (void)deleteKey:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

@end
