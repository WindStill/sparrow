//
//  QuestionSquareViewController.m
//  sparrow
//
//  Created by mac on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "QuestionSquareViewController.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "Constant.h"

@implementation QuestionSquareViewController

@synthesize allQuestions;
@synthesize bountyQuestions;
@synthesize currentQuestions;

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
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/questions.json?type=all", PREFIX_URL]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        self.allQuestions = [response mutableObjectFromJSONString];
        self.currentQuestions = self.allQuestions;
        
        NSLog(@"%d", currentQuestions.count);
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.allQuestions = nil;
    self.bountyQuestions = nil;
    self.currentQuestions = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)segementChanged:(id)sender {
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    NSInteger selected = [seg selectedSegmentIndex];
    if (selected == 0) {
        currentQuestions = allQuestions;
    } else {
        if (bountyQuestions == nil) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/questions.json?type=bounty", PREFIX_URL]];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
            [request startSynchronous];
            NSError *error = [request error];
            if (!error) {
                NSString *response = [request responseString];
                self.bountyQuestions = [response mutableObjectFromJSONString];
            }
        }
        currentQuestions = bountyQuestions;
    }
    UITableView *tableView = (UITableView *)[self.view viewWithTag:1];
    [tableView reloadData];
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.currentQuestions count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = [[currentQuestions objectAtIndex:[indexPath row]] objectForKey:@"title"];
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(tableView.frame.size.width - 20, 500) lineBreakMode:UILineBreakModeWordWrap];
    return size.height + 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"question";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSInteger row = indexPath.row;
    NSDictionary *question = [currentQuestions objectAtIndex:row];
    NSString *title = [question objectForKey:@"title"];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(tableView.frame.size.width - 20, 500) lineBreakMode:UILineBreakModeWordWrap];
    titleLabel.frame = CGRectMake(10, 10, tableView.frame.size.width - 20, size.height);  
    titleLabel.text = title;
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableView *tableView = (UITableView *)[self.view viewWithTag:1];
    
    UITableViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)]) {
        [destination setValue:self forKey:@"delegate"];
    }
    if ([destination respondsToSelector:@selector(setQuestionId:)]) {
        NSIndexPath *indexPath = [tableView indexPathForCell:sender];
        
        NSDictionary *question = (NSDictionary *)[currentQuestions objectAtIndex:indexPath.row];
        NSString *questionId = [question objectForKey:@"id"];
        [destination setValue:questionId forKey:@"questionId"];
    }
}

@end
