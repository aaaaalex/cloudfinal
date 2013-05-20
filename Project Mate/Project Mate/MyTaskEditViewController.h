//
//  MyTaskEditViewController.h
//  Project Mate
//
//  Created by 钱 紫霞 on 5/20/13.
//  Copyright (c) 2013 Cloud Computing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MyAppDelegate.h"

@interface MyTaskEditViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIDatePicker *DatePicker;
@property (nonatomic, strong) UIActionSheet *aac;
@property (nonatomic, strong) NSMutableArray *array;

@property CGPoint originalCenter;
@end
