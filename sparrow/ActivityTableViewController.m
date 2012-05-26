//
//  ActivityTableViewController.m
//  sparrow
//
//  Created by mac on 12-5-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ActivityTableViewController.h"
#import "Constant.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "UIImageView+WebCache.h"


@implementation ActivityTableViewController
@synthesize listData;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/activities", PREFIX_URL]];
    NSLog([url path]);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//    [request setRequestMethod:@"GET"];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        self.listData = [response mutableObjectFromJSONString];
        NSLog(@"row: %lu", (unsigned long)[listData count]);
    }

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.listData = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    NSDictionary *activity = [listData objectAtIndex:row];
    
    NSString *type = [activity objectForKey:@"activity_type"];
    NSString *title = nil;
    NSString *avatar_url = nil;
    NSString *name = @"李园";
    if ([type isEqualToString:@"vote_up_answer"]) {
        title = [[activity objectForKey:@"question"] objectForKey:@"title"];
        avatar_url = [[activity objectForKey:@"voter"] objectForKey:@"avatar_url"];
    }else if ([type isEqualToString:@"subscribe_post"]) {
        title = [[activity objectForKey:@"question"] objectForKey:@"title"];
        avatar_url = [[activity objectForKey:@"subscriber"] objectForKey:@"avatar_url"];
    }else if ([type isEqualToString:@"ask"]) {
        title = [[activity objectForKey:@"question"] objectForKey:@"title"];
        avatar_url = [[[activity objectForKey:@"question"] objectForKey:@"user"] objectForKey:@"avatar_url"];
    }else if ([type isEqualToString:@"answer"]) {
        title = [[activity objectForKey:@"question"] objectForKey:@"title"];
        avatar_url = [[[activity objectForKey:@"answer"] objectForKey:@"user"] objectForKey:@"avatar_url"];
    }
    
    cell.textLabel.text = title;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:10];
    cell.detailTextLabel.text = name;
    
    [cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PREFIX_URL, avatar_url]]
                   placeholderImage:[UIImage imageNamed:@"111-user.png"]];
    
    CGRect frame = cell.imageView.frame;
    frame.size.height = 5;
    frame.size.width = 5;
    cell.imageView.frame = frame;
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
}

@end