//
//  UserCenterViewControllerTableViewController.m
//  Online_learning
//
//  Created by qf on 14/7/9.
//  Copyright (c) 2014年 qf. All rights reserved.
//

#import "UserCenterTableViewController.h"
#import "User.h"
#import "NumTableViewCell.h"
#import "ProgressTableViewCell.h"
#import "FocusTableViewController.h"
#import "LoginViewController.h"
#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
#import "CourseTableViewController.h"
typedef NS_ENUM(NSInteger, UserCenterSectionStyel) {
    UserCenterSectionStyelInfo = 0,
    UserCenterSectionStyelDetail,
	UserCenterSectionStyelLcourse,
	UserCenterSectionStyelQandA,
	UserCenterSectionStyelBCcourse,
//	UserCenterSectionStyelTest,
	UserCenterSectionStyelLink,
	UserCenterSectionStyelLogout,
};


@interface UserCenterTableViewController ()
@property (nonatomic,strong) User *user;
@property (nonatomic,strong) UserInfoTableViewCell *uiCell;
@end

@implementation UserCenterTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _user = [User sharedUser];
	self.navigationItem.title = @"用户中心";
//	[_infoCell loadData];
}

- (void)viewWillAppear:(BOOL)animated{
	self.tabBarController.tabBar.hidden = NO;
}
//- (void)waitData{
//	while (!_user.info.account) {
//		_user = [User sharedUser];
//	}
//	[self performSelector:@selector(reloadUserData) withObject:nil afterDelay:0.2];
//}
//- (void)reloadUserData{
//	[self.tableView reloadData];
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Userinfo table view delegate

- (void)courseLabelTouchEvent{
	//course table
	NSLog(@"course label table");
	CourseTableViewController *ctb = [[CourseTableViewController alloc] initWithStyle:UITableViewStylePlain];
	ctb.courses = _user.info.lcourses;
	ctb.navigationItem.title = @"最近浏览";
	[self.navigationController pushViewController:ctb animated:YES];
}

- (void)focusLabelTouchEvent{
	FocusTableViewController *ftvc = [[FocusTableViewController alloc] initWithData:[_user.info.focus mutableCopy]];
//	ftvc.data = [_user.info.focus mutableCopy];
	[self.navigationController pushViewController:ftvc animated:YES];
}

