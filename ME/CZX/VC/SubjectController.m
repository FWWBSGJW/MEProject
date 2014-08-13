//
//  SubjectController.m
//  ME
//
//  Created by Johnny's on 14-7-25.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "SubjectController.h"
#import "UILabel+dynamicSizeMe.h"

@interface SubjectController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *myCorrectArray;
    NSArray *myPersonArray;
    NSArray *myQuestionArray;
    NSArray *myAnswerArray;
    NSMutableArray *myWrongArray;
    int page;
    UILabel *textView;
    NSArray *currentAnArray;
    NSArray *optionArray;
    UILabel *pageLabel;
    NSMutableParagraphStyle *textViewPS;
    NSDictionary *textViewAttribs;
}
@end
#define KColor RGBCOLOR(222, 255, 170)
//#define KColor RGBCOLOR(50, 126, 254)

@implementation SubjectController
@synthesize myTableView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCorrectAnswer:(NSArray *)correctArray personAnswer:(NSArray *)personArray questionArray:(NSArray *)queArray answerArray:(NSArray *)anArray page:(int)parmaPage
{
    self = [super init];
    if (self) {
        myCorrectArray = correctArray;
        myPersonArray = personArray;
        myQuestionArray = queArray;
        myAnswerArray = anArray;
        page = parmaPage;
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
    self.view.backgroundColor = [UIColor whiteColor];
    optionArray = @[@"A. ", @"B. ", @"C. ", @"D. "];
    
    textView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    textView.text = [NSString stringWithFormat:@"%d.%@", page+1, [myQuestionArray objectAtIndex:page]];
    textView.font = [UIFont systemFontOfSize:18.0];
    [textView resizeToFit];
    
    currentAnArray = [myAnswerArray objectAtIndex:page];
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 440)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.tableFooterView = [[UIView alloc] init];
    myTableView.tableHeaderView = textView;
    [self.view addSubview:myTableView];
    
    [self createTitleView];
    [self createPagingBtn];
    
    textViewPS = [[NSMutableParagraphStyle alloc] init];
    [textViewPS setLineSpacing:5.0];
    textViewAttribs = [NSDictionary new];
    textViewAttribs = @{NSFontAttributeName: [UIFont fontWithName:@"Helvetica Neue" size:16],NSParagraphStyleAttributeName:textViewPS};
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableAttributedString *str =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", [optionArray objectAtIndex:indexPath.row], [currentAnArray objectAtIndex:[indexPath row]]]                                                              attributes:textViewAttribs];
    
    return [self returnHeight:str];
}

- (CGFloat)returnHeight:(NSMutableAttributedString *)paramStr
{
    CGFloat height = ([paramStr size].width/200+1)*[paramStr size].height;
    if (height<43) {
        return 43;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", [optionArray objectAtIndex:indexPath.row], [currentAnArray objectAtIndex:[indexPath row]]]                                                              attributes:textViewAttribs];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, [self returnHeight:aStr])];
    label.numberOfLines = 0;
    label.attributedText = aStr;
    [cell addSubview:label];

    if (![[myPersonArray objectAtIndex:page] isEqualToString:@"4"] && myPersonArray.count>0)
    {
        if (indexPath.row == [[myPersonArray objectAtIndex:page] intValue]) {
            cell.backgroundColor = RGBCOLOR(230, 100, 120);
        }
    }
    if (indexPath.row == [[myCorrectArray objectAtIndex:page] intValue]) {
        cell.backgroundColor = KColor;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)createTitleView
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    UILabel *titleLa = [[UILabel alloc] initWithFrame:CGRectMake(120, 20, 80, 44)];
//    titleView.backgroundColor = KColor;
    titleView.backgroundColor = [UIColor whiteColor];
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
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(240, 20, 80, 44)];
    [rightBtn setTitle:@"截图保存" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(screenShot) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:rightBtn];
    [titleView addSubview:dismissBtn];
    [self.view addSubview:titleView];
}

- (void)createPagingBtn
{
    self.upBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 440, 120, 40)];
    self.downBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 440, 120, 40)];
    [self.upBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.downBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [self.upBtn setImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];
    //    [self.downBtn setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    //    [self.upBtn setImage:[UIImage imageNamed:@"upUp"] forState:UIControlStateHighlighted];
    //    [self.downBtn setImage:[UIImage imageNamed:@"downUp"] forState:UIControlStateHighlighted];
    [self.upBtn setTitle:@"上一题" forState:UIControlStateNormal];
    [self.downBtn setTitle:@"下一题" forState:UIControlStateNormal];
    self.upBtn.backgroundColor = RGBCOLOR(50, 126, 254);
    self.downBtn.backgroundColor = RGBCOLOR(50, 126, 254);
    [self.upBtn addTarget:self action:@selector(upPage) forControlEvents:UIControlEventTouchUpInside];
    [self.downBtn addTarget:self action:@selector(downPage) forControlEvents:UIControlEventTouchUpInside];
    pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 440, 80, 40)];
    pageLabel.backgroundColor = RGBCOLOR(50, 126, 254);
    pageLabel.textAlignment = NSTextAlignmentCenter;
    pageLabel.text = [NSString stringWithFormat:@"%d/%d", page+1, myQuestionArray.count];
    [self.view addSubview:pageLabel];
    [self.view addSubview:self.upBtn];
    [self.view addSubview:self.downBtn];
}

- (void)upPage
{
    if (page != 0)
    {
        page--;
        [self tableViewReload];
    }
}

- (void)downPage
{
    if (page<myQuestionArray.count-1)
    {
        page++;
        [self tableViewReload];
    }
}

- (void)tableViewReload
{
    textView.text = [NSString stringWithFormat:@"%d.%@", page+1, [myQuestionArray objectAtIndex:page]];
    [textView resizeToFit];
    myTableView.tableHeaderView = textView;
    pageLabel.text = [NSString stringWithFormat:@"%d/%d", page+1, myQuestionArray.count];
    currentAnArray = [myAnswerArray objectAtIndex:page];
    [myTableView reloadData];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)screenShot
{
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
//    NSLog(@"image:%@",image);
//    UIImageView *imaView = [[UIImageView alloc] initWithImage:image];
//    imaView.frame = CGRectMake(0, 700, 500, 500);
//    [self.view addSubview:imaView];
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:nil
                          message:@"截图已保存"
                          delegate:self
                          cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
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
