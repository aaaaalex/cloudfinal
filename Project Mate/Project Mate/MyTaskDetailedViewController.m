//
//  MyTaskDetailedViewController.m
//  Project Mate
//
//  Created by 钱 紫霞 on 5/19/13.
//  Copyright (c) 2013 Cloud Computing. All rights reserved.
//

#import "MyTaskDetailedViewController.h"

@interface MyTaskDetailedViewController ()

@end

@implementation MyTaskDetailedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"My Task";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"Get into task detail");
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonPressed:)];
    [self.navigationItem setRightBarButtonItem:rightButtonItem];
    
    
}

-(void)editButtonPressed:(id)sender
{
    NSLog(@"Get edited");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
