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
@synthesize headerView;
@synthesize headerViewStatus;
@synthesize headerViewHeight;
@synthesize compliedView;
@synthesize mediaPlayers;

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
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ 个回答", [sampleDetail objectForKey:@"answers_count"]];
    [self initTableViewHeader];
    [self requestQuestionDetail];
    [self buildCompliedViewInTableViewHeader];
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
    NSString *avatar_url = [user objectForKey:@"avatar_url"];
    NSString *compiled = [answer objectForKey:@"compiled"];
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
    contentLabel.text = [self flattenHTML:compiled];
    
    UILabel *voteLabel = (UILabel *)[cell viewWithTag:2];
    voteLabel.text = [NSString stringWithFormat:@"%@", voteCount];
        
    // Configure the cell...
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)]) {
        [destination setValue:self forKey:@"delegate"];
    }
    if ([destination respondsToSelector:@selector(setAnswer:)]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSDictionary *answer = (NSDictionary *)[answers objectAtIndex:indexPath.row];
        [destination setValue:answer forKey:@"answer"];
    }
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

- (void)buildBountyViewInTableViewHeader
{
    NSNumber *bounty = [sampleDetail objectForKey:@"bounties"];
    UIImageView *bountyImageView = nil;
    if ([bounty integerValue] > 0) {
        bountyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
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
        answerCountLabel.textColor = [UIColor darkGrayColor];
        answerCountLabel.font = [UIFont systemFontOfSize:13];
        NSInteger answersCount = [sampleDetail objectForKey:@"answers_count"];
        answerCountLabel.text = [NSString stringWithFormat:@"%@ 回答", answersCount];
        [bountyImageView addSubview:answerCountLabel];
        
        [headerView addSubview:bountyImageView];
    } else {
        bountyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
        bountyImageView.image = [UIImage imageNamed:@"badge-grey.png"];
        
        UILabel *answersCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, 44, 25)];
        answersCountLabel.textAlignment = UITextAlignmentCenter;
        answersCountLabel.backgroundColor = [UIColor clearColor];
        NSInteger answersCount = [sampleDetail objectForKey:@"answers_count"];
        answersCountLabel.text = [NSString stringWithFormat:@"%@", answersCount];
        [bountyImageView addSubview:answersCountLabel];
        
        UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(4, 35, 52, 21)];
        typeLabel.textAlignment = UITextAlignmentCenter;
        typeLabel.backgroundColor = [UIColor clearColor];
        typeLabel.font = [UIFont systemFontOfSize:15];
        typeLabel.text = @"回答";
        [bountyImageView addSubview:typeLabel];
        
        [headerView addSubview:bountyImageView];    
    }
    headerViewHeight = bountyImageView.image.size.height + 20;
}

- (void)buildTitleViewAInTableViewHeader
{
    NSString *title = [sampleDetail objectForKey:@"title"];
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLable.numberOfLines = 5;
    titleLable.font = [UIFont systemFontOfSize:15];
    titleLable.backgroundColor = [UIColor clearColor];
    CGSize constraint = CGSizeMake(232, 20000.0f);
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    [titleLable setFrame:CGRectMake(78, 10, 232, size.height)];
    titleLable.text = title;
    [headerView addSubview:titleLable];
    
    NSDictionary *user = [sampleDetail objectForKey:@"user"];
    UIView *userView = [[UIView alloc]initWithFrame:CGRectMake(78, 15+size.height, 232, 20)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PREFIX_URL, [user objectForKey:@"avatar_url"]]]
              placeholderImage:[UIImage imageNamed:@"111-user.png"]]; 
    [userView addSubview:imageView];
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 0, 133, 20)];
    nameLabel.font = [UIFont systemFontOfSize:13];
    nameLabel.lineBreakMode = UILineBreakModeTailTruncation;
    nameLabel.text = [NSString stringWithFormat:@"%@", [user objectForKey:@"name"]];
    [userView addSubview:nameLabel];
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(157, 0, 75, 20)];
    dateLabel.font = [UIFont systemFontOfSize:12];
    dateLabel.textColor = [UIColor darkGrayColor];
    dateLabel.text = [[sampleDetail objectForKey:@"created_at"]substringToIndex:10];
    [userView addSubview:dateLabel];
    [headerView addSubview:userView];
    
    NSInteger height = titleLable.frame.size.height + 5 + userView.frame.size.height;
    if (height + 20 > headerViewHeight) {
        headerViewHeight = height+20;
    }
}

- (void)initTableViewHeader
{
    
    headerView = [[UIView alloc] initWithFrame:CGRectZero];
//    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
    
    [self buildBountyViewInTableViewHeader];
    [self buildTitleViewAInTableViewHeader];    
    
    headerView.frame = CGRectMake(0, 0, 320, headerViewHeight);
//    headerView.backgroundColor = [UIColor lightGrayColor];
    [self.tableView setTableHeaderView:headerView];
    
    UITapGestureRecognizer *tableViewHeaderTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tableViewHeaderTapped:)];
    tableViewHeaderTap.numberOfTapsRequired = 1;
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
    
    NSArray *entities = [[NSArray alloc] initWithObjects:@"&nbsp;",@"&lt;",@"&gt;",@"&amp;",@"&quot;",@"&apos;",@"\n",nil];
    NSArray *plainText = [[NSArray alloc] initWithObjects:@" ",@"<",@">",@"&",@"\"",@"\'",@" ",nil];
    
    for (NSInteger i=0; i<entities.count; i++) {
        html = [html stringByReplacingOccurrencesOfString:[entities objectAtIndex:i] withString:[plainText objectAtIndex:i]];
    }
    return html;
}

