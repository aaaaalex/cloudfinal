//
//  MySettingsViewController.m
//  Project Mate
//
//  Created by Zongheng Wang on 5/18/13.
//  Copyright (c) 2013 Cloud Computing. All rights reserved.
//

#import "MySettingsViewController.h"

@interface MySettingsViewController ()

@end

@implementation MySettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Settings", @"Settings");
		self.tabBarItem.image = [UIImage imageNamed:@"settings"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_logOut setTitle:@"Log Out" forState:UIControlStateNormal];
	[_logOut setBackgroundImage:[[UIImage imageNamed:@"red button.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logOutPressed:(id)sender {
	[_logOut setTitle:@"Logging Out..." forState:UIControlStateNormal];
	[self.navigationController popToRootViewControllerAnimated:YES];
}

@end
