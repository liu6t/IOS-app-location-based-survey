//
//  WorkLocation.m
//  Test
//
//  Created by LiuTong on 16/10/31.
//  Copyright © 2016年 LiuTong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WorkLocation.h"

@implementation WorkLocation

- (NSDictionary *)hostToKinveyPropertyMapping
{
    return @{
             @"entityId" : KCSEntityKeyId, //the required _id field
             @"longtitude" : @"longtitude",
             @"latitude" : @"latitude",
             @"username" : @"username",
             @"type" : @"type",
             @"metadata" : KCSEntityKeyMetadata //optional _metadata field
             };
}

@end
