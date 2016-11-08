//
//  SZQuestionCheckBox.m
//  SZQuestionCheckBox_demo
//
//  Created by 吴三忠 on 16/4/27.
//  Copyright © 2016年 吴三忠. All rights reserved.
//

#import "SZQuestionCheckBox.h"
#import "SZQuestionCell.h"
#import "SZQuestionOptionCell.h"
#import "NewSurvey.h"
#import "SurveyResult.h"
#import <KinveyKit/KinveyKit.h>


@interface SZQuestionCheckBox ()


@property (nonatomic, assign) CGFloat titleWidth;
@property (nonatomic, assign) CGFloat OptionWidth;
@property (nonatomic, assign) BOOL complete;
@property (nonatomic, strong) NSArray *tempArray;
@property (nonatomic, strong) NSMutableArray *arrayM;
@property (nonatomic, strong) SZConfigure *configure;
@property (nonatomic, assign) QuestionCheckBoxType chekBoxType;
@property (nonatomic) CGFloat height;
@property (nonatomic) Boolean isFirst;
@property (nonatomic) Boolean isLog;
@property (nonatomic) NSString *type;

@end

@implementation SZQuestionCheckBox

- (instancetype)initWithItem:(SZQuestionItem *)questionItem {
    
    SZConfigure *configure = [[SZConfigure alloc] init];
    return [self initWithItem:questionItem andConfigure:configure];
}

- (instancetype)initWithItem:(SZQuestionItem *)questionItem andConfigure:(SZConfigure *)configure {
    
    return [self initWithItem:questionItem andCheckBoxType:QuestionCheckBoxWithoutHeader andConfigure:configure];
}

- (instancetype)initWithItem:(SZQuestionItem *)questionItem andCheckBoxType:(QuestionCheckBoxType)checkBoxType {
    
    SZConfigure *configure = [[SZConfigure alloc] init];
    return [self initWithItem:questionItem andCheckBoxType:checkBoxType andConfigure:configure];
}