- (void)buildCompliedViewInTableViewHeader
{
    NSString *html = [fullDetail objectForKey:@"compiled"];
    if (html != nil && html != @"") {
        CGRect frame = CGRectMake(0.0, headerViewHeight-10, self.view.frame.size.width, self.view.frame.size.height);
        [DTAttributedTextContentView setLayerClass:[CATiledLayer class]];
        compliedView = [[DTAttributedTextView alloc] initWithFrame:frame];
        compliedView.textDelegate = self;
        compliedView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [headerView addSubview:compliedView];
        
        NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
        
        // Create attributed string from HTML
        CGSize maxImageSize = CGSizeMake(self.view.bounds.size.width - 20.0, self.view.bounds.size.height - 20.0);
        
        // example for setting a willFlushCallback, that gets called before elements are written to the generated attributed string
        void (^callBackBlock)(DTHTMLElement *element) = ^(DTHTMLElement *element) {
            // if an element is larger than twice the font size put it in it's own block
            if (element.displayStyle == DTHTMLElementDisplayStyleInline && element.textAttachment.displaySize.height > 2.0 * element.fontDescriptor.pointSize)
            {
                element.displayStyle = DTHTMLElementDisplayStyleBlock;
            }
        };
        
        
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:1.0], NSTextSizeMultiplierDocumentOption, [NSValue valueWithCGSize:maxImageSize], DTMaxImageSize,
                                 @"Helvetica", DTDefaultFontFamily,  @"purple", DTDefaultLinkColor, nil, NSBaseURLDocumentOption, callBackBlock, DTWillFlushBlockCallBack, nil]; 
        NSAttributedString *string = [[NSAttributedString alloc] initWithHTML:data options:options documentAttributes:NULL];
        
        // Display string
        compliedView.contentView.edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        compliedView.attributedString = string;
        [compliedView setFrame:CGRectMake(0, headerViewHeight-10, self.view.frame.size.width, compliedView.contentSize.height)];
        compliedView.hidden = YES;
        [headerView addSubview:compliedView];
    }
}

- (void)tableViewHeaderTapped:(UITapGestureRecognizer *)recognizer
{
    CGRect newRect = headerView.frame;
    
    [UIView beginAnimations:@"expandView" context:nil];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(AnimationHasFinished:finished:context:)];
    [UIView setAnimationCurve:UIViewAutoresizingFlexibleHeight];
    
    if (headerViewStatus == 0) {
        headerViewStatus = 1;
        if (compliedView != nil) {
            newRect.size.height = headerViewHeight + compliedView.contentSize.height - 10;
            headerView.frame = newRect;
            self.tableView.tableHeaderView = headerView;
        }
    } else {
        headerViewStatus = 0;
        compliedView.hidden = YES;
        
        newRect.size.height = headerViewHeight;
        headerView.frame = newRect;
        self.tableView.tableHeaderView = headerView;
    }
    
    [UIView commitAnimations];
}

- (void)AnimationHasFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context;
{
    if (headerViewStatus == 0) {
        compliedView.hidden = YES;
    } else {
        compliedView.hidden = NO;
    }
}

