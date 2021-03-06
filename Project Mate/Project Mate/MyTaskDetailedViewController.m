//
//  MyTaskDetailedViewController.m
//  Project Mate
//
//  Created by 钱 紫霞 on 5/20/13.
//  Copyright (c) 2013 Cloud Computing. All rights reserved.
//

#import "MyTaskDetailedViewController.h"

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface MyTaskDetailedViewController ()

@end

@implementation MyTaskDetailedViewController

- (id)initWithMyTask: (Task *)myTask
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        _currentTask = myTask;
		
		self.navigationItem.title = _currentTask.title;
        
        // calculate project progress here
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
            return 1;
        case 1:
            return 1;
        case 2:
            //return _currentTask.tasks.count == 0 ? 1 : _currentProject.tasks.count;
            return 1;
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
        }
        
		[cell.textLabel setText:_currentTask.owner];
        
        return cell;
        
    } else if (indexPath.section == 1) {
        
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellMember"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellMember"];
			
        }
        
        if(indexPath.row == 0){
            //[cell.textLabel setText:@"Deadline"];
            formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            [cell.textLabel setText: [formatter stringFromDate:_currentTask.deadline]];
        }
        return cell;
        
    } else if(indexPath.section == 2){
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellTask"];
        
        // leave for task cell
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellTask"];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        if(indexPath.row == 0){
            [cell.textLabel setText:_currentTask.desc];
        }
        return cell;
    }
    else{
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellTask"];
        
        // leave for task cell
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellTask"];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
       
        return cell;

    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch(section) {
        case 0:
            return @"Owner";
        case 1:
            return @"Deadline";
        case 2:
            return @"Description";
        default:
            return @"";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section == 2) {
        UIView* bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,0,300, 150)];
        
        // progress bar
        float progress = [_projectProgress floatValue];
        UIColor *barColor;
        UIProgressView *progressBar=[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        [progressBar setFrame:CGRectMake(10, 30, 300, 20)];
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
        completeButton.frame = CGRectMake(10, 50, 300, 44);
        [completeButton setTitle:@"Completed!" forState:UIControlStateNormal];
        [completeButton addTarget:self action:@selector(onProjectCompleted:) forControlEvents:UIControlEventTouchUpInside];
        [completeButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [completeButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
        [completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [completeButton setTitleColor:[UIColor colorWithRed:150.0/256.0 green:150.0/256.0 blue:150.0/256.0 alpha:1.0] forState:UIControlStateHighlighted];
        
        // need revise here!!!!!
        // should set selected status based on the project
        //[favoriteButton setSelected: ];
        
        [bottomView addSubview:completeButton];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        if(indexPath.row == 0)
            return 50;
    }
    if(indexPath.section == 1){
        if(indexPath.row == 0)
            return 50;
    }
    if(indexPath.section == 2)
    {
        if(indexPath.row == 0)
            return 100;
    }
    return 0;;
}

/* ***********
 *
 * TO DO:
 */

// should return a value between 0 and 1 to indicate the progress of current project
// based on "completed tasks"/"total tasks"
- (CGFloat)calculateProjectProgress
{
    return 0.2;
}

// callback for complete button
- (void)onProjectCompleted:(id)sender
{
    // only when the project is truely completed
    if ([_projectProgress floatValue] == 1.0) {
        
    }
}

// callback for edit button
- (void)onProjectEdited:(id)sender
{
    MyTaskEditViewController *createProjectViewController = [[MyTaskEditViewController alloc] init];
	
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:createProjectViewController];
	nav.navigationItem.hidesBackButton = NO;
	createProjectViewController.currTask = _currentTask;
    NSLog(@"In this view (((***!!! deadline is => %@", _currentTask.deadline.description);
	[self presentViewController:nav animated:YES completion:nil];
}

@end
