//
//  MyProjTaskDetailViewController.m
//  Project Mate
//
//  Created by 钱 紫霞 on 5/20/13.
//  Copyright (c) 2013 Cloud Computing. All rights reserved.
//

#import "MyProjTaskDetailViewController.h"

@interface MyProjTaskDetailViewController ()

@end

@implementation MyProjTaskDetailViewController

- (id)initWithMyTask: (Task *)myTask
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        _currentTask = myTask;
        //        self.title = _currentProject.title;
        self.title = NSLocalizedString(@"Projects", @"Projects");
		self.tabBarItem.image = [UIImage imageNamed:@"projects"];
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
	//[self.navigationItem setRightBarButtonItem:rightBarButtonItem];
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
            
            [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
            [cell.detailTextLabel setFont: [UIFont systemFontOfSize: 16]];
            //            [cell.detailTextLabel setLineBreakMode:NSLineBreakByCharWrapping];
            //            cell.detailTextLabel.numberOfLines = 0;
        }
        
        switch (indexPath.row) {
            case 0:
                //[cell.textLabel setText:@"Owner"];
                [cell.textLabel setText:_currentTask.owner];
                break;
                //case 1:
                //                [cell.textLabel setText:@"Course"];
                //                [cell.detailTextLabel setText:_currentProject.course];
                //  break;
                
            case 2:
                [cell.textLabel setText:@"Description"];
                [cell.detailTextLabel setText:_currentTask.desc];
                break;
        }
        
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
            return @"Owner";
        case 1:
            return @"Deadline";
            //return @"";
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
        UIView* bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,0,300,150)];
        
        // progress bar
        float progress = [_projectProgress floatValue];
        UIColor *barColor;
        UIProgressView *progressBar=[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        [progressBar setFrame:CGRectMake(35, 30, 250.0, 20)];
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
        completeButton.frame = CGRectMake(35, 50, 250, 44);
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
        favoriteButton.frame = CGRectMake(35, 100, 250, 44);
        [favoriteButton addTarget:self action:@selector(onProjectMarkFavorite:) forControlEvents:UIControlEventTouchUpInside];
        [favoriteButton setBackgroundImage:buttonImage2 forState:UIControlStateNormal];
        [favoriteButton setBackgroundImage:buttonImageHighlight2 forState:UIControlStateHighlighted];
        [favoriteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [favoriteButton setTitleColor:[UIColor colorWithRed:150.0/256.0 green:150.0/256.0 blue:150.0/256.0 alpha:1.0] forState:UIControlStateHighlighted];
        
        [favoriteButton setTitle:@"Mark as favorite" forState:UIControlStateNormal];
        [favoriteButton setTitle:@"Remove from favorite" forState:UIControlStateSelected];
        
        // need revise here!!!!!
        // should set selected status based on the project
        //[favoriteButton setSelected: ];
        
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

// callback for favorite button
- (void)onProjectMarkFavorite:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [button setSelected:!button.selected];
}

// callback for edit button
- (void)onProjectEdited:(id)sender
{
//    MyTaskEditViewController *createProjectViewController = [[MyTaskEditViewController alloc] init];
//	
//	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:createProjectViewController];
//	nav.navigationItem.hidesBackButton = NO;
//	createProjectViewController.currTask = _currentTask;
//    NSLog(@"In this view (((***!!! deadline is => %@", _currentTask.deadline.description);
//	[self presentViewController:nav animated:YES completion:nil];
}

@end
