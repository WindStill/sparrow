//
//  UserShowViewController.m
//  sparrow
//
//  Created by mac on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserShowViewController.h"
#import "Constant.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "UIImageView+WebCache.h"

@implementation UserShowViewController
@synthesize userAvatar;
@synthesize nickname;
@synthesize bio;
@synthesize channelsCount;
@synthesize followingCount;
@synthesize followerCount;

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
    
    NSDictionary *userShow ;
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    
    NSString *name = [userInfo stringForKey:@"name"];
    NSString *avatarUrl = [userInfo stringForKey:@"avatar_url"];
    NSString *bio = [userInfo stringForKey:@"bio"];
    NSString *nickname = [userInfo stringForKey:@"nickname"];
    NSString *authenticationToken = [userInfo stringForKey:@"authentication_token"];
    
    NSLog(nickname);
    
    self.navigationItem.title = name;
    [self.userAvatar setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PREFIX_URL, avatarUrl]]
              placeholderImage:[UIImage imageNamed:@"111-user.png"]];
    self.nickname.text = [NSString stringWithFormat:@"@%@", nickname];
    self.bio.text = bio;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/%@.json?auth_token=%@", PREFIX_URL, nickname, authenticationToken]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    //    [request addRequestHeader:@"Content-Type" value:@"application/json; charset=utf-8"];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        userShow = [response mutableObjectFromJSONString];
        
        [self drawRect:110];
        self.channelsCount.text = [NSString stringWithFormat:@"%@", [userShow objectForKey:@"channels_count"]];
        self.followingCount.text = [NSString stringWithFormat:@"%@", [userShow objectForKey:@"following_count"]];
        self.followerCount.text = [NSString stringWithFormat:@"%@", [userShow objectForKey:@"follower_count"]];
        [self drawRect:180];
        
        
    }
}

- (void)viewDidUnload
{
    [self setUserAvatar:nil];
    [self setNickname:nil];
    [self setBio:nil];
    [self setChannelsCount:nil];
    [self setFollowingCount:nil];
    [self setFollowerCount:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)drawRect:(NSInteger)height {
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, height, self.view.bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView];
}

@end
