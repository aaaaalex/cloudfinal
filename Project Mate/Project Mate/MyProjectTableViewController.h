//
//  MyProjectTableViewController.h
//  Project Mate
//
//  Created by Zongheng Wang on 5/18/13.
//  Copyright (c) 2013 Cloud Computing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MyProject.h"
#import "MyCategorizedProjectTableViewController.h"
#import "MyCreateProjectViewController.h"
#import "MyAppDelegate.h"

@interface MyProjectTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *recentProjects;
@property (nonatomic, strong) NSMutableArray *projectsOverview;
@property (nonatomic, strong) NSString *userid;
@end
