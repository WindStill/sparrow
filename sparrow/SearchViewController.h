//
//  SearchViewController.h
//  sparrow
//
//  Created by mac on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>{
    UISearchDisplayController *searchDisplayController;
    UISearchBar *searchBar;
    NSArray *allItems;
    NSArray *searchResults;
}

@property (nonatomic, copy) NSArray *allItems;
@property (nonatomic, copy) NSArray *searchResults;

@end
