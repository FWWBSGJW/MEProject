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
@interface CDownloadViewController ()<dCelldelegate>

@property (strong, nonatomic) NSMutableArray *downLoadArray;

@end

@implementation CDownloadViewController

#pragma mark - getter and setter

- (NSMutableArray *)downLoadArray
{
    if (!_downLoadArray) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DownloadData.plist" ofType:nil];
        _downLoadArray = [NSMutableArray arrayWithContentsOfFile:filePath];
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
    cell.dFileImageView.image = [UIImage imageNamed:@"flv"];
    cell.dShouldDownNumber.text = dic[@"dcSize"];
    
    cell.dTitleLabel.text = [NSString stringWithFormat:@"%@ %@",dic[@"dcNum"],dic[@"dcName"]];
    if (indexPath.section == 0) {
        cell.dStateLabel.text = @"0.0kb/s";
        if (cell.dDownloadButton.isHidden) {
            cell.dhadDownNumber.text = dic[@"dcNow"];
            cell.dShouldDownNumber.text = dic[@"dcSize"];
            cell.dDownloadButton.hidden = NO;
        }
    } else if(indexPath.section == 1){
        cell.dStateLabel.text = dic[@"dcDate"];
        if (!cell.dDownloadButton.isHidden) {
            cell.dDownloadButton.hidden = YES;
            cell.dhadDownNumber.text = dic[@"dcSize"];
            cell.dShouldDownNumber.text = dic[@"dcSize"];
        }
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
        NSString *fileName = dic[@"dcUrl"];
        NSArray *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [doc[0] stringByAppendingPathComponent:fileName];
//        NSString *thePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
//        NSData *data = [NSData dataWithContentsOfFile:thePath];
//        [data writeToFile:filePath atomically:YES];
        NSLog(@"%@",filePath);
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
    
}

#pragma mark delete

- (void)startDeleteVideo
{
    self.tableView.editing  = !self.tableView.editing;
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
