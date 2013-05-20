//
//  MyLoginViewController.h
//  Project Mate
//
//  Created by Zongheng Wang on 5/17/13.
//  Copyright (c) 2013 Cloud Computing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MyTabBarController.h"
#import "MySignUpViewController.h"
#import "MyAppDelegate.h"

@interface MyLoginViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) UITextField *loginId;
@property (strong, nonatomic) UITextField *password;

@property (strong, nonatomic) UITableView *accountField;

@property (strong, nonatomic) IBOutlet UIButton *Login;
@property (strong, nonatomic) IBOutlet UIButton *SignUp;

@property CGPoint originalCenter;

@property BOOL loginSuccessfully;

- (IBAction)backgroundTouched:(id)sender;

@end
