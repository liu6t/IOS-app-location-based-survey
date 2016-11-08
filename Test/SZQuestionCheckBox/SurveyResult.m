//
//  SurveyResult.m
//  Test
//
//  Created by LiuTong on 16/10/11.
//  Copyright © 2016年 LiuTong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SurveyResult.h"

@implementation SurveyResult

- (NSDictionary *)hostToKinveyPropertyMapping
{
    return @{
             @"entityId" : KCSEntityKeyId, //the required _id field
             @"type" : @"type",
             @"result" : @"result",
             @"questionNum" : @"questionNum",
             @"username" : @"username",
             @"metadata" : KCSEntityKeyMetadata //optional _metadata field
             };
}

@end
