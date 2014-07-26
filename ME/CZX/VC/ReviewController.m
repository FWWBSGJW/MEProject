//
//  ReviewController.m
//  ME
//
//  Created by Johnny's on 14-7-25.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "ReviewController.h"
#import "SubjectController.h"

@interface ReviewController ()
{
    NSArray *myCorrectArray;
    NSArray *myPersonArray;
    NSArray *myQuestionArray;
    NSArray *myAnswerArray;
    NSMutableArray *myWrongArray;
}
@end

@implementation ReviewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCorrectAnswer:(NSArray *)correctArray personAnswer:(NSArray *)personArray questionArray:(NSArray *)queArray answerArray:(NSArray *)anArray
{
    self = [super init];
    if (self) {
        myCorrectArray = correctArray;
        myPersonArray = personArray;
        myQuestionArray = queArray;
        myAnswerArray = anArray;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    UILabel *titleLa = [[UILabel alloc] initWithFrame:CGRectMake(120, 20, 80, 44)];
    titleLa.text = @"查看题目";
    titleLa.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLa];
    titleView.userInteractionEnabled = YES;
    UIButton *dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 50, 44)];
    [dismissBtn setTitle:@"返回" forState:UIControlStateNormal];
    dismissBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [dismissBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dismissBtn addTarget:self action:@selector(back)
         forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:dismissBtn];
    [self.view addSubview:titleView];
    
    myWrongArray = [[NSMutableArray alloc] init];
    [self searchWrongSubject];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, 320, 416)];
    int line = 0;
    int j = 0;
    for (int i=0; i<myQuestionArray.count; i++)
    {
        int row = i%4;
        line = i/4;
        UIButton *subjectBtn = [[UIButton alloc]
                                initWithFrame:CGRectMake(80*row, 80*line, 80, 80)];
        subjectBtn.tag = 100+i;
        [subjectBtn setTitle:[NSString stringWithFormat:@"%d", i+1]
                    forState:UIControlStateNormal];
        [subjectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [subjectBtn addTarget:self action:@selector(selectSubject:)
             forControlEvents:UIControlEventTouchUpInside];
        [subjectBtn.layer setBorderWidth:0.3];
        [subjectBtn.layer setBorderColor:[UIColor blackColor].CGColor];
        if (![[myPersonArray objectAtIndex:i] isEqualToString:@"4"]) {
            subjectBtn.backgroundColor = RGBCOLOR(222, 255, 170);
        }
        if (j<myWrongArray.count && [[myWrongArray objectAtIndex:j] isEqualToString:[NSString stringWithFormat:@"%d", i]])
        {
            subjectBtn.backgroundColor = RGBCOLOR(230, 100, 120);
            j++;
        }
        
        [scrollView addSubview:subjectBtn];
    }
    scrollView.contentSize = CGSizeMake(320, 80*(line+1));
    [self.view addSubview:scrollView];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchWrongSubject
{
    for (int i=0; i<myQuestionArray.count; i++)
    {
        if (![[myPersonArray objectAtIndex:i] isEqualToString:@"4"] && ![[myPersonArray objectAtIndex:i] isEqualToString:[myCorrectArray objectAtIndex:i]])
        {
            [myWrongArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
}

- (void)selectSubject:(UIButton *)btn
{
    [self.navigationController pushViewController:[[SubjectController alloc] initWithCorrectAnswer:myCorrectArray personAnswer:myPersonArray questionArray:myQuestionArray answerArray:myAnswerArray page:btn.tag-100] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
