//
//  QuestionSquareViewController.h
//  sparrow
//
//  Created by mac on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionSquareViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *allQuestions;
@property (strong, nonatomic) NSArray *bountyQuestions;
@property (strong, nonatomic) NSArray *currentQuestions;

- (IBAction)segementChanged:(id)sender;
@end
