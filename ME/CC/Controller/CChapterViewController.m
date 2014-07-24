//
//  CChapterViewController.m
//  移动教育1.0
//
//  Created by yato_kami on 14-7-9.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "CChapterHead.h"
#import "CChapterViewController.h"
#import "CCommentCell.h"
#import "CourseChapter.h"
#import "SendComNoteView.h"

#import "CVideoPlayerController.h"
#define headHeight 160
enum Segement_Type
{
    SegementDiscription, //课程介绍
    SegementChapter, //课程章节
    SegementComment, //课程评论
    SegementNote //课程笔记
};

enum Button_Tag
{
    ButtonTagPrivate = 400, //收藏按钮TAG
    ButtonTagDownLoad, //下载
    ButtonTagComment,//评论
    ButtonTagShare,//分享
    ButtonTagNote//笔记
};

@interface CChapterViewController ()
{
    CChapterHead *_headView; //课程head
    //UITextView *_textView; //课程介绍textview
}

@property (strong, nonatomic) CourseChapter *courseChapter;//课程模型

@property (assign, nonatomic) NSInteger courseID;//课程id

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSDictionary *courseInfoDic;//课程信息字典
@property (strong, nonatomic) NSArray *courseChapterArray;//课程章节数组
@property (strong, nonatomic) NSArray *courseCommentArray;//课程评论数组
@property (strong, nonatomic) NSArray *courseNote; //课程笔记数组

@property (strong, nonatomic) NSMutableArray *chapterOpenArray;//章节是否展开数组
@property (weak, nonatomic) UISegmentedControl *segmentControl;

@property (strong, nonatomic) SendComNoteView *sendComNoteView; //发送评论，笔记试图
@property (weak, nonatomic) UIView *tabBarView;
@end

@implementation CChapterViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _courseChapter = [[CourseChapter alloc] init];
    
   
    self.title = self.courseInfoDic[@"cName"];

    UIView *tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-30, SCREEN_WIDTH, 30.0f)];
    tabBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tabBarView];
    //设置底部功能按钮
    NSArray *array = [NSArray arrayWithObjects:@"收藏",@"下载",@"评论",@"分享",@"笔记", nil];
    for (NSInteger i =0; i<5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setBackgroundColor:[UIColor whiteColor]];
        
        [button setBackgroundImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
        
        CGFloat blackWidth = (SCREEN_WIDTH - 30*5.0) / (array.count+1.0);
        
        button.frame = CGRectMake(blackWidth+(blackWidth+30) * i, 0, 30, 30);
        button.tag = 400+i;
        [button addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
        [tabBarView addSubview:button];
    }
    
    self.tabBarView = tabBarView;
    //[self.segmentControl addTarget:self action:@selector(segementChange) forControlEvents:UIControlEventValueChanged];
    
    //注册cell
    
    UINib *nib = [UINib nibWithNibName:@"CCommentCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"commentCell"];
    
    
}




#pragma mark - 类实例方法

+ (instancetype)chapterVCwithCourseID:(NSInteger)courseID
{
    CChapterViewController *VC = [[CChapterViewController alloc] init];
    VC.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-30-64) style:UITableViewStylePlain];
    
    VC.courseID = courseID;
    
    [VC.view addSubview:VC.tableView];
    return VC;
    
}

#pragma mark - getter and setter

- (NSMutableArray *)chapterOpenArray
{
    if (!_chapterOpenArray) {
        _chapterOpenArray = [NSMutableArray arrayWithCapacity:self.courseChapterArray.count];
        for (NSInteger i = 0; i < self.courseChapterArray.count; i++) {
            [_chapterOpenArray addObject:@0];
        }
    }
    return _chapterOpenArray;
}

- (SendComNoteView *)sendComNoteView
{
    if (!_sendComNoteView) {
        
        _sendComNoteView = [[SendComNoteView alloc] init];
        _sendComNoteView.frame = CGRectMake((SCREEN_WIDTH-_sendComNoteView.frame.size.width)/2.0, -_sendComNoteView.frame.size.height, _sendComNoteView.frame.size.width, _sendComNoteView.frame.size.height);
        _sendComNoteView.alpha = 0.0;
        [[UIApplication sharedApplication].keyWindow addSubview:_sendComNoteView];
    }
    return _sendComNoteView;
}

