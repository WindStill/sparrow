//
//  MainViewController.h
//  sparrow
//
//  Created by mac on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *button;

- (IBAction)buttonPressed:(id)sender;
@end