#pragma mark Custom Views on Text
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForLink:(NSURL *)url identifier:(NSString *)identifier frame:(CGRect)frame
{
	DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:frame];
	button.URL = url;
	button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
	button.GUID = identifier;
	
	// use normal push action for opening URL
	[button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
	
	// demonstrate combination with long press
	UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(linkLongPressed:)];
	[button addGestureRecognizer:longPress];
	
	return button;
}

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
{
	if (attachment.contentType == DTTextAttachmentTypeVideoURL)
	{
		NSURL *url = (id)attachment.contentURL;
		
		// we could customize the view that shows before playback starts
		UIView *grayView = [[UIView alloc] initWithFrame:frame];
		grayView.backgroundColor = [DTColor blackColor];
		
		// find a player for this URL if we already got one
		MPMoviePlayerController *player = nil;
		for (player in self.mediaPlayers)
		{
			if ([player.contentURL isEqual:url])
			{
				break;
			}
		}
		
		if (!player)
		{
			player = [[MPMoviePlayerController alloc] initWithContentURL:url];
			[self.mediaPlayers addObject:player];
		}
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_4_2
		NSString *airplayAttr = [attachment.attributes objectForKey:@"x-webkit-airplay"];
		if ([airplayAttr isEqualToString:@"allow"])
		{
			if ([player respondsToSelector:@selector(setAllowsAirPlay:)])
			{
				player.allowsAirPlay = YES;
			}
		}
#endif
		
		NSString *controlsAttr = [attachment.attributes objectForKey:@"controls"];
		if (controlsAttr)
		{
			player.controlStyle = MPMovieControlStyleEmbedded;
		}
		else
		{
			player.controlStyle = MPMovieControlStyleNone;
		}
		
		NSString *loopAttr = [attachment.attributes objectForKey:@"loop"];
		if (loopAttr)
		{
			player.repeatMode = MPMovieRepeatModeOne;
		}
		else
		{
			player.repeatMode = MPMovieRepeatModeNone;
		}
		
		NSString *autoplayAttr = [attachment.attributes objectForKey:@"autoplay"];
		if (autoplayAttr)
		{
			player.shouldAutoplay = YES;
		}
		else
		{
			player.shouldAutoplay = NO;
		}
		
		[player prepareToPlay];
		
		player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		player.view.frame = grayView.bounds;
		[grayView addSubview:player.view];
		
		return grayView;
	}
	else if (attachment.contentType == DTTextAttachmentTypeImage)
	{
		// if the attachment has a hyperlinkURL then this is currently ignored
		DTLazyImageView *imageView = [[DTLazyImageView alloc] initWithFrame:frame];
		imageView.delegate = self;
		if (attachment.contents)
		{
			imageView.image = attachment.contents;
		}
		
		// url for deferred loading
		imageView.url = attachment.contentURL;
		
		// if there is a hyperlink then add a link button on top of this image
		if (attachment.hyperLinkURL)
		{
			// NOTE: this is a hack, you probably want to use your own image view and touch handling
			// also, this treats an image with a hyperlink by itself because we don't have the GUID of the link parts
			imageView.userInteractionEnabled = YES;
			DTLinkButton *button = (DTLinkButton *)[self attributedTextContentView:attributedTextContentView viewForLink:attachment.hyperLinkURL identifier:attachment.hyperLinkGUID frame:imageView.bounds];
			[imageView addSubview:button];
		}
		
		return imageView;
	}
	else if (attachment.contentType == DTTextAttachmentTypeIframe)
	{
		DTWebVideoView *videoView = [[DTWebVideoView alloc] initWithFrame:frame];
		videoView.attachment = attachment;
		
		return videoView;
	}
	else if (attachment.contentType == DTTextAttachmentTypeObject)
	{
		// somecolorparameter has a HTML color
		UIColor *someColor = [UIColor colorWithHTMLName:[attachment.attributes objectForKey:@"somecolorparameter"]];
		
		UIView *someView = [[UIView alloc] initWithFrame:frame];
		someView.backgroundColor = someColor;
		someView.layer.borderWidth = 1;
		someView.layer.borderColor = [UIColor blackColor].CGColor;
		
		return someView;
	}
	
	return nil;
}


- (BOOL)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView shouldDrawBackgroundForTextBlock:(DTTextBlock *)textBlock frame:(CGRect)frame context:(CGContextRef)context forLayoutFrame:(DTCoreTextLayoutFrame *)layoutFrame
{
	UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:10];
    
	CGColorRef color = [textBlock.backgroundColor CGColor];
	if (color)
	{
		CGContextSetFillColorWithColor(context, color);
		CGContextAddPath(context, [roundedRect CGPath]);
		CGContextFillPath(context);
		
		CGContextAddPath(context, [roundedRect CGPath]);
		CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
		CGContextStrokePath(context);
		return NO;
	}
	
	return YES; // draw standard background
}

#pragma mark DTLazyImageViewDelegate

- (void)lazyImageView:(DTLazyImageView *)lazyImageView didChangeImageSize:(CGSize)size {
	NSURL *url = lazyImageView.url;
	CGSize imageSize = size;
	
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"contentURL == %@", url];
	
	// update all attachments that matchin this URL (possibly multiple images with same size)
	for (DTTextAttachment *oneAttachment in [compliedView.contentView.layoutFrame textAttachmentsWithPredicate:pred])
	{
		oneAttachment.originalSize = imageSize;
		
		if (!CGSizeEqualToSize(imageSize, oneAttachment.displaySize))
		{
			oneAttachment.displaySize = imageSize;
		}
	}
//    
//    CGPoint newPoint = lazyImageView.center;
//    newPoint.x = 160;
//    lazyImageView.center = newPoint;
//    
//    NSLog([NSString stringWithFormat:@"x:%f y:%f w:%f h:%f",lazyImageView.frame.origin.x,lazyImageView.frame.origin.y,lazyImageView.frame.size.width,lazyImageView.frame.size.height]);
	
	// redo layout
	// here we're layouting the entire string, might be more efficient to only relayout the paragraphs that contain these attachments
	[compliedView.contentView relayoutText];
    [compliedView setFrame:CGRectMake(0, headerViewHeight-10, self.view.frame.size.width, compliedView.contentSize.height)];
    if (headerViewStatus == 1) {
        CGRect newRect = headerView.frame;
        newRect.size.height = headerViewHeight + compliedView.contentSize.height-10;
        headerView.frame = newRect;
        self.tableView.tableHeaderView = headerView;
    }
}

@end
