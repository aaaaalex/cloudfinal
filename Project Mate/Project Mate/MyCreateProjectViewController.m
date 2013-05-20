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
	
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 11;
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
		
			UILabel *mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 15.0, 90.0, 20.0)];
			mainLabel.tag = 1;
			mainLabel.font = [UIFont systemFontOfSize:15.0];
			mainLabel.textAlignment = NSTextAlignmentRight;
			mainLabel.textColor = [UIColor grayColor];
			mainLabel.backgroundColor = [UIColor clearColor];
			[cell.contentView addSubview:mainLabel];
			
			if (indexPath.row == 0) {
				UITextField *title = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 210, 21)];
				title.placeholder = @"new project title";
				title.tag = 2;
				title.autocorrectionType = UITextAutocorrectionTypeNo;
				title.autocapitalizationType = YES;
				[title setClearButtonMode:UITextFieldViewModeWhileEditing];
				title.returnKeyType = UIReturnKeyNext;
				//title.delegate = self;
				title.enablesReturnKeyAutomatically = YES;
				cell.accessoryView = title;
			} else if (indexPath.row == 2) {
				UITextField *description = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 210, 21)];
				description.placeholder = @"new project description";
				description.tag = 2;
				description.autocorrectionType = UITextAutocorrectionTypeNo;
				description.autocapitalizationType = YES;
				[description setClearButtonMode:UITextFieldViewModeWhileEditing];
				description.returnKeyType = UIReturnKeyNext;
				//description.delegate = self;
				description.enablesReturnKeyAutomatically = YES;
				cell.accessoryView = description;
			} else if (indexPath.row == 4) {
				UILabel *owner = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 210.0, 21)];
				owner.tag = 2;
				owner.font = [UIFont systemFontOfSize:15.0];
				owner.textAlignment = NSTextAlignmentLeft;
				owner.textColor = [UIColor grayColor];
				owner.backgroundColor = [UIColor clearColor];
				owner.text = @"David Beckham";
				cell.accessoryView = owner;
			} else if (indexPath.row == 6) {
				NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
				[dateFormatter setDateFormat:@"yyyy-MM-dd, HH:mm"];
				NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
				
				UILabel *starttime = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 210.0, 21)];
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
				
				UILabel *deadline = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 210.0, 21)];
				deadline.tag = 2;
				deadline.font = [UIFont systemFontOfSize:15.0];
				deadline.textAlignment = NSTextAlignmentLeft;
				deadline.textColor = [UIColor blackColor];
				deadline.backgroundColor = [UIColor clearColor];
				deadline.text = dateString;
				cell.accessoryView = deadline;
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
    if(indexPath.row == 8) {
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
		[self.view endEditing:YES];
		
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
	
	NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:8 inSection:0];
	((UILabel *)[[self.tableView cellForRowAtIndexPath:selectedIndexPath] viewWithTag:2]).text = dateString;
	NSLog(@"%d %d", selectedIndexPath.section, selectedIndexPath.row);
    [_aac dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)DatePickercancelClick:(id)sender
{
    [_aac dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark - Text field
/*
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
*/
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
