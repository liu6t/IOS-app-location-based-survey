//
//  ViewController.m
//  Test
//
//  Created by LiuTong on 16/10/7.
//  Copyright © 2016年 LiuTong. All rights reserved.
//

#import "ViewController.h"
#import "SZQuestionCheckBox.h"
#import "AppDelegate.h"
#import "NewSurvey.h"

#import <CoreLocation/CoreLocation.h>
#import <KinveyKit/KinveyKit.h>
@import GooglePlaces;

@interface ViewController ()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property BOOL deferringUpdates;
@property (nonatomic) NSTimer* locationUpdateTimer;


@property (nonatomic, strong, nonnull) SZQuestionCheckBox *questionBox;
@property (nonatomic, strong) NSArray *resultArray;

@property (strong) NSString *current_id;
@property (strong) NSString *type;

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *optionArray;
@property (nonatomic, strong) NSMutableArray *typeArray;
@property (strong) NSString *surveytype;

@property UIButton *surveyATMButton;
@property UIButton *surveyAcademicButton;
@property UIButton *surveyCafeButton;
@property UIButton *surveyGroceryButton;

@end

@implementation ViewController {
GMSPlacesClient *_placesClient;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

//    _placesClient = [GMSPlacesClient sharedClient];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView:) name:@"refreshView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView1:) name:@"refreshView1" object:nil];
    
    
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 50, 200, 50)];
    countLabel.text = @"available surveys:";
    countLabel.font=[UIFont boldSystemFontOfSize:20.0];
    countLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:countLabel];
    NSLog(@"...");
    // first time, ask input id
    if ([self hasLaunched] == NO) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setInteger:2 forKey:@"typ1count"];
        [userDefaults setInteger:0 forKey:@"typ1now"];
        [userDefaults setInteger:2 forKey:@"typ2count"];
        [userDefaults setInteger:0 forKey:@"typ2now"];
        [userDefaults setInteger:2 forKey:@"typ3count"];
        [userDefaults setInteger:0 forKey:@"typ3now"];
        [userDefaults setInteger:2 forKey:@"typ4count"];
        [userDefaults setInteger:0 forKey:@"typ4now"];
        
        self.titleArray = [[NSMutableArray alloc] init];
        self.optionArray = [[NSMutableArray alloc] init];
        self.typeArray = [[NSMutableArray alloc] init];
        
        [self.titleArray addObject: @""];
        [self.optionArray addObject: @[]];
        [self.typeArray addObject: @(1)];
        [self.titleArray addObject: @""];
        [self.optionArray addObject: @[]];
        [self.typeArray addObject: @(1)];
        
        [self.titleArray addObject: @"Please input your id: "];
        [self.optionArray addObject: @[]];
        [self.typeArray addObject: @(3)];
        
        [self.titleArray addObject: @"longtitude: "];
        [self.optionArray addObject: @[]];
        [self.typeArray addObject: @(3)];
        
        [self.titleArray addObject: @"latitude: "];
        [self.optionArray addObject: @[]];
        [self.typeArray addObject: @(3)];
        
        [self.titleArray addObject: @"place: "];
        [self.optionArray addObject: @[]];
        [self.typeArray addObject: @(3)];
        
        [self.titleArray addObject: @"type: "];
        [self.optionArray addObject: @[]];
        [self.typeArray addObject: @(3)];
        [self.titleArray addObject: @""];
        [self.optionArray addObject: @[]];
        [self.typeArray addObject: @(1)];
        
        SZQuestionItem *item = [[SZQuestionItem alloc] initWithTitleArray:self.titleArray andOptionArray:self.optionArray andResultArray: self.resultArray andQuestonTypes:self.typeArray];
        
        self.questionBox = [[SZQuestionCheckBox alloc] initWithItem:item];
        [self.questionBox setIsFirst:true];
        [self.questionBox setType:@"first"];

        
        self.titleArray = [[NSMutableArray alloc] init];
        self.optionArray = [[NSMutableArray alloc] init];
        self.typeArray = [[NSMutableArray alloc] init];
        
        
        
        [self.view addSubview:self.questionBox.view];
        
    }
    
    // if not log in
    else if (![KCSUser activeUser]) {
        //show log-in views
        self.titleArray = [[NSMutableArray alloc] init];
        self.optionArray = [[NSMutableArray alloc] init];
        self.typeArray = [[NSMutableArray alloc] init];
        
        [self.titleArray addObject: @""];
        [self.optionArray addObject: @[]];
        [self.typeArray addObject: @(1)];
        [self.titleArray addObject: @""];
        [self.optionArray addObject: @[]];
        [self.typeArray addObject: @(1)];
        [self.titleArray addObject: @"Please log in with your id: "];
        [self.optionArray addObject: @[]];
        [self.typeArray addObject: @(3)];
        
        [self.titleArray addObject: @""];
        [self.optionArray addObject: @[]];
        [self.typeArray addObject: @(1)];
        
        SZQuestionItem *item = [[SZQuestionItem alloc] initWithTitleArray:self.titleArray andOptionArray:self.optionArray andResultArray: self.resultArray andQuestonTypes:self.typeArray];
        
        self.questionBox = [[SZQuestionCheckBox alloc] initWithItem:item];
        [self.questionBox setIsFirst:false];
        [self.questionBox setIsLog:true];
        
        self.titleArray = [[NSMutableArray alloc] init];
        self.optionArray = [[NSMutableArray alloc] init];
        self.typeArray = [[NSMutableArray alloc] init];
        
        [self.view addSubview:self.questionBox.view];
    }
    else {
        
        self.titleArray = [[NSMutableArray alloc] init];
        self.optionArray = [[NSMutableArray alloc] init];
        self.typeArray = [[NSMutableArray alloc] init];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

        if([userDefaults integerForKey:@"typ1now"] > 0) {
        CGRect frame1 = CGRectMake(50, 150, 300, 50);
        self.surveyATMButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.surveyATMButton.backgroundColor = [UIColor clearColor];
        self.surveyATMButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
        [self.surveyATMButton setTitle:@"get ATM survey" forState:UIControlStateNormal];
        self.surveyATMButton.frame = frame1;
        [self.surveyATMButton addTarget:self action:@selector(getSurveyATM) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.surveyATMButton];
        }
        
        if([userDefaults integerForKey:@"typ2now"] > 0) {
        CGRect frame2 = CGRectMake(25, 250, 300, 50);
        self.surveyAcademicButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.surveyAcademicButton.backgroundColor = [UIColor clearColor];
        self.surveyAcademicButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
        [self.surveyAcademicButton setTitle:@"get academie/work survey" forState:UIControlStateNormal];
        self.surveyAcademicButton.frame = frame2;
        [self.surveyAcademicButton addTarget:self action:@selector(getSurveyAcademic) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.surveyAcademicButton];
        }
        
        if([userDefaults integerForKey:@"typ3now"] > 0) {
        CGRect frame3 = CGRectMake(25, 350, 300, 50);
        self.surveyCafeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.surveyCafeButton.backgroundColor = [UIColor clearColor];
        self.surveyCafeButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
        [self.surveyCafeButton setTitle:@"get restaurant/cafe survey" forState:UIControlStateNormal];
        self.surveyCafeButton.frame = frame3;
        [self.surveyCafeButton addTarget:self action:@selector(getSurveyCafe) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.surveyCafeButton];
        }
        
        if([userDefaults integerForKey:@"typ4now"] > 0) {
        CGRect frame4 = CGRectMake(50, 450, 300, 50);
        self.surveyGroceryButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.surveyGroceryButton.backgroundColor = [UIColor clearColor];
        self.surveyGroceryButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
        [self.surveyGroceryButton setTitle:@"get grocery survey" forState:UIControlStateNormal];
        self.surveyGroceryButton.frame = frame4;
        [self.surveyGroceryButton addTarget:self action:@selector(getSurveyGrocery) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.surveyGroceryButton];
        }
        
        
    }
    
    //We have to make sure that the Background App Refresh is enable for the Location updates to work in the background.