//- (CommentView *)sendCommentView
//{
//    if (!_sendCommentView) {
//        _sendCommentView = [[CommentView alloc] init];
//        //_sendCommentView.textView.delegate = self;
////        _sendCommentView.frame = CGRectMake((SCREEN_WIDTH-_sendCommentView.frame.size.width)/2.0, -_sendCommentView.frame.size.height, _sendCommentView.frame.size.width, _sendCommentView.frame.size.height);
////        _sendCommentView.alpha = 0;
////        //[self.view addSubview:_sendCommentView];
//       //[[UIApplication sharedApplication].keyWindow addSubview:_sendCommentView];
//    
//    }
//    return _sendCommentView;
//}

#warning 以下三方法待实现后台获取数据
- (NSArray *)courseChapterArray
{
    if (!_courseChapterArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"CourseChapterData" ofType:@"plist"];
        _courseChapterArray = [NSArray arrayWithContentsOfFile:path];
    }
    return _courseChapterArray;
}

- (NSArray *)courseCommentArray
{
    if (!_courseCommentArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"CourseCommentData" ofType:@"plist"];
        _courseCommentArray = [NSArray arrayWithContentsOfFile:path];
    }
    return _courseCommentArray;
}

- (NSDictionary *)courseInfoDic
{
    if (!_courseInfoDic) {
        [self.courseChapter loadCourseInfoWithCourseID:self.courseID];
        _courseInfoDic = self.courseChapter.courseInfoDic;
        //NSLog(@"%@",_courseInfoDic);
        
    }
    return _courseInfoDic;
}

