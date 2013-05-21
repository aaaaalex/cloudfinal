//
//  MyProjTaskViewController.m
//  Project Mate
//
//  Created by 钱 紫霞 on 5/20/13.
//  Copyright (c) 2013 Cloud Computing. All rights reserved.
//

#import "MyProjTaskViewController.h"

@interface MyProjTaskViewController ()

@end

@implementation MyProjTaskViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        MyAppDelegate *appdelegate = (MyAppDelegate *)[[UIApplication sharedApplication] delegate];
        _userid = appdelegate.userid;
        
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _alltasks = [[NSMutableArray alloc] init];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
	UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]
										   initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
										   target:self
										   action:@selector(addButtonWasPressed:)];
	[self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    
}

-(void) addButtonWasPressed:(id)sender
{
    MyTaskCreateViewController *dev = [[MyTaskCreateViewController alloc] init];
    _pid = [NSString stringWithFormat:@"%d", _currProj.proid];
    dev.pid = _pid;
    dev.currproj = _currProj;
    [self.navigationController pushViewController:dev animated:YES];
}

- (void) viewDidAppear:(BOOL)animated
{
    NSLog(@"Try to get tasks");
    NSString *proid = [NSString stringWithFormat:@"%d", _currProj.proid];
    _pid = proid;
    [self getAllTask];
    
    NSLog(@"!!!The total number of tasksk => %d", [_alltasks count]);
    if([_alltasks count] > 0){
        Task *tmp = [_alltasks objectAtIndex:0];
        NSLog(@"title => %@", tmp.title);
    }
    [self.tableView reloadData];
}

-(void)getAllTask
{
    NSLog(@"Try to get tasks222");
    NSString *urlstr = [NSString stringWithFormat:@"http://projectmatefinalfinal.appspot.com/listprojecttasks?projid=%@", _pid];
    NSLog(@"%@",urlstr);
    NSURL *url = [NSURL URLWithString:urlstr];
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:nil];
    NSDictionary *jsonroot = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *tasks = [jsonroot objectForKey:@"tasks"];
    [_alltasks removeAllObjects];
    for(NSDictionary *task in tasks)
    {
        Task *tmp = [[Task alloc] init];
        tmp.title = [task objectForKey:@"title"];
        tmp.parentProj = [NSString stringWithFormat:@"%d", [[task objectForKey:@"parentProj"] intValue]];
        tmp.owner = [task objectForKey:@"owner"];
        tmp.taskid = [task objectForKey:@"tid"];
        tmp.desc = [task objectForKey:@"descr"];
        tmp.status = [NSString stringWithFormat:@"%d", [[task objectForKey:@"status"] intValue]];
        NSString *dlstr = [task objectForKey:@"deadline"];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        
        [df setDateFormat:@"MM/dd/yyyy - HH:mm:ss"];
        
        tmp.deadline = [df dateFromString:dlstr];
        [_alltasks addObject:tmp];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSLog(@"!!***!!! the size of _alltasks is %d", [_alltasks count]);
    return [_alltasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    // Configure the cell...
    Task *curr = [_alltasks objectAtIndex:indexPath.row];
    NSLog(@"Now the title is >>>>> %@", curr.title);
    cell.textLabel.text = curr.title;
    
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    //NSLog(@"We get into it");
    MyProjTaskDetailViewController *dev = [[MyProjTaskDetailViewController alloc] init];
    Task *curr = [_alltasks objectAtIndex:indexPath.row];
    dev.currentTask = curr;
    
    [self.navigationController pushViewController:dev animated:YES];
}

@end
