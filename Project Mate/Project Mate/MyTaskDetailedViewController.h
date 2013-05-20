//
//  MyTaskDetailedViewController.h
//  Project Mate
//
//  Created by 钱 紫霞 on 5/20/13.
//  Copyright (c) 2013 Cloud Computing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@interface MyTaskDetailedViewController : UITableViewController
@property (nonatomic, strong) Task *currentTask;
@property (nonatomic, strong) NSNumber *projectProgress;

- (id) initWithMyTast: (Task *) currentTask;
@end
