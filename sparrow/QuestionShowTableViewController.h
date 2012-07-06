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
#import <MediaPlayer/MediaPlayer.h>

@interface QuestionShowTableViewController : UITableViewController<DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate>

@property (strong, nonatomic) NSDictionary *sampleDetail;
@property (strong, nonatomic) NSDictionary *fullDetail;
@property (strong, nonatomic) NSArray *answers;
@property (strong, nonatomic) id delegate;
@property (strong, nonatomic) UIView *headerView;
@property (nonatomic) NSInteger headerViewStatus;
@property (nonatomic) NSInteger headerViewHeight;
@property (strong, nonatomic) DTAttributedTextView *compliedView;
@property (strong, nonatomic) NSMutableSet *mediaPlayers;

//@property (strong, nonatomic) UIView *headerView;

- (void)initTableViewHeader;
- (void)buildBountyViewInTableViewHeader;
- (void)buildTitleViewAInTableViewHeader;
- (void)buildCompliedViewInTableViewHeader;
- (void)requestQuestionDetail;
- (NSString *)flattenHTML:(NSString *)html;
- (void)tableViewHeaderTapped:(UITapGestureRecognizer *)recognizer;
@end
