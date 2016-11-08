//
//  AppDelegate.m
//  Test
//
//  Created by LiuTong on 16/10/7.
//  Copyright © 2016年 LiuTong. All rights reserved.
//

@import GoogleMaps;
@import GooglePlaces;

#import "AppDelegate.h"
#import "SurveyResult.h"
#import "NewSurvey.h"
#import "WorkLocation.h"
#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <KinveyKit/KinveyKit.h>

@interface AppDelegate ()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property BOOL deferringUpdates;
@property (nonatomic) NSTimer* locationUpdateTimer;
@property NSString *lastLocation;
@property NSString *nLocation;
@property BOOL type1;
@property BOOL type2;
@property BOOL type3;
@property BOOL type4;
@property BOOL canAdd;

@property (strong) NSNumber *longtitude;
@property (strong) NSNumber *latitude;
@property (strong) NSString *worktype;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    UIUserNotificationType types = (UIUserNotificationType) (UIUserNotificationTypeBadge |
                                                             UIUserNotificationTypeSound | UIUserNotificationTypeAlert);
    
    UIUserNotificationSettings *mySettings =
    [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    
    if (localNotif) {
        
        //load your controller
        NSDictionary *infoDic = localNotif.userInfo;    }
    
    
    if (self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    else {
        nil;
    }
    
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    else {
        nil;
    }
    
    if ([[UIDevice currentDevice].systemVersion floatValue] > 9)
    {
        [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    }
    
    self.locationManager.distanceFilter = 20;
    self.locationManager.pausesLocationUpdatesAutomatically = NO;
    [self.locationManager startUpdatingLocation];
    
    self.hasNot = false;
    self.canAdd = false;
    self.type1 = false;
    self.type2 = false;
    self.type3 = false;
    self.type4 = false;
    
    self.latitude = 0;
    self.longtitude = 0;
    self.worktype = @"";
    
    self.type = @"";
    
    // set alert at fixed time
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    
    // Get the current date
    NSDate *now = [NSDate date];
    
    // Break the date up into components
    NSDateComponents *dateComponents = [calendar components:( NSYearCalendarUnit |       NSMonthCalendarUnit |  NSDayCalendarUnit )
                                                   fromDate:now];
    
    NSDateComponents *timeComponents = [calendar components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit)
                                                   fromDate:now];
    
    
    // Set up the fire time
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    
    [dateComps setDay:[dateComponents day]];
    [dateComps setMonth:[dateComponents month]];
    [dateComps setYear:[dateComponents year]];
    
    [dateComps setHour:20];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    // Notification will fire in one minute
    
    NSDate *itemDate = [calendar dateFromComponents:dateComps];
    
    UILocalNotification *localNotif1 = [[UILocalNotification alloc] init];
    if (localNotif1 == nil)
        return YES;
    
    NSLog(@"set time: %@", itemDate);
    
    localNotif1.fireDate = itemDate;
    localNotif1.timeZone = [NSTimeZone defaultTimeZone];
    
    // Notification details
    localNotif1.alertBody = @"please finish the surveys if there's any";
    
    // Set the action button
    localNotif1.alertAction = @"View";
    localNotif1.repeatInterval = NSDayCalendarUnit;
    localNotif1.soundName = UILocalNotificationDefaultSoundName;
    localNotif1.regionTriggersOnce = true;
    
    // Schedule the notification
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif1];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    UIUserNotificationType types = (UIUserNotificationType) (UIUserNotificationTypeBadge |
                                                             UIUserNotificationTypeSound | UIUserNotificationTypeAlert);
    
    UIUserNotificationSettings *mySettings =
    [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    if (self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    else {
        nil;
    }
    
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    else {
        nil;
    }
    
    if ([[UIDevice currentDevice].systemVersion floatValue] > 9)
    {
        [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    }
    
    self.locationManager.distanceFilter = 20;
    self.locationManager.pausesLocationUpdatesAutomatically = NO;
    [self.locationManager startUpdatingLocation];
    
    self.lastLocation = @"";
    self.nLocation = @"";
    
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
/*    if([KCSUser activeUser] && self.latitude == 0) {
        NSMutableArray* array = [[NSMutableArray alloc] init];
        __block NSMutableArray* aarray = [[NSMutableArray alloc] init];
        [array addObject: [KCSUser activeUser].username];
        KCSAppdataStore *_store = [KCSAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName : @"WorkLocation", KCSStoreKeyCollectionTemplateClass : [WorkLocation class]}];
        [_store queryWithQuery:[KCSQuery queryOnField:@"username" usingConditional:kKCSIn forValue:array] withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            if (errorOrNil != nil) {
                //An error happened, just log for now
                NSLog(@"An error occurred on fetch: %@", errorOrNil);
            } else {
                //got all events back from server -- update table view
                [aarray setArray:objectsOrNil];
                
                if([aarray count] != 0) {
                    WorkLocation *n = aarray[0];
                    self.latitude = n.latitude;
                    self.longtitude = n.longtitude;
                    self.worktype = n.type;
                    NSLog(@"query: %@, %@, %@", self.longtitude, self.latitude, self.worktype);
                }
            }
        } withProgressBlock:nil];

    }*/
    
    CLLocation *newLocation = [locations lastObject];
    NSLog(@"didUpdateLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;

    
    if (currentLocation != nil) {
        float longtitude = currentLocation.coordinate.longitude;
        float latitude = currentLocation.coordinate.latitude;
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        double long_diff = fabs(longtitude - [[userDefaults stringForKey:@"longtitude"] doubleValue]);
        double lat_diff = fabs(latitude - [[userDefaults stringForKey:@"latitude"] doubleValue]);

        NSLog(@"long_diff:%f", long_diff);
        NSLog(@"lat_diff:%f", [[userDefaults stringForKey:@"latitude"] doubleValue]);
        if(long_diff < 0.001 && lat_diff < 0.001 && self.type2 == false) {
/*            NSMutableArray* array = [[NSMutableArray alloc] init];
            __block NSMutableArray* aarray = [[NSMutableArray alloc] init];
            [array addObject: [KCSUser activeUser].username];
            KCSAppdataStore *_store = [KCSAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName : @"NewSurvey", KCSStoreKeyCollectionTemplateClass : [NewSurvey class]}];
            [_store queryWithQuery:[KCSQuery queryOnField:@"username" usingConditional:kKCSIn forValue:array] withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                if (errorOrNil != nil) {
                    //An error happened, just log for now
                    NSLog(@"An error occurred on fetch: %@", errorOrNil);
                } else {
                    //got all events back from server -- update table view
                    [aarray setArray:objectsOrNil];
                    
                    if([aarray count] == 0) {
                        NewSurvey* newSurvey = [[NewSurvey alloc] init];
                        newSurvey.username = [KCSUser activeUser].username;
                        newSurvey.type1Now = [[NSNumber alloc] initWithInt:0];
                        newSurvey.type1Count = [[NSNumber alloc] initWithInt:2];
                        newSurvey.type2Now = [[NSNumber alloc] initWithInt:1];
                        newSurvey.type2Count = [[NSNumber alloc] initWithInt:1];
                        newSurvey.type3Now = [[NSNumber alloc] initWithInt:0];
                        newSurvey.type3Count = [[NSNumber alloc] initWithInt:2];
                        newSurvey.type4Now = [[NSNumber alloc] initWithInt:0];
                        newSurvey.type4Count = [[NSNumber alloc] initWithInt:2];
                        [_store saveObject:newSurvey withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                            if (errorOrNil != nil) {
                                //save failed
                                NSLog(@"Save failed, with error: %@", [errorOrNil localizedFailureReason]);
                            } else {
                                //save was successful
                                NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);
                                self.canAdd = true;
                                [self startShowingNotifications: @"Colleges and Universities": @"academic"];
                            }
                        } withProgressBlock:nil];
                    }
                    else {
                        NewSurvey *n = aarray[0];*/
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    

                        if([userDefaults integerForKey:@"typ2count"] > 0 && [userDefaults integerForKey:@"typ2now"] == 0) {
                            self.canAdd = true;
/*                            n.type2Now = [[NSNumber alloc] initWithInt:1];
                            n.type2Count = [[NSNumber alloc] initWithInt:[n.type2Count intValue]-1];
                            [_store saveObject:n withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                                if (errorOrNil != nil) {
                                    //save failed
                                    NSLog(@"Save failed, with error: %@", [errorOrNil localizedFailureReason]);
                                } else {
                                    //save was successful
                                    NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);
                                    [self startShowingNotifications: @"Colleges and Universities": @"academic"];                          }
                            } withProgressBlock:nil];*/
                            [userDefaults setInteger:[userDefaults integerForKey:@"typ2count"]-1 forKey:@"typ2count"];
                            [userDefaults setInteger:1 forKey:@"typ2now"];
                            NSString *notif = [NSString stringWithFormat:@"%@%@%@", @"A camera near ", [userDefaults stringForKey:@"place"], @" detected you passing by. We have a survey about their use of facial recognition. You can take it now or come back to the app later."];
                            [self startShowingNotifications: notif: [userDefaults stringForKey:@"place_type"]];
                        }
                        else
                        self.canAdd = false;
                        NSLog(@"query: %d", self.canAdd);
/*                    }
                }
            } withProgressBlock:nil];*/
        }
        
        
        NSString *url_string = [NSString stringWithFormat: @"https://privacyassistant.andrew.cmu.edu/study/placesnear?lat=%.8f&lon=%.8f&dist=10", latitude, longtitude];
        NSLog(@"lat%@", url_string);
        NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url_string]];
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSArray * address = [json valueForKey:@"address"];
        NSArray * category = [json valueForKey:@"category_labels"];
        NSArray * name = [json valueForKey:@"name"];

        if (address == nil || [address count] == 0)
            return;
        NSLog(@"address%@", name[0]);
//        [self startShowingNotifications: address[0]: @"address"];
    
        if ([KCSUser activeUser] && [category[0][0] containsObject: @"ATMs"] && self.type1 == false) {
            // if not exist, add
/*            NSMutableArray* array = [[NSMutableArray alloc] init];
            __block NSMutableArray* aarray = [[NSMutableArray alloc] init];
            [array addObject: [KCSUser activeUser].username];
            KCSAppdataStore *_store = [KCSAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName : @"NewSurvey", KCSStoreKeyCollectionTemplateClass : [NewSurvey class]}];
            [_store queryWithQuery:[KCSQuery queryOnField:@"username" usingConditional:kKCSIn forValue:array] withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                if (errorOrNil != nil) {
                    //An error happened, just log for now
                    NSLog(@"An error occurred on fetch: %@", errorOrNil);
                } else {
                    //got all events back from server -- update table view
                    [aarray setArray:objectsOrNil];
                    
                    if([aarray count] == 0) {
                        NewSurvey* newSurvey = [[NewSurvey alloc] init];
                        newSurvey.username = [KCSUser activeUser].username;
                        newSurvey.type1Now = [[NSNumber alloc] initWithInt:1];
                        newSurvey.type1Count = [[NSNumber alloc] initWithInt:1];
                        newSurvey.type2Now = [[NSNumber alloc] initWithInt:0];
                        newSurvey.type2Count = [[NSNumber alloc] initWithInt:2];
                        newSurvey.type3Now = [[NSNumber alloc] initWithInt:0];
                        newSurvey.type3Count = [[NSNumber alloc] initWithInt:2];
                        newSurvey.type4Now = [[NSNumber alloc] initWithInt:0];
                        newSurvey.type4Count = [[NSNumber alloc] initWithInt:2];
                        [_store saveObject:newSurvey withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                            if (errorOrNil != nil) {
                                //save failed
                                NSLog(@"Save failed, with error: %@", [errorOrNil localizedFailureReason]);
                            } else {
                                //save was successful
                                NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);
                                self.canAdd = true;
                                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                [userDefaults setObject:name[0] forKey:@"myString1"];
                                NSString *notif = [NSString stringWithFormat:@"%@%@%@", @"A camera near ", name[0], @" detected you passing by. We have a survey about it using facial recognition technology. You can take it now or come back to the app later"];
                                [self startShowingNotifications: notif: @"ATMs"];
                            }
                        } withProgressBlock:nil];
                    }
                    else {
                        NewSurvey *n = aarray[0];*/
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            
            if([userDefaults integerForKey:@"typ1count"] > 0 && [userDefaults integerForKey:@"typ1now"] == 0) {
                            self.canAdd = true;
                /*                            n.type2Now = [[NSNumber alloc] initWithInt:1];
                 n.type2Count = [[NSNumber alloc] initWithInt:[n.type2Count intValue]-1];
                 [_store saveObject:n withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                 if (errorOrNil != nil) {
                 //save failed
                 NSLog(@"Save failed, with error: %@", [errorOrNil localizedFailureReason]);
                 } else {
                 //save was successful
                 NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);
                 [self startShowingNotifications: @"Colleges and Universities": @"academic"];                          }
                 } withProgressBlock:nil];*/
                [userDefaults setInteger:[userDefaults integerForKey:@"typ1count"]-1 forKey:@"typ1count"];
                [userDefaults setInteger:1 forKey:@"typ1now"];
                [userDefaults setObject:name[0] forKey:@"myString1"];
                NSString *notif = [NSString stringWithFormat:@"%@%@%@", @"A camera near ", name[0], @" detected you passing by. We have a survey about their use of facial recognition. You can take it now or come back to the app later."];
                [self startShowingNotifications: notif: @"ATMs"];
                        }
                        else
                            self.canAdd = false;
                        NSLog(@"query: %d", self.canAdd);
/*                    }
                }
            } withProgressBlock:nil];*/

        }
        else if ([KCSUser activeUser] && [category[0][0] containsObject: @"Colleges and Universities"] && self.type2 == false) {
            // if not exist, add
            /*            NSMutableArray* array = [[NSMutableArray alloc] init];
             __block NSMutableArray* aarray = [[NSMutableArray alloc] init];
             [array addObject: [KCSUser activeUser].username];
             KCSAppdataStore *_store = [KCSAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName : @"NewSurvey", KCSStoreKeyCollectionTemplateClass : [NewSurvey class]}];
             [_store queryWithQuery:[KCSQuery queryOnField:@"username" usingConditional:kKCSIn forValue:array] withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
             if (errorOrNil != nil) {
             //An error happened, just log for now
             NSLog(@"An error occurred on fetch: %@", errorOrNil);
             } else {
             //got all events back from server -- update table view
             [aarray setArray:objectsOrNil];
             
             if([aarray count] == 0) {
             NewSurvey* newSurvey = [[NewSurvey alloc] init];
             newSurvey.username = [KCSUser activeUser].username;
             newSurvey.type1Now = [[NSNumber alloc] initWithInt:0];
             newSurvey.type1Count = [[NSNumber alloc] initWithInt:2];
             newSurvey.type2Now = [[NSNumber alloc] initWithInt:1];
             newSurvey.type2Count = [[NSNumber alloc] initWithInt:1];
             newSurvey.type3Now = [[NSNumber alloc] initWithInt:0];
             newSurvey.type3Count = [[NSNumber alloc] initWithInt:2];
             newSurvey.type4Now = [[NSNumber alloc] initWithInt:0];
             newSurvey.type4Count = [[NSNumber alloc] initWithInt:2];
             [_store saveObject:newSurvey withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
             if (errorOrNil != nil) {
             //save failed
             NSLog(@"Save failed, with error: %@", [errorOrNil localizedFailureReason]);
             } else {
             //save was successful
             NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);
             self.canAdd = true;
             [self startShowingNotifications: @"Colleges and Universities": @"academic"];
             }
             } withProgressBlock:nil];
             }
             else {
             NewSurvey *n = aarray[0];*/
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            
            if([userDefaults integerForKey:@"typ2count"] > 0 && [userDefaults integerForKey:@"typ2now"] == 0) {
                self.canAdd = true;
                /*                            n.type2Now = [[NSNumber alloc] initWithInt:1];
                 n.type2Count = [[NSNumber alloc] initWithInt:[n.type2Count intValue]-1];
                 [_store saveObject:n withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                 if (errorOrNil != nil) {
                 //save failed
                 NSLog(@"Save failed, with error: %@", [errorOrNil localizedFailureReason]);
                 } else {
                 //save was successful
                 NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);
                 [self startShowingNotifications: @"Colleges and Universities": @"academic"];                          }
                 } withProgressBlock:nil];*/
                [userDefaults setInteger:[userDefaults integerForKey:@"typ2count"]-1 forKey:@"typ2count"];
                [userDefaults setInteger:1 forKey:@"typ2now"];
                [userDefaults setObject:name[0] forKey:@"myString2"];
                NSString *notif = [NSString stringWithFormat:@"%@%@%@", @"A camera near ", name[0], @" detected you passing by. We have a survey about their use of facial recognition. You can take it now or come back to the app later."];
                [self startShowingNotifications: notif: @"academic"];            }
            else
                self.canAdd = false;
            NSLog(@"query: %d", self.canAdd);
            /*                    }
             }
             } withProgressBlock:nil];*/

            
        }
        else if ([KCSUser activeUser] && [category[0][0] containsObject: @"Social"] && self.type3 == false) {
            // if not exist, add
            /*            NSMutableArray* array = [[NSMutableArray alloc] init];
             __block NSMutableArray* aarray = [[NSMutableArray alloc] init];
             [array addObject: [KCSUser activeUser].username];
             KCSAppdataStore *_store = [KCSAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName : @"NewSurvey", KCSStoreKeyCollectionTemplateClass : [NewSurvey class]}];
             [_store queryWithQuery:[KCSQuery queryOnField:@"username" usingConditional:kKCSIn forValue:array] withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
             if (errorOrNil != nil) {
             //An error happened, just log for now
             NSLog(@"An error occurred on fetch: %@", errorOrNil);
             } else {
             //got all events back from server -- update table view
             [aarray setArray:objectsOrNil];
             
             if([aarray count] == 0) {
             NewSurvey* newSurvey = [[NewSurvey alloc] init];
             newSurvey.username = [KCSUser activeUser].username;
             newSurvey.type1Now = [[NSNumber alloc] initWithInt:0];
             newSurvey.type1Count = [[NSNumber alloc] initWithInt:2];
             newSurvey.type2Now = [[NSNumber alloc] initWithInt:1];
             newSurvey.type2Count = [[NSNumber alloc] initWithInt:1];
             newSurvey.type3Now = [[NSNumber alloc] initWithInt:0];
             newSurvey.type3Count = [[NSNumber alloc] initWithInt:2];
             newSurvey.type4Now = [[NSNumber alloc] initWithInt:0];
             newSurvey.type4Count = [[NSNumber alloc] initWithInt:2];
             [_store saveObject:newSurvey withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
             if (errorOrNil != nil) {
             //save failed
             NSLog(@"Save failed, with error: %@", [errorOrNil localizedFailureReason]);
             } else {
             //save was successful
             NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);
             self.canAdd = true;
             [self startShowingNotifications: @"Colleges and Universities": @"academic"];
             }
             } withProgressBlock:nil];
             }
             else {
             NewSurvey *n = aarray[0];*/
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSLog(@"current count: %ld", (long)[userDefaults integerForKey:@"typ3now"]);
            NSLog(@"current count: %ld", (long)[userDefaults integerForKey:@"typ3count"]);
            
            if([userDefaults integerForKey:@"typ3count"] > 0 && [userDefaults integerForKey:@"typ3now"] == 0) {
                self.canAdd = true;
                /*                            n.type2Now = [[NSNumber alloc] initWithInt:1];
                 n.type2Count = [[NSNumber alloc] initWithInt:[n.type2Count intValue]-1];
                 [_store saveObject:n withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                 if (errorOrNil != nil) {
                 //save failed
                 NSLog(@"Save failed, with error: %@", [errorOrNil localizedFailureReason]);
                 } else {
                 //save was successful
                 NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);
                 [self startShowingNotifications: @"Colleges and Universities": @"academic"];                          }
                 } withProgressBlock:nil];*/
                [userDefaults setInteger:[userDefaults integerForKey:@"typ3count"]-1 forKey:@"typ3count"];
                [userDefaults setInteger:1 forKey:@"typ3now"];
                [userDefaults setObject:name[0] forKey:@"myString3"];
                NSString *notif = [NSString stringWithFormat:@"%@%@%@", @"A camera near ", name[0], @" detected you passing by. We have a survey about their use of facial recognition. You can take it now or come back to the app later."];
                [self startShowingNotifications: notif: @"Restaurants"];
            }
            else
                self.canAdd = false;
            NSLog(@"query: %d", self.canAdd);
            /*                    }
             }
             } withProgressBlock:nil];*/
        }
        else if ([KCSUser activeUser] && [category[0][0] containsObject: @"Supermarkets and Groceries"] && self.type4 == false) {
            // if not exist, add
            /*            NSMutableArray* array = [[NSMutableArray alloc] init];
             __block NSMutableArray* aarray = [[NSMutableArray alloc] init];
             [array addObject: [KCSUser activeUser].username];
             KCSAppdataStore *_store = [KCSAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName : @"NewSurvey", KCSStoreKeyCollectionTemplateClass : [NewSurvey class]}];
             [_store queryWithQuery:[KCSQuery queryOnField:@"username" usingConditional:kKCSIn forValue:array] withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
             if (errorOrNil != nil) {
             //An error happened, just log for now
             NSLog(@"An error occurred on fetch: %@", errorOrNil);
             } else {
             //got all events back from server -- update table view
             [aarray setArray:objectsOrNil];
             
             if([aarray count] == 0) {
             NewSurvey* newSurvey = [[NewSurvey alloc] init];
             newSurvey.username = [KCSUser activeUser].username;
             newSurvey.type1Now = [[NSNumber alloc] initWithInt:0];
             newSurvey.type1Count = [[NSNumber alloc] initWithInt:2];
             newSurvey.type2Now = [[NSNumber alloc] initWithInt:1];
             newSurvey.type2Count = [[NSNumber alloc] initWithInt:1];
             newSurvey.type3Now = [[NSNumber alloc] initWithInt:0];
             newSurvey.type3Count = [[NSNumber alloc] initWithInt:2];
             newSurvey.type4Now = [[NSNumber alloc] initWithInt:0];
             newSurvey.type4Count = [[NSNumber alloc] initWithInt:2];
             [_store saveObject:newSurvey withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
             if (errorOrNil != nil) {
             //save failed
             NSLog(@"Save failed, with error: %@", [errorOrNil localizedFailureReason]);
             } else {
             //save was successful
             NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);
             self.canAdd = true;
             [self startShowingNotifications: @"Colleges and Universities": @"academic"];
             }
             } withProgressBlock:nil];
             }
             else {
             NewSurvey *n = aarray[0];*/
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            NSLog(@"current count: %ld", (long)[userDefaults integerForKey:@"typ4now"]);
            NSLog(@"current count: %ld", (long)[userDefaults integerForKey:@"typ4count"]);

            if([userDefaults integerForKey:@"typ4count"] > 0 && [userDefaults integerForKey:@"typ4now"] == 0) {
                self.canAdd = true;
                /*                            n.type2Now = [[NSNumber alloc] initWithInt:1];
                 n.type2Count = [[NSNumber alloc] initWithInt:[n.type2Count intValue]-1];
                 [_store saveObject:n withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                 if (errorOrNil != nil) {
                 //save failed
                 NSLog(@"Save failed, with error: %@", [errorOrNil localizedFailureReason]);
                 } else {
                 //save was successful
                 NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);
                 [self startShowingNotifications: @"Colleges and Universities": @"academic"];                          }
                 } withProgressBlock:nil];*/
                [userDefaults setInteger:[userDefaults integerForKey:@"typ4count"]-1 forKey:@"typ4count"];
                [userDefaults setInteger:1 forKey:@"typ4now"];
                [userDefaults setObject:name[0] forKey:@"myString4"];
                NSString *notif = [NSString stringWithFormat:@"%@%@%@", @"A camera near ", name[0], @" detected you passing by. We have a survey about their use of facial recognition. You can take it now or come back to the app later."];
                [self startShowingNotifications: notif: @"grocery"];
            }
            else
                self.canAdd = false;
            NSLog(@"query: %d", self.canAdd);
            /*                    }
             }
             } withProgressBlock:nil];*/
        }


        
        
        // distinguish category of nearest location
        
        // add survey content
        
/*        if (address != nil && [address count] > 0) {
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            [appDelegate.titleArray addObject: @"Do you think this is a good method of verifying the identity of bank customers?"];
            [appDelegate.titleArray addObject: @"According to you, what is a reasonable time for the bank to retain the information collected?"];
            [appDelegate.titleArray addObject: address[0]];
            
            [appDelegate.optionArray addObject: @[@"Yes", @"No"]];
            [appDelegate.optionArray addObject: @[@"less than 3 months", @"3-12 months", @"more than 1 year", @"forever"]];
            [appDelegate.optionArray addObject: @[]];
            [appDelegate.typeArray addObject: @(1)];
            [appDelegate.typeArray addObject: @(2)];
            [appDelegate.typeArray addObject: @(3)];
            
            NSLog(@"added");
            
            NSLog(@"address%@", address[0]);
            [self startShowingNotifications: address[0]]; // Custom method defined below
            self.nLocation =address[0];
            
            KCSAppdataStore *_store = [KCSAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName : @"Location", KCSStoreKeyCollectionTemplateClass : [SurveyResult class]}];
            SurveyResult* survey = [[SurveyResult alloc] init];
            survey.type = @"";
            survey.result = address[0];
            survey.username = [KCSUser activeUser].username;
            survey.questionNum = [[NSNumber alloc] initWithInt:0];
            [_store saveObject:survey withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                if (errorOrNil != nil) {
                    //save failed
                    NSLog(@"Save failed, with error: %@", [errorOrNil localizedFailureReason]);
                } else {
                    //save was successful
                    NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);
                }
            } withProgressBlock:nil];
        
        }
        else {
            KCSAppdataStore *_store = [KCSAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName : @"Location", KCSStoreKeyCollectionTemplateClass : [SurveyResult class]}];
            SurveyResult* survey = [[SurveyResult alloc] init];
            survey.type = @"";
            survey.result = @"moving";
            survey.username = [KCSUser activeUser].username;
            survey.questionNum = [[NSNumber alloc] initWithInt:0];
            [_store saveObject:survey withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                if (errorOrNil != nil) {
                    //save failed
                    NSLog(@"Save failed, with error: %@", [errorOrNil localizedFailureReason]);
                } else {
                    //save was successful
                    NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);
                }
            } withProgressBlock:nil];
        }*/
        
    }
}

- (void)startShowingNotifications: (NSString*) con: (NSString*) t {
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = con;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.regionTriggersOnce = YES;
    localNotification.alertAction = @"Get survey now";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:t,@"type", nil];
    localNotification.userInfo = infoDic;
    
    [localNotification setHasAction:YES];
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

-(void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif {
    
    //load your controller
    self.hasNot = true;
    UIApplicationState state = [app applicationState];
    if (state == UIApplicationStateInactive) {
        // Application was in the background when notification was delivered.
        
        NSDictionary *infoDic = notif.userInfo;
        NSLog(@"current type1: %@", infoDic[@"type"]);
        self.type =infoDic[@"type"];
        ViewController *obj = [[ViewController alloc]init];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshView" object:nil];
    } else {
    }
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"back");
    self.type = @"";
    ViewController *obj = [[ViewController alloc]init];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshView1" object:nil];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


// test : https://privacyassistant.andrew.cmu.edu/study/placesnear?lat=40.440744&lon=-79.957859&dist=10
// test : https://privacyassistant.andrew.cmu.edu/study/placesnear?lat=40.45151&lon=-79.999627&dist=10

@end