/*    if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied){
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > General > Background App Refresh"
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
        
    }else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted){
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The functions of this app are limited because the Background App Refresh is disable."
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
        
    } else{
        
        // time interval for the timer
        NSTimeInterval time = 5;
        
        // start the timer
        self.locationUpdateTimer =
        [NSTimer scheduledTimerWithTimeInterval:time
                                         target:self
                                       selector:@selector(targetMethod:)
                                       userInfo:nil
                                        repeats:YES];
    }*/
    
}

-(void)refreshView1:(NSNotification *) notification {
    NSLog(@"refresh_general");
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults integerForKey:@"typ1now"] > 0) {
        CGRect frame1 = CGRectMake(50, 150, 300, 50);
        self.surveyATMButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.surveyATMButton.backgroundColor = [UIColor clearColor];
        self.surveyATMButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
        [self.surveyATMButton setTitle:@"get ATM survey" forState:UIControlStateNormal];
        self.surveyATMButton.frame = frame1;
        [self.surveyATMButton addTarget:self action:@selector(getSurveyATM) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.surveyATMButton];
    }
    
    if([userDefaults integerForKey:@"typ2now"] > 0) {
        CGRect frame2 = CGRectMake(25, 250, 300, 50);
        self.surveyAcademicButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.surveyAcademicButton.backgroundColor = [UIColor clearColor];
        self.surveyAcademicButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
        [self.surveyAcademicButton setTitle:@"get academie/work survey" forState:UIControlStateNormal];
        self.surveyAcademicButton.frame = frame2;
        [self.surveyAcademicButton addTarget:self action:@selector(getSurveyAcademic) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.surveyAcademicButton];
    }
    
    if([userDefaults integerForKey:@"typ3now"] > 0) {
        CGRect frame3 = CGRectMake(25, 350, 300, 50);
        self.surveyCafeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.surveyCafeButton.backgroundColor = [UIColor clearColor];
        self.surveyCafeButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
        [self.surveyCafeButton setTitle:@"get restaurant/cafe survey" forState:UIControlStateNormal];
        self.surveyCafeButton.frame = frame3;
        [self.surveyCafeButton addTarget:self action:@selector(getSurveyCafe) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.surveyCafeButton];
    }
    
    if([userDefaults integerForKey:@"typ4now"] > 0) {
        CGRect frame4 = CGRectMake(50, 450, 300, 50);
        self.surveyGroceryButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.surveyGroceryButton.backgroundColor = [UIColor clearColor];
        self.surveyGroceryButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
        [self.surveyGroceryButton setTitle:@"get grocery survey" forState:UIControlStateNormal];
        self.surveyGroceryButton.frame = frame4;
        [self.surveyGroceryButton addTarget:self action:@selector(getSurveyGrocery) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.surveyGroceryButton];
    }
}

