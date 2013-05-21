//
//  MyProjTaskViewController.h
//  Project Mate
//
//  Created by 钱 紫霞 on 5/20/13.
//  Copyright (c) 2013 Cloud Computing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyProject.h"
#import "MyAppDelegate.h"
#import "MyProjTaskDetailViewController.h"
#import "MyTaskCreateViewController.h"
@interface MyProjTaskViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSString *pid;
@property (strong, nonatomic) MyProject *currProj;
@property (strong, nonatomic) NSMutableArray *alltasks;
@property (strong, nonatomic) NSString *userid;
@end