- (NSArray *)courseNote
{
    if (!_courseNote) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"CourseNoteData" ofType:@"plist"];
        _courseNote = [NSArray arrayWithContentsOfFile:path];
    }
    return _courseNote;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    switch (self.segmentControl.selectedSegmentIndex) {
        case SegementDiscription:
            return 1;
            break;
        case SegementComment:
            return 1;
            break;
        case SegementNote:
            return 1;
        case SegementChapter:
            return 1 + self.courseChapterArray.count;
        default:
            return 1;
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (self.segmentControl.selectedSegmentIndex) {
        case SegementDiscription:
            return 1;
            break;
        case SegementChapter: {
            if (section == 0) {
                //第一个section课程信息，
                return 0;
            } else{
                //chapterOpenArray =1 展开章节 =0 收拢章节
                return  [self.chapterOpenArray[section-1] integerValue] == 0 ? 0:((NSArray *)[self.courseChapterArray[section-1] objectForKey:@"CCvideo"]).count;
            }
            break;
        }
        case SegementComment:
            return self.courseCommentArray.count;
        case SegementNote:
            return self.courseNote.count;
        default:
            return 0;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        //设置标题的head
        //CChapterHead *headView = [tableView dequeueReusableCellWithIdentifier:@"mainHeadIdentifier"];
        if (!_headView) {
            _headView = [[CChapterHead alloc] init];
            _segmentControl = _headView.segmentControl;
            [self.segmentControl addTarget:self action:@selector(selectSegemnt) forControlEvents:UIControlEventValueChanged];
            
            //NSLog(@"%@",self.courseInfoDic);
            
            //UIImage *image = [UIImage imageNamed:self.courseInfoDic[@"courseImageUrl"]];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseURL,self.courseInfoDic[@"cPic"]]];
            [_headView.CCImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"directionDefault"]];
            _headView.CCtypeLabel.text = self.courseInfoDic[@"type"];
            _headView.CCpriceLaebl.text = [NSString stringWithFormat:@"%d元",[self.courseInfoDic[@"cPrice"] integerValue]];
            _headView.CCteacherLabel.text = self.courseInfoDic[@"cTeacher"];
            _headView.CCtimeLabel.text = [NSString stringWithFormat:@"%d分钟",[self.courseInfoDic[@"cTime"] integerValue]];
        }
        return _headView;
    } else {
        //设置章节的head-章
        UIView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"chapterHeadIdentifier"];
        if (!headView) {
            
            headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
            //headView.backgroundColor = [UIColor colorWithRed:0.2 green:0.8 blue:0.2 alpha:0.8];
            headView.backgroundColor = [UIColor whiteColor];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
            imageView.image = [UIImage imageNamed:@"cellTag"];
            //设置三角形图片的旋转角度
            
            [self.chapterOpenArray[section-1] integerValue] ? [imageView setTransform:CGAffineTransformMakeRotation(M_PI_2)] : [imageView setTransform:CGAffineTransformMakeRotation(0)];
            
            [headView addSubview:imageView];
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 2, SCREEN_WIDTH-40, 30)];
            [textLabel setBackgroundColor:[UIColor clearColor]];
            textLabel.tag = 205;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            //用button的tag来记录对应的section
            button.tag = section;
            //[button setBackgroundColor:[UIColor greenColor]];
            [button addTarget:self action:@selector(clickHeader:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(0, 0, SCREEN_WIDTH, 35);
            [headView addSubview:textLabel];
            [headView addSubview:button];
        }
        UILabel *label = (UILabel *)[headView viewWithTag:205];
        NSDictionary *chapterDic = self.courseChapterArray[section - 1];
        label.text = [NSString stringWithFormat:@"第%d章 %@",[chapterDic[@"CCnum"] integerValue],chapterDic[@"CCname"]];
        return headView;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return headHeight;
    } else
        return 35;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.segmentControl.selectedSegmentIndex) {
        case SegementDiscription:
        {
            static NSString *disCellIdentifier = @"discriptionCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:disCellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:disCellIdentifier];
                cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - headHeight);
                UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH-10, SCREEN_HEIGHT - 44 - headHeight)];
                [textView setEditable:NO];
                [textView setFont:[UIFont systemFontOfSize:16.0f]];
                [cell.contentView addSubview:textView];
                //_textView = textView;
                
                [textView setText:self.courseInfoDic[@"cDetail"]];
            }
            return cell;
        }
            break;
        case SegementComment:
        {
            static NSString *commentCellIdentifier = @"commentCell";
            CCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellIdentifier forIndexPath:indexPath];
            if (cell==nil) {
                cell = [[CCommentCell alloc] init];
            }
            NSDictionary *dic = self.courseCommentArray[indexPath.row];
            cell.headImageView.image = [UIImage imageNamed:dic[@"userImageUrl"]];
            cell.dateLable.text = dic[@"userConmentDate"];
            cell.commentLabel.text = dic[@"userConment"];
            cell.userNameLable.text = dic[@"userName"];
            
            return cell;
        }
            break;
        case SegementChapter:
        {
            static NSString *chapterCellIdentifier = @"chapterCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chapterCellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:chapterCellIdentifier];
                UIImageView *timeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-65, 12, 20, 20)];
                [timeImageView setImage:[UIImage imageNamed:@"CtimeNum"]];
                [cell.contentView addSubview:timeImageView];
                UILabel *timeLable = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-45, 6, 45, 30)];
                [timeLable setFont:[UIFont systemFontOfSize:12.0]];
                [cell.contentView addSubview:timeLable];
                timeLable.tag = 120; //
            }
            NSArray *chapter = self.courseChapterArray[indexPath.section -1][@"CCvideo"];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",chapter[indexPath.row][@"CVnum"],chapter[indexPath.row][@"CVname"]];
            UILabel *label = (UILabel *)[cell viewWithTag:120];
            label.text = [NSString stringWithFormat:@"%@分钟",chapter[indexPath.row][@"CVtime"]];
            return cell;
        }
            break;
        case SegementNote:
        {
            static NSString *noteCellIdentifier = @"noteCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:noteCellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:noteCellIdentifier];
            }
            NSDictionary *dic = self.courseNote[indexPath.row];
            cell.textLabel.text = dic[@"CNcomment"];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@:%@  %@",dic[@"CVnum"],dic[@"CVname"],dic[@"CNdate"]];
            return cell;

        }
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.segmentControl.selectedSegmentIndex) {
        case SegementDiscription:
            return SCREEN_HEIGHT - 44 - headHeight;
            break;
        case SegementChapter:
            return 44;
            break;
        case SegementNote:
            return 44;
        case SegementComment:
            return 70;
        default:
            return 50;
            break;
    }
}

