//
//  URDeviceIdUUIDUtil.h
//  UUIDDemo
//
//  Created by weiyan on 12/12/2016.
//  Copyright © 2016 weiyan. All rights reserved.
//

// 使用当前库的时候，需要打开keychain shareing 选项，不然会有-34018 错误

#import <Foundation/Foundation.h>

@interface URDeviceIdUUIDUtil : NSObject

@property (nonatomic, strong) NSString *defaultDeviceId;

- (instancetype)initWithService:(NSString *) service withGroup:(NSString*)group;

- (NSString *)generatorDeviceId;

-(BOOL) insert:(NSString *)key data:(NSData *)data;

-(BOOL) update:(NSString *)key data:(NSData *) data;

-(BOOL) remove:(NSString*)key;

-(NSData*)find:(NSString*)key;

@end
