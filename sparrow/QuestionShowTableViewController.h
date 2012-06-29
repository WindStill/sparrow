//
//  QuestionShowTableViewController.h
//  sparrow
//
//  Created by mac on 12-6-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzCore/QuartzCore.h"
#import "Constant.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"

@interface QuestionShowTableViewController : UITableViewController

@property (strong, nonatomic) NSDictionary *sampleDetail;
@property (strong, nonatomic) NSDictionary *fullDetail;
@property (strong, nonatomic) NSArray *answers;
@property (strong, nonatomic) id delegate;

- (void)initTableViewHeader;
- (void)requestQuestionDetail;
@end
