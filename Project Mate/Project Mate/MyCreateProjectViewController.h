//
//  MyCreateProjectViewController.h
//  Project Mate
//
//  Created by Zongheng Wang on 5/19/13.
//  Copyright (c) 2013 Cloud Computing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MyAppDelegate.h"

@interface MyCreateProjectViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIDatePicker *DatePicker;
@property (nonatomic, strong) UIActionSheet *aac;
@property (nonatomic, strong) NSMutableArray *array;

@property CGPoint originalCenter;

@property (nonatomic, strong) NSDate *local_starttime;
@property (nonatomic, strong) NSDate *local_deadline;

@end
