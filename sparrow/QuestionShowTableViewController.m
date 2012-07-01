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
@synthesize headerViewStatus;
@synthesize headerViewHeight;
//@synthesize headerView;
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
    headerViewStatus = 0;
    
    [self initTableViewHeader];
    [self requestQuestionDetail];
//    NSString *title = [NSString stringWithFormat:@"%@", answers.count];
//    self.navigationItem.title = title;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.sampleDetail = nil;
    self.fullDetail = nil;
    self.answers = nil;
    self.delegate = nil;
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
    return [answers count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
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
    NSDictionary *user = [answer objectForKey:@"user"];
    NSString *name = [user objectForKey:@"name"];
    NSString *bio = [user objectForKey:@"bio"];
    NSString *avatar_url = [user objectForKey:@"avatar_url"];
    NSString *markdown = [answer objectForKey:@"markdown"];
    NSInteger voteCount = [answer objectForKey:@"votes_count"];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PREFIX_URL, avatar_url]]
              placeholderImage:[UIImage imageNamed:@"111-user.png"]];
    imageView.layer.borderWidth = 1;
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 3;
    imageView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:3];
    nameLabel.text = name;
    
    UILabel *contentLabel = (UILabel *)[cell viewWithTag:4];
    contentLabel.text = [self flattenHTML:markdown];
    
    UILabel *voteLabel = (UILabel *)[cell viewWithTag:2];
    voteLabel.text = [NSString stringWithFormat:@"%@", voteCount];
        
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
    
    NSInteger bounty = [sampleDetail objectForKey:@"bounties"];
    UIImageView *bountyImageView = nil;
    if (bounty > 0) {
        bountyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 60, 60)];
        bountyImageView.image = [UIImage imageNamed:@"badge-yellow.png"];
        
        UILabel *bountyLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, 44, 20)];
        bountyLabel.textAlignment = UITextAlignmentCenter;
        bountyLabel.backgroundColor = [UIColor whiteColor];
        bountyLabel.layer.masksToBounds = YES;
        bountyLabel.layer.cornerRadius = 3;
        bountyLabel.text = [NSString stringWithFormat:@"%@ 元", bounty];
        [bountyImageView addSubview:bountyLabel];
        
        UILabel *answerCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(4, 35, 52, 20)];
        answerCountLabel.textAlignment = UITextAlignmentCenter;
        answerCountLabel.backgroundColor = [UIColor clearColor];
        answerCountLabel.font = [UIFont systemFontOfSize:15];
        NSInteger answersCount = [sampleDetail objectForKey:@"answers_count"];
        answerCountLabel.text = [NSString stringWithFormat:@"%@ 回答", answersCount];
        [bountyImageView addSubview:answerCountLabel];
        
        [headerView addSubview:bountyImageView];
    } else {
        bountyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 60, 60)];
        bountyImageView.image = [UIImage imageNamed:@"badge-red.png"];
        
        UILabel *answersCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, 44, 25)];
        answersCountLabel.textAlignment = UITextAlignmentCenter;
        NSInteger answersCount = [sampleDetail objectForKey:@"answers_count"];
        answersCountLabel.text = [NSString stringWithFormat:@"%@", answersCount];
        [bountyImageView addSubview:answersCountLabel];

        UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(4, 35, 52, 21)];
        typeLabel.textAlignment = UITextAlignmentCenter;
        typeLabel.text = @"回答";
        [bountyImageView addSubview:typeLabel];
        
        [headerView addSubview:bountyImageView];    
    }
        
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLable.numberOfLines = 5;
    titleLable.font = [UIFont systemFontOfSize:15];
    titleLable.backgroundColor = [UIColor clearColor];
    CGSize constraint = CGSizeMake(212, 20000.0f);
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    [titleLable setFrame:CGRectMake(88, 20, 212, size.height)];
    
    titleLable.text = title;
    
    [headerView addSubview:titleLable];
    if (size.height > bountyImageView.image.size.height) {
        headerViewHeight = size.height+40;
    }else {
        headerViewHeight = bountyImageView.image.size.height + 40;
    }
    headerView.frame = CGRectMake(0, 0, 320, headerViewHeight);
    headerView.backgroundColor = [UIColor lightGrayColor];
    [self.tableView setTableHeaderView:headerView];
    
    UITapGestureRecognizer *tableViewHeaderTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tableViewHeaderTapped:)];
    [headerView addGestureRecognizer:tableViewHeaderTap];
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
        if (response) {
            fullDetail = [response objectFromJSONString];
            answers = (NSArray *)[fullDetail objectForKey:@"answers"];
        }
    }
}

- (NSString *)flattenHTML:(NSString *)html
{
    NSScanner *scanner = [NSScanner scannerWithString:html];
    NSString *text = nil;
    while ([scanner isAtEnd] == NO) {
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    
    NSArray *entities = [[NSArray alloc] initWithObjects:@"&nbsp;",@"&lt;",@"&gt;",@"&amp;",@"&quot;",@"&apos;",nil];
    NSArray *plainText = [[NSArray alloc] initWithObjects:@" ",@"<",@">",@"&",@"\"",@"\'",nil];
    
    for (NSInteger i=0; i<entities.count; i++) {
        html = [html stringByReplacingOccurrencesOfString:[entities objectAtIndex:i] withString:[plainText objectAtIndex:i]];
    }
    return html;
}

- (void)tableViewHeaderTapped:(UITapGestureRecognizer *)recognizer
{
    NSInteger height = 140;
    if (headerViewStatus == 0) {
        headerViewStatus = 1;
    } else {
        headerViewStatus = 0;
        height = headerViewHeight;
    }
    UIView *headerView = self.tableView.tableHeaderView;
    headerView.frame = CGRectMake(0, 0, 320, height);
    [self.tableView setTableHeaderView:headerView];
    NSLog(@"TableViewHeader tapped");
}

@end
