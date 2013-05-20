//
//  MyInvitationViewController.h
//  Project Mate
//
//  Created by Zongheng Wang on 5/19/13.
//  Copyright (c) 2013 Zongheng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyProject.h"
#import <QuartzCore/QuartzCore.h>
#import "MyAppDelegate.h"

@interface MyInvitationViewController : UITableViewController

@property NSMutableArray *invitations;
@property NSIndexPath *tmpIndexPath; //to fix the didSelectRowAtIndexPath overflow bug

@property (nonatomic, strong) NSMutableArray *lname, *fname;

@end
