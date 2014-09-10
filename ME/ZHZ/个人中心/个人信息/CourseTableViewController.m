//
//  CourseTableViewController.m
//  ME
//
//  Created by qf on 14/7/22.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "CourseTableViewController.h"
#import "ProgressTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "CChapterViewController.h"
#import "CAlertLabel.h"
#import "User.h"
#import "OLNetManager.h"
@interface CourseTableViewController ()

@end

@implementation CourseTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
		_deletable = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	if (_deletable) {
		self.navigationItem.rightBarButtonItem = self.editButtonItem;
	}
	if (_list) {
		[_list refreshLinkContent];
		_courses = _list.linkContent;
	}
	[self setExtraCellLineHidden:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated{
	self.tabBarController.tabBar.hidden = YES;
	self.navigationController.navigationBarHidden = NO;
	if (_list && [User sharedUser].havaChange) {
		[_list refreshLinkContent];
		_courses = _list.linkContent;
		[self.tableView reloadData];
		[User sharedUser].havaChange = NO;
		[User sharedUser].refreshMe = YES;
	}
	
}

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 61;
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
	NSInteger count = [_courses count];
	if (count == 0) {
		self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, 150, 200, 30)];
		label.textColor = [UIColor lightGrayColor];
		label.text = @"这里还没有东西～～";
		[self.tableView addSubview:label];
	}else{
		self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	}
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static  NSString *identifier = @"CourseCell";
    ProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		cell = [[ProgressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
	}

	NSDictionary *course = [_courses objectAtIndex:indexPath.row];
		
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];//取消被选中的高亮效果
	
	[cell cellWithCourse:course];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	ProgressTableViewCell *cell = (ProgressTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
	[self.navigationController pushViewController:[CChapterViewController chapterVCwithCourseID:[cell.courseId integerValue] andVideoHistoryDic:[[_courses objectAtIndex:indexPath.row] objectForKey:@"maptChapter"]] animated:YES];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return _deletable;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	if (_headTitle) {
		return _headTitle;
	}
	return nil;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
		if (![OLNetManager privateWithCourseID:[[_courses[indexPath.row] objectForKey:@"cid"] intValue] andUserID:[User sharedUser].info.userId]){
			//网络请求 结果错误 提示
			[[CAlertLabel alertLabelWithAdjustFrameForText:@"删除失败"] showAlertLabel];
			return ;
		}
		[[CAlertLabel alertLabelWithAdjustFrameForText:@"删除成功"] showAlertLabel];
		[_courses removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
		[[User sharedUser] refreshInfo];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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
