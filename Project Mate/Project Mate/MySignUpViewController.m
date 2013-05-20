//
//  MySignUpViewController.m
//  Project Mate
//
//  Created by Zongheng Wang on 5/18/13.
//  Copyright (c) 2013 Cloud Computing. All rights reserved.
//

#import "MySignUpViewController.h"

@interface MySignUpViewController ()

@end

@implementation MySignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UIView *backView1 = [[UIView alloc] initWithFrame:CGRectZero];
	backView1.backgroundColor = [UIColor clearColor];
	UIView *backView2 = [[UIView alloc] initWithFrame:CGRectZero];
	backView2.backgroundColor = [UIColor clearColor];
	
	_nameField = [[UITableView alloc] initWithFrame:CGRectMake(10, 25, 300, 100) style:UITableViewStyleGrouped];
	_nameField.dataSource = self;
	_nameField.delegate = self;
	_nameField.scrollEnabled = NO;
	_nameField.backgroundView = backView1;
	[self.view addSubview:_nameField];
	
	_accountField = [[UITableView alloc] initWithFrame:CGRectMake(10, 206, 300, 150) style:UITableViewStyleGrouped];
	_accountField.dataSource = self;
	_accountField.delegate = self;
	_accountField.scrollEnabled = NO;
	_accountField.backgroundView = backView2;
	[self.view addSubview:_accountField];
	
	self.title = @"Sign Up";
	UIBarButtonItem *leftBarButtonItem  = [[UIBarButtonItem alloc]
										   initWithTitle:@"Cancel"
										   style:UIBarButtonItemStyleBordered
										   target:self
										   action:@selector(cancelButtonWasPressed:)];
	[self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
	
	self.originalCenter = self.view.center;
	
	[_signUp setEnabled:NO];
	[_signUp setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
	[_signUp setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
	
	UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
	NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:UITextAttributeFont];
	[_gender setTitleTextAttributes:attributes forState:UIControlStateNormal];
	
	_sex = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelButtonWasPressed:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)signUpPressed:(id)sender {
	
	if([_password1.text isEqualToString:_password2.text]) {
		
		NSError *error = nil;
		NSString *urlstr = [NSString stringWithFormat:@"http://projectmatefinalfinal.appspot.com/signup?userId=%@&userPwd=%@&lastName=%@&firstName=%@&sex=%@", _email.text, _password1.text, _lastName.text, _firstName.text, _sex];
		NSLog(@"%@",urlstr);
		
		NSURL *url = [NSURL URLWithString:urlstr];
		
		NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
		if(error) {
			NSLog(@"Error on getting JSON: %@", [error description]);
		}
		
		NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
		if(error) {
			NSLog(@"Error parsing JSON: %@", [error description]);
		}
		
		NSLog(@"%@", JSON);
		NSString *result = [JSON objectForKey:@"result"];
		if([result isEqualToString:@"no"]){
			UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Sign up error"
																message:@"Username already exists."
															   delegate:nil
													  cancelButtonTitle:@"OK"
													  otherButtonTitles:nil];
			[errorView show];
			return;
		} else {
			UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Congratulations"
																message:@"Sign up sucessfully. Welcome to Project Mate!"
															   delegate:self
													  cancelButtonTitle:@"OK"
													  otherButtonTitles:nil];
			[errorView show];
		}
		
	} else {
		UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Sign up error"
															message:@"Please confirm your passward again."
														   delegate:nil
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
		[errorView show];
	}
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changeSegment:(id)sender {
	if(_gender.selectedSegmentIndex == 0) {
		_sex = @"female";
	} else if(_gender.selectedSegmentIndex == 1) {
		_sex = @"male";
	}
	if(_firstName.text.length == 0 || _lastName.text.length == 0 || _email.text.length == 0
	   || _password1.text.length == 0 || _password2.text.length == 0 || _sex == nil) {
		[_signUp setEnabled:NO];
		[_signUp setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
	} else {
		[_signUp setEnabled:YES];
		[_signUp setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
	}
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(tableView == _nameField)
    	return 2;
	else
		return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(tableView == _nameField) {
		UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"NameCell"];
		if(cell == nil)
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NameCell"];
	
			[cell setBackgroundColor:[UIColor whiteColor]];
	
		if (indexPath.row == 0) {
			_firstName = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, 260, 21)];
			_firstName.placeholder = @"First Name";
			_firstName.autocorrectionType = UITextAutocorrectionTypeNo;
			[_firstName setClearButtonMode:UITextFieldViewModeWhileEditing];
			_firstName.returnKeyType = UIReturnKeyNext;
			_firstName.delegate = self;
			_firstName.enablesReturnKeyAutomatically = YES;
			cell.accessoryView = _firstName ;
		} else {
			_lastName = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, 260, 21)];
			_lastName.placeholder = @"Last Name";
			_lastName.autocorrectionType = UITextAutocorrectionTypeNo;
			[_lastName setClearButtonMode:UITextFieldViewModeWhileEditing];
			_lastName.returnKeyType = UIReturnKeyNext;
			_lastName.delegate = self;
			_lastName.enablesReturnKeyAutomatically = YES;
			cell.accessoryView = _lastName;
		}
	
		[self.view addSubview:_firstName];
		[self.view addSubview:_lastName];
	
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		return cell;
	} else {
		UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AccountCell"];
		if(cell == nil)
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AccountCell"];
		
		[cell setBackgroundColor:[UIColor whiteColor]];
		
		if (indexPath.row == 0) {
			_email = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, 260, 21)];
			_email.placeholder = @"Email";
			_email.autocorrectionType = UITextAutocorrectionTypeNo;
			_email.autocapitalizationType = NO;
			[_email setClearButtonMode:UITextFieldViewModeWhileEditing];
			_email.returnKeyType = UIReturnKeyNext;
			_email.delegate = self;
			_email.enablesReturnKeyAutomatically = YES;
			cell.accessoryView = _email ;
		} else if (indexPath.row == 1) {
			_password1 = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, 260, 21)];
			_password1.placeholder = @"New Password";
			_password1.secureTextEntry = YES;
			_password1.autocorrectionType = UITextAutocorrectionTypeNo;
			[_password1 setClearButtonMode:UITextFieldViewModeWhileEditing];
			_password1.returnKeyType = UIReturnKeyNext;
			_password1.delegate = self;
			_password1.enablesReturnKeyAutomatically = YES;
			cell.accessoryView = _password1;
		} else {
			_password2 = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, 260, 21)];
			_password2.placeholder = @"Confirm Password";
			_password2.secureTextEntry = YES;
			_password2.autocorrectionType = UITextAutocorrectionTypeNo;
			[_password2 setClearButtonMode:UITextFieldViewModeWhileEditing];
			_password2.returnKeyType = UIReturnKeyGo;
			_password2.delegate = self;
			_password2.enablesReturnKeyAutomatically = YES;
			cell.accessoryView = _password2;
		}
		
		[self.view addSubview:_email];
		[self.view addSubview:_password1];
		[self.view addSubview:_password2];
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		return cell;
	}
}

