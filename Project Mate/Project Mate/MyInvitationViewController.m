//
//  MyInvitationViewController.m
//  Project Mate
//
//  Created by Zongheng Wang on 5/19/13.
//  Copyright (c) 2013 Zongheng Wang. All rights reserved.
//

#import "MyInvitationViewController.h"

@interface MyInvitationViewController ()

@end

@implementation MyInvitationViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _invitations = [[NSMutableArray alloc] init];
		MyProject *testitem = [[MyProject alloc] init];
		testitem.title = @"Robot Vision";
		testitem.owner = @"Tian Xia";
		testitem.starttime = [NSDate date];
		testitem.state = 0;
		[_invitations addObject:testitem];
		
		[[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
		
		self.title = NSLocalizedString(@"Invitations", @"Invitations");
		self.tabBarItem.image = [UIImage imageNamed:@"invitations"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]
										   initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
										   target:self
										   action:@selector(editButtonWasPressed:)];
	[self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
	
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getProjects];
		dispatch_async(dispatch_get_main_queue(), ^{
			if(_invitations.count) {
				self.tableView.tableHeaderView = nil;
				[[self tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%d", _invitations.count]];
			} else {
				UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 398.0)];
				message.text = @"You don't have new invitations now.";
				message.font = [UIFont systemFontOfSize:14.0];
				message.textAlignment = NSTextAlignmentCenter;
				message.textColor = [UIColor grayColor];
				message.backgroundColor = [UIColor clearColor];
				self.tableView.tableHeaderView = message;
				[[self tabBarItem] setBadgeValue:nil];
			}
			[[self tableView] reloadData];
		});
    });
}

-(void)refresh {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		MyProject *project1 = [[MyProject alloc] init];
		project1.title = @"Rubik's Cube Solver";
		project1.description = @"This is a project that tries to solve a 3*3*3 cube.";
		NSDate *currentDate = [NSDate date];
		project1.starttime = currentDate;
		project1.owner = @"Angela";
		project1.state = 0;
    	[_invitations addObject:project1];
		dispatch_async(dispatch_get_main_queue(), ^{
    		[self performSelector:@selector(updateTable) withObject:nil afterDelay:0];
		});
	});
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateTable
{
	if(_invitations.count)
		self.tableView.tableHeaderView = nil;
	else {
		UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 398.0)];
		message.text = @"You don't have new invitations now.";
		message.font = [UIFont systemFontOfSize:14.0];
		message.textAlignment = NSTextAlignmentCenter;
		message.textColor = [UIColor grayColor];
		message.backgroundColor = [UIColor clearColor];
		self.tableView.tableHeaderView = message;
	}
	[[self tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%d", _invitations.count]];
	[self.tableView reloadData];
	[self.refreshControl endRefreshing];
}

- (void)editButtonWasPressed:(id)sender
{
	[[self tableView] setEditing:YES animated:YES];
	
	UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]
										  initWithBarButtonSystemItem:UIBarButtonSystemItemDone
										  target:self
										  action:@selector(doneButtonWasPressed:)];
	[self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}

- (void)doneButtonWasPressed:(id)sender
{
	[[self tableView] setEditing:NO animated:YES];
	
	UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]
										  initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
										  target:self
										  action:@selector(editButtonWasPressed:)];
	[self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}

