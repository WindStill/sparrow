//
//  AnswerShowViewController.h
//  sparrow
//
//  Created by mac on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTAttributedTextView.h"
#import "QuartzCore/QuartzCore.h"
#import <MediaPlayer/MediaPlayer.h>
#import "DTLazyImageView.h"

@interface AnswerShowViewController : UIViewController<UIActionSheetDelegate, DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate>
{
    DTAttributedTextView *compliedView;
}
@property (strong, nonatomic) NSDictionary *answer;
@property (strong, nonatomic) NSURL *baseURL;
@property (strong, nonatomic) NSMutableSet *mediaPlayers;
@property (nonatomic, strong) NSURL *lastActionLink;

- (void)compliedViewTapped:(UITapGestureRecognizer *)recognizer;

- (void)linkPushed:(DTLinkButton *)button;
- (void)linkLongPressed:(UILongPressGestureRecognizer *)gesture;
- (void)debugButton:(UIBarButtonItem *)sender;
@end
