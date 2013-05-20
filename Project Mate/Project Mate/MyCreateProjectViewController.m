//
//  MyCreateProjectViewController.m
//  Project Mate
//
//  Created by Zongheng Wang on 5/19/13.
//  Copyright (c) 2013 Cloud Computing. All rights reserved.
//

#import "MyCreateProjectViewController.h"

@interface MyCreateProjectViewController ()

@end

@implementation MyCreateProjectViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
		[[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
		self.tableView.scrollEnabled = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"New Project";
	UIBarButtonItem *leftBarButtonItem  = [[UIBarButtonItem alloc]
										   initWithTitle:@"Cancel"
										   style:UIBarButtonItemStyleBordered
										   target:self
										   action:@selector(cancelButtonWasPressed:)];
	[self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
	
	UIBarButtonItem *rightBarButtonItem  = [[UIBarButtonItem alloc]
										   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
										   target:self
										   action:@selector(doneButtonWasPressed:)];
	[self.navigationItem setRightBarButtonItem:rightBarButtonItem];
	
	UILabel *gap = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 30.0, 200.0, 10.0)];
	gap.backgroundColor = [UIColor clearColor];
	self.tableView.tableHeaderView = gap;
	
	self.originalCenter = self.view.center;
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

- (void)doneButtonWasPressed:(id)sender
{
	NSIndexPath *IndexPath0 = [NSIndexPath indexPathForRow:0 inSection:0];
	UITextField *targetTextField0 = (UITextField *)[[self.tableView cellForRowAtIndexPath:IndexPath0] viewWithTag:2];
	NSIndexPath *IndexPath1 = [NSIndexPath indexPathForRow:2 inSection:0];
	UITextField *targetTextField1 = (UITextField *)[[self.tableView cellForRowAtIndexPath:IndexPath1] viewWithTag:2];
	NSIndexPath *IndexPath2 = [NSIndexPath indexPathForRow:8 inSection:0];
	NSIndexPath *IndexPath3 = [NSIndexPath indexPathForRow:10 inSection:0];
	UITextField *targetTextField3 = (UITextField *)[[self.tableView cellForRowAtIndexPath:IndexPath3] viewWithTag:2];
	
	[self.view endEditing:YES];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	self.view.center = CGPointMake(self.originalCenter.x, self.originalCenter.y - 42);
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	[UIView commitAnimations];
	
	if(targetTextField0.text == nil || [targetTextField0.text isEqualToString:@""]) {
		[self shakeView:[self.tableView cellForRowAtIndexPath:IndexPath0]];
		return;
	}
	
	if(targetTextField1.text == nil || [targetTextField1.text isEqualToString:@""]) {
		[self shakeView:[self.tableView cellForRowAtIndexPath:IndexPath1]];
		return;
	}
	
	if(_local_deadline == nil) {
		[self shakeView:[self.tableView cellForRowAtIndexPath:IndexPath2]];
		return;
	}
		
	if(!([_local_starttime compare:_local_deadline] == NSOrderedAscending)) {
		UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error"
															message:@"Deadline has already passed."
														   delegate:nil
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
		[errorView show];
		return;
	}
	
	if(targetTextField3.text == nil || [targetTextField3.text isEqualToString:@""]) {
		[self shakeView:[self.tableView cellForRowAtIndexPath:IndexPath3]];
		return;
	}
	
	NSArray *members = [targetTextField3.text componentsSeparatedByString: @","];
	NSString *inexistenceList = @"";
	MyAppDelegate *appdelegate = (MyAppDelegate *)[[UIApplication sharedApplication] delegate];
	for(int i = 0; i < members.count; i++) {
		
		NSString *user = [members objectAtIndex:i];
		
		if([user isEqualToString:appdelegate.userid]) {
			UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error"
																message:[NSString stringWithFormat:@"Do not contain yourself again in the members field."]
															   delegate:nil
													  cancelButtonTitle:@"OK"
													  otherButtonTitles:nil];
			[errorView show];
			return;
		}
		
		for(int j = i + 1; j < members.count; j++) {
			if([[members objectAtIndex:j] isEqualToString:user]) {
				UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error"
																	message:[NSString stringWithFormat:@"User %@ is included more than once", user]
																   delegate:nil
														  cancelButtonTitle:@"OK"
														  otherButtonTitles:nil];
				[errorView show];
				return;
			}
		}
		
		NSError *error = nil;
		NSString *urlstr = [NSString stringWithFormat:@"http://projectmatefinalfinal.appspot.com/checkuser?userId=%@", user];
		NSURL *url = [NSURL URLWithString:urlstr];
		
		
		NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
		if(error) {
			NSLog(@"Error on getting JSON: %@", [error description]);
		}
		
		NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
		if(error) {
			NSLog(@"Error parsing JSON: %@", [error description]);
		}

		NSString *result = [JSON objectForKey:@"result"];
		if([result isEqualToString:@"no"]) {
			if([inexistenceList isEqualToString:@""])
				inexistenceList = [NSString stringWithFormat:@"%@", user];
			else
				inexistenceList = [NSString stringWithFormat:@"%@, %@", inexistenceList, user];
		}

	}
	
	if(![inexistenceList isEqualToString:@""]) {
		UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error"
															message:[NSString stringWithFormat:@"The following users do not exist: %@.", inexistenceList]
														   delegate:nil
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
		[errorView show];
		return;
	}
	
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MM/dd/yyyy - HH:mm:ss"];
	NSString *dateString = [dateFormatter stringFromDate:_local_deadline];
	
	NSError *error = nil;
	NSString *urlstr = [NSString stringWithFormat:@"http://projectmatefinalfinal.appspot.com/createproject?owner=%@&descr=%@&title=%@&deadline=%@&status=0&members=%@", appdelegate.userid, targetTextField1.text, targetTextField0.text, dateString, targetTextField3.text];
	NSURL *url = [NSURL URLWithString:[urlstr stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
	
	NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
	if(error) {
		NSLog(@"Error on getting JSON: %@", [error description]);
	}
	
	NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
	if(error) {
		NSLog(@"Error parsing JSON: %@", [error description]);
	}
	
	NSString *result = [JSON objectForKey:@"result"];
	if([result isEqualToString:@"no"]) {
		UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error"
															message:[NSString stringWithFormat:@"Fail to create project \"%@\".", targetTextField0.text]
														   delegate:nil
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
		[errorView show];
		return;
	} else {
		UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Sucess"
															message:[NSString stringWithFormat:@"Project \"%@\" created sucessfully.", targetTextField0.text]
														   delegate:self
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
		[errorView show];
	}
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row % 2)
		return 10;
	else
		return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell;
	if(indexPath.row % 2 == 1)
    	cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell_nil"];
	else
		cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell%d", indexPath.row]];

	if (cell == nil) {
		
		if(indexPath.row % 2 == 0) {
			
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[NSString stringWithFormat:@"Cell%d", indexPath.row]];
			
			CAGradientLayer *background = [CAGradientLayer layer];
			[background setFrame: CGRectMake(0, 0, 320, 50)];
			[background setColors:[NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:1 alpha:0.5] CGColor], (id)[[UIColor colorWithWhite:0.99 alpha:0.7] CGColor], (id)[[UIColor colorWithWhite:0.95 alpha:0.9] CGColor], nil]];
			[[[cell viewForBaselineLayout] layer] insertSublayer:background atIndex:0];
			[[[cell viewForBaselineLayout] layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
			[[[cell viewForBaselineLayout] layer] setBorderWidth:0.8];
			[[[cell viewForBaselineLayout] layer] setMasksToBounds:YES];
		
			UILabel *mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 17.0, 80.0, 20.0)];
			mainLabel.tag = 1;
			mainLabel.font = [UIFont systemFontOfSize:13.0];
			mainLabel.textAlignment = NSTextAlignmentRight;
			mainLabel.textColor = [UIColor grayColor];
			mainLabel.backgroundColor = [UIColor clearColor];
			[cell.contentView addSubview:mainLabel];
			
			if (indexPath.row == 0) {
				UITextField *title = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 220, 20)];
				title.placeholder = @"new project title";
				title.tag = 2;
				title.autocorrectionType = UITextAutocorrectionTypeNo;
				title.autocapitalizationType = YES;
				[title setClearButtonMode:UITextFieldViewModeWhileEditing];
				title.returnKeyType = UIReturnKeyNext;
				title.delegate = self;
				title.enablesReturnKeyAutomatically = YES;
				cell.accessoryView = title;
			} else if (indexPath.row == 2) {
				UITextField *description = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 220, 20)];
				description.placeholder = @"new project description";
				description.tag = 2;
				description.autocorrectionType = UITextAutocorrectionTypeNo;
				description.autocapitalizationType = YES;
				[description setClearButtonMode:UITextFieldViewModeWhileEditing];
				description.returnKeyType = UIReturnKeyDone;
				description.delegate = self;
				description.enablesReturnKeyAutomatically = YES;
				cell.accessoryView = description;
			} else if (indexPath.row == 4) {
				MyAppDelegate *appdelegate = (MyAppDelegate *)[[UIApplication sharedApplication] delegate];
				
				UILabel *owner = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220.0, 20)];
				owner.tag = 2;
				owner.font = [UIFont systemFontOfSize:15.0];
				owner.textAlignment = NSTextAlignmentLeft;
				owner.textColor = [UIColor grayColor];
				owner.backgroundColor = [UIColor clearColor];
				owner.text = [NSString stringWithFormat:@"%@ %@", appdelegate.userfname, appdelegate.userlname];
				cell.accessoryView = owner;
			} else if (indexPath.row == 6) {
				NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
				[dateFormatter setDateFormat:@"yyyy-MM-dd, HH:mm"];
				_local_starttime = [NSDate date];
				NSString *dateString = [dateFormatter stringFromDate:_local_starttime];
				
				UILabel *starttime = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220.0, 20)];
				starttime.tag = 2;
				starttime.font = [UIFont systemFontOfSize:15.0];
				starttime.textAlignment = NSTextAlignmentLeft;
				starttime.textColor = [UIColor grayColor];
				starttime.backgroundColor = [UIColor clearColor];
				starttime.text = dateString;
				cell.accessoryView = starttime;
			} else if (indexPath.row == 8) {
				NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
				[dateFormatter setDateFormat:@"yyyy-MM-dd, HH:mm"];
				NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
				
				UILabel *deadline = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220.0, 20)];
				deadline.tag = 2;
				deadline.font = [UIFont systemFontOfSize:15.0];
				deadline.textAlignment = NSTextAlignmentLeft;
				deadline.textColor = [UIColor blackColor];
				deadline.backgroundColor = [UIColor clearColor];
				deadline.text = dateString;
				cell.accessoryView = deadline;
			} else if (indexPath.row == 10) {
				UITextField *members = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 220, 21)];
				members.placeholder = @"add members";
				members.tag = 2;
				members.autocorrectionType = UITextAutocorrectionTypeNo;
				members.autocapitalizationType = NO;
				[members setClearButtonMode:UITextFieldViewModeWhileEditing];
				members.returnKeyType = UIReturnKeyDone;
				members.delegate = self;
				members.enablesReturnKeyAutomatically = YES;
				cell.accessoryView = members;
			}
			
		} else {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell_nil"];
		}
		
		if(indexPath.row == 0) {
			((UILabel *)[cell viewWithTag:1]).text = @"title :";
		} else if(indexPath.row == 2) {
			((UILabel *)[cell viewWithTag:1]).text = @"description :";
		} else if(indexPath.row == 4) {
			((UILabel *)[cell viewWithTag:1]).text = @"owner :";
		} else if(indexPath.row == 6) {
			((UILabel *)[cell viewWithTag:1]).text = @"starttime :";
		} else if(indexPath.row == 8) {
			((UILabel *)[cell viewWithTag:1]).text = @"deadline :";
		} else if(indexPath.row == 10) {
			((UILabel *)[cell viewWithTag:1]).text = @"members :";
		}
	}
    // Configure the cell...
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	[self.view endEditing:YES];
	
    if(indexPath.row == 8) {
		
		int y = self.originalCenter.y - 180;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		self.view.center = CGPointMake(self.originalCenter.x, y);
		[UIView commitAnimations];
		
		_aac = [[UIActionSheet alloc] initWithTitle:@"\n\n"
										   delegate:self
								  cancelButtonTitle:nil
							 destructiveButtonTitle:nil
								  otherButtonTitles:nil];
		
		_DatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
		_DatePicker.datePickerMode=UIDatePickerModeDateAndTime;
		UIToolbar *pickerDateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];	pickerDateToolbar.barStyle = UIBarStyleBlackOpaque;
		[pickerDateToolbar sizeToFit];
		
		NSMutableArray *barItems = [[NSMutableArray alloc] init];
		UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DatePickerDoneClick:)];
		[barItems addObject:doneBtn];
		
		UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
		
		UILabel *toolBarItemlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180,30)];
		
		[toolBarItemlabel setTextAlignment:NSTextAlignmentCenter];
		[toolBarItemlabel setTextColor:[UIColor whiteColor]];
		[toolBarItemlabel setFont:[UIFont boldSystemFontOfSize:16]];
		[toolBarItemlabel setBackgroundColor:[UIColor clearColor]];
		toolBarItemlabel.text = [NSString stringWithFormat:@"Select Time"];
		
		UIBarButtonItem *buttonLabel =[[UIBarButtonItem alloc]initWithCustomView:toolBarItemlabel];
		[barItems addObject:buttonLabel];
		
		[barItems addObject:flexSpace];
		
		UIBarButtonItem *SelectBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(DatePickercancelClick:)];
		[barItems addObject:SelectBtn];
		
		[pickerDateToolbar setItems:barItems animated:YES];
		[_aac addSubview:pickerDateToolbar];
		[_aac addSubview:_DatePicker];
		
		CGRect myImageRect = CGRectMake(0.0f, 300.0f, 320.0f, 175.0f);;
		[_aac showFromRect:myImageRect inView:self.view animated:YES ];
		
		[UIView beginAnimations:nil context:nil];
		[_aac setBounds:CGRectMake(0,0,320, 464)];
		
		[UIView commitAnimations];
	} else {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		self.view.center = CGPointMake(self.originalCenter.x, self.originalCenter.y - 42);
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
		[UIView commitAnimations];
	}
}