-(void)refreshView:(NSNotification *) notification {
    KCSUser* activeUser = [KCSUser activeUser];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    
    NSLog(@"refresh");
    if([appDelegate.type isEqualToString:@"ATMs"] || [appDelegate.type isEqualToString:@"academic"] || [appDelegate.type isEqualToString:@"work"] || [appDelegate.type isEqualToString:@"Restaurants"] || [appDelegate.type isEqualToString:@"grocery"]) {
        sleep(1);
        self.surveytype =appDelegate.type;
        appDelegate.type = @"";
        /*            [NSTimer scheduledTimerWithTimeInterval:1.0
         target:self
         selector:@selector(getSurveyLocal:)
         userInfo:nil
         repeats:NO];*/
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSLog(@"current type: %@", self.surveytype);
        
        if([userDefaults integerForKey:@"typ1now"] == 1 && [self.surveytype isEqualToString:@"ATMs"]) {
            self.type = @"ATM";
        }
        else if([userDefaults integerForKey:@"typ2now"] == 1 && [self.surveytype isEqualToString:@"academic"]) {
            
            self.type = @"academic";
        }
        else if([userDefaults integerForKey:@"typ2now"] == 1 && [self.surveytype isEqualToString:@"work"]) {
            
            self.type = @"work";
        }
        else if([userDefaults integerForKey:@"typ3now"] == 1 && [self.surveytype isEqualToString:@"Restaurants"]) {
            self.type = @"cafe";
        }
        else if([userDefaults integerForKey:@"typ4now"] == 1 && [self.surveytype isEqualToString:@"grocery"]) {
            self.type = @"grocery";
        }
        
        self.locationUpdateTimer =
        [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(targetMethod:)
                                       userInfo:nil
                                        repeats:NO];

        
    }
}

- (void)targetMethod:(NSTimer*)theTimer {
    [self retrieveSurvey];
}

/*
- (void)targetMethod:(NSTimer*)theTimer {
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    if (dateComponent.hour > 11 && dateComponent.hour < 18) {
        
        [_placesClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList *likelihoodList, NSError *error) {
            if (error != nil) {
                NSLog(@"Current Place error %@", [error localizedDescription]);
                return;
            }
            
            for (GMSPlaceLikelihood *likelihood in likelihoodList.likelihoods) {
                GMSPlace* place = likelihood.place;
                NSLog(@"Current Place name %@ at likelihood %g", place.name, likelihood.likelihood);
                NSLog(@"Current Place address %@", place.formattedAddress);
                NSLog(@"Current Place attributions %@", place.attributions);
                NSLog(@"Current PlaceID %@", place.placeID);
                NSLog(@"Current Place type %@", place.types);
            }
            
        }];
    }
    
}*/

- (void)getSurveyLocal: (NSTimer*)t {
    self.titleArray = [[NSMutableArray alloc] init];
    self.optionArray = [[NSMutableArray alloc] init];
    self.typeArray = [[NSMutableArray alloc] init];
    
/*    NSMutableArray* array = [[NSMutableArray alloc] init];
    __block NSMutableArray* aarray = [[NSMutableArray alloc] init];
    [array addObject: [KCSUser activeUser].username];
    NSLog(@"current user: %@", [KCSUser activeUser].username);
    
    KCSAppdataStore *_store = [KCSAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName : @"NewSurvey", KCSStoreKeyCollectionTemplateClass : [NewSurvey class]}];
    [_store queryWithQuery:[KCSQuery queryOnField:@"username" usingConditional:kKCSIn forValue:array] withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //An error happened, just log for now
            NSLog(@"An error occurred on fetch: %@", errorOrNil);
        } else {
            //got all events back from server -- update table view
            [aarray setArray:objectsOrNil];
            if([aarray count] == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"no survey"
                                                                message:@"no survey available yet."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                return;
            }
            
            sleep(3);
            NewSurvey *n = aarray[0];
            NSLog(@"current type: %@", self.surveytype);
            NSLog(@"current survey: %@", n.type2Now);
            NSLog(@"current survey: %@", n.type3Now);*/
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            if([userDefaults integerForKey:@"typ1now"] == 1 && [self.surveytype isEqualToString:@"ATMs"]) {
                self.type = @"ATM";
            }
            else if([userDefaults integerForKey:@"typ2now"] == 1 && [self.surveytype isEqualToString:@"academic"]) {
                
                self.type = @"academic";
            }
            else if([userDefaults integerForKey:@"typ2now"] == 1 && [self.surveytype isEqualToString:@"work"]) {
                
                self.type = @"work";
            }

            else if([userDefaults integerForKey:@"typ3now"] == 1 && [self.surveytype isEqualToString:@"Restaurants"]) {
                self.type = @"cafe";
            }
            else if([userDefaults integerForKey:@"typ4now"] == 1 && [self.surveytype isEqualToString:@"grocery"]) {
                self.type = @"grocery";
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"no survey"
                                                                message:@"no survey available yet."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                return;
            }
/*        }
    } withProgressBlock:nil];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                     target:self
                                   selector:@selector(retrieveSurvey1:)
                                   userInfo:nil
                                    repeats:NO];*/
    

}

