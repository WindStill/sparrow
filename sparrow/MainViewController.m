//
//  MainViewController.m
//  sparrow
//
//  Created by mac on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "SignInViewController.h"

@implementation MainViewController
@synthesize button;

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
    [button setBackgroundImage:[UIImage imageNamed:@"coverpageindicatorSel"] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:@"coverpageindicator"] forState:UIControlStateNormal];
    
}

- (void)viewDidUnload
{
    [self setButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)buttonPressed:(id)sender {
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    
    if ([userInfo boolForKey:@"nickname"] == YES) {
        [self performSegueWithIdentifier:@"inderect" sender:self];
    }else {
        SignInViewController *signInViewControlloer = [self.storyboard instantiateViewControllerWithIdentifier:@"signin"];
        [self presentModalViewController:signInViewControlloer animated:YES];
    }

}
@end