- (instancetype)initWithItem:(SZQuestionItem *)questionItem andCheckBoxType:(QuestionCheckBoxType)checkBoxType andConfigure:(SZConfigure *)configure {
    
    self = [super init];
    self.isFirst = false;
    
    if (self) {
        self.sourceArray = questionItem.ItemQuestionArray;
        if (configure != nil) self.configure = configure;
        self.chekBoxType = checkBoxType;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.canEdit = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if(self.type.length > 0) {
        CGRect frame;
        if([self.type isEqualToString:@"ATM"])
            frame = CGRectMake(0, self.height * 1.25, 100, 50);
        else if([self.type isEqualToString:@"academic"])
            frame = CGRectMake(0, self.height * 1.31, 100, 50);
        else if([self.type isEqualToString:@"work"])
            frame = CGRectMake(0, self.height * 1.28, 100, 50);
        else if([self.type isEqualToString:@"cafe"])
            frame = CGRectMake(0, self.height * 1.17, 100, 50);
        else if([self.type isEqualToString:@"grocery"])
            frame = CGRectMake(0, self.height * 1.2, 100, 50);
        else if([self.type isEqualToString:@"first"])
            frame = CGRectMake(0, self.height * 1, 100, 50);
            
    if(self.height < 200)
        frame = CGRectMake(0, 150, 100, 50);
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    submitButton.backgroundColor = [UIColor clearColor];
    submitButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
    [submitButton setTitle:@"submit" forState:UIControlStateNormal];
    submitButton.frame = frame;
    [submitButton addTarget:self action:@selector(submitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:submitButton];
        NSLog(@"current type2: %@", self.type);

    }
    
    if(![self.type isEqualToString:@"first"]) {
    CGRect frame1 = CGRectMake(300, 0, 100, 50);
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    returnButton.backgroundColor = [UIColor clearColor];
    returnButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
    [returnButton setTitle:@"return" forState:UIControlStateNormal];
    returnButton.frame = frame1;
    [returnButton addTarget:self action:@selector(returnButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnButton];
    }
    
    CGRect frame2 = CGRectMake(0, 0, 220, 50);
    UIButton *skipButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    skipButton.backgroundColor = [UIColor clearColor];
    skipButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
    if([self.type isEqualToString:@"ATM"])
        [skipButton setTitle:@"not my bank" forState:UIControlStateNormal];
    else if([self.type isEqualToString:@"academic"])
        [skipButton setTitle:@"skip this survey" forState:UIControlStateNormal];
    else if([self.type isEqualToString:@"work"])
        [skipButton setTitle:@"skip this survey" forState:UIControlStateNormal];
    else if([self.type isEqualToString:@"cafe"])
        [skipButton setTitle:@"not my restaurant/cafe" forState:UIControlStateNormal];
    else if([self.type isEqualToString:@"grocery"])
        [skipButton setTitle:@"not my grocery store" forState:UIControlStateNormal];

    skipButton.frame = frame2;
    [skipButton addTarget:self action:@selector(skipButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:skipButton];
}

-(void) returnButtonClicked{
    self.type = @"";
    self.view.removeFromSuperview;
}

-(void) skipButtonClicked{
/*    NSMutableArray* array = [[NSMutableArray alloc] init];
    __block NSMutableArray* aarray = [[NSMutableArray alloc] init];
    [array addObject: [KCSUser activeUser].username];
    KCSAppdataStore *_store2 = [KCSAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName : @"NewSurvey", KCSStoreKeyCollectionTemplateClass : [NewSurvey class]}];
    [_store2 queryWithQuery:[KCSQuery queryOnField:@"username" usingConditional:kKCSIn forValue:array] withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //An error happened, just log for now
            NSLog(@"An error occurred on fetch: %@", errorOrNil);
        } else {
            //got all events back from server -- update table view
            [aarray setArray:objectsOrNil];
            NSLog(@"current type: %@", self.type);
            NewSurvey *n = aarray[0];*/
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
            if([self.type isEqualToString:@"ATM"]) {
                [userDefaults setInteger:[userDefaults integerForKey:@"typ1count"]+1 forKey:@"typ1count"];
                [userDefaults setInteger:0 forKey:@"typ1now"];
/*                n.type1Count = [[NSNumber alloc] initWithInt:[n.type1Count intValue]+1];
                n.type1Now = [[NSNumber alloc] initWithInt:0];           */ }
            else if([self.type isEqualToString:@"academic"] || [self.type isEqualToString:@"work"]) {
                [userDefaults setInteger:[userDefaults integerForKey:@"typ2count"]+1 forKey:@"typ2count"];
                [userDefaults setInteger:0 forKey:@"typ2now"];
                /*                n.type1Count = [[NSNumber alloc] initWithInt:[n.type1Count intValue]+1];
                 n.type1Now = [[NSNumber alloc] initWithInt:0];           */  }
            else if([self.type isEqualToString:@"cafe"]) {
                [userDefaults setInteger:[userDefaults integerForKey:@"typ3count"]+1 forKey:@"typ3count"];
                [userDefaults setInteger:0 forKey:@"typ3now"];
                /*                n.type1Count = [[NSNumber alloc] initWithInt:[n.type1Count intValue]+1];
                 n.type1Now = [[NSNumber alloc] initWithInt:0];           */ ;
            }
            else if([self.type isEqualToString:@"grocery"]) {
                [userDefaults setInteger:[userDefaults integerForKey:@"typ4count"]+1 forKey:@"typ4count"];
                [userDefaults setInteger:0 forKey:@"typ4now"];
                /*                n.type1Count = [[NSNumber alloc] initWithInt:[n.type1Count intValue]+1];
                 n.type1Now = [[NSNumber alloc] initWithInt:0];           */ ;
            }
            
/*            [_store2 saveObject:n withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                if (errorOrNil != nil) {
                    //save failed
                    NSLog(@"Save failed, with error: %@", [errorOrNil localizedFailureReason]);
                } else {
                    //save was successful
                    NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);                            }
            } withProgressBlock:nil];
            
        }
    } withProgressBlock:nil];*/
    
    self.type = @"";
    [self.view.superview setNeedsDisplay];
    self.view.removeFromSuperview;
}

-(void) submitButtonClicked{
    if(![self isComplete]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"not finished"
                                                        message:@"The survey is not finished."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (self.isFirst) {
        [KCSUser userWithUsername: self.resultArray[0] password:@"123" fieldsAndValues:@{KCSUserAttributeGivenname : @"2222"} withCompletionBlock:^(KCSUser *user, NSError *errorOrNil, KCSUserActionResult result) {
            if (errorOrNil == nil) {
                NSLog(@"created@");
                self.view.removeFromSuperview;
            } else {
                NSLog(@"create error@");
            }
        }];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:self.resultArray[1] forKey:@"longtitude"];
        [userDefaults setObject:self.resultArray[2] forKey:@"latitude"];
        [userDefaults setObject:self.resultArray[3] forKey:@"place"];
        [userDefaults setObject:self.resultArray[4] forKey:@"place_type"];

    }
    else if(self.isLog) {
        
        [KCSUser loginWithUsername: self.resultArray[0] password:@"123" withCompletionBlock:^(KCSUser *user, NSError *errorOrNil, KCSUserActionResult result) {
            if (errorOrNil ==  nil) {
                //the log-in was successful and the user is now the active user and credentials saved
                //hide log-in view and show main app content
                NSLog(@"login@");
                self.view.removeFromSuperview;
            } else {
                //there was an error with the update save
                NSString* message = [errorOrNil localizedDescription];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Create account failed", @"Sign account failed")
                                                                message:message
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                      otherButtonTitles: nil];
                [alert show];
            }
        }];
    }
    else {
        KCSAppdataStore *_store = [KCSAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName : @"Survey", KCSStoreKeyCollectionTemplateClass : [SurveyResult class]}];
        
        int j = 1;
        KCSUser* activeUser = [KCSUser activeUser];
        for(NSArray *array in self.resultArray) {
            SurveyResult* survey = [[SurveyResult alloc] init];
            survey.type = self.type;
            survey.result = array;
            survey.username = activeUser.username;
            survey.questionNum = [[NSNumber alloc] initWithInt:j];
            j = j + 1;
                
            NSLog(@"%@", survey);
            [_store saveObject:survey withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                if (errorOrNil != nil) {
                    //save failed
                    NSLog(@"Save failed, with error: %@", [errorOrNil localizedFailureReason]);
                } else {
                    //save was successful
                    NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);
                }
            } withProgressBlock:nil];        }
        
/*        NSMutableArray* array = [[NSMutableArray alloc] init];
        __block NSMutableArray* aarray = [[NSMutableArray alloc] init];
        [array addObject: [KCSUser activeUser].username];
        KCSAppdataStore *_store2 = [KCSAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName : @"NewSurvey", KCSStoreKeyCollectionTemplateClass : [NewSurvey class]}];
        [_store2 queryWithQuery:[KCSQuery queryOnField:@"username" usingConditional:kKCSIn forValue:array] withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            if (errorOrNil != nil) {
                //An error happened, just log for now
                NSLog(@"An error occurred on fetch: %@", errorOrNil);
            } else {
                //got all events back from server -- update table view
                [aarray setArray:objectsOrNil];
                NSLog(@"current type: %@", self.type);
                NewSurvey *n = aarray[0];*/
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
                if([self.type isEqualToString:@"ATM"]) {
                    [userDefaults setInteger:0 forKey:@"typ1now"];
                }
                else if([self.type isEqualToString:@"academic"] || [self.type isEqualToString:@"work"]) {
                    [userDefaults setInteger:0 forKey:@"typ2now"];
                }
                else if([self.type isEqualToString:@"cafe"]) {
                    [userDefaults setInteger:0 forKey:@"typ3now"];
                }
                else if([self.type isEqualToString:@"grocery"]) {
                    [userDefaults setInteger:0 forKey:@"typ4now"];
                }
                
/*                [_store2 saveObject:n withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                    if (errorOrNil != nil) {
                        //save failed
                        NSLog(@"Save failed, with error: %@", [errorOrNil localizedFailureReason]);
                    } else {
                        //save was successful
                        NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);                            }
                } withProgressBlock:nil];
                
                }
        } withProgressBlock:nil];*/
        
    }
    self.type = @"";
    self.view.removeFromSuperview;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.titleWidth = self.view.frame.size.width - self.configure.titleSideMargin * 2;
    self.OptionWidth = self.view.frame.size.width - self.configure.optionSideMargin * 2 - self.configure.buttonSize - 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isComplete {
    
    [self getResult];
    return self.complete;
}

- (NSArray *)resultArray {
    
    [self getResult];
    return self.tempArray;
}

- (void)getResult {
    
    [self.view endEditing:YES];
    BOOL complete          = true;
    NSMutableArray *arrayM = [NSMutableArray array];
    int len = [self.sourceArray count];
    for (int i=2; i<len-1;i++) {
        NSDictionary *dict = self.sourceArray[i];
        if ([dict[@"type"] integerValue] == SZQuestionOpenQuestion) {
            NSString *str = dict[@"marked"];
            complete      = (str.length > 0) && complete;
            [arrayM addObject:str.length ? str : @""];
        }
        else {
            NSArray *array = dict[@"marked"];
            complete       = ([array containsObject:@"YES"] || [array containsObject:@"yes"] || [array containsObject:@(1)] || [array containsObject:@"1"]) && complete;
            [arrayM addObject:array];
        }
    }
    self.complete   = complete;
    self.tempArray  = arrayM.copy;
}

- (void)setCanEdit:(BOOL)canEdit {
    
    _canEdit = canEdit;
    [self.tableView reloadData];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
}

#pragma mark - UITableViewdatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.chekBoxType == QuestionCheckBoxWithHeader ? self.sourceArray.count : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.chekBoxType == QuestionCheckBoxWithHeader) {
        NSDictionary *dict = self.sourceArray[section];
        if ([dict[@"type"] intValue] == SZQuestionOpenQuestion) {
            return 1;
        }
        else {
            NSArray *optionArray = dict[@"option"];
            return optionArray.count;
        }
    }
    else {
        return self.sourceArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.chekBoxType == QuestionCheckBoxWithHeader) {
        NSDictionary *dict = self.sourceArray[indexPath.section];
        SZQuestionOptionCell *cell = [[SZQuestionOptionCell alloc]
                                      initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"questionOptionCellIdentifier"
                                      andDict:dict
                                      andIndexPath:indexPath
                                      andWidth:self.view.frame.size.width
                                      andConfigure:self.configure];
        __weak typeof(self) weakSelf = self;
        cell.selectOptionButtonBack = ^(NSIndexPath *indexPath, NSDictionary *dict) {
            [weakSelf.arrayM replaceObjectAtIndex:indexPath.section withObject:dict];
            weakSelf.sourceArray = weakSelf.arrayM.copy;
            NSIndexSet *set = [NSIndexSet indexSetWithIndex:indexPath.section];
            [weakSelf.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userInteractionEnabled = self.canEdit;
        return cell;
    }
    else {
        NSDictionary *dict = self.sourceArray[indexPath.row];
        SZQuestionCell *cell = [[SZQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                     reuseIdentifier:@"questionCellIdentifier"
                                                             andDict:dict
                                                      andQuestionNum:indexPath.row + 1
                                                            andWidth:self.view.frame.size.width
                                                        andConfigure:self.configure];
        __weak typeof(self) weakSelf = self;
        cell.selectOptionBack = ^(NSInteger index, NSDictionary *dict, BOOL refresh) {
            [weakSelf.arrayM replaceObjectAtIndex:index withObject:dict];
            weakSelf.sourceArray = weakSelf.arrayM.copy;
            if (refresh) {
                NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
                [weakSelf.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
            }
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userInteractionEnabled = self.canEdit;
        return cell;
    }
}

#pragma mark - UITableViewdelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.chekBoxType == QuestionCheckBoxWithHeader) {
        NSDictionary *dict = self.sourceArray[section];
        NSString *title = self.configure.automaticAddLineNumber ? [NSString stringWithFormat:@"%zd、%@", section + 1, dict[@"title"]] : dict[@"title"];
        CGFloat title_height = [SZQuestionItem heightForString:title
                                                         width:self.titleWidth
                                                      fontSize:self.configure.titleFont
                                                 oneLineHeight:self.configure.oneLineHeight];
        UIView *v = [[UIView alloc] init];
        v.backgroundColor = [UIColor whiteColor];
        UILabel *lbl =({
            lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.configure.titleSideMargin, 0, self.titleWidth, title_height)];
            lbl.font = [UIFont systemFontOfSize:self.configure.titleFont];
            lbl.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
            lbl.numberOfLines = 0;
            lbl.text = title;
            lbl;
        });
        [v addSubview:lbl];
        return v;
    }
    else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (self.chekBoxType == QuestionCheckBoxWithHeader) {
        NSDictionary *dict = self.sourceArray[section];
        CGFloat title_height = [SZQuestionItem heightForString:dict[@"title"]
                                                         width:self.titleWidth
                                                      fontSize:self.configure.titleFont
                                                 oneLineHeight:self.configure.oneLineHeight];
        return title_height;
    }
    else {
        return 0;
    }
}

