//
//  QuestionShowTableViewController.m
//  sparrow
//
//  Created by mac on 12-6-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "QuestionShowTableViewController.h"


@implementation QuestionShowTableViewController
@synthesize sampleDetail;
@synthesize fullDetail;
@synthesize answers;
@synthesize delegate;

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
    [self initTableViewHeader];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.sampleDetail = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestQuestionDetail];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [answers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSInteger row = indexPath.row;
    NSDictionary *answer = [answers objectAtIndex:row];
    NSString *markdown = [answer objectForKey:@"markdown"];
    cell.textLabel.text = markdown;
    
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

- (void)initTableViewHeader
{
    NSString *title = [sampleDetail objectForKey:@"title"];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];
//    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLable.layer.borderWidth = 1;
    titleLable.numberOfLines = 5;
    titleLable.font = [UIFont systemFontOfSize:18];
    CGSize constraint = CGSizeMake(320 - (20 *2), 20000.0f);
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    [titleLable setFrame:CGRectMake(20, 20, 280, size.height)];
    
    titleLable.text = title;
    
    [headerView addSubview:titleLable];
    headerView.frame = CGRectMake(0, 0, 320, size.height+30);
    [self.tableView setTableHeaderView:headerView];
}

- (void)requestQuestionDetail
{
    NSInteger qid = [sampleDetail objectForKey:@"id"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/questions/%@.json",PREFIX_URL, qid]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
    
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"aaaa");
        if (response) {
            fullDetail = [response objectFromJSONString];
            answers = (NSArray *)[fullDetail objectForKey:@"answers"];
        }
    }
}

@end
