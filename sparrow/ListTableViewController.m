//
//  ListTableViewController.m
//  sparrow
//
//  Created by 园园 李 on 12-7-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ListTableViewController.h"
#import "Constant.h"

@interface ListTableViewController ()

@end

@implementation ListTableViewController

@synthesize allItems;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/lists/group.json", PREFIX_URL]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        allItems = [response mutableObjectFromJSONString];
    }

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [allItems count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSDictionary *list = [allItems objectAtIndex:section];
    NSArray *posts = [list objectForKey:@"posts"];
    return [posts count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    NSDictionary *list = [allItems objectAtIndex:section];
    NSArray *posts = [list objectForKey:@"posts"];
    NSDictionary *post = [posts objectAtIndex:row];
    NSString *title = [post objectForKey:@"title"];
    
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(tableView.frame.size.width - 20, 500) lineBreakMode:UILineBreakModeWordWrap];
    return size.height + 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"list_post";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    NSDictionary *list = [allItems objectAtIndex:section];
    NSArray *posts = [list objectForKey:@"posts"];
    NSDictionary *post = [posts objectAtIndex:row];
    NSString *title = [post objectForKey:@"title"];

    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(tableView.frame.size.width - 20, 500) lineBreakMode:UILineBreakModeWordWrap];
    titleLabel.frame = CGRectMake(10, 10, tableView.frame.size.width - 20, size.height);  
    titleLabel.text = title;
        
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 70)];
    if (section == 0) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, tableView.frame.size.width - 20, 54)];
        imageView.image = [UIImage imageNamed:@"login_logo"];
        [headerView addSubview:imageView];
    } else {
        NSDictionary *list = [allItems objectAtIndex:section];
        NSString *cover = [list objectForKey:@"cover"];
        NSString *name = [list objectForKey:@"name"];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
        [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PREFIX_URL, cover]]
                  placeholderImage:[UIImage imageNamed:@"111-user.png"]];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(68, 8, 232, 21)];
        nameLabel.font = [UIFont boldSystemFontOfSize:14];
        nameLabel.text = name;
        
        [headerView addSubview:imageView];
        [headerView addSubview:nameLabel];
    }
    headerView.backgroundColor = [UIColor whiteColor];
    return headerView;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)]) {
        [destination setValue:self forKey:@"delegate"];
    }
    if ([destination respondsToSelector:@selector(setQuestionId:)]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        NSDictionary *list = [allItems objectAtIndex:[indexPath section]];
        NSArray *posts = [list objectForKey:@"posts"];
        NSDictionary *post = [posts objectAtIndex:[indexPath row]];
        NSString *questionId = [post objectForKey:@"id"];
        [destination setValue:questionId forKey:@"questionId"];
    }

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
}

@end