- (void)focusedLabelTouchEvent{
		FocusTableViewController *ftvc = [[FocusTableViewController alloc] initWithData:[_user.info.focused mutableCopy]];
//	ftvc.data = [_user.info.focused mutableCopy];
	[self.navigationController pushViewController:ftvc animated:YES];
}
#pragma mark - Table view data source
#if 1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.section == 0) {
		return 90;
	}else if(indexPath.section == 2){
		return 90;
	}
	return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (section) {
		case UserCenterSectionStyelLcourse: return MIN([_user.info.lcourses count], 3); break;
		case UserCenterSectionStyelQandA:	return 3; break;
		case UserCenterSectionStyelBCcourse: return 2; break;
//		case UserCenterSectionStyelTest	:  return 2;break;
		default:
			break;
	}
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = nil;
	if (indexPath.section == UserCenterSectionStyelInfo) {
		_uiCell = [[UserInfoTableViewCell alloc] initWithFrame:CGRectNull];
		[_uiCell setSelectionStyle:UITableViewCellSelectionStyleNone];	//设置cell被选中时的StyleNone 没有高亮效果
//		_uiCell.userInteractionEnabled = NO;	//将cell设置为不可选中 ps:会使触摸事件失效
		_uiCell.delegate = self;
		if (_user.info.isLogin) {
			[_uiCell setAImage:_user.info.imageUrl
					andName:_user.info.name
				  courseNum:[_user.info.lcourses count]
				   focusNum:[_user.info.focus count]
				 focusedNum:[_user.info.focused count]];
		}
		return _uiCell;
	}else if (indexPath.section == UserCenterSectionStyelDetail){
		//详情
		cell = [[UITableViewCell alloc] init];
		cell.textLabel.text = @"详细信息";
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}else if (indexPath.section == UserCenterSectionStyelLcourse){
		//加载三门最近浏览的课程
		ProgressTableViewCell * cell1 = [[ProgressTableViewCell alloc] initWithFrame:CGRectNull];
		if (_user.info.isLogin) {
			NSDictionary *course = [_user.info.lcourses objectAtIndex:indexPath.row];
			
			[cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];//取消被选中的高亮效果
			cell1.nameLabel.text = [course objectForKey:@"courseName"];
			[cell1.courseImage setImageWithURL:[NSURL URLWithString:[course objectForKey:@"image"]]];
			cell1.progressView.progress = [[course objectForKey:@"progress"] doubleValue];
			cell1.progressView.text = [NSString stringWithFormat:@"%.2lf%%",[[course objectForKey:@"progress"] doubleValue]*100];
		}
		return cell1;
	}else if (indexPath.section == UserCenterSectionStyelQandA){
		//最近的提问和回答
		if (indexPath.row == 0) {
			cell = [[UITableViewCell alloc] init];
			cell.textLabel.text = @"全部问答动态";
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}else if(indexPath.row == 1){
			//用含 num 的自定义Cell
			NumTableViewCell *numCell = [[NumTableViewCell alloc] initWithFrame:CGRectNull];
			numCell.textLabel.text = @"问过";
			numCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			numCell.numLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[_user.info.questions count]];
			cell = numCell;
		}else {
			NumTableViewCell *numCell = [[NumTableViewCell alloc] initWithFrame:CGRectNull];
			numCell.textLabel.text = @"答过";
			numCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			numCell.numLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[_user.info.answers count]];
			cell = numCell;
		}
	}else if(indexPath.section == UserCenterSectionStyelBCcourse){
		if (indexPath.row == 0) {
			//含 num 的自定义cell
			NumTableViewCell *numCell = [[NumTableViewCell alloc] initWithFrame:CGRectNull];
			numCell.textLabel.text = @"已购买课程";
			numCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			numCell.numLabel.text = [NSString stringWithFormat:@"%lu",[_user.info.bcourses count]];
			cell = numCell;
		}else {
			NumTableViewCell *numCell = [[NumTableViewCell alloc] initWithFrame:CGRectNull];
			numCell.textLabel.text = @"收藏的课程";
			numCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			numCell.numLabel.text = [NSString stringWithFormat:@"%lu",[_user.info.ccourses count]];
			cell = numCell;
		}
	}else if(indexPath.section == UserCenterSectionStyelLink){
		cell = [[UITableViewCell alloc] init];
		cell.textLabel.text = @"新浪微博 微信 qq等绑定链接";
	}else if(indexPath.section == UserCenterSectionStyelLogout){
		cell = [[UITableViewCell alloc] init];
		cell.textLabel.text = @"退出登陆";
		cell.textLabel.textColor = [UIColor redColor];
		cell.textLabel.textAlignment = NSTextAlignmentCenter;
	}
	[cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	if (section == UserCenterSectionStyelLcourse) {
		return @"最近课程";
	}
	return nil;
}
#endif
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


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == UserCenterSectionStyelLogout) {
		//推出登陆
		[_user logout];
		LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
		self.navigationController.viewControllers = @[login];
	}else if (indexPath.section == UserCenterSectionStyelDetail){
		//用户详情
		DetailViewController *detail = [[DetailViewController alloc] init];
		detail.userData = _user.info;
		detail.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
		[self.navigationController pushViewController:detail animated:YES];
		
	}else if (indexPath.section == UserCenterSectionStyelBCcourse){
		CourseTableViewController *ctb = [[CourseTableViewController alloc]initWithStyle:UITableViewStylePlain];
		ctb.courses = (indexPath.row==1)?_user.info.bcourses:_user.info.ccourses;
		self.navigationItem.title = (indexPath.row==1)?@"已购课程":@"已收藏课程";
		[self.navigationController pushViewController:ctb animated:YES];
		
	}else if (indexPath.section == UserCenterSectionStyelLcourse){
		//course interface
		
//		self.tabBarController.selectedIndex = 0;
//		[[self.tabBarController.viewControllers objectAtIndex:0] pushViewController:ctb animated:YES	];
	}else if (indexPath.section == UserCenterSectionStyelLink){
		
	}else if (indexPath.section == UserCenterSectionStyelQandA){
			
	}
	else{
		
	}
}


@end
