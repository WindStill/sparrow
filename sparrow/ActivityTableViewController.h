//
//  ActivityTableViewController.h
//  sparrow
//
//  Created by mac on 12-5-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityTableViewController : UITableViewController
<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSArray *listData;
@end