-(void) getSurveyATM{
    if([KCSUser activeUser] ){
        self.titleArray = [[NSMutableArray alloc] init];
        self.optionArray = [[NSMutableArray alloc] init];
        self.typeArray = [[NSMutableArray alloc] init];
        
        NSMutableArray* array = [[NSMutableArray alloc] init];
        __block NSMutableArray* aarray = [[NSMutableArray alloc] init];
        [array addObject: [KCSUser activeUser].username];
        NSLog(@"current user: %@", [KCSUser activeUser].username);
        
/*        KCSAppdataStore *_store = [KCSAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName : @"NewSurvey", KCSStoreKeyCollectionTemplateClass : [NewSurvey class]}];
        [_store queryWithQuery:[KCSQuery queryOnField:@"username" usingConditional:kKCSIn forValue:array] withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            if (errorOrNil != nil) {
                //An error happened, just log for now
                NSLog(@"An error occurred on fetch: %@", errorOrNil);
            } else {
                //got all events back from server -- update table view
                [aarray setArray:objectsOrNil];
                if([aarray count] == 0) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"no survey"
                                                                    message:@"no survey available yet."
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                
                sleep(3);
                NewSurvey *n = aarray[0];
                NSLog(@"current survey: %@", n.type3Now);*/
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
           
                if([userDefaults integerForKey:@"typ1now"] == 1) {
                    self.type = @"ATM";
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"no survey"
                                                                    message:@"no survey available yet."
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    return;
                }
/*            }
        } withProgressBlock:nil];
        
        [NSTimer scheduledTimerWithTimeInterval:3.0
                                         target:self
                                       selector:@selector(retrieveSurvey:)
                                       userInfo:nil
                                        repeats:NO];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"no survey"
                                                        message:@"no survey available yet."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;*/
    }
    [self retrieveSurvey];

}

-(void) getSurveyAcademic{
    if([KCSUser activeUser] ){
        self.titleArray = [[NSMutableArray alloc] init];
        self.optionArray = [[NSMutableArray alloc] init];
        self.typeArray = [[NSMutableArray alloc] init];
        
        NSMutableArray* array = [[NSMutableArray alloc] init];
        __block NSMutableArray* aarray = [[NSMutableArray alloc] init];
        [array addObject: [KCSUser activeUser].username];
        NSLog(@"current user: %@", [KCSUser activeUser].username);
        
/*        KCSAppdataStore *_store = [KCSAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName : @"NewSurvey", KCSStoreKeyCollectionTemplateClass : [NewSurvey class]}];
        [_store queryWithQuery:[KCSQuery queryOnField:@"username" usingConditional:kKCSIn forValue:array] withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            if (errorOrNil != nil) {
                //An error happened, just log for now
                NSLog(@"An error occurred on fetch: %@", errorOrNil);
            } else {
                //got all events back from server -- update table view
                [aarray setArray:objectsOrNil];
                if([aarray count] == 0) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"no survey"
                                                                    message:@"no survey available yet."
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                
                sleep(3);
                NewSurvey *n = aarray[0];
                NSLog(@"current survey: %@", n.type3Now);*/
                
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        if([userDefaults integerForKey:@"typ2now"] == 1) {
                    self.type = [userDefaults stringForKey:@"place_type"];
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"no survey"
                                                                    message:@"no survey available yet."
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    return;
                }
/*            }
        } withProgressBlock:nil];
        
        [NSTimer scheduledTimerWithTimeInterval:3.0
                                         target:self
                                       selector:@selector(retrieveSurvey:)
                                       userInfo:nil
                                        repeats:NO];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"no survey"
                                                        message:@"no survey available yet."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;*/
    }
    [self retrieveSurvey];

}

-(void) getSurveyCafe{
    if([KCSUser activeUser] ){
        self.titleArray = [[NSMutableArray alloc] init];
        self.optionArray = [[NSMutableArray alloc] init];
        self.typeArray = [[NSMutableArray alloc] init];
        
        NSMutableArray* array = [[NSMutableArray alloc] init];
        __block NSMutableArray* aarray = [[NSMutableArray alloc] init];
        [array addObject: [KCSUser activeUser].username];
        NSLog(@"current user: %@", [KCSUser activeUser].username);
        
/*        KCSAppdataStore *_store = [KCSAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName : @"NewSurvey", KCSStoreKeyCollectionTemplateClass : [NewSurvey class]}];
        [_store queryWithQuery:[KCSQuery queryOnField:@"username" usingConditional:kKCSIn forValue:array] withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            if (errorOrNil != nil) {
                //An error happened, just log for now
                NSLog(@"An error occurred on fetch: %@", errorOrNil);
            } else {
                //got all events back from server -- update table view
                [aarray setArray:objectsOrNil];
                if([aarray count] == 0) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"no survey"
                                                                    message:@"no survey available yet."
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                
                sleep(3);
                NewSurvey *n = aarray[0];
                NSLog(@"current survey: %@", n.type3Now);*/
                
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        if([userDefaults integerForKey:@"typ3now"] == 1) {
                    self.type = @"cafe";
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"no survey"
                                                                    message:@"no survey available yet."
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    return;
                }
/*            }
        } withProgressBlock:nil];
        
        [NSTimer scheduledTimerWithTimeInterval:3.0
                                         target:self
                                       selector:@selector(retrieveSurvey:)
                                       userInfo:nil
                                        repeats:NO];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"no survey"
                                                        message:@"no survey available yet."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;*/
    }
    [self retrieveSurvey];

}


