//
//  MyTaskDetailedViewController.h
//  Project Mate
//
//  Created by 钱 紫霞 on 5/20/13.
//  Copyright (c) 2013 Cloud Computing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "MyTaskEditViewController.h"

@interface MyTaskDetailedViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) Task *currentTask;
@property (nonatomic, strong) NSNumber *projectProgress;

- (id)initWithMyTask: (Task *)myTask;

@end
