//
//  MyProjectInfoViewController.m
//  Project Mate
//
//  Created by kid on 13-5-20.
//  Copyright (c) 2013年 Cloud Computing. All rights reserved.
//

#import "MyProjectInfoViewController.h"
#import <QuartzCore/QuartzCore.h>

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface MyProjectInfoViewController ()

@end

@implementation MyProjectInfoViewController

- (id)initWithMyProject: (MyProject *)myProject
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        _currentProject = myProject;
//        self.title = _currentProject.title;
        self.title = NSLocalizedString(@"Projects", @"Projects");
		self.tabBarItem.image = [UIImage imageNamed:@"projects"];
        self.navigationItem.title = _currentProject.title;
        
        // calculate project progress here
        _projectProgress = [NSNumber numberWithFloat:[self calculateProjectProgress]];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]
										   initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
										   target:self
										   action:@selector(onProjectEdited:)];
	[self.navigationItem setRightBarButtonItem:rightBarButtonItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section) {
        case 0:
            return 3;
        case 1:
            return _currentProject.members.count;
        case 2:
            return 1;//_currentProject.tasks.count == 0 ? 1 : _currentProject.tasks.count;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDateFormatter *formatter;
    if (indexPath.section == 0) {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellGeneral"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"CellGeneral"];
            
            [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
            [cell.detailTextLabel setFont: [UIFont systemFontOfSize: 16]];
        }
        
        switch (indexPath.row) {
            case 0:
                [cell.textLabel setText:@"Owner"];
                [cell.detailTextLabel setText:_currentProject.owner];
                break;
            case 1:
                [cell.textLabel setText:@"Deadline"];
                formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                [cell.detailTextLabel setText: [formatter stringFromDate:_currentProject.deadline]];
                break;
            case 2:
                [cell.textLabel setText:@"Description"];
                [cell.detailTextLabel setText:_currentProject.description];
                break;
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
        
    } else if (indexPath.section == 1) {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellMember"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellMember"];
        }
        
        [cell.textLabel setText:[NSString stringWithFormat:@"%@ %@",[[_currentProject.members objectAtIndex:indexPath.row] objectForKey:@"firstName"], [[_currentProject.members objectAtIndex:indexPath.row] objectForKey:@"lastName"]]];
		
		if([[[_currentProject.members objectAtIndex:indexPath.row] objectForKey:@"sex"] isEqualToString:@"male"])
			[cell.imageView setImage:[self resizeImage:[UIImage imageNamed:@"male"]
											 withWidth:27 withHeight:27]];
		else
			[cell.imageView setImage:[self resizeImage:[UIImage imageNamed:@"female"]
											 withWidth:27 withHeight:27]];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
        
    } else {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellTask"];
        
        // leave for task cell
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellTask"];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
/*
        if (_currentProject.tasks.count != 0) {
            // display first task
        } else {*/
		[cell.textLabel setText:@"Tasks Details"];
        
        
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

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
//{
//    NSString *text;
//    NSDateFormatter *formatter;
//    
//    if(indexPath.section == 0) {
//        switch (indexPath.row) {
//            case 0:
//                text = _currentProject.owner;
//                break;
//            case 1:
//                text = _currentProject.course;
//                break;
//            case 2:
//                formatter = [[NSDateFormatter alloc] init];
//                [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//                text = [formatter stringFromDate:_currentProject.deadline];
//                break;
//            case 3:
//                text = _currentProject.description;
//                break;
//        }
//    } else if (indexPath.section == 1){
//        text = [_currentProject.members objectAtIndex:indexPath.row];
//    } else {
//        text = [_currentProject.members objectAtIndex:0];
//    }
//    
//    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
//    
//    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByCharWrapping];
//    
//    CGFloat height = MAX(size.height, 44.0f);
//    
//    return height + (CELL_CONTENT_MARGIN * 2);
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch(section) {
        case 0:
            return @"General";
        case 1:
            return @"Members";
        case 2:
            return @"Tasks";
        default:
            return @"";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.section == 2)
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	else
		[tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section == 2) {
        UIView* bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,0,300,150)];
    
        // progress bar
        float progress = [_projectProgress floatValue];
        UIColor *barColor;
        UIProgressView *progressBar=[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        [progressBar setFrame:CGRectMake(10, 20, 300.0, 20)];
        if (progress < 0.3)
            barColor = [UIColor redColor];
        else if (progress < 0.6)
            barColor = [UIColor orangeColor];
        else if (progress < 0.9)
            barColor = [UIColor blueColor];
        else
            barColor = [UIColor greenColor];
        progressBar.progressTintColor = barColor;
        [progressBar setProgress:progress];

        // button for completing project
        UIImage *buttonImage = [[UIImage imageNamed:@"blueButton.png"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
        UIImage *buttonImageHighlight = [[UIImage imageNamed:@"blueButtonHighlight.png"]
                                         resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
        
        UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        completeButton.frame = CGRectMake(10, 50, 140, 44);
        [completeButton setTitle:@"Completed!" forState:UIControlStateNormal];
        [completeButton addTarget:self action:@selector(onProjectCompleted:) forControlEvents:UIControlEventTouchUpInside];
        [completeButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [completeButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
        [completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [completeButton setTitleColor:[UIColor colorWithRed:150.0/256.0 green:150.0/256.0 blue:150.0/256.0 alpha:1.0] forState:UIControlStateHighlighted];
        
        // button for setting favorite
        UIImage *buttonImage2 = [[UIImage imageNamed:@"tanButton.png"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
        UIImage *buttonImageHighlight2 = [[UIImage imageNamed:@"tanButtonHighlight.png"]
                                         resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
        
        UIButton *favoriteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        favoriteButton.frame = CGRectMake(170, 50, 140, 44);
        [favoriteButton addTarget:self action:@selector(onProjectMarkFavorite:) forControlEvents:UIControlEventTouchUpInside];
        [favoriteButton setBackgroundImage:buttonImage2 forState:UIControlStateNormal];
        [favoriteButton setBackgroundImage:buttonImageHighlight2 forState:UIControlStateHighlighted];
        [favoriteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [favoriteButton setTitleColor:[UIColor colorWithRed:150.0/256.0 green:150.0/256.0 blue:150.0/256.0 alpha:1.0] forState:UIControlStateHighlighted];
        
        [favoriteButton setTitle:@"Mark as favorite" forState:UIControlStateNormal];
        
        [bottomView addSubview:completeButton];
        [bottomView addSubview:favoriteButton];
        [bottomView addSubview:progressBar];
        return bottomView;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2)
        return 150;
    return 0;
}

/* ***********
 *
 * TO DO:
 */

// should return a value between 0 and 1 to indicate the progress of current project
// based on "completed tasks"/"total tasks"
- (CGFloat)calculateProjectProgress
{
	if(_currentProject.state == 0)
    	return 0.2;
	else if(_currentProject.state == 1)
		return 1;
	else
		return 0.8;
}

// callback for complete button
- (void)onProjectCompleted:(id)sender
{
    // only when the project is truely completed
    //if ([_projectProgress floatValue] == 1.0) {
    
    //}
    NSString *urlstr = [NSString stringWithFormat:@"http://projectmatefinal.appspot.com/addcomplete?projid=%d", _currentProject.proid];
	NSURL *url = [NSURL URLWithString:urlstr];
	[NSData dataWithContentsOfURL:url options:0 error:nil];
}

// callback for favorite button
- (void)onProjectMarkFavorite:(id)sender
{	
	MyAppDelegate *appdelegate = (MyAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *urlstr = [NSString stringWithFormat:@"http://projectmatefinal.appspot.com/addfavorite?userId=%@&projid=%d", appdelegate.userid, _currentProject.proid];
	NSURL *url = [NSURL URLWithString:urlstr];
	[NSData dataWithContentsOfURL:url options:0 error:nil];
}

// callback for edit button
- (void)onProjectEdited:(id)sender
{
    
}

@end
