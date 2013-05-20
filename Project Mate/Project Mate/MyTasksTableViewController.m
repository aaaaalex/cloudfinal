//
//  MyTasksTableViewController.m
//  Project Mate
//
//  Created by Alex Xia on 5/18/13.
//  Copyright (c) 2013 Cloud Computing. All rights reserved.
//

#import "MyTasksTableViewController.h"

@interface MyTasksTableViewController ()

@property(strong, nonatomic) NSMutableArray *tasks;
@end

@implementation MyTasksTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Deadlines", @"Deadlines");
        //[self.navigationController setNavigationBarHidden:NO];
        
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
    
    /********************************************************************/
    //We assume that we have got the userid (may use AppDelegate variable)
    /********************************************************************/
    _userid = @"abc";
    _tasks = [[NSMutableArray alloc] init];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonPressed:)];
    
    [self.navigationItem setRightBarButtonItem:rightButtonItem];
   
}

-(void) editButtonPressed:(id)sender
{
    NSLog(@"Edit button pressed");
}

- (void)fetchTasks
{
    /********************************************************************/
    //Wait for api
    /********************************************************************/
    NSString *urlstr = [NSString stringWithFormat:@""];
    NSURL *url = [NSURL URLWithString:urlstr];
    NSLog(@"get url");
    NSError *error = nil;
    NSData *jsonData = [NSData dataWithContentsOfURL:url options:0 error:&error];
    NSLog(@"json raw data got");
    if(error)
    {
        NSLog(@"got error as: %@", [error description]);
    }
    
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    NSLog(@"JSON array got");
    
    /********************************************************************/
    //Latter do the json parse and build task and add them into tasks array
    /********************************************************************/
    
    
    
}

- (IBAction)pressedButton:(id)sender {
    
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TaskCell";
    TaskCell *cell = (TaskCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        NSLog(@"******It is NULL CELL********");
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TaskCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //Task *currtask = [_tasks objectAtIndex:indexPath.row];
    
    cell.title.text = @"This is the first task";
    cell.time.text = @"25-05-2013";
    cell.desc.text = @"This is a task view made for test perpose, we wil make it for futher development";
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"cellimg2.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"cellimg2.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
    
    //cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"celling.png"] ]
    
    // Configure the cell...
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;;
}

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
    
    MyTaskDetailedViewController *dev = [[MyTaskDetailedViewController alloc] init];
    [self.navigationController pushViewController:dev animated:YES];
}

@end