-(void) getSurveyGrocery{
    if([KCSUser activeUser] ){
        self.titleArray = [[NSMutableArray alloc] init];
        self.optionArray = [[NSMutableArray alloc] init];
        self.typeArray = [[NSMutableArray alloc] init];
        
        NSMutableArray* array = [[NSMutableArray alloc] init];
        __block NSMutableArray* aarray = [[NSMutableArray alloc] init];
        [array addObject: [KCSUser activeUser].username];
        NSLog(@"current user: %@", [KCSUser activeUser].username);
        
/*        KCSAppdataStore *_store = [KCSAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName : @"NewSurvey", KCSStoreKeyCollectionTemplateClass : [NewSurvey class]}];
        [_store queryWithQuery:[KCSQuery queryOnField:@"username" usingConditional:kKCSIn forValue:array] withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            if (errorOrNil != nil) {
                //An error happened, just log for now
                NSLog(@"An error occurred on fetch: %@", errorOrNil);
            } else {
                //got all events back from server -- update table view
                [aarray setArray:objectsOrNil];
                if([aarray count] == 0) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"no survey"
                                                                    message:@"no survey available yet."
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                
                sleep(3);
                NewSurvey *n = aarray[0];
                NSLog(@"current survey: %@", n.type3Now);*/
                
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        if([userDefaults integerForKey:@"typ4now"] == 1) {
                    self.type = @"grocery";
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"no survey"
                                                                    message:@"no survey available yet."
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    return;
                }
/*            }
        } withProgressBlock:nil];
        
        [NSTimer scheduledTimerWithTimeInterval:3.0
                                         target:self
                                       selector:@selector(retrieveSurvey:)
                                       userInfo:nil
                                        repeats:NO];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"no survey"
                                                        message:@"no survey available yet."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;*/
    }
    [self retrieveSurvey];

}

