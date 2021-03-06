//
//  MineTableViewController.h
//  sparrow
//
//  Created by 园园 李 on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserTableViewController : UITableViewController
    <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSUserDefaults *userInfo;
@property (strong, nonatomic) NSDictionary *userShow;
@property (strong, nonatomic) NSDictionary *items;
@property (strong, nonatomic) NSArray *groups;

- (void)initGroupsAndItems;
- (void)initTableViewHeader;
@end
