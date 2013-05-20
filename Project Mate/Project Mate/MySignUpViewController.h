//
//  MySignUpViewController.h
//  Project Mate
//
//  Created by Zongheng Wang on 5/18/13.
//  Copyright (c) 2013 Cloud Computing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MySignUpViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) UITextField *firstName;
@property (strong, nonatomic) UITextField *lastName;

@property (strong, nonatomic) UITableView *nameField;

@property (strong, nonatomic) UITextField *email;
@property (strong, nonatomic) UITextField *password1;
@property (strong, nonatomic) UITextField *password2;

@property (strong, nonatomic) UITableView *accountField;

@property CGPoint originalCenter;
@property (strong, nonatomic) NSString *sex;

- (IBAction)backgroundTouched:(id)sender;
- (IBAction)changeSegment:(id)sender;

@property (strong, nonatomic) IBOutlet UISegmentedControl *gender;
@property (strong, nonatomic) IBOutlet UIButton *signUp;

@end
