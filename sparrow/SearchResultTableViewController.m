//
//  SearchResultTableViewController.m
//  sparrow
//
//  Created by mac on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SearchResultTableViewController.h"
#import "Constant.h"
#import "LXUtil.h"
#import "QuartzCore/QuartzCore.h"

@implementation SearchResultTableViewController

@synthesize scopeType;
@synthesize searchText;
@synthesize allItems;

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
    NSString *urlString = [NSString stringWithFormat:@"%@/search/%@.json?q=%@", PREFIX_URL, scopeType, searchText];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setResponseEncoding:NSUTF8StringEncoding];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        if ([scopeType isEqualToString:@"list"] || [scopeType isEqualToString:@"tag"]) {
            NSDictionary *result = [response objectFromJSONString];
            allItems = [result objectForKey:@"result"];
        } else {
            allItems = [response mutableObjectFromJSONString];
        }
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [allItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([scopeType isEqualToString:@"list"]) {
        return 70;
    } else if ([scopeType isEqualToString:@"user"]) {
        return 55;
    } else if ([scopeType isEqualToString:@"post"]) {
        NSString *title = [[allItems objectAtIndex:[indexPath row]] objectForKey:@"title"];
        CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(tableView.frame.size.width - 20, 500) lineBreakMode:UILineBreakModeWordWrap];
        return size.height + 20;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"%@Search", scopeType];    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];    
    NSInteger row = indexPath.row;
    NSDictionary *item = [allItems objectAtIndex:row];
    
    if ([scopeType isEqualToString:@"post"]) {
        NSString *title = [item objectForKey:@"title"];
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
        titleLabel.text = title;
        
        CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(tableView.frame.size.width - 20, 500) lineBreakMode:UILineBreakModeWordWrap];
        titleLabel.frame = CGRectMake(10, 10, tableView.frame.size.width - 20, size.height);
    } else if ([scopeType isEqualToString:@"user"]) {        
        NSString *avatar_url = [item objectForKey:@"avatar_url"];
        NSString *name = [item objectForKey:@"name"];
        NSString *bio = [item objectForKey:@"bio"];
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
        [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PREFIX_URL, avatar_url]]
                  placeholderImage:[UIImage imageNamed:@"111-user.png"]];
        imageView.layer.borderWidth = 0.6;
        imageView.layer.borderColor = [[LXUtil cellImageBorderColor] CGColor];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 3;
        
        UILabel *nameLabel = (UILabel *)[cell viewWithTag:2];
        nameLabel.text = name;
        
        UILabel *bioLabel = (UILabel *)[cell viewWithTag:3];
        bioLabel.text = bio;
    } else if ([scopeType isEqualToString:@"list"]) {
        NSString *cover = [item objectForKey:@"cover"];
        NSString *name = [item objectForKey:@"name"];
        NSString *abstract = [item objectForKey:@"abstract"];
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
        [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PREFIX_URL, cover]]
                  placeholderImage:[UIImage imageNamed:@"111-user.png"]];
        imageView.layer.borderWidth = 0.6;
        imageView.layer.borderColor = [[LXUtil cellImageBorderColor] CGColor];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 5;

        
        UILabel *nameLabel = (UILabel *)[cell viewWithTag:2];
        nameLabel.text = name;
        
        UILabel *abstractLabel = (UILabel *)[cell viewWithTag:3];
        abstractLabel.text = abstract;
    } else if ([scopeType isEqualToString:@"tag"]) {
        NSString *name = [item objectForKey:@"name"];
        UIFont * font = [UIFont boldSystemFontOfSize:14];
        CGSize singleLineStringSize = [name sizeWithFont:font];
        UILabel *tagLabel = (UILabel *)[cell viewWithTag:1];
        tagLabel.frame = CGRectMake(20, 11, singleLineStringSize.width+30, singleLineStringSize.height+4);
        tagLabel.textAlignment = UITextAlignmentCenter;
        tagLabel.textColor = [UIColor whiteColor];
        tagLabel.backgroundColor = [UIColor colorWithRed:114/255.0f green:193/255.0f blue:221/255.0f alpha:1.0f];
        tagLabel.layer.cornerRadius = 10;
        [tagLabel.layer setMasksToBounds:YES];
        tagLabel.font = font;
        tagLabel.text = name;
    }
    
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    UIFont * font = [UIFont systemFontOfSize:14];
    
    CGSize searchTextLabelSize = [searchText sizeWithFont:font];
    UILabel *searchTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, (40-searchTextLabelSize.height)/2, searchTextLabelSize.width, searchTextLabelSize.height)];
    searchTextLabel.textColor = [UIColor redColor];
    searchTextLabel.font = font;
    searchTextLabel.text = searchText;
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(searchTextLabelSize.width + 10, (40-searchTextLabelSize.height)/2, 100, searchTextLabelSize.height)];
    textLabel.font = font;
    textLabel.textColor = [UIColor lightGrayColor];
    textLabel.text = @"  的搜索结果";
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, tableView.frame.size.width, 1)];
    lineView.backgroundColor = [LXUtil cellImageBorderColor];
    
    [headerView addSubview:searchTextLabel];
    [headerView addSubview:textLabel];
    [headerView addSubview:lineView];
    headerView.backgroundColor = [UIColor whiteColor];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ([self numberOfSectionsInTableView:tableView] == (section + 1)) {
        return [UIView new];
    }
    return nil;
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
    if ([scopeType isEqualToString:@"post"]) {
        UITableViewController *destination = segue.destinationViewController;
        if ([destination respondsToSelector:@selector(setDelegate:)]) {
            [destination setValue:self forKey:@"delegate"];
        }
        if ([destination respondsToSelector:@selector(setQuestionId:)]) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            
            NSDictionary *post = [allItems objectAtIndex:[indexPath row]];
            NSString *questionId = [post objectForKey:@"id"];
            [destination setValue:questionId forKey:@"questionId"];
        }
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
