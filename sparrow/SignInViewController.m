//
//  SignInViewController.m
//  sparrow
//
//  Created by mac on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SignInViewController.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "Constant.h"

@implementation SignInViewController
@synthesize username;
@synthesize password;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setUsername:nil];
    [self setPassword:nil];
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
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)signInButtonPressed:(id)sender {
    //    NSString *const PREFIX = @"http://0.0.0.0:3000/";
    //    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@users/sign_in.json", PREFIX]];
    NSLog(PREFIX_URL);
    NSURL *url = [NSURL URLWithString:@"http://0.0.0.0:3000/users/sign_in.json"];
    NSString *username = self.username.text;
    NSString *password = self.password.text;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:username forKey:@"user[login]"];
    [request setPostValue:password forKey:@"user[password]"];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSDictionary *user_info = [response objectFromJSONString];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValuesForKeysWithDictionary:user_info];
        
        if (response) {
            [self performSegueWithIdentifier:@"signinsegue" sender:self];
        }
        
}
    
    
//    [self performSegueWithIdentifier:@"signinsegue" sender:self];
}
@end