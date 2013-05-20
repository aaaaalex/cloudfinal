//
//  MyCategorizedProjectTableViewController.m
//  Project Mate
//
//  Created by Zongheng Wang on 5/19/13.
//  Copyright (c) 2013 Cloud Computing. All rights reserved.
//

#import "MyCategorizedProjectTableViewController.h"

@interface MyCategorizedProjectTableViewController ()

@end

@implementation MyCategorizedProjectTableViewController

- (id)initWithRequestCategory:(NSInteger)category
{
	self = [super initWithStyle:UITableViewStyleGrouped];
	if (self) {
		_projects = [[NSMutableArray alloc] init];
		_category = category;
		if(_category == 0)
			self.title = @"Upcoming Projects";
		else if(_category == 1)
			self.title = @"On-going Projects";
		else if(_category == 2)
			self.title = @"Completed Projects";
		else
			self.title = @"Favorite Projects";
        MyAppDelegate *appdelegate = (MyAppDelegate *)[[UIApplication sharedApplication] delegate];
        _userid = appdelegate.userid;
        NSLog(@"%@",_userid);

	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getProjects];
		dispatch_async(dispatch_get_main_queue(), ^{
			[[self tableView] reloadData];
		});
    });
	
	UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

-(void)refresh {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		MyProject *project1 = [[MyProject alloc] init];
		project1.title = @"Rubik's Cube Solver";
		project1.description = @"This is a project that tries to solve a 3*3*3 cube.";
		NSDate *currentDate = [NSDate date];
		project1.deadline = currentDate;
		project1.state = 0;
    	[_projects addObject:project1];
		dispatch_async(dispatch_get_main_queue(), ^{
    		[self performSelector:@selector(updateTable) withObject:nil afterDelay:0];
		});
	});
}

- (void)updateTable
{
	[self.tableView reloadData];
	[self.refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSString *urlstr;
    if(_category == 0){
        urlstr = [NSString stringWithFormat:@"http://projectmatefinal.appspot.com/getupcomings?userId=%@", _userid];
    } else if(_category == 1){
        urlstr = [NSString stringWithFormat:@"http://projectmatefinal.appspot.com/getongoings?userId=%@", _userid];
    } else if(_category == 2){
        urlstr = [NSString stringWithFormat:@"http://projectmatefinal.appspot.com/getcompleteds?userId=%@", _userid];
    } else {
        urlstr = [NSString stringWithFormat:@"http://projectmatefinal.appspot.com/getfavorites?userId=%@", _userid];
    }
    NSURL *url = [NSURL URLWithString:urlstr];
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    if(error){
        NSLog(@"ERROR 1 - %@", error.description);
    }
    error = nil;
    NSString *catchoice;
    
    if(_category == 0){
        catchoice = @"upcomings";
    } else if(_category == 1){
        catchoice = @"ongoings";
    } else if(_category == 2){
        catchoice = @"completeds";
    } else {
        catchoice = @"favorites";
    }

    
    NSDictionary *rootjsons = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSArray *jsons = [rootjsons objectForKey:catchoice];
    if(error){
        NSLog(@"ERROR 2 - %@", error.description);
    }
    NSLog(@"**!!!!!!!!!Ready to get details");
    for(NSDictionary *json in jsons){
    MyProject *project = [[MyProject alloc] init];
        NSLog(@"0. Ready to start");
        project.title = [json objectForKey:@"title"];
        NSLog(@"1.Got title");
    project.state = [[json objectForKey:@"status"] intValue];
        NSLog(@"2.Got status");
    project.description = [json objectForKey:@"descr"];
        NSLog(@"3.Got descr");
    NSString *dlstr = [json objectForKey:@"deadline"];
        NSLog(@"4.Got deadline");
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy - HH:mm:ss"];
    NSDate *deadline = [df dateFromString:dlstr];
        NSLog(@"5.Set deadline");
    project.deadline = deadline;
    project.proid = [[json objectForKey:@"proid"] intValue];
        NSLog(@"Got proid");
        [_projects addObject:project];
    
//    MyProject *project2 = [[MyProject alloc] init];
//	project2.title = @"HW4 Memory Management";
//	project2.description = @"This is an assignment about memory management in which we are about implement shared memory";
//	NSDate *currentDate = [NSDate date];
//	project2.deadline = currentDate;
//	project2.state = 2;
//	[_projects addObject:project2];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _projects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell2"];
    
	if(cell == nil) {
		UILabel *titleLabel, *deadlineLabel, *description;
		
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell2"];
		
		titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0, 10.0, 235, 20.0)];
		titleLabel.tag = 1;
		titleLabel.font = [UIFont systemFontOfSize:18.0];
		titleLabel.textAlignment = NSTextAlignmentLeft;
		titleLabel.textColor = [UIColor blackColor];
		titleLabel.backgroundColor = [UIColor clearColor];
		[cell.contentView addSubview:titleLabel];
		
		deadlineLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0, 30.0, 105.0, 15.0)];
		deadlineLabel.tag = 2;
		deadlineLabel.font = [UIFont systemFontOfSize:12.0];
		deadlineLabel.textAlignment = NSTextAlignmentLeft;
		deadlineLabel.textColor = [UIColor blackColor];
		deadlineLabel.backgroundColor =[UIColor clearColor];
		[cell.contentView addSubview:deadlineLabel];
		
		description = [[UILabel alloc] initWithFrame:CGRectMake(40.0, 45.0, 235, 15.0)];
		description.tag = 3;
		description.font = [UIFont systemFontOfSize:12.0];
		description.textAlignment = NSTextAlignmentLeft;
		description.textColor = [UIColor lightGrayColor];
		description.backgroundColor =[UIColor clearColor];
		[cell.contentView addSubview:description];
		
		titleLabel.text = [(MyProject *)[_projects objectAtIndex:indexPath.row] title];
		NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd, HH:mm"];
		NSString *dateString = [dateFormatter stringFromDate:
								[(MyProject *)[_projects objectAtIndex:indexPath.row] deadline]];
		deadlineLabel.text = dateString;
		description.text = [(MyProject *)[_projects objectAtIndex:indexPath.row] description];
		
		if([(MyProject *)[_projects objectAtIndex:indexPath.row] state] == 0)
			[cell.imageView setImage:[self resizeImage:[UIImage imageNamed:@"inprogress"]
											 withWidth:27 withHeight:27]];
		else if([(MyProject *)[_projects objectAtIndex:indexPath.row] state] == 1)
			[cell.imageView setImage:[self resizeImage:[UIImage imageNamed:@"complete"]
											 withWidth:27 withHeight:27]];
		else
			[cell.imageView setImage:[self resizeImage:[UIImage imageNamed:@"coming"]
											 withWidth:27 withHeight:27]];
		
	} else {
		((UILabel *)[cell.contentView viewWithTag:1]).text = [(MyProject *)[_projects objectAtIndex:indexPath.row] title];
		NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd, HH:mm"];
		NSString *dateString = [dateFormatter stringFromDate:
								[(MyProject *)[_projects objectAtIndex:indexPath.row] deadline]];
		((UILabel *)[cell.contentView viewWithTag:2]).text = dateString;
		((UILabel *)[cell.contentView viewWithTag:3]).text = [(MyProject *)[_projects objectAtIndex:indexPath.row] description];
	}
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"Project List";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	return @"The projects are ordered by the deadline.";
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return  70;
}

@end
