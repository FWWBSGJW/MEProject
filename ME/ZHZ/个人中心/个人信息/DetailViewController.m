//
//  DetailViewController.m
//  Online_learning
//
//  Created by qf on 14/7/9.
//  Copyright (c) 2014年 qf. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
#import "UILabel+dynamicSizeMe.h"
#import "UIViewAdditions.h"
#import "UserInfo.h"
@interface DetailViewController ()
@property (nonatomic,strong) UIImageView *portrait;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *describleLabel;
@end

@implementation DetailViewController

- (id)initWithUserId:(NSInteger)userId
{
    self = [super init];
    if (self) {
		_userData = [[UserInfo alloc] initWithUserId:userId];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	_portrait = [[UIImageView alloc] initWithFrame:CGRectMake(110, 64, 100, 100)];
	_portrait.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CuserPhoto"]];
	_nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 164, 100, 30)];
	_nameLabel.textAlignment = NSTextAlignmentCenter;
	_describleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 300, SCREEN_HEIGHT - _nameLabel.bottom)];
	[self setUI];
	[self.view addSubview:_describleLabel];
	[self.view addSubview:_nameLabel];
	[self.view addSubview:_portrait];
}

- (void)setUI{
	if (_userData) {
		[_portrait setImageWithURL:[NSURL URLWithString:_userData.imageUrl]];
		_nameLabel.text = _userData.name;
		_describleLabel.text = _userData.describe;
		[_describleLabel resizeToFit];
	}
}
	 
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
