//
//  SurveyResult.h
//  Test
//
//  Created by LiuTong on 16/10/11.
//  Copyright © 2016年 LiuTong. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <KinveyKit/KinveyKit.h>

@interface SurveyResult : NSObject <KCSPersistable>
@property (nonatomic, copy) NSString* entityId; //Kinvey entity _id
@property (nonatomic, copy) NSString* type;
@property (nonatomic, copy) NSArray* result;
@property (nonatomic, copy) NSNumber* questionNum;
@property (nonatomic, copy) NSString* username;
@property (nonatomic, retain) KCSMetadata* metadata; //Kinvey metadata, optional
@end
