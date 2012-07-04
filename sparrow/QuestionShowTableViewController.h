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
#import "UIImageView+WebCache.h"

@interface QuestionShowTableViewController : UITableViewController

@property (strong, nonatomic) NSDictionary *sampleDetail;
@property (strong, nonatomic) NSDictionary *fullDetail;
@property (strong, nonatomic) NSArray *answers;
@property (strong, nonatomic) id delegate;
@property (nonatomic) NSInteger headerViewStatus;
@property (nonatomic) NSInteger headerViewHeight;
//@property (strong, nonatomic) UIView *headerView;

- (void)initTableViewHeader;
- (void)initTableViewHeader:(UIView *)headerView;
- (void)requestQuestionDetail;
- (NSString *)flattenHTML:(NSString *)html;
- (void)tableViewHeaderTapped:(UITapGestureRecognizer *)recognizer;
- (void)tableViewCellTapped:(UITapGestureRecognizer *)recognizer;
@end
