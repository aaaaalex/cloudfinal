//
//  MyTasksTableViewController.h
//  Project Mate
//
//  Created by Alex Xia on 5/18/13.
//  Copyright (c) 2013 Cloud Computing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "MyTaskDetailedViewController.h"
#import "TaskCell.h"
#import "MyAppDelegate.h"
#import "User.h"

@interface MyTasksTableViewController : UITableViewController
@property (strong, nonatomic) NSString *userid;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell;
@property (strong, nonatomic) NSMutableArray *tasks;
@end
