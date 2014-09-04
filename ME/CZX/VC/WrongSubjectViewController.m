//
//  WrongSubjectViewController.m
//  ME
//
//  Created by Johnny's on 14-8-2.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "WrongSubjectViewController.h"
#import "JJSubjectModel.h"
#import "JJSubjectManage.h"
#import "SubjectController.h"

@interface WrongSubjectViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UIButton *editBtn;
}
@end

@implementation WrongSubjectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithWrongSubjectArray:(NSArray *)wrongArray
{
    self = [super init];
    if (self)
    {
        self.wrongSubjectArray = [NSMutableArray new];
        self.wrongSubjectArray = (NSMutableArray *)wrongArray;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的错题";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backBarButton;
    

    
    if (self.wrongSubjectArray.count == 0)
    {
        UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(130, 220, 60, 40)];
        la.text = @"还没有错题哦~";
        [self.view addSubview:la];
    }
    else
    {
        editBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [editBtn addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *editBarButton = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
        self.navigationItem.rightBarButtonItem = editBarButton;
        self.tableView = [[UITableView alloc]
                                  initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:self.tableView];
        self.correctAnswerArray = [NSMutableArray new];
        self.answerArray = [NSMutableArray new];
        self.questionArray = [NSMutableArray new];
        self.numberCorrectAnswerArray = [NSMutableArray new];
        NSArray *array = @[@"a", @"b", @"c", @"d"];
        for (int i=0; i<self.wrongSubjectArray.count; i++)
        {
            JJSubjectModel *model = [self.wrongSubjectArray objectAtIndex:i];
            [self.correctAnswerArray addObject:model.ceAnswer];
            [self.answerArray addObject:model.options];
            [self.questionArray addObject:model.ceContext];
        }
        for (int i=0; i<self.correctAnswerArray.count; i++)
        {
            for (int j=0; j<array.count; j++)
            {
                if ([[array objectAtIndex:j] isEqualToString:[self.correctAnswerArray objectAtIndex:i]])
                {
                    [self.numberCorrectAnswerArray
                     addObject:[NSString stringWithFormat:@"%d", j]];
                }
            }
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.wrongSubjectArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    JJSubjectModel *model = [self.wrongSubjectArray objectAtIndex:indexPath.row];
    cell.textLabel.text = model.ceContext;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubjectController *vc = [[SubjectController alloc] initWithCorrectAnswer:self.numberCorrectAnswerArray personAnswer:nil questionArray:self.questionArray answerArray:self.answerArray page:[indexPath row]];
    [self.navigationController pushViewController:vc animated:YES];
//    vc.myTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)edit
{
    if (self.tableView.editing == NO)
    {
        [self.tableView setEditing:YES animated:YES];
        [editBtn setTitle:@"完成" forState:UIControlStateNormal];
    }
    else
    {
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [self.tableView setEditing:NO animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.删除模型数据
    [self.wrongSubjectArray removeObjectAtIndex:indexPath.row];
    
    //2.删除tableview数据
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [[[JJSubjectManage alloc] init] saveDirectionModel:self.wrongSubjectArray];
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
