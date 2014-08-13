//
//  CDownloadViewController.m
//  ME
//
//  Created by yato_kami on 14-7-30.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "CDownloadViewController.h"
#import "CourseChapter.h"
#import "CdownlordCell.h"
#import  <MediaPlayer/MediaPlayer.h>
#import "CDownloadModel.h"
@interface CDownloadViewController ()<dCelldelegate,downloadDelegate>

@property (strong, nonatomic) NSMutableArray *downLoadArray;
@property (strong, nonatomic) CDownloadModel *downloadModel;
@property (strong, nonatomic) NSTimer *refreshTimer;

@end

@implementation CDownloadViewController

#pragma mark - getter and setter

- (CDownloadModel *)downloadModel
{
    if (!_downloadModel) {
        _downloadModel = [CDownloadModel sharedCDownloadModel];
        _downloadModel.myDelegate = self;
    }
    return _downloadModel;
}

- (NSMutableArray *)downLoadArray
{
    if (!_downLoadArray) {
        //NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DownloadData.plist" ofType:nil];
        //_downLoadArray = [NSMutableArray arrayWithContentsOfFile:filePath];
        _downLoadArray = self.downloadModel.downloadArray;
    }
    return _downLoadArray;
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        NSLog(@"%@",self.downLoadArray);
        self.title = @"离线视频";
        self.navigationController.navigationBarHidden = NO;
        if (self.navigationController.navigationBarHidden == YES) {
            self.navigationController.navigationBarHidden = NO;
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (self.navigationController.navigationBarHidden == YES) {
        self.navigationController.navigationBarHidden = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.bounces = NO;
    [self setExtraCellLineHidden:self.tableView]; //隐藏多需的cell线
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(startDeleteVideo)];
    self.navigationItem.rightBarButtonItem = deleteButton;
    
    UINib *nib = [UINib nibWithNibName:@"CdownlordCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"downloadCell"];
    
    _refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(reloadDowloadUI) userInfo:nil repeats:YES];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *array = [self.downLoadArray objectAtIndex:section];
    return array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CdownlordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"downloadCell" forIndexPath:indexPath];
    cell.cellDelegate = self;
    if (cell == nil) {
        cell = [[CdownlordCell alloc] init];
    }
    NSDictionary *dic = [self.downLoadArray objectAtIndex:indexPath.section][indexPath.row];
    
    cell.dShouldDownNumber.text = dic[@"dcSize"];
    
    cell.dTitleLabel.text = [NSString stringWithFormat:@"%@ %@",dic[@"dcNum"],dic[@"dcName"]];
    if (indexPath.section == 0) {
        cell.dhadDownNumber.text = [NSString stringWithFormat:@"%.1fM",[dic[@"dcNow"] doubleValue]];
        cell.dShouldDownNumber.text = [NSString stringWithFormat:@"%.1fM",[dic[@"dcSize"] doubleValue]];
        cell.dStateLabel.text = [dic[@"dcSpeed"] stringByAppendingString:@"kb/s"];
        if (cell.dDownloadButton.isHidden) {
            cell.dDownloadButton.hidden = NO;
        }
        
        if ([dic[@"dcState"] integerValue]) {
            [cell.dDownloadButton setTitle:@"暂停" forState:UIControlStateNormal];
        } else {
            [cell.dDownloadButton setTitle:@"开始" forState:UIControlStateNormal];
        }
        cell.dDownloadButton.tag = indexPath.row;
        
    } else if(indexPath.section == 1){
        cell.dStateLabel.text = dic[@"dcDate"];
        
        if (!cell.dDownloadButton.isHidden) {
            cell.dDownloadButton.hidden = YES;
        }
        cell.dhadDownNumber.text = [NSString stringWithFormat:@"%.1fM",[dic[@"dcSize"] doubleValue]];
        cell.dShouldDownNumber.text = [NSString stringWithFormat:@"%.1fM",[dic[@"dcSize"] doubleValue]];
    }
    
    return cell;
}

 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *array = self.downLoadArray[section];
    if (section == 0) {
        return [NSString stringWithFormat:@"正在下载(%d)",array.count];
    } if (section == 1) {
        return [NSString stringWithFormat:@"下载成功(%d)",array.count];
    }
    return nil;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

#pragma 点击cell

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        
    } else if(indexPath.section == 1){
    
        NSDictionary *dic = self.downLoadArray[indexPath.section][indexPath.row];
        NSString *filePath = dic[@"dcUrl"];
        
        MPMoviePlayerViewController *playVC = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:filePath]];
        [self presentMoviePlayerViewControllerAnimated:playVC];
        
    }
}

#pragma action

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)touchStartorPauseButton:(UIButton *)sender
{
    NSInteger vNumber = sender.tag;
    NSMutableDictionary *dic = self.downloadModel.downloadArray[0][vNumber];
    NSString *videoID = dic[@"videoID"];
    if (![dic[@"dcState"] integerValue]) {
        //开始下载
        dic[@"dcState"] = @1;
        [self.downloadModel continueWithVideoID:videoID];
        [sender setTitle:@"暂停" forState:UIControlStateNormal];
    } else{
        //暂停
        dic[@"dcState"] = @0;
        [self.downloadModel pauseWithVideoID:videoID];
        [sender setTitle:@"下载" forState:UIControlStateNormal];
    }

}

#pragma mark - delegate

- (void)startDeleteVideo
{
    self.tableView.editing  = !self.tableView.editing;
}

- (void)upDateUI
{
    [self.tableView reloadData];
    NSLog(@"%@",self.downLoadArray);
}

- (void)reloadDowloadUI
{
    //NSDictionary *dic = self.downLoadArray[0];
    if (((NSArray *)self.downLoadArray[0]).count > 0) {
        for (NSMutableDictionary *dic in self.downLoadArray[0] ) {
            dic[@"dcSpeed"] = [NSString stringWithFormat:@"%d",(int)(([dic[@"dcNow"] floatValue] - [dic[@"dcLastSize"] floatValue])*1000) ];
            dic[@"dcLastSize"] = dic[@"dcNow"];
        }
        
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];

    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
