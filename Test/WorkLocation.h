//
//  WorkLocation.h
//  Test
//
//  Created by LiuTong on 16/10/31.
//  Copyright © 2016年 LiuTong. All rights reserved.
//

#ifndef WorkLocation_h
#define WorkLocation_h


#endif /* WorkLocation_h */
#import <KinveyKit/KinveyKit.h>

@interface WorkLocation : NSObject <KCSPersistable>
@property (nonatomic, copy) NSString* entityId; //Kinvey entity _id
@property (nonatomic, copy) NSNumber* longtitude;
@property (nonatomic, copy) NSNumber* latitude;
@property (nonatomic, copy) NSString* username;
@property (nonatomic, copy) NSString* type;
@property (nonatomic, retain) KCSMetadata* metadata; //Kinvey metadata, optional
@end
