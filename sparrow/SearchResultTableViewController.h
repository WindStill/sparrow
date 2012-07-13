//
//  SearchResultTableViewController.h
//  sparrow
//
//  Created by mac on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultTableViewController : UITableViewController

@property (strong, nonatomic) NSString *scopeType;
@property (strong, nonatomic) NSString *searchText;
@property (strong, nonatomic) NSArray *allItems;

@end
