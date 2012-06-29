//
//  ActivityTableViewController.h
//  sparrow
//
//  Created by mac on 12-5-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTPusher.h"
#import "PTPusherChannel.h"
#import "PTPusherDelegate.h"
#import "PTPusherEvent.h"

@interface ActivityTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *listData;
@property (strong, nonatomic) PTPusher *client;
@property (strong, nonatomic) PTPusherChannel *channel;
@end
