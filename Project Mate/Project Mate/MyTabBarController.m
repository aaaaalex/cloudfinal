//
//  MyTabBarController.m
//  Project Mate
//
//  Created by Zongheng Wang on 5/17/13.
//  Copyright (c) 2013 Cloud Computing. All rights reserved.
//

#import "MyTabBarController.h"

@interface MyTabBarController ()

@end

@implementation MyTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		MyProjectTableViewController *projectTableViewController = [[MyProjectTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
		UINavigationController *navForTab1 = [[UINavigationController alloc] initWithRootViewController:projectTableViewController];
		
		MyInvitationViewController *invitationViewController = [[MyInvitationViewController alloc] initWithStyle:UITableViewStylePlain];
		UINavigationController *navForTab3 = [[UINavigationController alloc] initWithRootViewController:invitationViewController];
		
        MyTasksTableViewController *taskViewController = [[MyTasksTableViewController alloc] init];
        UINavigationController *navForTask = [[UINavigationController alloc] initWithRootViewController:taskViewController];
        
        MySettingsViewController *settingsViewController = [[MySettingsViewController  alloc] init];
		
		self.viewControllers = @[navForTab1, navForTask,navForTab3, settingsViewController];
		self.delegate = self;
		self.navigationItem.hidesBackButton = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tab Bar

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
	if([viewController isMemberOfClass:[MySettingsViewController class]])
	{
	}
}

@end
