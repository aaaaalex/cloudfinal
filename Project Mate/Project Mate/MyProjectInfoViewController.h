//
//  MyProjectInfoViewController.h
//  Project Mate
//
//  Created by kid on 13-5-20.
//  Copyright (c) 2013年 Cloud Computing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyProject.h"
#import "MyAppDelegate.h"
#import "MyProjTaskViewController.h"

@interface MyProjectInfoViewController : UITableViewController

@property (nonatomic, strong) MyProject *currentProject;
@property (nonatomic, strong) NSNumber *projectProgress;

- (id) initWithMyProject: (MyProject *) currentProject;

@end