-(void)getProjects
{
#warning request
	/*
	 NSError *error = nil;
	 NSURL *videoPlaylistURL = [NSURL URLWithString:@"http://gdata.youtube.com/feeds/api/playlists/PL61BC997C1C3002AD?alt=json&start-index=1&max-results=50"];
	 NSData *videoData = [NSData dataWithContentsOfURL:videoPlaylistURL options:0 error:&error];
	 if(error) {
	 NSLog(@"Error on getting video data: %@", [error description]);
	 }
	 
	 NSArray *videoJSON = [[[NSJSONSerialization JSONObjectWithData:videoData options:NSJSONReadingMutableLeaves error:&error] objectForKey:@"feed"] objectForKey:@"entry"];
	 if(error) {
	 NSLog(@"Error parsing JSON: %@", [error description]);
	 }*/
    MyProject *project2 = [[MyProject alloc] init];
	project2.title = @"HW4 Memory Management";
	project2.description = @"This is an assignment about memory management in which we are about implement shared memory";
	NSDate *currentDate = [NSDate date];
	project2.starttime = currentDate;
	project2.owner = @"David";
	project2.state = 2;
	[_invitations addObject:project2];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _invitations.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UIImage*)resizeImage:(UIImage*)image withWidth:(int)width withHeight:(int)height
{
    CGSize newSize = CGSizeMake(width, height);
    float widthRatio = newSize.width/image.size.width;
    float heightRatio = newSize.height/image.size.height;
	
    if(widthRatio > heightRatio)
    {
        newSize=CGSizeMake(image.size.width*heightRatio,image.size.height*heightRatio);
    }
    else
    {
        newSize=CGSizeMake(image.size.width*widthRatio,image.size.height*widthRatio);
    }
	
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return newImage;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		
		UILabel *mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(65.0, 15.0, 150.0, 22.0)];
        mainLabel.tag = 1;
        mainLabel.font = [UIFont systemFontOfSize:18.0];
        mainLabel.textAlignment = NSTextAlignmentLeft;
        mainLabel.textColor = [UIColor blackColor];
        mainLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:mainLabel];
		
		UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(65.0, 30.0, 225.0, 36)];
        detailLabel.tag = 2;
        detailLabel.font = [UIFont systemFontOfSize:10.0];
        detailLabel.textAlignment = NSTextAlignmentLeft;
        detailLabel.textColor = [UIColor grayColor];
        detailLabel.backgroundColor = [UIColor clearColor];
		detailLabel.numberOfLines = 2;
        [cell.contentView addSubview:detailLabel];
		
		UILabel *timeView = [[UILabel alloc] initWithFrame:CGRectMake(215, 15.5, 65, 22)];
		[timeView setBackgroundColor:[UIColor clearColor]];
		timeView.tag = 3;
		timeView.text = [[((MyProject *)[_invitations objectAtIndex:indexPath.row]).starttime description] substringToIndex:10];
		timeView.font = [UIFont fontWithName:@"Times New Roman" size:13];
		timeView.textColor = [UIColor grayColor];
		[timeView setTextAlignment:NSTextAlignmentRight];
		[cell.contentView addSubview:timeView];
		
		CAGradientLayer *background = [CAGradientLayer layer];
		[background setFrame: CGRectMake(0, 0, 320, 70)];
		[background setColors:[NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:1 alpha:0.5] CGColor], (id)[[UIColor colorWithWhite:0.99 alpha:0.7] CGColor], (id)[[UIColor colorWithWhite:0.95 alpha:0.9] CGColor], nil]];
		[[[cell viewForBaselineLayout] layer] insertSublayer:background atIndex:0];
		[[[cell viewForBaselineLayout] layer] setBorderColor:[[UIColor colorWithWhite:0.9 alpha:1] CGColor]];
		[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
	
	((UILabel *)[cell viewWithTag:1]).text = ((MyProject *)[_invitations objectAtIndex:indexPath.row]).title;
	((UILabel *)[cell viewWithTag:2]).text = [NSString stringWithFormat:@"%@ invited you to join the project \"%@\"", ((MyProject *)[_invitations objectAtIndex:indexPath.row]).owner,
		((MyProject *)[_invitations objectAtIndex:indexPath.row]).title];
	((UILabel *)[cell viewWithTag:3]).text = [[((MyProject *)[_invitations objectAtIndex:indexPath.row]).starttime description] substringToIndex:10];
    
	cell.imageView.image = [self resizeImage:[UIImage imageNamed:@"question"] withWidth:45 withHeight:45];
	[cell.imageView setBackgroundColor:[UIColor clearColor]];
    
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [_invitations removeObjectAtIndex: indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
		
#warning reject request
		
		if(_invitations.count == 0) {
			UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 398.0)];
			message.text = @"You don't have new invitations now.";
			message.font = [UIFont systemFontOfSize:14.0];
			message.textAlignment = NSTextAlignmentCenter;
			message.textColor = [UIColor grayColor];
			message.backgroundColor = [UIColor clearColor];
			tableView.tableHeaderView = message;
			[[self tabBarItem] setBadgeValue:nil];
		} else
			[[self tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%d", _invitations.count]];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	((UILabel *)[cell viewWithTag:1]).textColor = [UIColor whiteColor];
	((UILabel *)[cell viewWithTag:2]).textColor = [UIColor whiteColor];
	((UILabel *)[cell viewWithTag:3]).textColor = [UIColor whiteColor];
	_tmpIndexPath = indexPath;
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:_tmpIndexPath];
	((UILabel *)[cell viewWithTag:1]).textColor = [UIColor blackColor];
	((UILabel *)[cell viewWithTag:2]).textColor = [UIColor grayColor];
	((UILabel *)[cell viewWithTag:3]).textColor = [UIColor grayColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[[self tableView] deselectRowAtIndexPath:indexPath animated:YES];
	
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
