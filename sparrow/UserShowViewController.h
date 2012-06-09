//
//  UserShowViewController.h
//  sparrow
//
//  Created by mac on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserShowViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *userAvatar;
@property (strong, nonatomic) IBOutlet UILabel *nickname;
@property (strong, nonatomic) IBOutlet UILabel *bio;

@property (strong, nonatomic) IBOutlet UILabel *channelsCount;
@property (strong, nonatomic) IBOutlet UILabel *followingCount;
@property (strong, nonatomic) IBOutlet UILabel *followerCount;

- (void)drawRect:(NSInteger)height;

@end
