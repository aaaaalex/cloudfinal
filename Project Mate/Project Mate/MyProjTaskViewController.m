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
        
        _alltasks = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
}

- (void) viewDidAppear:(BOOL)animated
{
    NSString *proid = [NSString stringWithFormat:@"%d", _currProj.proid];
    _pid = proid;
    [self getAllTask];
    
}

-(void)getAllTask
{
    NSString *urlstr = [NSString stringWithFormat:@"http://projectmatefinal.appspot.com/listprojecttasks?projid=%@", _pid];
    NSURL *url = [NSURL URLWithString:urlstr];
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:nil];
    NSDictionary *jsonroot = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *tasks = [jsonroot objectForKey:@"tasks"];
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
    return [_alltasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Task *curr = [_alltasks objectAtIndex:indexPath.row];
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
    MyProjTaskDetailViewController *dev = [[MyProjTaskDetailViewController alloc] init];
    Task *curr = [_alltasks objectAtIndex:indexPath.row];
    dev.currentTask = curr;
    [dev.navigationController pushViewController:dev animated:YES];
}

@end