#pragma mark selecCell进入视频信息页面

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section > 0) {
        switch (self.segmentControl.selectedSegmentIndex) {
            case SegementChapter:
            {
                //获取对应视频id
                NSDictionary *dic = (self.courseChapterArray[indexPath.section-1][@"CCvideo"])[indexPath.row];
                NSInteger CVid = [dic[@"CVid"] integerValue];
                //NSLog(@"%d",CVid);
            
                CVideoPlayerController *player = [[CVideoPlayerController alloc] init];
                [player playVideoWithVideoID:CVid andVideoTitle:[NSString stringWithFormat:@"%@ %@",dic[@"CVnum"],dic[@"CVname"]]];
                [self presentMoviePlayerViewControllerAnimated:player];
                
                
            }
                break;
            case SegementNote:
            {
                
            }
                break;
            default:
                break;
        }
    }
}


#pragma mark - Action 方法

#pragma mark  segement Changed 方法
- (void)selectSegemnt
{
    //NSLog(@"%d",self.segmentControl.selectedSegmentIndex);
    switch (self.segmentControl.selectedSegmentIndex) {
        case SegementDiscription:
            [self.tableView reloadData];
            break;
            
        default:
            [self.tableView reloadData];;
    }
}

#pragma mark 点击header展开/收缩章节方法
- (void)clickHeader : (UIButton *)button
{
    NSInteger section = button.tag;
    //NSLog(@"%d-touched",section);
    NSInteger isOpen = [self.chapterOpenArray[section-1] integerValue];
    [self.chapterOpenArray replaceObjectAtIndex:section-1 withObject:(isOpen ? @0 : @1)];
    NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:section];
    [self.tableView reloadSections:indexset withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark 功能button方法
- (void)touchButton:(UIButton *)button
{
#warning -  功能待实现
    switch (button.tag) {
        case ButtonTagPrivate:{
            //NSLog(@"private");
        }
            break;
        case ButtonTagDownLoad:{
            
        }
            break;
        case ButtonTagShare:{
            
        }
            break;
        case ButtonTagComment:{
#pragma mark 待判断用户是否登录
        /*
            [UIView animateWithDuration:1.0f animations:^{
                [self.sendCommentView setFrame:CGRectMake((SCREEN_WIDTH-_sendCommentView.frame.size.width)/2.0, 20.0, _sendCommentView.frame.size.width, _sendCommentView.frame.size.height)];
                self.sendCommentView.alpha = 1.0f;
            } completion:^(BOOL finished) {
                NSLog(@"%@",self.sendCommentView) ;
                [self.sendCommentView.textView becomeFirstResponder];
            }];
            
        }
         */
            //[self.view addSubview:self.sendCommentView];
            UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
            view.backgroundColor = [UIColor blackColor];
            view.alpha = 0.4;
            [[UIApplication sharedApplication].keyWindow addSubview:view];
            [UIView animateWithDuration:0.6f animations:^{
                [self.sendComNoteView setFrame:CGRectMake((SCREEN_WIDTH-_sendComNoteView.frame.size.width)/2.0, 20.0, _sendComNoteView.frame.size.width, _sendComNoteView.frame.size.height)];
                self.sendComNoteView.alpha = 1.0f;
            } completion:^(BOOL finished) {
                NSLog(@"%@",self.sendComNoteView) ;
                [self.sendComNoteView.textView becomeFirstResponder];
            }];

        }
            break;
        case ButtonTagNote:{
            
            
        }
        default:
            break;
    }
}
@end