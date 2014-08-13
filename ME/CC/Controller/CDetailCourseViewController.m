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

@interface CDetailCourseViewController ()

@property (strong, nonatomic) CDAllSection *cdAllSection;//课程数组阶段模型

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
        [self setFirstHeadUI:headView];
        return headView;
    } 
    return nil;
    
    
}

 
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 220;
    } else
        return 10;
}



#pragma mark - 设置首个head的UI
- (void)setFirstHeadUI:(CDetailHead *)headView
{
    [headView.imageView setImageWithURL:[NSURL URLWithString:self.courseDirection.CDimageUrlString] placeholderImage:[UIImage imageNamed:@"directionDefault"]];
    headView.detailTextView.text = self.courseDirection.CDdetail;
    headView.courseNumLabel.text = [NSString stringWithFormat:@"%d",self.courseDirection.CDcourseNum];
    headView.videoNumLabel.text = [NSString stringWithFormat:@"%d",self.courseDirection.CDvideoNum];
    headView.practiceNumLabel.text = [NSString stringWithFormat:@"%d",self.courseDirection.CDpracticeNum];
}
/*
#warning 测试
- (NSDictionary *)videoInfoDic
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TestList.plist" ofType:nil];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    return dic;
}
*/
#pragma mark - 选择 进行页面跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section) {
        CDSection *cdSection = self.cdAllSection.cdAllSectionArray[indexPath.section-1];
        
        NSDictionary *content = cdSection.csContent[indexPath.row];
        CChapterViewController *headVC = [CChapterViewController chapterVCwithCourseID:[content[@"courseID"] integerValue]];
        //CChapterViewController *headVC = [CChapterViewController chapterVCwithCourseID:[content[@"courseID"]integerValue] andVideoHistoryDic:[self videoInfoDic]];
        [self.navigationController pushViewController:headVC animated:YES];
        
    }
}



@end
