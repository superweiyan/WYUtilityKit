//
//  URDeviceIdUUIDUtil.m
//  UUIDDemo
//
//  Created by weiyan on 12/12/2016.
//  Copyright © 2016 weiyan. All rights reserved.
//

#import "URDeviceIdUUIDUtil.h"
#import <UIKit/UIDevice.h>

@interface URDeviceIdUUIDUtil()
{
    NSString * _service;
    NSString * _group;
}
@end

@implementation URDeviceIdUUIDUtil

- (instancetype)initWithService:(NSString *)service withGroup:(NSString*)group
{
    self = [super init];
    if (self) {
        
        _service = [NSString stringWithString:service];
        
        if(_group) {
            _group = [NSString stringWithString:group];
        }
    }
    return self;
}

-(NSMutableDictionary*) prepareDict:(NSString *) key
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    NSData *encodedKey = [key dataUsingEncoding:NSUTF8StringEncoding];
    [dict setObject:encodedKey forKey:(__bridge id)kSecAttrGeneric];
    [dict setObject:encodedKey forKey:(__bridge id)kSecAttrAccount];
    [dict setObject:_service forKey:(__bridge id)kSecAttrService];
    [dict setObject:(__bridge id)kSecAttrAccessibleAlwaysThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
    
    //This is for sharing data across apps
    if(_group != nil)
        [dict setObject:_group forKey:(__bridge id)kSecAttrAccessGroup];
    
    return  dict;
}

-(BOOL) insert:(NSString *)key data:(NSData *)data
{
    NSMutableDictionary * dict =[self prepareDict:key];
    [dict setObject:data forKey:(__bridge id)kSecValueData];
    
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)dict, NULL);
    if(errSecSuccess != status) {
        NSLog(@"Unable add item with key =%@ error:%d",key, (int)status);
    }
    return (errSecSuccess == status);
}

-(BOOL) update:(NSString*)key data:(NSData*) data
{
    NSMutableDictionary * dictKey =[self prepareDict:key];
    
    NSMutableDictionary * dictUpdate =[[NSMutableDictionary alloc] init];
    [dictUpdate setObject:data forKey:(__bridge id)kSecValueData];
    
    OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)dictKey, (__bridge CFDictionaryRef)dictUpdate);
    if(errSecSuccess != status) {
        NSLog(@"Unable add update with key =%@ error:%ld",key, (NSInteger)status);
    }
    return (errSecSuccess == status);
}

-(BOOL) remove: (NSString*)key
{
    NSMutableDictionary *dict = [self prepareDict:key];
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)dict);
    if( status != errSecSuccess) {
        NSLog(@"Unable to remove item for key %@ with error:%ld",key, (NSInteger)status);
        return NO;
    }
    return  YES;
}

-(NSData*) find:(NSString*)key
{
    NSMutableDictionary *dict = [self prepareDict:key];
    [dict setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [dict setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    CFTypeRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)dict,&result);
    
    if( status != errSecSuccess) {
        NSLog(@"Unable to fetch item for key %@ with error:%ld",key, (NSInteger)status);
        return nil;
    }
    
    return (__bridge NSData *)result;
}


- (NSString *)generatorDeviceId
{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}


@end
