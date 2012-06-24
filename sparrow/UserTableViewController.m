//
//  MineTableViewController.m
//  sparrow
//
//  Created by 园园 李 on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserTableViewController.h"
#import "Constant.h"
#import "UIImageView+WebCache.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"

@interface UserTableViewController ()

@end

@implementation UserTableViewController
@synthesize userInfo;
@synthesize userShow;
@synthesize groups;
@synthesize items;

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

    self.userInfo = [NSUserDefaults standardUserDefaults];
    NSString *nickname = [userInfo stringForKey:@"nickname"];
    NSString *authenticationToken = [userInfo stringForKey:@"authentication_token"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/%@.json?auth_token=%@", PREFIX_URL, nickname, authenticationToken]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//    [request addRequestHeader:@"Content-Type" value:@"application/json; charset=utf-8"];
    [request startSynchronous];
    NSError *error = [request error];
    
    if (!error) {
        NSString *response = [request responseString];
        self.userShow = [response mutableObjectFromJSONString];
    }
    
    [self initGroupsAndItems];
    [self initTableViewHeader];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.userInfo = nil;
    self.userShow = nil;
    self.items = nil;
    self.groups = nil;
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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [groups count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSString *groupName = [self.groups objectAtIndex:section];
    NSArray *group = (NSArray *)[items objectForKey:groupName];

    return [group count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];

    NSString *groupName = [self.groups objectAtIndex:section];   
    NSArray *group = [self.items objectForKey:groupName];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [group objectAtIndex:row];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;

}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = nil;
//    if (indexPath.row == 0) {
//        CellIdentifier = @"info";
//    } else if (indexPath.row == 1) {
//        CellIdentifier = @"count";
//    }
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (indexPath.row == 0) {
//        UIImageView * imageView = (UIImageView *)[cell viewWithTag:1];
//        NSString *avatar_url = [userInfo stringForKey:@"avatar_url"];
//        [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PREFIX_URL, avatar_url]]
//                  placeholderImage:[UIImage imageNamed:@"111-user.png"]]; 
//        
//        UILabel *nameLabel = (UILabel *)[cell viewWithTag:2];
//        NSString *name = [userInfo stringForKey:@"name"];
//        nameLabel.text = name;
//        
//        UILabel *bioLabel = (UILabel *)[cell viewWithTag:3];
//        NSString *bio = [userInfo stringForKey:@"bio"];
//        bioLabel.text = bio;
//    } else if (indexPath.row == 1) {
//        UILabel *listCountLabel = (UILabel *)[cell viewWithTag:1];
//        listCountLabel.text = [NSString stringWithFormat:@"%@", [userShow objectForKey:@"channels_count"]];
//        UILabel *followingCount = (UILabel *)[cell viewWithTag:2];
//        followingCount.text = [NSString stringWithFormat:@"%@", [userShow objectForKey:@"following_count"]];
//        UILabel *followerCount = (UILabel *)[cell viewWithTag:3];
//        followerCount.text = [NSString stringWithFormat:@"%@", [userShow objectForKey:@"follower_count"]];
//    }
//        
//    
//    return cell;
//}

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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 65.0f;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, screenRect.size.height)];
        headerView.autoresizesSubviews = YES;
        headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        //        listCountLabel.text = [NSString stringWithFormat:@"%@", [userShow objectForKey:@"channels_count"]];
        //        UILabel *followingCount = (UILabel *)[cell viewWithTag:2];
        //        followingCount.text = [NSString stringWithFormat:@"%@", [userShow objectForKey:@"following_count"]];
        //        UILabel *followerCount = (UILabel *)[cell viewWithTag:3];
        //        followerCount.text = [NSString stringWithFormat:@"%@", [userShow objectForKey:@"follower_count"]];
        
        UIButton *channelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        channelButton.frame = CGRectMake(20, 7, 90, 46);
        UILabel *channelCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(24, 2, 42, 21)];
        channelCountLabel.textAlignment = UITextAlignmentCenter;
        channelCountLabel.backgroundColor = [UIColor clearColor];
        channelCountLabel.text = [NSString stringWithFormat:@"%@", [userShow objectForKey:@"channels_count"]];
        UILabel *channelLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 23, 56, 21)];
        channelLabel.textAlignment = UITextAlignmentCenter;
        channelLabel.font = [UIFont systemFontOfSize:13];
        channelLabel.textColor = [UIColor darkGrayColor];
        channelLabel.backgroundColor = [UIColor clearColor];
        channelLabel.text = @"我的频道";
        [channelButton addSubview:channelCountLabel];
        [channelButton addSubview:channelLabel];
                
        UIButton *followingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        followingButton.frame = CGRectMake(115, 7, 90, 46);
        UILabel *followingCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(24, 2, 42, 21)];
        followingCountLabel.textAlignment = UITextAlignmentCenter;
        followingCountLabel.backgroundColor = [UIColor clearColor];
        followingCountLabel.text = [NSString stringWithFormat:@"%@", [userShow objectForKey:@"following_count"]];
        UILabel *followingLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 23, 66, 21)];
        followingLabel.textAlignment = UITextAlignmentCenter;
        followingLabel.font = [UIFont systemFontOfSize:13];
        followingLabel.textColor = [UIColor darkGrayColor];
        followingLabel.backgroundColor = [UIColor clearColor];
        followingLabel.text = @"我关注的人";
        [followingButton addSubview:followingCountLabel];
        [followingButton addSubview:followingLabel];

        
        UIButton *followerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        followerButton.frame = CGRectMake(210, 7, 90, 46);
        UILabel *followerCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(24, 2, 42, 21)];
        followerCountLabel.textAlignment = UITextAlignmentCenter;
        followerCountLabel.backgroundColor = [UIColor clearColor];
        followerCountLabel.text = [NSString stringWithFormat:@"%@", [userShow objectForKey:@"follower_count"]];
        UILabel *followerLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 23, 66, 21)];
        followerLabel.textAlignment = UITextAlignmentCenter;
        followerLabel.font = [UIFont systemFontOfSize:13];
        followerLabel.textColor = [UIColor darkGrayColor];
        followerLabel.backgroundColor = [UIColor clearColor];
        followerLabel.text = @"关注我的人";
        [followerButton addSubview:followerCountLabel];
        [followerButton addSubview:followerLabel];

        
        [headerView addSubview:channelButton];
        [headerView addSubview:followingButton];
        [headerView addSubview:followerButton];
        

        return headerView;
    }
    return nil;
}