-(void)DatePickerDoneClick:(id)sender
{    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd, HH:mm"];
	NSString *dateString = [dateFormatter stringFromDate:_DatePicker.date];
	_local_deadline = _DatePicker.date;
	
	NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:8 inSection:0];
	((UILabel *)[[self.tableView cellForRowAtIndexPath:selectedIndexPath] viewWithTag:2]).text = dateString;
    [_aac dismissWithClickedButtonIndex:0 animated:YES];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	self.view.center = CGPointMake(self.originalCenter.x, self.originalCenter.y - 42);
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	[UIView commitAnimations];
}

-(void)DatePickercancelClick:(id)sender
{
    [_aac dismissWithClickedButtonIndex:0 animated:YES];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	self.view.center = CGPointMake(self.originalCenter.x, self.originalCenter.y - 42);
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	[UIView commitAnimations];
}

#pragma mark - Text field

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
	
	NSIndexPath *IndexPath = [NSIndexPath indexPathForRow:10 inSection:0];
	UITextField *targetTextField = (UITextField *)[[self.tableView cellForRowAtIndexPath:IndexPath] viewWithTag:2];	
	int y = self.originalCenter.y - 125;
	
	if(textField == targetTextField)
	{
		[UIView beginAnimations:nil context:NULL];
    	[UIView setAnimationDuration:0.3];
    	self.view.center = CGPointMake(self.originalCenter.x, y);
    	[UIView commitAnimations];
	} else {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		self.view.center = CGPointMake(self.originalCenter.x, self.originalCenter.y - 42);
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
		[UIView commitAnimations];
	}
	return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	NSIndexPath *IndexPath = [NSIndexPath indexPathForRow:10 inSection:0];
	UITextField *targetTextField = (UITextField *)[[self.tableView cellForRowAtIndexPath:IndexPath] viewWithTag:2];

	if([string isEqualToString:@" "] && targetTextField == textField)
		return NO;
	
	return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
	NSIndexPath *IndexPath0 = [NSIndexPath indexPathForRow:0 inSection:0];
	UITextField *targetTextField0 = (UITextField *)[[self.tableView cellForRowAtIndexPath:IndexPath0] viewWithTag:2];
	NSIndexPath *IndexPath1 = [NSIndexPath indexPathForRow:2 inSection:0];
	UITextField *targetTextField1 = (UITextField *)[[self.tableView cellForRowAtIndexPath:IndexPath1] viewWithTag:2];
	NSIndexPath *IndexPath2 = [NSIndexPath indexPathForRow:10 inSection:0];
	UITextField *targetTextField2 = (UITextField *)[[self.tableView cellForRowAtIndexPath:IndexPath2] viewWithTag:2];
	
	if (textField == targetTextField0) {
		[targetTextField1 becomeFirstResponder];
	} else if (textField == targetTextField1) {
		[self.view endEditing:YES];
	} else if (textField == targetTextField2) {
		[self.view endEditing:YES];
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		self.view.center = CGPointMake(self.originalCenter.x, self.originalCenter.y - 42);
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
		[UIView commitAnimations];
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