#pragma mark - Keyboard appears/disappears

- (IBAction)backgroundTouched:(id)sender {
	
	[self.view endEditing:YES];

	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.view.center = CGPointMake(self.originalCenter.x, self.originalCenter.y);
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
    [UIView commitAnimations];
}

#pragma mark - Text field

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
	int y;
	if(textField == _firstName)
		y = self.originalCenter.y;
	else if(textField == _lastName)
		y = self.originalCenter.y - 50;
	else if(textField == _email)
		y = self.originalCenter.y - 100;
	else if(textField == _password1)
		y = self.originalCenter.y - 130;
	else
		y = self.originalCenter.y - 160;
	
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.view.center = CGPointMake(self.originalCenter.x, y);
    [UIView commitAnimations];
	
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	if([string isEqualToString:@" "])
		return NO;
		
	NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [textField setText:newString];
	if(_firstName.text.length == 0 || _lastName.text.length == 0 || _email.text.length == 0
		|| _password1.text.length == 0 || _password2.text.length == 0 || _sex == nil) {
		[_signUp setEnabled:NO];
		[_signUp setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
	} else {
		[_signUp setEnabled:YES];
		[_signUp setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
	}
	return NO;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
	[_signUp setEnabled:NO];
	[_signUp setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
	return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
	if (textField == _firstName) {
		[_lastName becomeFirstResponder];
	} else if (textField == _lastName) {
		[_email becomeFirstResponder];
	} else if (textField == _email) {
		[_password1 becomeFirstResponder];
	} else if (textField == _password1) {
		[_password2 becomeFirstResponder];
	} else {
		if(_firstName.text.length == 0 || _lastName.text.length == 0) {
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.3];
			self.view.center = self.originalCenter;
			[UIView commitAnimations];
			
			[self shakeView:_nameField];
		} else if(_sex == nil) {
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.3];
			self.view.center = CGPointMake(self.originalCenter.x, self.originalCenter.y - 100);
			[UIView commitAnimations];
			
			[self shakeView:_gender];
		}
		else if(_email.text.length == 0 || _password1.text.length == 0)
			[self shakeView:_accountField];
		else
			[self signUpPressed:0];
	}
    return YES;
}

#pragma mark - Shake a view

- (void)shakeView:(UIView*)view
{
    CGAffineTransform translateRight = CGAffineTransformTranslate(CGAffineTransformIdentity, 10.0, 0.0);
    CGAffineTransform translateLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, -10.0, 0.0);
	
    view.transform = translateLeft;
	
    [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:4.0];
        view.transform = translateRight;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                view.transform = CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}

@end
