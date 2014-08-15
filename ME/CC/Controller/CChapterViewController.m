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
#import "SVPullToRefresh.h"
#import "User.h"
#import "CVideoPlayerController.h"
#import "CDownloadViewController.h"
#import "CNoteCell.h"
#import <ShareSDK/ShareSDK.h>
#import "CAlertLabel.h"
#import "CMoreActionView.h"
#import "JJTestDetailViewController.h"
#import "CDownloadModel.h"
#import "UserCenterTableViewController.h"
#import "RecommendViewController.h"
#import "GetAndPayModel.h"
#import "UIImageView+AFNetworking.h"
#define headHeight 160
enum ActionSheet_Type
{
    ActionSheetLogin = 550,
    ActionSheetBuy
};

enum Segement_Type
{
    SegementDiscription, //课程介绍
    SegementChapter, //课程章节
    SegementComment, //课程评论
    SegementNote //课程笔记
};

enum TextView_Type
{
    TextViewComment = 500,//评论textview
    TextViewNote // 笔记textView
};

enum Button_Tag
{
    ButtonTagPrivate = 400, //收藏按钮TAG
    ButtonTagDownLoad, //下载
    ButtonTagBuy,   //购买
    ButtonTagComment,//评论
    //ButtonTagShare,//分享
    ButtonTagNote//笔记
};

enum DownloadButton_Tag
{
    DownloadCancel = 450, //取消下载
    DownloadConfirm //确认下载
};

enum MoreActionButton_Tag
{
    MoreButtonTagTest = 550,
    MoreButtonTagPeople,
    MoreButtonTagShare
};

@interface CChapterViewController () <CourseChapterDelegate>
{
    CChapterHead *_headView; //课程head
    //UITextView *_textView; //课程介绍textview
}

@property (strong, nonatomic) CourseChapter *courseChapter;//课程模型

@property (assign, nonatomic) BOOL isNeedHistory;//区别正常进入还是历史记录进入
@property (strong, nonatomic) NSDictionary *videoHDic;//视频观看记录字典

@property (assign, nonatomic) NSInteger courseID;//课程id

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSDictionary *courseInfoDic;//课程信息字典
@property (strong, nonatomic) NSMutableArray *courseChapterArray;//课程章节数组
@property (strong, nonatomic) NSArray *courseCommentArray;//课程评论数组
@property (strong, nonatomic) NSMutableArray *courseNoteArray; //课程笔记数组

@property (strong, nonatomic) NSMutableArray *chapterOpenArray;//章节是否展开数组
@property (strong, nonatomic) NSMutableArray *noteOpenArray; //笔记是否展开数组
@property (weak, nonatomic) UISegmentedControl *segmentControl;

@property (strong, nonatomic) SendComNoteView *sendComNoteView; //发送评论，笔记试图
@property (strong, nonatomic) UIView *dimView; //发送评论时背影
@property (weak, nonatomic) UIToolbar *toobar;
@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (strong, nonatomic) UIView *downLoadBarView;
@property (strong, nonatomic) CMoreActionView *moreActionView;

@property (strong, nonatomic) CDownloadModel *downloadModel;
@property (strong, nonatomic) GetAndPayModel *getAndPayModel;
@end

@implementation CChapterViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    
    _courseChapter = [[CourseChapter alloc] init];
    
    //下拉
    __weak CChapterViewController *weakSelf = self;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf refreshView];
    }];
    
    //上拉更多
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    }];
    self.tableView.showsInfiniteScrolling = NO;
    [self setExtraCellLineHidden:self.tableView]; //隐藏多需的cell线
    
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(moreAction)];
    
    [self.navigationItem setRightBarButtonItem:moreItem animated:YES];
    //设置底部功能按钮
    
    UIToolbar *toorBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-33, SCREEN_WIDTH, 33.0f)];
    
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:12];
    NSArray *array = [NSArray arrayWithObjects:@"cStar",@"cDownload",@"Cbuy",@"cMessage",@"cNote",nil];

    for (NSInteger i =0; i<array.count; i++) {
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:array[i]] style:UIBarButtonItemStyleBordered target:self action:@selector(touchButton:)];
        item.tag = 400+i;
        UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [items addObject:item];
        [items addObject:flexItem];
    }
    [items removeLastObject];
    toorBar.items = items;
    [self.view addSubview:toorBar];
    if ([User sharedUser].info.isLogin) {
        
        for (NSDictionary *dic in [[User sharedUser].info.ccourses linkContent]) {
            if ( [dic[@"cid"] integerValue] == self.courseID) {
                UIBarButtonItem *item = items[0];
                item.image = [UIImage imageNamed:@"cStarFull"];
                break;
            }
        }
    }
    
    self.toobar = toorBar;
    
    //注册cell
    
    UINib *nib = [UINib nibWithNibName:@"CCommentCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"commentCell"];
    
    UINib *nib2 = [UINib nibWithNibName:@"CNoteCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:@"noteCell"];
    self.title = @"";

    self.courseChapter.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (!self.tabBarController.tabBar.hidden) {
        self.tabBarController.tabBar.hidden = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    if (self.isNeedHistory) {
        self.segmentControl.selectedSegmentIndex = SegementChapter;
        [self.tableView reloadData];
        NSDictionary *dic = self.videoHDic[@"lastVideo"];
        NSArray *array = [dic[@"vSectionsNo"] componentsSeparatedByString:@"."];
        //NSLog(@"%@",array);
        NSInteger sectionNum = [array[0] integerValue];
        NSInteger cellNum = [array[1] integerValue]-1;
        [self openChapterWithSection:sectionNum];
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:cellNum inSection:sectionNum] animated:YES  scrollPosition:UITableViewScrollPositionMiddle];
        CAlertLabel *alertLabel = [CAlertLabel alertLabelInHeadForText:@"已为你定位到上次观看的视频" andIsHaveNavigationBar:YES];
        [alertLabel showAlertLabelForHead];
        //[[UIApplication sharedApplication].keyWindow addSubview:alertLabel];
    }
}

