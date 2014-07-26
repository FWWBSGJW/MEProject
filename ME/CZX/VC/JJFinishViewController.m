//
//  JJFinishViewController.m
//  在线教育
//
//  Created by Johnny's on 14-7-11.
//  Copyright (c) 2014年 Johnny's. All rights reserved.
//

#import "JJFinishViewController.h"
#import "JJTestDetailViewController.h"
#import "ReviewController.h"

@interface JJFinishViewController ()
{
    NSString *myScore;
    NSArray *myCorrectArray;
    NSArray *myPersonArray;
    NSArray *myQuestionArray;
    NSArray *myAnswerArray;
    int myMins;
    int mySeconds;
}
@end

@implementation JJFinishViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithScore:(NSString *)score correctAnswer:(NSArray *)correctArray personAnswer:(NSArray *)personArray questionArray:(NSArray *)queArray answerArray:(NSArray *)anArray costMins:(int)paramMins costSeconds:(int)paramSeconds
{
    self = [super init];
    if (self) {
        myScore = score;
        myCorrectArray = correctArray;
        myPersonArray = personArray;
        myQuestionArray = queArray;
        myAnswerArray = anArray;
        myMins = paramMins;
        mySeconds = paramSeconds;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(222, 255, 170);
    self.scoreLa.text = myScore;
    self.timeLa.text = [NSString stringWithFormat:@"%02d:%02d", myMins, mySeconds];
    [self.reviewBtn addTarget:self action:@selector(review)
             forControlEvents:UIControlEventTouchUpInside];
}

- (void)review
{
    [self.navigationController pushViewController:[[ReviewController alloc] initWithCorrectAnswer:myCorrectArray personAnswer:myPersonArray questionArray:myQuestionArray answerArray:myAnswerArray] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (IBAction)back:(id)sender
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}
@end
