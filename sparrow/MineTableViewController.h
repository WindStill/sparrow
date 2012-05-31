//
//  MineTableViewController.h
//  sparrow
//
//  Created by 园园 李 on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineTableViewController : UITableViewController
    <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSUserDefaults *userInfo;
@end
