//
//  NewSurvey.h
//  Test
//
//  Created by LiuTong on 16/10/21.
//  Copyright © 2016年 LiuTong. All rights reserved.
//

#ifndef NewSurvey_h
#define NewSurvey_h
#import <Foundation/Foundation.h>
#import <KinveyKit/KinveyKit.h>

#endif /* NewSurvey_h */

@interface NewSurvey : NSObject <KCSPersistable>
@property (nonatomic, copy) NSString* entityId; //Kinvey entity _id
@property (nonatomic, copy) NSString* username;
@property (nonatomic, copy) NSNumber* type1Count;
@property (nonatomic, copy) NSNumber* type1Now;
@property (nonatomic, copy) NSNumber* type2Count;
@property (nonatomic, copy) NSNumber* type2Now;
@property (nonatomic, copy) NSNumber* type3Count;
@property (nonatomic, copy) NSNumber* type3Now;
@property (nonatomic, copy) NSNumber* type4Count;
@property (nonatomic, copy) NSNumber* type4Now;
@property (nonatomic, retain) KCSMetadata* metadata; //Kinvey metadata, optional
@end