- (void) retrieveSurvey {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.hasNot = false;
    NSLog(@"retrieve");
    
    // YES! Do something here!!
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    if([self.type isEqualToString:@"ATM"]) {
        NSString *myString = [userDefaultes stringForKey:@"myString1"];
        
        [self.titleArray addObject: @"  "];
        [self.optionArray addObject: @[]];
        [self.typeArray addObject: @(1)];
        
        NSString *notif = [NSString stringWithFormat:@"%@%@", myString, @" has decided to use facial recognition to prevent fraud. All customers of the bank will be asked to submit a photo through their online account. A camera in the ATM can capture your face when you approach it and link your face with your bank account information. This ensures that the person making transactions on this card is really you.\n"];
        [self.titleArray addObject: notif];
        [self.optionArray addObject: @[]];
        [self.typeArray addObject: @(1)];

        notif = [NSString stringWithFormat:@"%@%@%@", @"1.Do you think ", myString, @"’s use of facial recognition in this manner will improve the security of your bank account?"];
        [self.titleArray addObject: notif];
        [self.optionArray addObject: @[@"Yes", @"No"]];
        [self.typeArray addObject: @(1)];

        [self.titleArray addObject: @"2.The camera is about 1 foot away from where customers would typically stand in front of the ATM. Do you think this camera can capture your face and link it to your bank account correctly?"];
        [self.optionArray addObject: @[@"Yes", @"No"]];
        [self.typeArray addObject: @(1)];
        
        notif = [NSString stringWithFormat:@"%@%@%@", @"3.Will you be more likely, less likely, or just as likely to continue using your account with ", myString, @" when it begins this service?"];
        [self.titleArray addObject: notif];
        [self.optionArray addObject: @[@"Yes", @"No"]];
        [self.typeArray addObject: @(1)];
        
        notif = [NSString stringWithFormat:@"%@%@%@", @"4.Do you trust ", myString, @" to keep images collected from the ATM camera secure against hackers or other people who shouldn’t have this data?"];
        [self.titleArray addObject: notif];
        [self.optionArray addObject: @[@"Yes", @"No"]];
        [self.typeArray addObject: @(1)];
        
        [self.titleArray addObject: @"5.How likely are you to inquire about the privacy policy regarding this innovation?"];
        [self.optionArray addObject: @[@"Definitely", @"Maybe", @"No"]];
        [self.typeArray addObject: @(1)];
        
        notif = [NSString stringWithFormat:@"%@%@%@", @"6.Do you trust ", myString, @" to use the images collected from the ATM camera only for the purpose of authentication?"];
        [self.titleArray addObject: notif];
        [self.optionArray addObject: @[@"Yes", @"No"]];
        [self.typeArray addObject: @(1)];

        [self.titleArray addObject: @"7.Imagine you are spending time with your friends on a weekend night, and you need to withdraw cash from an ATM to pay for drinks at the bar. Would you be concerned if the camera in the ATM could capture the faces of people with you and identify who they are?"];
        [self.optionArray addObject: @[@"Yes", @"No"]];
        [self.typeArray addObject: @(1)];
        
        notif = [NSString stringWithFormat:@"%@%@%@", @"8.According to you, what is a reasonable time for ", myString, @" to retain the image they capture of you"];
        [self.titleArray addObject: notif];
        [self.optionArray addObject: @[@"Less than 1 week", @"1 week", @"1 month", @"3 months", @"6 months", @"1 year", @"Indefinitely"]];
        [self.typeArray addObject: @(2)];
        
        [self.titleArray addObject: @"9.Does this use of facial recognition technology raise any other concerns for you?"];
        [self.optionArray addObject: @[]];
        [self.typeArray addObject: @(3)];
        
        [self.titleArray addObject: @"    "];
        [self.optionArray addObject: @[]];
        [self.typeArray addObject: @(1)];
    }
    else if([self.type isEqualToString:@"academic"]) {
        NSString *myString = [userDefaultes stringForKey:@"place"];
        [self.titleArray addObject: @"  "];
        [self.optionArray addObject: @[]];
        [self.typeArray addObject: @(1)];

        NSString *notif = [NSString stringWithFormat:@"%@%@", myString, @" administration has partnered with the IT department on a new project to promote student mental health. The team implementing this project will use public cameras to capture students’ faces and pair their faces with each student’s ID. This will allow the team to track students as they go about their everyday activities.\nStudents will have the option to download an app in conjunction with this project. Based on various measures, such as duration between meals, frequency of exercise, time spent in the library, and time spent in groups, the team will push notifications to the app that provide individualized suggestions on how to maintain a healthy lifestyle. In cases where students appear to be in higher need of support, the team may use personal laptop cameras to watch student behavior more closely, and additional notifications will be pushed to their email.\n"];
        [self.titleArray addObject: notif];
        [self.optionArray addObject: @[]];
        [self.typeArray addObject: @(1)];
        
        [self.titleArray addObject: @"1.Do you think this approach will improve mental health on campus?"];
        [self.optionArray addObject: @[@"Yes", @"No"]];
        [self.typeArray addObject: @(1)];
        
        [self.titleArray addObject: @"2.Do you think that this project will provide accurate suggestions for how an individual can improve their mental health?"];
        [self.optionArray addObject: @[@"Yes", @"No"]];
        [self.typeArray addObject: @(1)];
        
        [self.titleArray addObject: @"3.On average, cameras are placed about 15 feet away from where students would typically walk. Do you think the cameras will capture your face and link it to your student ID correctly?"];
        [self.optionArray addObject: @[@"Yes", @"No"]];
        [self.typeArray addObject: @(1)];
        
        [self.titleArray addObject: @"4.If there were an option to opt out of facial recognition on campus, would you take it?"];
        [self.optionArray addObject: @[@"Yes", @"No"]];
        [self.typeArray addObject: @(1)];
        
        [self.titleArray addObject: @"5.How likely are you to inquire about the privacy policy for this new project?"];
        [self.optionArray addObject: @[@"Definitely", @"Maybe", @"No"]];
        [self.typeArray addObject: @(1)];
        
        notif = [NSString stringWithFormat:@"%@%@%@", @"6.Do you trust ", myString, @" to keep the images collected from the cameras secure against hackers or other people who shouldn’t have this data?"];
        [self.titleArray addObject: notif];
        [self.optionArray addObject: @[@"Yes", @"No"]];
        [self.typeArray addObject: @(1)];
        
        [self.titleArray addObject: @"7.Are there certain places on campus where you would not want the camera to capture your face?"];
        [self.optionArray addObject: @[@"Yes", @"No"]];
        [self.typeArray addObject: @(1)];

        [self.titleArray addObject: @"8.Are there campus activities for which you would not want the camera to capture your face?"];
        [self.optionArray addObject: @[@"Yes", @"No"]];
        [self.typeArray addObject: @(1)];
        
        notif = [NSString stringWithFormat:@"%@%@%@", @"9.Do you trust ", myString, @" to use the images collected from these cameras only for the purpose of improving mental health?"];
        [self.titleArray addObject: notif];
        [self.optionArray addObject: @[@"Yes", @"No"]];
        [self.typeArray addObject: @(1)];
        
        notif = [NSString stringWithFormat:@"%@%@%@", @"10.", myString, @" may also aggregate these images to determine who students spend time with. In your opinion, would this be an acceptable use of images for the purpose of improving mental health"];
        [self.titleArray addObject: notif];
        [self.optionArray addObject: @[@"Yes", @"No"]];
        [self.typeArray addObject: @(1)];
        
        notif = [NSString stringWithFormat:@"%@%@%@", @"11.According to you, what is a reasonable time for ", myString, @" to retain the image they capture of you?"];
        [self.titleArray addObject: notif];
        [self.optionArray addObject: @[@"Less than 1 week", @"1 week", @"1 month", @"3 months", @"6 months", @"1 year", @"Indefinitely"]];
        [self.typeArray addObject: @(2)];
        
        [self.titleArray addObject: @"12.Does this use of facial recognition technology raise any other concerns for you?"];
        [self.optionArray addObject: @[]];
        [self.typeArray addObject: @(3)];
        
        [self.titleArray addObject: @"    "];
        [self.optionArray addObject: @[]];
        [self.typeArray addObject: @(1)];
    }
    else if([self.type isEqualToString:@"work"]) {
        NSString *myString = [userDefaultes stringForKey:@"place"];
        [self.titleArray addObject: @"  "];
        [self.optionArray addObject: @[]];
        [self.typeArray addObject: @(1)];
        
        NSString *notif = [NSString stringWithFormat:@"%@", @"Employers are becoming increasingly concerned about employee productivity and retention rates. Given that employee mental health has an impact on both domains, employers are beginning to use workplace cameras and facial recognition to track employees as they carry out their work responsibilities during the day. Based on various measures, such as time spent sitting and standing, time spent interacting with other employees, and duration between breaks, employers will tailor employees’ schedules to optimize productivity and maintain employee satisfaction.\n"];
        [self.titleArray addObject: notif];
        [self.optionArray addObject: @[]];
        [self.typeArray addObject: @(1)];
        
        [self.titleArray addObject: @"1.Do you think this approach will improve employee productivity and satisfaction on the job?"];
        [self.optionArray addObject: @[@"Yes", @"No"]];
        [self.typeArray addObject: @(1)];
        
        [self.titleArray addObject: @"2.Do you think that this strategy will provide accurate suggestions for how an employee can improve their mental health?"];
        [self.optionArray addObject: @[@"Yes", @"No"]];
        [self.typeArray addObject: @(1)];
        
        [self.titleArray addObject: @"3.How likely are you to inquire about the privacy policy regarding this workplace strategy?"];
        [self.optionArray addObject: @[@"Definitely", @"Maybe", @"No"]];
        [self.typeArray addObject: @(1)];
        
        [self.titleArray addObject: @"4.On average, cameras are placed about 10 feet away from where employees would typically walk. Do you think the cameras will capture your face and detect your identity correctly?"];
        [self.optionArray addObject: @[@"Yes", @"No"]];
        [self.typeArray addObject: @(1)];
        
        [self.titleArray addObject: @"5.Do you trust your employer to keep the images collected from the cameras secure against hackers or other people who shouldn’t have this data?"];
        [self.optionArray addObject: @[@"Yes", @"No"]];
        [self.typeArray addObject: @(1)];
        
        [self.titleArray addObject: @"6.Are there certain places in the workplace where you would not want the camera to capture your face?"];
        [self.optionArray addObject: @[@"Yes", @"No"]];
        [self.typeArray addObject: @(1)];
        
        [self.titleArray addObject: @"7.Are there workplace responsibilities for which you would not want the camera to capture your face?"];
        [self.optionArray addObject: @[@"Yes", @"No"]];
        [self.typeArray addObject: @(1)];
        
        [self.titleArray addObject: @"8.Do you trust your employer to use the images collected from these cameras only for the purpose of improving employee mental health?"];
        [self.optionArray addObject: @[@"Yes", @"No"]];
        [self.typeArray addObject: @(1)];
        
        [self.titleArray addObject: @"9.According to you, what is a reasonable time for your employer to retain the image they capture of you?"];
        [self.optionArray addObject: @[@"Less than 1 week", @"1 week", @"1 month", @"3 months", @"6 months", @"1 year", @"Indefinitely"]];
        [self.typeArray addObject: @(2)];
        
        [self.titleArray addObject: @"10.Does this use of facial recognition technology raise any other concerns for you?"];
        [self.optionArray addObject: @[]];
        [self.typeArray addObject: @(3)];
        
        [self.titleArray addObject: @"    "];
        [self.optionArray addObject: @[]];
        [self.typeArray addObject: @(1)];
    }

    else if([self.type isEqualToString:@"cafe"]) {
        NSString *myString = [userDefaultes stringForKey:@"myString3"];
        [self.titleArray addObject: @"  "];
        [self.optionArray addObject: @[]];
        [self.typeArray addObject: @(1)];
        
        NSString *notif = [NSString stringWithFormat:@"%@%@", myString, @" uses facial recognition to uniquely identify you and link it with your history of orders to improve their service. Their future plan is to provide a customized menu with suggestions based on your previous orders.\n"];
        
        [self.titleArray addObject: notif];
        [self.optionArray addObject: @[]];
        [self.typeArray addObject: @(1)];
        
        [self.titleArray addObject: @"1.How often do you visit this restaurant?"];
        [self.optionArray addObject: @[@"More than once a week", @"Once a week", @"Once a month"]];
        [self.typeArray addObject: @(1)];

        [self.titleArray addObject: @"2.Will this new business practice change your frequency of visits?"];
        [self.optionArray addObject: @[@"Yes", @"No"]];
        [self.typeArray addObject: @(1)];
        
        [self.titleArray addObject: @"3.Would this make you feel more conscious about what you order and your behavior in the restaurant?"];
        [self.optionArray addObject: @[@"Yes", @"No"]];
        [self.typeArray addObject: @(1)];
        
        [self.titleArray addObject: @"4.If there was an option to opt out, would you take it?"];
        [self.optionArray addObject: @[@"Yes", @"No"]];
        [self.typeArray addObject: @(1)];
        
        notif = [NSString stringWithFormat:@"%@%@%@", @"5.Do you trust ", myString, @" to keep the images collected from the cameras secure against hackers or other people who shouldn’t have this data?"];
        [self.titleArray addObject: notif];
        [self.optionArray addObject: @[@"Yes", @"No"]];
        [self.typeArray addObject: @(1)];
        
        [self.titleArray addObject: @"6.How likely are you to inquire about their privacy policy regarding this business practice?"];
        [self.optionArray addObject: @[@"Definitely", @"Maybe", @"No"]];
        [self.typeArray addObject: @(1)];

        notif = [NSString stringWithFormat:@"%@%@%@", @"7.Imagine ", myString, @" starts using these images to understand the composition of its customer base – for example, to figure out the percentage of different races and genders of customers. Would you feel more comfortable, less comfortable, or just as comfortable with this practice?"];
        [self.titleArray addObject: notif];
        [self.optionArray addObject: @[@"More comfortable", @"Less comfortable", @"Just as comfortable"]];
        [self.typeArray addObject: @(1)];

        [self.titleArray addObject: @"8.Would you feel more comfortable, less comfortable, or just as comfortable if other information such as your name, phone number and credit card information is linked to the image of your face?"];
        [self.optionArray addObject: @[@"More comfortable", @"Less comfortable", @"Just as comfortable"]];
        [self.typeArray addObject: @(1)];
        
        notif = [NSString stringWithFormat:@"%@%@%@", @"9.According to you, what is a reasonable time for ", myString, @" to retain the images collected?"];
        [self.titleArray addObject: notif];
        [self.optionArray addObject: @[@"Less than 1 week", @"1 week", @"1 month", @"3 months", @"6 months", @"1 year", @"Indefinitely"]];
        [self.typeArray addObject: @(2)];
        
        [self.titleArray addObject: @"10.Does this use of facial recognition technology raise any other concerns for you?"];
        [self.optionArray addObject: @[]];
        [self.typeArray addObject: @(3)];
        
        [self.titleArray addObject: @"    "];
        [self.optionArray addObject: @[]];
        [self.typeArray addObject: @(1)];

    }
    else if([self.type isEqualToString:@"grocery"]) {
        NSString *myString = [userDefaultes stringForKey:@"myString4"];
        
        [self.titleArray addObject: @"  "];
        [self.optionArray addObject: @[]];
        [self.typeArray addObject: @(1)];
        
        NSString *notif = [NSString stringWithFormat:@"%@%@", myString, @" has recently partnered with Facebook to use facial recognition at the store’s entrance. The hope is to provide a personalized shopping experience, where the store can pair your member card with your Facebook account. This allows the store to offer discounts that fit your interests and lifestyle.\n"];
        
        [self.titleArray addObject: notif];
        [self.optionArray addObject: @[]];
        [self.typeArray addObject: @(1)];
        
        [self.titleArray addObject: @"1.Will this innovation change your frequency of visits?"];
        [self.optionArray addObject: @[@"Yes", @"No"]];
        [self.typeArray addObject: @(1)];
        
        [self.titleArray addObject: @"2.Would this practice make you feel more conscious about your purchasing behavior in the grocery store?"];
        [self.optionArray addObject: @[@"Yes", @"No"]];
        [self.typeArray addObject: @(1)];
        
        [self.titleArray addObject: @"3.Would this make you feel more conscious about whom you are with in the grocery store?"];
        [self.optionArray addObject: @[@"Yes", @"No"]];
        [self.typeArray addObject: @(1)];
        
        [self.titleArray addObject: @"4.If there were an option to opt out of facial recognition in the store, would you take it?"];
        [self.optionArray addObject: @[@"Yes", @"No"]];
        [self.typeArray addObject: @(1)];
        
        notif = [NSString stringWithFormat:@"%@%@%@", @"5.Do you trust ", myString, @" to keep the images collected from the cameras secure against hackers or other people who shouldn’t have this data?"];
        [self.titleArray addObject: notif];
        [self.optionArray addObject: @[@"Yes", @"No"]];
        [self.typeArray addObject: @(1)];
        
        
        [self.titleArray addObject: @"6.How likely are you to inquire about their privacy policy regarding this innovation?"];
        [self.optionArray addObject: @[@"Definitely", @"Maybe", @"No"]];
        [self.typeArray addObject: @(1)];
        
        [self.titleArray addObject: @"7.Do you think this facial recognition technology could accurately link your face to your Facebook account?"];
        [self.optionArray addObject: @[@"Yes", @"No"]];
        [self.typeArray addObject: @(1)];
        
        notif = [NSString stringWithFormat:@"%@%@%@", @"8.", myString, @" may decide to track what types of customers shop at particular times in order to tailor its services further. This would involve aggregating your data with that of other customers that arrive and shop at the same time. Do you think this is an acceptable use of the data collected?"];
        [self.titleArray addObject: notif];
        [self.optionArray addObject: @[@"Yes", @"No"]];
        [self.typeArray addObject: @(1)];
        
        [self.titleArray addObject: @"9.Would you feel more comfortable, less comfortable, or just as comfortable if other information such as your name, phone number and membership card information is linked to your face?"];
        [self.optionArray addObject: @[@"More comfortable", @"Less comfortable", @"Just as comfortable"]];
        [self.typeArray addObject: @(1)];

        notif = [NSString stringWithFormat:@"%@%@%@", @"10.According to you, what is a reasonable time for ", myString, @" to retain the information collected?"];
        [self.titleArray addObject: notif];
        [self.optionArray addObject: @[@"Less than 1 week", @"1 week", @"1 month", @"3 months", @"6 months", @"1 year", @"Indefinitely"]];
        [self.typeArray addObject: @(2)];
        
        [self.titleArray addObject: @"11.Does this use of facial recognition technology raise any other concerns for you?"];
        [self.optionArray addObject: @[]];
        [self.typeArray addObject: @(3)];
        
        [self.titleArray addObject: @"    "];
        [self.optionArray addObject: @[]];
        [self.typeArray addObject: @(1)];

    }
    
    
    NSLog(@"current array: %@", self.titleArray);
    
    SZQuestionItem *item = [[SZQuestionItem alloc] initWithTitleArray:self.titleArray andOptionArray:self.optionArray andResultArray: self.resultArray andQuestonTypes:self.typeArray];
    
    self.questionBox = [[SZQuestionCheckBox alloc] initWithItem:item];
    
    self.titleArray = [[NSMutableArray alloc] init];
    self.optionArray = [[NSMutableArray alloc] init];
    self.typeArray = [[NSMutableArray alloc] init];
    
    NSLog(@"current type: %@", self.type);
    [self.questionBox setType:self.type];
    self.type = @"";
    
    [self.view addSubview:self.questionBox.view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)hasLaunched {
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![[userDefaults objectForKey:@"version"] isEqualToString:version]) {
        [userDefaults setObject:version forKey:@"version"];
        return NO;
    }else {
        return YES;
    }
}

@end
