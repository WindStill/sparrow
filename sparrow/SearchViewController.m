//
//  SearchViewController.m
//  sparrow
//
//  Created by mac on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"
#import "Constant.h"
#import "SearchResultTableViewController.h"

@implementation SearchViewController
@synthesize allItems;
@synthesize searchResults;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *items = [[NSArray alloc] initWithObjects:
                      @"Code Geass",
                      @"Asura Cryin'",
                      @"Voltes V",
                      @"Mazinger Z",
                      @"Daimos",
                      nil];
    
    self.allItems = items;
    [self.view viewWithTag:1].hidden = YES;
    self.searchDisplayController.active = NO;
//    self.searchDisplayController.searchResultsTableView.hidden = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger row = 0;
    
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        row = [self.searchResults count];
    }
    else {
        row = [self.allItems count];
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView 
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] 
                 initWithStyle:UITableViewCellStyleDefault 
                 reuseIdentifier:CellIdentifier];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    /* Configure the cell. */
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        cell.textLabel.text = 
        [self.searchResults objectAtIndex:indexPath.row];
    }
    else{
        cell.textLabel.text =
        [self.allItems objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSArray *scopePaths = [[NSArray alloc]initWithObjects:@"post", @"user", @"list", @"tag", nil];
    NSInteger scope = [searchBar selectedScopeButtonIndex];
    NSString *scopeText = [[searchBar scopeButtonTitles]objectAtIndex:scope];
    NSString *scopeType = [scopePaths objectAtIndex:scope];
    NSString *searchText = [searchBar text];
    
    [self.searchDisplayController setActive:NO animated:NO];
    
//    self.view.backgroundColor = [UIColor whiteColor];
    SearchResultTableViewController *destination = [SearchResultTableViewController alloc];
    destination.navigationItem.title = scopeText;
    destination.scopeType = scopeType;
    destination.searchText = searchText;
    [self.navigationController pushViewController:destination animated:NO];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText isEqualToString:@""]) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.view.backgroundColor = [UIColor whiteColor];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString
{
    return NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    return NO;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView
{
    tableView.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:100/255.0f green:100/255.0f blue:100/255.0f alpha:0.5f];
}

@end
