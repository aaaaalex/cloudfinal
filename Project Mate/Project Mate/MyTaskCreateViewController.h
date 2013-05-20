//
//  MyTaskCreateViewController.h
//  Project Mate
//
//  Created by 钱 紫霞 on 5/20/13.
//  Copyright (c) 2013 Cloud Computing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MyAppDelegate.h"
#import "Task.h"

@interface MyTaskCreateViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UITextFieldDelegate>
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) UIDatePicker *DatePicker;
@property (nonatomic, strong) UIActionSheet *aac;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) Task *currTask;
@property CGPoint originalCenter;
@property (nonatomic, strong) NSString *userid;
@end