- (void)initGroupsAndItems {
    self.groups = [[NSArray alloc] initWithObjects:@"options", @"feedback",@"signout", nil];
    NSArray *options = [[NSArray alloc] initWithObjects:@"回答", @"提问", @"胜出", nil];
    NSArray *feedback = [[NSArray alloc] initWithObjects:@"问题反馈", nil];
    NSArray *signout = [[NSArray alloc] initWithObjects:@"退出账号", nil];
    self.items = [NSDictionary dictionaryWithObjectsAndKeys:
                  options, @"options", feedback, @"feedback", signout, @"signout", nil];
}

- (void)initTableViewHeader {
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 320, 101)];
    [self.tableView setTableHeaderView:headerView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 18, 81, 81)];
    NSString *avatar_url = [userInfo stringForKey:@"avatar_url"];
    [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PREFIX_URL, avatar_url]]
                     placeholderImage:[UIImage imageNamed:@"111-user.png"]]; 
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(109, 21, 191, 30)];
    nameLabel.font = [UIFont boldSystemFontOfSize:20];
    NSString *name = [userInfo stringForKey:@"name"];
    nameLabel.text = name;
    
    UILabel *bioLabel = [[UILabel alloc]initWithFrame:CGRectMake(109, 54, 191, 40)];
    bioLabel.font = [UIFont systemFontOfSize:14];
    bioLabel.textColor = [UIColor darkGrayColor];
    bioLabel.numberOfLines = 2;
    NSString *bio = [userInfo stringForKey:@"bio"];
    bioLabel.text = bio;
    
    [self.tableView.tableHeaderView addSubview:imageView];
    [self.tableView.tableHeaderView addSubview:nameLabel];
    [self.tableView.tableHeaderView addSubview:bioLabel];
//    self.tableView.tableHeaderView.autoresizesSubviews = YES;
//    self.tableView.tableHeaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    self.tableView.tableHeaderView.hidden = NO;
}
@end
