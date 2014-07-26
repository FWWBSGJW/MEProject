//
//  JJFinishViewController.h
//  在线教育
//
//  Created by Johnny's on 14-7-11.
//  Copyright (c) 2014年 Johnny's. All rights reserved.
//

#import "JJBaseViewController.h"

@interface JJFinishViewController : JJBaseViewController

@property (strong, nonatomic) IBOutlet UILabel *scoreLa;
- (IBAction)back:(id)sender;

- (id)initWithScore:(NSString *)score correctAnswer:(NSArray *)correctArray personAnswer:(NSArray *)personArray questionArray:(NSArray *)queArray answerArray:(NSArray *)anArray;
@property (strong, nonatomic) IBOutlet UIButton *reviewBtn;
@end
