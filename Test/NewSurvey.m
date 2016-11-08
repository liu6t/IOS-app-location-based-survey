//
//  NewSurvey.m
//  Test
//
//  Created by LiuTong on 16/10/21.
//  Copyright © 2016年 LiuTong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NewSurvey.h"

@implementation NewSurvey

- (NSDictionary *)hostToKinveyPropertyMapping
{
    return @{
             @"entityId" : KCSEntityKeyId, //the required _id field
             @"username" : @"username",
             @"type1Count" : @"type1Count",
             @"type1Now" : @"type1Now",
             @"type2Count" : @"type2Count",
             @"type2Now" : @"type2Now",
             @"type3Count" : @"type3Count",
             @"type3Now" : @"type3Now",
             @"type4Count" : @"type4Count",
             @"type4Now" : @"type4Now",
             @"metadata" : KCSEntityKeyMetadata //optional _metadata field
             };
}

@end