/**
 *  返回各个Cell的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.chekBoxType == QuestionCheckBoxWithHeader) {
        
        NSDictionary *dict = self.sourceArray[indexPath.section];
        if ([dict[@"type"] intValue] == SZQuestionOpenQuestion) {
            self.height += self.configure.oneLineHeight;
            NSLog(@"%f", self.height);
            return self.configure.oneLineHeight;
        }
        else {
            
            NSArray *optionArray = dict[@"option"];
            NSString *optionString = [NSString stringWithFormat:@"M、%@", optionArray[indexPath.row]];
            CGFloat option_height = [SZQuestionItem heightForString:optionString width:self.OptionWidth fontSize:self.configure.optionFont oneLineHeight:self.configure.oneLineHeight];
            self.height += option_height;
            NSLog(@"%f", self.height);
            return option_height;
        }
    }
    else {
        
        CGFloat topDistance = (indexPath.row == 0 ? self.configure.topDistance : 0);
        NSDictionary *dict = self.sourceArray[indexPath.row];
        
        if ([dict[@"type"] intValue] == SZQuestionOpenQuestion) {
            
            CGFloat title_height = [SZQuestionItem heightForString:dict[@"title"]
                                                             width:self.titleWidth
                                                          fontSize:self.configure.titleFont
                                                     oneLineHeight:self.configure.oneLineHeight];
            if (self.configure.answerFrameFixedHeight && self.configure.answerFrameUseTextView == YES) {

                self.height += title_height + self.configure.answerFrameFixedHeight + 10 + topDistance;
                NSLog(@"%f", self.height);
                return title_height + self.configure.answerFrameFixedHeight + 10 + topDistance;

            }
            if ([dict[@"marked"] length] > 0) {
                CGFloat answer_width = self.view.frame.size.width - self.configure.optionSideMargin * 2;
                CGFloat answer_height = [SZQuestionItem heightForString:dict[@"marked"] width:answer_width - 10 fontSize:self.configure.optionFont oneLineHeight:self.configure.oneLineHeight];
                if (self.configure.answerFrameLimitHeight && answer_height > self.configure.answerFrameLimitHeight && self.configure.answerFrameUseTextView == YES) {

                    self.height += title_height + self.configure.answerFrameLimitHeight + 10 + topDistance;
                    NSLog(@"%f", self.height);
                    return title_height + self.configure.answerFrameLimitHeight + 10 + topDistance;
                }
                self.height += title_height + answer_height + 10 + topDistance;
                NSLog(@"%f", self.height);
                return title_height + answer_height + 10 + topDistance;
            }
            self.height += title_height + self.configure.oneLineHeight + topDistance;
            NSLog(@"%f", self.height);
            return title_height + self.configure.oneLineHeight + topDistance;
        }
        else {
            
            CGFloat title_height = [SZQuestionItem heightForString:dict[@"title"]
                                                             width:self.titleWidth
                                                          fontSize:self.configure.titleFont
                                                     oneLineHeight:self.configure.oneLineHeight];
            CGFloat option_height = 0;
            for (NSString *str in dict[@"option"]) {
                NSString *optionString = [NSString stringWithFormat:@"M、%@", str];
                option_height += [SZQuestionItem heightForString:optionString width:self.OptionWidth fontSize:self.configure.optionFont oneLineHeight:self.configure.oneLineHeight];
            }
            self.height += title_height + option_height + topDistance;
            NSLog(@"%f", self.height);
            return title_height + option_height + topDistance;
        }
    }
}

#pragma mark - 懒加载

- (NSMutableArray *)arrayM {
    
    if (_arrayM == nil) {
        _arrayM = [[NSMutableArray alloc] initWithArray:self.sourceArray];
    }
    return _arrayM;
}

@end
