//
//  CDetailCourseViewController.m
//  移动教育1.0
//
//  Created by yato_kami on 14-7-5.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "CDetailCourseViewController.h"
#import "CDetailHead.h"
#import "CChapterViewController.h"
#import "CDAllSection.h"
#import "UIImageView+AFNetworking.h"
#import "JCRBlurView.h"

#define headHeight 170.0
@interface CDetailCourseViewController ()<cdAllSectionDelegate>

@property (strong, nonatomic) CDAllSection *cdAllSection;//课程数组阶段模型
@property (strong, nonatomic) UIButton *backViewButton;
@property (strong, nonatomic) UIView *dimView;
@property (strong, nonatomic) JCRBlurView *backView;
@property (strong, nonatomic) UITextView *textView;

@end

@implementation CDetailCourseViewController

#pragma mark - getter and setter

- (CDAllSection *)cdAllSection
{
    if (!_cdAllSection) {
        _cdAllSection = [[CDAllSection alloc] init];
        if (_cdAllSection.cdAllSectionArray == nil) {
            [_cdAllSection loadDataWithCDid:self.courseDirection.CDid];
        }
    }
    return _cdAllSection;
}

- (UIView *)dimView
{
    if (!_dimView) {
        _dimView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
        _dimView.backgroundColor = [UIColor blackColor];
        _dimView.alpha = 0.4f;
    }
    return _dimView;
}

- (UIButton *)backViewButton
{
    if (!_backViewButton) {
        _backViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backViewButton setFrame:[UIApplication sharedApplication].keyWindow.frame];
        [_backViewButton addTarget:self action:@selector(hidMoreView) forControlEvents:UIControlEventTouchUpInside];
        
        _backView = [[JCRBlurView alloc] initWithFrame:CGRectMake(0, 175, SCREEN_WIDTH, 0.0)];
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 10, SCREEN_WIDTH-10, 160.0-34-10)];
        _textView.editable = NO;
        [_backViewButton addSubview:_backView];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(hidMoreView) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 160-34, SCREEN_WIDTH, 34);
        [_backView addSubview:button];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.textColor = [UIColor blackColor];
        _textView.text = self.courseDirection.CDdetail;
        [_backView addSubview:_textView];
    }
    return _backViewButton;
}
#pragma mark - 类构造方法
+ (instancetype)detailCourseVCwithCourseDirection:(CourseDirection *)courseDirection
{
    CDetailCourseViewController *CDCourseVC = [[CDetailCourseViewController alloc] initWithStyle:UITableViewStyleGrouped];
    CDCourseVC.courseDirection = courseDirection;
    CDCourseVC.title = courseDirection.CDhead; //设置标题
    return CDCourseVC;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        //self.title = self.courseDirection.CDhead;
    }
    return self;
}

#pragma mark - 控制旋转
-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cdAllSection.delegate = self;
    self.tableView.rowHeight = 60.0; //设置cell高度
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cdAllSection.cdAllSectionArray.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section != 0 ) {

        CDSection *cdSection = self.cdAllSection.cdAllSectionArray[section-1];//.csContent;
    
        return cdSection.csContent.count;
    } else
        return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIentifier = @"CScell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
    }
    
    CDSection *cdSection = self.cdAllSection.cdAllSectionArray[indexPath.section-1];
    NSDictionary *csDic = cdSection.csContent[indexPath.row];
    
    cell.textLabel.text = csDic[@"courseName"];
    [cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseURL, csDic[@"courseImageUrl"]]] placeholderImage:[UIImage imageNamed:@"directionDefault"]];


    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section>0) {
        CDSection *cdSection = self.cdAllSection.cdAllSectionArray[section-1];
        NSString *text = [NSString stringWithFormat:@"学习阶段%d:%@",section,cdSection.csName];
        return text;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        CDetailHead *headView = [[CDetailHead alloc] init];
        headView.imageView.layer.borderWidth = 1.0f;
        headView.imageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        [self setFirstHeadUI:headView];
        return headView;
    } 
    return nil;
    
    
}

 
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return headHeight;
    } else
        return 10;
}



#pragma mark - 设置首个head的UI
- (void)setFirstHeadUI:(CDetailHead *)headView
{
    [headView.imageView setImageWithURL:[NSURL URLWithString:self.courseDirection.CDimageUrlString] placeholderImage:[UIImage imageNamed:@"directionDefault"]];
    //headView.detailTextView.text = self.courseDirection.CDdetail;
    [headView.showMoreButton addTarget:self action:@selector(showMore:) forControlEvents:UIControlEventTouchUpInside];
    headView.detailTextLabel.text = self.courseDirection.CDdetail;
    headView.courseNumLabel.text = [NSString stringWithFormat:@"%d",self.courseDirection.CDcourseNum];
    headView.videoNumLabel.text = [NSString stringWithFormat:@"%d",self.courseDirection.CDvideoNum];
    headView.practiceNumLabel.text = [NSString stringWithFormat:@"%d",self.courseDirection.CDpracticeNum];
}

#pragma mark - 选择 进行页面跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section) {
        CDSection *cdSection = self.cdAllSection.cdAllSectionArray[indexPath.section-1];
        
        NSDictionary *content = cdSection.csContent[indexPath.row];
        CChapterViewController *headVC = [CChapterViewController chapterVCwithCourseID:[content[@"courseID"] integerValue]];
        //CChapterViewController *headVC = [CChapterViewController chapterVCwithCourseID:[content[@"courseID"]integerValue] andVideoHistoryDic:[self videoInfoDic]];
        headVC.title = content[@"courseName"];
        [self.navigationController pushViewController:headVC animated:YES];
        
    }
}


- (void)showMore:(UIButton *)sender
{
    [[UIApplication sharedApplication].keyWindow addSubview:self.dimView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.backViewButton];
    [UIView animateWithDuration:0.6f animations:^{
        self.backView.frame = CGRectMake(0, 175.0, SCREEN_WIDTH, 160.0);
        
    } completion:^(BOOL finished) {
    }];
    //[[UIApplication sharedApplication].keyWindow addSubview:backView];
}

- (void)hidMoreView
{
    
    [self.backViewButton removeFromSuperview];
    [self.dimView removeFromSuperview];
    self.backView.frame = CGRectMake(0, 175.0, SCREEN_WIDTH, 0);
}

#pragma mark - delegate
- (void)upDateUI
{
    [self.tableView reloadData];
}
@end
