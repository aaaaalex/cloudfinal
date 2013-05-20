//
//  MyCategorizedProjectTableViewController.h
//  Project Mate
//
//  Created by Zongheng Wang on 5/19/13.
//  Copyright (c) 2013 Cloud Computing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyProject.h"
#import "MyAppDelegate.h"
#import "MyProjectInfoViewController.h"

@interface MyCategorizedProjectTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property NSInteger category;
@property (nonatomic, strong) NSMutableArray *projects;
@property (nonatomic, strong) NSString *userid;
- (id)initWithRequestCategory:(NSInteger)category;

@end
