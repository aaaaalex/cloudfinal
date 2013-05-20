//
//  MyProjectTableViewController.m
//  Project Mate
//
//  Created by Zongheng Wang on 5/18/13.
//  Copyright (c) 2013 Cloud Computing. All rights reserved.
//

#import "MyProjectTableViewController.h"

@interface MyProjectTableViewController ()

@end

@implementation MyProjectTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = NSLocalizedString(@"Projects", @"Projects");
		self.tabBarItem.image = [UIImage imageNamed:@"projects"];
		
        MyAppDelegate *appdelegate = (MyAppDelegate *)[[UIApplication sharedApplication] delegate];
        _userid = appdelegate.userid;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]
										   initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
										   target:self
										   action:@selector(addButtonWasPressed:)];
	[self.navigationItem setRightBarButtonItem:rightBarButtonItem];
	
	_recentProjects = [[NSMutableArray alloc] init];
	_projectsOverview = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],
						 [NSNumber numberWithInt:0],[NSNumber numberWithInt:0],nil];
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getProjectsOverview];
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
		
		dispatch_async(dispatch_get_main_queue(), ^{
    		[self performSelector:@selector(updateTable) withObject:nil afterDelay:0];
		});
	});
}

- (void)updateTable
{
    [self getProjectsOverview];
	[self.tableView reloadData];
	[self.refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getProjectsOverview
{

    NSError *error = nil;
    
    NSString *urlstr = [NSString stringWithFormat:@"http://projectmatefinal.appspot.com/getprojectinfo?userId=%@", _userid];
    NSURL *url = [NSURL URLWithString:urlstr];
    NSData *data = [NSData dataWithContentsOfURL:url options: 0 error:&error];
    if(error){
        NSLog(@"Error => %@", error.description);
    }
    error = nil;
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if(error){
        NSLog(@"Error => %@", error.description);
    }
    
    int ongoing = [[json objectForKey:@"ongoing"] intValue];
    int upcoming = [[json objectForKey:@"upcoming"] intValue];
	int completed = [[json objectForKey:@"completed"] intValue];
    int fav = [[json objectForKey:@"favorite"] intValue];
    
    NSArray *recs = [json objectForKey:@"recents"];
    [_recentProjects removeAllObjects];
    if(recs.count > 0){
        for(NSDictionary *rec in recs){
            MyProject *project = [[MyProject alloc] init];
            project.title = [rec objectForKey:@"title"];
            project.description = [rec objectForKey:@"descr"];
            NSString *dlstr = [rec objectForKey:@"deadline"];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"MM/dd/yyyy - HH:mm:ss"];
            NSDate *deadline = [df dateFromString:dlstr];
            project.deadline = deadline;
            project.state = [[rec objectForKey:@"status"] intValue];
            project.owner = [rec objectForKey:@"owner"];
			project.proid = [[rec objectForKey:@"projid"] intValue];
            [_recentProjects addObject:project];
        }
    }

    [_projectsOverview replaceObjectAtIndex:0 withObject:[NSNumber numberWithInt:upcoming]];
    [_projectsOverview replaceObjectAtIndex:1 withObject:[NSNumber numberWithInt:ongoing]];
	[_projectsOverview replaceObjectAtIndex:2 withObject:[NSNumber numberWithInt:completed]];
    [_projectsOverview replaceObjectAtIndex:3 withObject:[NSNumber numberWithInt:fav]];

}


- (void)addButtonWasPressed:(id)sender
{
	MyCreateProjectViewController *createProjectViewController = [[MyCreateProjectViewController alloc] init];
	
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:createProjectViewController];
	nav.navigationItem.hidesBackButton = NO;
	
	[self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if(_recentProjects.count == 0)
    	return 1;
	else
		return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(_recentProjects.count == 0 || section == 0)
    	return 4;
	else{
		return _recentProjects.count;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.section == 0) {
		
		UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell0"];
    
    	if(cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell0"];
			
			UIButton *counter = [UIButton buttonWithType:UIButtonTypeCustom];
			[counter setEnabled:NO];
			[counter setFrame:CGRectMake(220.0, 10.5, 40.0, 22.0)];
			[counter setTitle:[NSString stringWithFormat:@"%d", [[_projectsOverview objectAtIndex:indexPath.row] intValue]] forState:UIControlStateNormal];
			[counter.titleLabel setFont:[UIFont fontWithName:@"Futura-Medium" size:14]];
			[counter setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
			
			// Add Border
			CALayer *layer = counter.layer;
			layer.cornerRadius = 3.0f;
			layer.masksToBounds = YES;
			layer.borderWidth = 1.0f;
			layer.borderColor = [UIColor colorWithWhite:0.5f alpha:0.2f].CGColor;
			
			// Add Shine
			CAGradientLayer *shineLayer = [CAGradientLayer layer];
			shineLayer.frame = layer.bounds;
			shineLayer.colors = [NSArray arrayWithObjects:
								 (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
								 (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
								 (id)[UIColor colorWithWhite:0.75f alpha:0.2f].CGColor,
								 (id)[UIColor colorWithWhite:0.4f alpha:0.2f].CGColor,
								 (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
								 nil];
			shineLayer.locations = [NSArray arrayWithObjects:
									[NSNumber numberWithFloat:0.0f],
									[NSNumber numberWithFloat:0.3f],
									[NSNumber numberWithFloat:0.5f],
									[NSNumber numberWithFloat:0.8f],
									[NSNumber numberWithFloat:1.0f],
									nil];
			[layer addSublayer:shineLayer];
			
			if(indexPath.row == 0)
				[counter setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
			else if(indexPath.row == 1)
				[counter setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
			else if(indexPath.row == 2)
				[counter setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
			else
				[counter setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
			
			[cell.contentView addSubview:counter];
		} else {
			[(UIButton *)[cell.contentView.subviews objectAtIndex:0] setTitle:[NSString stringWithFormat:@"%d", [[_projectsOverview objectAtIndex:indexPath.row] intValue]] forState:UIControlStateNormal];
		}

		if(indexPath.row == 0) {
			[cell.textLabel setText:@"Upcoming"];
			[cell.imageView setImage:[self resizeImage:[UIImage imageNamed:@"exclamation"]
											 withWidth:20 withHeight:20]];
		} else if(indexPath.row == 1) {
			[cell.textLabel setText:@"On-going"];
			[cell.imageView setImage:[self resizeImage:[UIImage imageNamed:@"arrow"]
											 withWidth:20 withHeight:20]];
		} else if(indexPath.row == 2) {
			[cell.textLabel setText:@"Completed"];
			[cell.imageView setImage:[self resizeImage:[UIImage imageNamed:@"check"]
											 withWidth:20 withHeight:20]];
		} else {
			[cell.textLabel setText:@"Favorite"];
			[cell.imageView setImage:[self resizeImage:[UIImage imageNamed:@"heart"]
											 withWidth:20 withHeight:20]];
		}
		
		[cell.textLabel setFont:[UIFont systemFontOfSize:18]];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
    	return cell;
	} else {
		UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell1"];
    
		if(cell == nil) {
			UILabel *titleLabel, *deadlineLabel, *description;

			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell1"];
			
			titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 10.0, 225, 20.0)];
			titleLabel.tag = 1;
			titleLabel.font = [UIFont systemFontOfSize:18.0];
			titleLabel.textAlignment = NSTextAlignmentLeft;
			titleLabel.textColor = [UIColor blackColor];
			titleLabel.backgroundColor = [UIColor clearColor];
			[cell.contentView addSubview:titleLabel];
			
			deadlineLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 30.0, 105.0, 15.0)];
			deadlineLabel.tag = 2;
			deadlineLabel.font = [UIFont systemFontOfSize:12.0];
			deadlineLabel.textAlignment = NSTextAlignmentLeft;
			deadlineLabel.textColor = [UIColor blackColor];
			deadlineLabel.backgroundColor =[UIColor clearColor];
			[cell.contentView addSubview:deadlineLabel];

			description = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 45.0, 225, 15.0)];
			description.tag = 3;
			description.font = [UIFont systemFontOfSize:12.0];
			description.textAlignment = NSTextAlignmentLeft;
			description.textColor = [UIColor lightGrayColor];
			description.backgroundColor =[UIColor clearColor];
			[cell.contentView addSubview:description];
			
			titleLabel.text = [(MyProject *)[_recentProjects objectAtIndex:indexPath.row] title];
			NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateFormat:@"yyyy-MM-dd, HH:mm"];
			NSString *dateString = [dateFormatter stringFromDate:
									[(MyProject *)[_recentProjects objectAtIndex:indexPath.row] deadline]];
			deadlineLabel.text = dateString;
			description.text = [(MyProject *)[_recentProjects objectAtIndex:indexPath.row] description];
			
			if([(MyProject *)[_recentProjects objectAtIndex:indexPath.row] state] == 0)
				[cell.imageView setImage:[self resizeImage:[UIImage imageNamed:@"inprogress"]
										  withWidth:27 withHeight:27]];
			else if([(MyProject *)[_recentProjects objectAtIndex:indexPath.row] state] == 1)
				[cell.imageView setImage:[self resizeImage:[UIImage imageNamed:@"complete"]
										  withWidth:27 withHeight:27]];
			else
				[cell.imageView setImage:[self resizeImage:[UIImage imageNamed:@"coming"]
										  withWidth:27 withHeight:27]];

		} else {
			((UILabel *)[cell.contentView viewWithTag:1]).text = [(MyProject *)[_recentProjects objectAtIndex:indexPath.row] title];
			NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateFormat:@"yyyy-MM-dd, HH:mm"];
			NSString *dateString = [dateFormatter stringFromDate:
									[(MyProject *)[_recentProjects objectAtIndex:indexPath.row] deadline]];
			((UILabel *)[cell.contentView viewWithTag:2]).text = dateString;
			((UILabel *)[cell.contentView viewWithTag:3]).text = [(MyProject *)[_recentProjects objectAtIndex:indexPath.row] description];
		}
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		return cell;
	}
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if(_recentProjects.count == 0 || section == 0)
		return @"Overview";
	else
		return @"Recent";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	if(section == 1)
		return @"Maximum four projects viewed recently are listed above.";
	return @"";
}
					
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
	if(indexPath.section == 0) {
		MyCategorizedProjectTableViewController *categorizedProjectTableViewController = [[MyCategorizedProjectTableViewController alloc] initWithRequestCategory:indexPath.row];
		[self.navigationController pushViewController:categorizedProjectTableViewController animated:YES];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.section == 1)
    	return 70;
	else
		return 44;
}

@end