#pragma mark - 页面数据刷新
- (void)refreshView
{
    __weak CChapterViewController *weakSelf = self;
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [weakSelf.tableView.pullToRefreshView stopAnimating];
        [self.tableView reloadData];
    });
    
    
}

#pragma mark - 上拉更多
- (void)insertRowAtBottom
{
    __weak CChapterViewController *weakSelf = self;
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        if (weakSelf.courseChapter.nextCommentPageUrl != nil && self.segmentControl.selectedSegmentIndex == SegementComment) {
            [weakSelf.tableView beginUpdates];
            if (self.segmentControl.selectedSegmentIndex == SegementComment) {
                NSInteger dataCount = self.courseCommentArray.count;
                NSLog(@"%@",self.courseCommentArray);
                [self.courseChapter loadNextPageCourseComment];
                NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:self.courseCommentArray.count-dataCount];
                for(NSInteger i = dataCount;i < self.courseCommentArray.count;i++){
                    NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
                    [indexPaths addObject:path];
                }
                [weakSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
            [weakSelf.tableView endUpdates];
            
        }
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
        
    });
}


#pragma mark - 类实例方法

+ (instancetype)chapterVCwithCourseID:(NSInteger)courseID
{
    CChapterViewController *VC = [[CChapterViewController alloc] init];
    VC.isNeedHistory = NO;
    VC.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-33-64) style:UITableViewStylePlain];
    
    VC.courseID = courseID;
    
    [VC.view addSubview:VC.tableView];
    return VC;
}

+ (instancetype)chapterVCwithCourseID:(NSInteger)courseID andVideoHistoryDic:(NSDictionary *)videoHDic
{
    CChapterViewController *VC = [CChapterViewController chapterVCwithCourseID:courseID];
    if(videoHDic.count>0){
        VC.isNeedHistory = YES;
        VC.videoHDic = videoHDic;
    }
    return VC;
}

#pragma mark - getter and setter

- (GetAndPayModel *)getAndPayModel
{
    if (!_getAndPayModel) {
        _getAndPayModel = [[GetAndPayModel alloc] init];
    }
    return _getAndPayModel;
}

- (CMoreActionView *)moreActionView
{
    if (!_moreActionView) {
        _moreActionView = [[CMoreActionView alloc] init];
        [self.view addSubview:_moreActionView];
        _moreActionView.testButton.tag = MoreButtonTagTest;
        _moreActionView.peopleButton.tag = MoreButtonTagPeople;
        _moreActionView.shareButton.tag = MoreButtonTagShare;
        [_moreActionView.testButton addTarget:self action:@selector(moreActionTouched:) forControlEvents:UIControlEventTouchUpInside];
        [_moreActionView.peopleButton addTarget:self action:@selector(moreActionTouched:) forControlEvents:UIControlEventTouchUpInside];
        [_moreActionView.shareButton addTarget:self action:@selector(moreActionTouched:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreActionView;
}


- (UIActionSheet *)actionSheet
{
    if (!_actionSheet) {
        _actionSheet = [[UIActionSheet alloc] initWithTitle:@"登陆才能使用此功能哦~" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"登陆" otherButtonTitles:nil, nil];
        _actionSheet.tag = ActionSheetLogin;
    }
    return _actionSheet;
}

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

- (NSMutableArray *)noteOpenArray
{
    if (!_noteOpenArray) {
        _noteOpenArray = [NSMutableArray arrayWithCapacity:self.courseNoteArray.count];
        for (NSInteger i = 0; i<self.courseNoteArray.count; i++) {
            [_noteOpenArray addObject:@0];
        }
    }
  
    return _noteOpenArray;
}

- (SendComNoteView *)sendComNoteView
{
    if (!_sendComNoteView) {
        
        _sendComNoteView = [[SendComNoteView alloc] init];
        _sendComNoteView.frame = CGRectMake((SCREEN_WIDTH-_sendComNoteView.frame.size.width)/2.0, -_sendComNoteView.frame.size.height, _sendComNoteView.frame.size.width, _sendComNoteView.frame.size.height);
        _sendComNoteView.alpha = 0.0;
        [_sendComNoteView.sendButton addTarget:self action:@selector(sendComNote) forControlEvents:UIControlEventTouchUpInside];
        [_sendComNoteView.backButton addTarget:self action:@selector(cancelSend) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _sendComNoteView;
}


- (UIView *)dimView
{
    if (!_dimView) {
        _dimView = [[UIView alloc] initWithFrame:self.view.frame];
        _dimView.backgroundColor = [UIColor blackColor];
        _dimView.alpha = 0.4;
    }
    return _dimView;
}

- (UIView *)downLoadBarView
{
    if (_downLoadBarView == nil) {
        _downLoadBarView = [[UIView alloc] initWithFrame:self.toobar.frame];
        _downLoadBarView.layer.borderWidth = 0.25;
        _downLoadBarView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _downLoadBarView.backgroundColor = [UIColor whiteColor];
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        cancelButton.frame = CGRectMake(0, 0, _downLoadBarView.frame.size.width/2.0, _downLoadBarView.frame.size.height);
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.tag = DownloadCancel;
        [cancelButton addTarget:self action:@selector(doDownload:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *downloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        downloadButton.frame = CGRectMake(_downLoadBarView.frame.size.width/2.0, 0, _downLoadBarView.frame.size.width/2.0, _downLoadBarView.frame.size.height);
        [downloadButton setTitle:@"下载" forState:UIControlStateNormal];
        downloadButton.tag = DownloadConfirm;
        [downloadButton addTarget:self action:@selector(doDownload:) forControlEvents:UIControlEventTouchUpInside];
        [downloadButton setBackgroundColor:[UIColor redColor]];
        [_downLoadBarView addSubview:cancelButton];
        [_downLoadBarView addSubview:downloadButton];
    }
    return _downLoadBarView;
}


- (NSMutableArray *)courseChapterArray
{
    if (!_courseChapterArray) {
        [self.courseChapter loadCourseAllChapterWithCourseID:self.courseID];
        _courseChapterArray = self.courseChapter.courseChapterArray;
    }
    return _courseChapterArray;
}

- (NSArray *)courseCommentArray
{
    if (!_courseCommentArray) {
        [self.courseChapter loadCourseCommentWithCourseID:self.courseID andPage:1];
        self.courseCommentArray = self.courseChapter.courseCommentArray;
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

- (NSMutableArray *)courseNoteArray
{
    if (!_courseNoteArray && [User sharedUser].info.isLogin) {
        
        [self.courseChapter loadCourseNoteArrayWithCourseID:self.courseID andUserID:1];
        _courseNoteArray = self.courseChapter.couserNoteArray;
    }
    return _courseNoteArray;
}

- (CDownloadModel *)downloadModel
{
    if (!_downloadModel) {
        _downloadModel = [CDownloadModel sharedCDownloadModel];
    }
    return _downloadModel;
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
            return 1 + self.courseNoteArray.count;
            break;
        case SegementChapter:
            return 1 + self.courseChapterArray.count;
            break;
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
            break;
        case SegementNote: {
            if (section == 0) {
                return 0;
            } else{
                //return  [self.chapterOpenArray[section-1] integerValue] == 0 ? 0:((NSArray *)[self.courseChapterArray[section-1] objectForKey:@"CCvideo"]).count;
                return ([self.noteOpenArray[section-1] integerValue] == 0) ? 0:((NSArray *)[self.courseNoteArray[section-1] objectForKey:@"CCnote"]).count;
            }
            break;
        }
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
        }else{
#warning 待补全积分价格
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseURL,self.courseInfoDic[@"cPic"]]];
            [_headView.CCImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"directionDefault"]];
            _headView.CCtypeLabel.text = self.courseInfoDic[@"type"];
            _headView.CCteacherLabel.text = self.courseInfoDic[@"cTeacher"];
            _headView.CCtimeLabel.text = [NSString stringWithFormat:@"%d分钟",[self.courseInfoDic[@"cTime"] integerValue]];
            _headView.CCpriceLaebl.text = [NSString stringWithFormat:@"%d元",[self.courseInfoDic[@"cPrice"] integerValue]];
            if ([User sharedUser].info.isLogin) {
                NSArray *purchaseArray = [[User sharedUser].info.bcourses linkContent];
                for (NSDictionary *dic in purchaseArray) {
                    if ([dic[@"cid"] integerValue] == self.courseID) {
                        _headView.CCpriceLaebl.text = @"已购买";
                        //_headView.CCpointLabel.text = @"已购买";
                        break;
                    }
                }
            }
        }
        return _headView;
    } else {
        //设置章节的head-章
        UIView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"chapterHeadIdentifier"];
        if (!headView) {
            
            headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
            //headView.backgroundColor = [UIColor colorWithRed:0.2 green:0.8 blue:0.2 alpha:0.8];
            
            headView.layer.borderWidth = 0.25;
            headView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            headView.layer.masksToBounds = YES;
            
            headView.backgroundColor = [UIColor whiteColor];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 12, 20, 20)];
            imageView.image = [UIImage imageNamed:@"cellTag"];
            //设置三角形图片的旋转角度
            
            NSMutableArray *openArray = (self.segmentControl.selectedSegmentIndex == SegementChapter ? self.chapterOpenArray : self.noteOpenArray);
            [openArray[section-1] integerValue] ? [imageView setTransform:CGAffineTransformMakeRotation(M_PI_2)] : [imageView setTransform:CGAffineTransformMakeRotation(0)];
            
            [headView addSubview:imageView];
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 6, SCREEN_WIDTH-40, 30)];
            [textLabel setBackgroundColor:[UIColor clearColor]];
            textLabel.tag = 205;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            //用button的tag来记录对应的section
            button.tag = section;
            //[button setBackgroundColor:[UIColor greenColor]];
            [button addTarget:self action:@selector(clickHeader:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(0, 1, SCREEN_WIDTH, 42);
            [headView addSubview:textLabel];
            [headView addSubview:button];
        }
        if (self.segmentControl.selectedSegmentIndex == SegementChapter) {
            UILabel *label = (UILabel *)[headView viewWithTag:205];
            NSDictionary *chapterDic = self.courseChapterArray[section - 1];
            label.text = [NSString stringWithFormat:@"第%d章 %@",[chapterDic[@"chChapterNo"] integerValue],chapterDic[@"chChapterName"]];
        } else if (self.segmentControl.selectedSegmentIndex == SegementNote){
            UILabel *label = (UILabel *)[headView viewWithTag:205];
            NSDictionary *noteDic = self.courseNoteArray[section - 1];
            label.text = (section == 1 ? @"普通笔记" : [NSString stringWithFormat:@"第%d章 %@",[noteDic[@"chChapterNo"] integerValue],noteDic[@"chChapterName"]]);
        }
        
        return headView;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return headHeight;
    } else
        return 44.0;
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
                cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - headHeight-33);
                UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH-10, SCREEN_HEIGHT - 64-33 - headHeight)];
                [textView setEditable:NO];
                textView.tag = 601;
                [textView setFont:[UIFont systemFontOfSize:13.0f]];
                [cell.contentView addSubview:textView];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            UITextView *textView = (UITextView *)[cell viewWithTag:601];
            [textView setText:self.courseInfoDic[@"cDetail"]];
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
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            NSDictionary *dic = self.courseCommentArray[indexPath.row];
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",kBaseURL,dic[@"userPortrait"]];
            [cell.headImageView setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"CuserPhoto"]];
            
            cell.dateLable.text = dic[@"ccDate"];
            cell.commentLabel.text = dic[@"ccContent"];
            cell.userNameLable.text = dic[@"userName"];
            cell.imageButton.tag = indexPath.row;
            [cell.imageButton addTarget:self action:@selector(touchHeadImage:) forControlEvents:UIControlEventTouchUpInside];
            
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
                //[timeImageView setImage:[UIImage imageNamed:@"CtimeNum"]];
                timeImageView.tag = 121;
                [cell.contentView addSubview:timeImageView];
                UILabel *timeLable = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-45, 6, 45, 30)];
                [timeLable setFont:[UIFont systemFontOfSize:12.0]];
                [cell.contentView addSubview:timeLable];
                timeLable.tag = 120; //
            }
            UIImageView *imageView = (UIImageView *)[cell viewWithTag:121];
            imageView.image = [UIImage imageNamed:@"CtimeNum"];
            
            NSArray *chapter = self.courseChapterArray[indexPath.section -1][@"CCvideo"];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",chapter[indexPath.row][@"vSectionsNo"],chapter[indexPath.row][@"vSectionsName"]];
            UILabel *label = (UILabel *)[cell viewWithTag:120];
            label.text = [NSString stringWithFormat:@"%@分钟",chapter[indexPath.row][@"vTime"]];
            
            if(self.isNeedHistory){
                NSArray *array = self.videoHDic[@"chapter"];
                for(NSDictionary *dic in array){
                    NSInteger chapterNum = [dic[@"chChapterNo"] integerValue];
                    if(chapterNum == indexPath.section){
                        NSArray *vArray = dic[@"listVideo"];
                        for(NSDictionary *dic in vArray){
                            if([chapter[indexPath.row][@"vSectionsNo"] isEqualToString:dic[@"vSectionsNo"]])
                               [imageView setImage:[UIImage imageNamed:@"CtimeNum_full"]];
                        }
                    }
                }
            }
            
            return cell;
        }
            break;
        case SegementNote:
        {
            static NSString *noteCellIdentifier = @"noteCell";
            
            CNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:noteCellIdentifier];
            
            NSArray *noteArray = self.courseNoteArray[indexPath.section-1][@"CCnote"];
            NSDictionary *noteDic = noteArray[indexPath.row];
            
            if (indexPath.section == 1) {
                cell.noteLabel.text = noteDic[@"cnContext"];
                cell.chapterLabel.text = noteDic[@"cnDate"];
                cell.timeLabel.text = @"无";
            } else{
                cell.noteLabel.text = noteDic[@"Dcomponent"];
                cell.chapterLabel.text = [NSString stringWithFormat:@"%@ %@",noteDic[@"vSectionsNo"],noteDic[@"vSectionsName"]];
                cell.timeLabel.text = [NSString stringWithFormat:@"%@",[self chageTime:[noteDic[@"Dtime"] integerValue]]];
            }
            
            
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
            return SCREEN_HEIGHT - 64 - headHeight - 33;
            break;
        case SegementChapter:
            return 44;
            break;
        case SegementNote:
            return 60;
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
    if (!self.tableView.isEditing) {
        switch (self.segmentControl.selectedSegmentIndex) {
            case SegementChapter:
            {
                //获取对应视频id
                
                NSDictionary *dic = (self.courseChapterArray[indexPath.section-1][@"CCvideo"])[indexPath.row];
                NSInteger CVid = [dic[@"vId"] integerValue];
                //NSLog(@"%d",CVid);
            
                CVideoPlayerController *player = [[CVideoPlayerController alloc] init];
                [player playVideoWithVideoID:CVid andVideoTitle:[NSString stringWithFormat:@"%@ %@",dic[@"vSectionsNo"],dic[@"vSectionsName"]] andVideoUrlString:[NSString stringWithFormat:@"%@%@",kBaseURL,dic[@"vUrl"]]];
                [self presentMoviePlayerViewControllerAnimated:player];
                
                //异步处理看视频获得积分事件
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(queue, ^{
                    [self.getAndPayModel getCoinForVideoWithUserID:[User sharedUser].info.userId];
                });
                
            }
                break;
            case SegementNote:
            {
                if (indexPath.section > 1) {
                    NSArray *noteArray = self.courseNoteArray[indexPath.section-1][@"CCnote"];
                    NSDictionary *noteDic = noteArray[indexPath.row];
                    NSString *vUrl = noteDic[@"videoUrl"];
                    NSString *title = [NSString stringWithFormat:@"%@ %@",noteDic[@"vSectionsNo"],noteDic[@"vSectionsName"]];
                    NSTimeInterval noteTime = [noteDic[@"Dtime"] doubleValue];
                    CVideoPlayerController *player = [[CVideoPlayerController alloc] init];
                    [player playVideoWithVideoID:[noteDic[@"videoID"] integerValue] andStartTime:noteTime andVideoUrlString:vUrl andVideoTitle:title];
                    [self presentMoviePlayerViewControllerAnimated:player];
                }
                
            }
                break;
            case SegementComment:
            {
                /*
                NSDictionary *dic = self.courseCommentArray[indexPath.row];
                NSString *userID = dic[@"userid"];
                DetailViewController *detailVC = [[DetailViewController alloc] initWithUserId:userID];
                [self.navigationController pushViewController:detailVC animated:YES];
                 */
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - 编辑模式 下载
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segmentControl.selectedSegmentIndex == SegementChapter) {
        
        NSDictionary *dic = self.courseChapterArray[indexPath.section-1];
        NSDictionary *videoDic = dic[@"CCvideo"][indexPath.row];
        //判断是否已下载
        for (NSInteger i = 0; i < self.downloadModel.downloadArray.count; i++) {
            for (NSDictionary *dic in self.downloadModel.downloadArray[0]) {
                if ([dic[@"videoID"] isEqualToString:[NSString stringWithFormat:@"%@",videoDic[@"vId"]]]) {
                    return NO;
                }
            }
        }

        return YES;
    } else
        return NO;
}



#pragma mark - Action 方法

#pragma mark touch headImageButton
- (void)touchHeadImage:(UIButton *)sender
{
    NSDictionary *dic = self.courseCommentArray[sender.tag];
    NSInteger userID = [dic[@"userid"] integerValue];
    UserCenterTableViewController *userVC = [[UserCenterTableViewController alloc] initWithUserId:userID];
    [self.navigationController pushViewController:userVC animated:YES];
}

#pragma mark  segement Changed 方法
- (void)selectSegemnt
{
    //NSLog(@"%d",self.segmentControl.selectedSegmentIndex);
    switch (self.segmentControl.selectedSegmentIndex) {
        case SegementDiscription:
            self.tableView.showsInfiniteScrolling = NO;
            [self.tableView reloadData];
            break;
        case SegementChapter:
            self.tableView.showsInfiniteScrolling = NO;
            [self.tableView reloadData];
            break;
        case SegementComment:
            self.tableView.showsInfiniteScrolling = YES;
            [self.tableView reloadData];
            break;
        case SegementNote:
            self.tableView.showsInfiniteScrolling = NO;
            [self.tableView reloadData];
            break;
        default: ;
            [self.tableView reloadData];;
    }
}

#pragma mark 点击header展开/收缩章节方法 --- 从后台获取章节信息
- (void)clickHeader : (UIButton *)button
{
    NSInteger section = button.tag;
    [self openChapterWithSection:section];
}
//为下载复用
- (void)openChapterWithSection:(NSInteger)section
{
    if (self.segmentControl.selectedSegmentIndex == SegementChapter) {
        NSMutableDictionary *chapterDic = self.courseChapterArray[section - 1];
        
        if (chapterDic[@"CCvideo"] == nil) {
            NSInteger chapterID = [chapterDic[@"chId"] integerValue];
            NSArray *array = [self.courseChapter loadCourseDetailChapterWithChapterID:chapterID];
            [chapterDic setObject:array forKey:@"CCvideo"];
        }
        //NSLog(@"%d-touched",section);
        NSInteger isOpen = [self.chapterOpenArray[section-1] integerValue];
        [self.chapterOpenArray replaceObjectAtIndex:section-1 withObject:(isOpen ? @0 : @1)];
        NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:section];
        [self.tableView reloadSections:indexset withRowAnimation:UITableViewRowAnimationAutomatic];
    } else if (self.segmentControl.selectedSegmentIndex == SegementNote){
        NSMutableDictionary *noteDic = self.courseNoteArray[section-1];
        if (noteDic[@"CCnote"] == nil) {
            NSString *url = noteDic[@"innerUrl"];
            NSMutableArray *array = [self.courseChapter loadCourseDetailNoteWithUrl:url];
            [noteDic setObject:array forKey:@"CCnote"];
        }
        NSInteger isOpen = [self.noteOpenArray[section-1] integerValue];
        [self.noteOpenArray replaceObjectAtIndex:section-1 withObject:(isOpen?@0:@1)];
        NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:section];
        [self.tableView reloadSections:indexset withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}

#pragma mark toolBar Buttion事件
- (void)touchButton:(UIBarButtonItem *)button
{

    switch (button.tag) {
        case ButtonTagPrivate:{
            [self userCheck];
            if ([User sharedUser].info.isLogin) {
                button.image = [UIImage imageNamed:@"cStarFull"];
                NSInteger userID = [User sharedUser].info.userId;
                NSInteger result = [self.courseChapter privateWithCourseID:self.courseID andUserID:userID];
                if (result == 1) {
                    CAlertLabel *alertLabel = [CAlertLabel alertLabelWithAdjustFrameForText:@"收藏成功"];
                    [alertLabel showAlertLabel];
                    button.image = [UIImage imageNamed:@"cStarFull"];
                }else if(result == 2){
                    CAlertLabel *alertLabel = [CAlertLabel alertLabelWithAdjustFrameForText:@"取消收藏成功"];
                    [alertLabel showAlertLabel];
                    button.image = [UIImage imageNamed:@"cStar"];
                }else{
                    CAlertLabel *alertLabel = [CAlertLabel alertLabelWithAdjustFrameForText:@"操作失败!"];
                    [alertLabel showAlertLabel];
                }
                [User sharedUser].havaChange = YES;
              
            }

        }
            break;
        case ButtonTagDownLoad:{
            
            if (self.segmentControl.selectedSegmentIndex != SegementChapter) {
                [self.segmentControl setSelectedSegmentIndex:SegementChapter];
                [self.tableView reloadData];
            }
            [self.segmentControl setEnabled:NO];
            if ([self.chapterOpenArray[0] integerValue] == 0) {
                [self openChapterWithSection:1]; //展开第一行 提示可下载
            }
            [self.tableView setEditing:YES animated:YES];
            [self.view addSubview:self.downLoadBarView];
        }
            break;
        case ButtonTagComment:{
            [self userCheck];
            if ([User sharedUser].info.isLogin) {
                //弹出输入框
                [[UIApplication sharedApplication].keyWindow addSubview:self.dimView];
                [[UIApplication sharedApplication].keyWindow addSubview:self.sendComNoteView];
                [self.sendComNoteView.textView becomeFirstResponder];
                //self.sendComNoteView.titleLabel.text = @"发送评论";
                self.sendComNoteView.titleLabel.backgroundColor = [UIColor greenColor];
                self.sendComNoteView.tag = TextViewComment;
                [UIView animateWithDuration:0.4f animations:^{
                    [self.sendComNoteView setFrame:CGRectMake((SCREEN_WIDTH-_sendComNoteView.frame.size.width)/2.0, 20.0, _sendComNoteView.frame.size.width, _sendComNoteView.frame.size.height)];
                    self.sendComNoteView.alpha = 1.0f;
                } completion:^(BOOL finished) {
                    
                }];
            }

        }
            break;
        case ButtonTagNote:{
            //弹出输入框
            [self userCheck];
            if ([User sharedUser].info.isLogin) {
                [[UIApplication sharedApplication].keyWindow addSubview:self.dimView];
                [[UIApplication sharedApplication].keyWindow addSubview:self.sendComNoteView];
                [self.sendComNoteView.textView becomeFirstResponder];
                //self.sendComNoteView.titleLabel.backgroundColor = [UIColor blueColor];
                self.sendComNoteView.titleLabel.text = @"写笔记";
                self.sendComNoteView.tag = TextViewNote;
                [UIView animateWithDuration:0.4f animations:^{
                    [self.sendComNoteView setFrame:CGRectMake((SCREEN_WIDTH-_sendComNoteView.frame.size.width)/2.0, 20.0, _sendComNoteView.frame.size.width, _sendComNoteView.frame.size.height)];
                    self.sendComNoteView.alpha = 1.0f;
                } completion:^(BOOL finished) {
                    
                }];
            }
            
        }
            break;
        case ButtonTagBuy:{
#warning 待实现购买
            [self userCheck];
            if ([User sharedUser].info.isLogin) {
                BOOL hadBuyed = NO;
                NSArray *purchaseArray = [[User sharedUser].info.bcourses linkContent];
                for (NSDictionary *dic in purchaseArray) {
                    if ([dic[@"cid"] integerValue] == self.courseID) {
                        hadBuyed = YES;
                        break;
                    }
                }
                if (!hadBuyed) {
                    UIActionSheet *buyActionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择购买方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"支付宝购买" otherButtonTitles:@"积分购买", nil];
                    buyActionSheet.tag = ActionSheetBuy;
                    [buyActionSheet showFromToolbar:self.toobar];

                }else{
                    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"你已经购买了此课程" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:@"知道啦" otherButtonTitles:nil, nil];
                    [actionSheet showFromToolbar:self.toobar];
                }
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark download Action
- (void)doDownload:(UIButton *)sender
{
    NSArray *array = [self.tableView indexPathsForSelectedRows];
    if (sender.tag == DownloadConfirm && array.count > 0) {

        //NSMutableArray *downChapterArray = [NSMutableArray arrayWithCapacity:array.count];
        for (NSIndexPath *indexPath in array) {
            NSDictionary *dic = self.courseChapterArray[indexPath.section-1];
            NSDictionary *videoDic = dic[@"CCvideo"][indexPath.row];
           
            [self.downloadModel downLoadVideoWithUrlString:[NSString stringWithFormat:@"%@%@",kBaseURL,videoDic[@"vUrl"] ] andName:videoDic[@"vSectionsName"] andCNum:videoDic[@"vSectionsNo"] andVideoID:[NSString stringWithFormat:@"%d",[dic[@"vId"] integerValue]]];
        }

        
        NSString *aMessage = [NSString stringWithFormat:@"你选择的%d个视频已近开始下载",array.count];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"开始下载" message:aMessage delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles:@"去看看", nil];
        [alertView show];
    }
    [self.tableView setEditing:NO animated:YES];
    [self.segmentControl setEnabled:YES];
    [self.downLoadBarView removeFromSuperview];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        CDownloadViewController *dVC = [[CDownloadViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:dVC animated:YES];
    }
}

#pragma sendView button action
- (void)sendComNote
{
    [self userCheck];
    //评论
    if ([User sharedUser].info.isLogin) {
        if (self.sendComNoteView.tag == TextViewComment) {
            NSLog(@"评论---%@",self.sendComNoteView.textView.text);
            User *user = [User sharedUser];
            if (user.info.isLogin) {
                NSInteger userID = user.info.userId;
                [self.courseChapter sendCourseCommentWithCourseID:self.courseID andUserID:userID andContent:self.sendComNoteView.textView.text];
            }
            
        } else if (self.sendComNoteView.tag == TextViewNote){ //笔记
            NSLog(@"笔记---%@",_sendComNoteView.textView.text);
            [self.courseChapter sendCourseNoteWithCourseID:1 andUserID:self.courseID andContent:self.sendComNoteView.textView.text];
        }
        
        [self sendComNoteViewBack];
        NSInteger isGetCoin = (self.sendComNoteView.tag == TextViewComment ? [self.getAndPayModel getCoinForCommentWithUserID:[User sharedUser].info.userId] : [self.getAndPayModel getCoinForNoteWithUserID:[User sharedUser].info.userId]);
        CAlertLabel *alertLabel = [CAlertLabel alertLabelWithAdjustFrameForText:[NSString stringWithFormat:@"发送成功%@",isGetCoin?@"，积分+1":@""]];
        [alertLabel showAlertLabel];
        //self.sendComNoteView.textView.text = nil;
    }
}

- (void)cancelSend
{
    [self sendComNoteViewBack];
}

- (void)sendComNoteViewBack
{
    [self.sendComNoteView.textView resignFirstResponder];

    [UIView animateWithDuration:0.4f animations:^{
        [self.sendComNoteView setFrame:CGRectMake((SCREEN_WIDTH-_sendComNoteView.frame.size.width)/2.0, -_sendComNoteView.frame.size.height, _sendComNoteView.frame.size.width, _sendComNoteView.frame.size.height)];
        self.sendComNoteView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.dimView removeFromSuperview];
        self.sendComNoteView.textView.text = nil;
    }];

}

#pragma mark - moreAction，下拉菜单事件
- (void)moreAction
{
    self.moreActionView.isShow ? [self.moreActionView disMissMoreActionView] : [self.moreActionView showMoreActionView];
}

- (void)moreActionTouched:(UIButton *)sender
{
    switch (sender.tag) {
        case MoreButtonTagTest:
        {
            NSInteger testID = [self.courseInfoDic[@"tcId"] integerValue];
            JJTestDetailViewController *testVC = [JJTestDetailViewController testDetailVCwithTestID:testID];
            [self.navigationController pushViewController:testVC animated:YES];
        }
            break;
        case MoreButtonTagPeople:
        {
            [self userCheck];
            RecommendViewController *rVC = [[RecommendViewController alloc] initWithUserID:[User sharedUser].info.userId  andCourseID:self.courseID];
            [self.navigationController pushViewController:rVC animated:YES];
        }
            break;
        case MoreButtonTagShare:
        {
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK"  ofType:@"jpg"];
            
            //构造分享内容
            id<ISSContent> publishContent = [ShareSDK content:@"我正在使用ME手机app学习java，c++等，你们也来学习吧"
                                               defaultContent:@"我正在使用ME手机app学习java，c++等，你们也来学习吧"
                                                        image:[ShareSDK imageWithPath:imagePath]
                                                        title:@"分享"
                                                          url:nil
                                                  description:@"这是一条测试信息"
                                                    mediaType:SSPublishContentMediaTypeNews];
            
            [ShareSDK showShareActionSheet:nil
                                 shareList:nil
                                   content:publishContent
                             statusBarTips:YES
                               authOptions:nil
                              shareOptions: nil
                                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                        if (state == SSResponseStateSuccess)
                                        {
                                            [self.getAndPayModel getCoinForShareWithUserID:[User sharedUser].info.userId];
                                            NSLog(@"分享成功");
                                        }
                                        else if (state == SSResponseStateFail)
                                        {
                                            NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                        }
                                    }];
        }
            break;
        default:
            break;
    }
    [self.moreActionView disMissMoreActionView];
}

#pragma mark - 用户登录相关

- (void)userCheck
{
    if(![User sharedUser].info.isLogin){
        [self.actionSheet showFromToolbar:self.toobar];
    }
}

#pragma mark - 时间转换

- (NSString *)chageTime:(NSInteger)theSecond
{
    NSInteger h,m,s;
    h = theSecond/3600;
    m = (theSecond-h*3600)/60;
    s = theSecond%60;
    return [NSString stringWithFormat:@"%02d:%02d:%02d",h,m,s];
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark - delegate

- (void)updateUI
{
    //self.courseInfoDic = self.courseChapter.courseInfoDic;
    if ([self.title isEqualToString:@""]) {
        self.title = self.courseInfoDic[@"cName"];
    }
    [self.tableView reloadData];

}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag) {
        case ActionSheetLogin:
        {
            if (buttonIndex == 0) {
                [[User sharedUser] gotoUserLoginFrom:self];
            }
        }
            break;
        case ActionSheetBuy:{
#warning 待实现支付
            if (buttonIndex == 0) {
                //支付宝支付
                NSLog(@"支付宝支付");
            }else if (buttonIndex == 1){
                //积分支付
                NSLog(@"积分支付");
            }
        }
            break;
        default:
            break;
    }
}

@end