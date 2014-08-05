//
//  JJTestDetailViewController.h
//  TestVC
//
//  Created by Johnny's on 14-7-4.
//  Copyright (c) 2014年 Johnny's. All rights reserved.
//

#import "JJBaseViewController.h"
#import "JJMeasurementViewController.h"
#import "JJTestModel.h"
#import "User.h"

@interface JJTestDetailViewController : JJBaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *commentView;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UIButton *likeBtn;

@property (strong, nonatomic) IBOutlet UITextView *introduceView;
@property (strong, nonatomic) IBOutlet UILabel *testName;

- (IBAction)buyOrEnter:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *timeLa;
//@property (strong, nonatomic) IBOutlet UILabel *priceLa;
@property (strong, nonatomic) IBOutlet UILabel *subjectNumLa;
@property (strong, nonatomic) IBOutlet UILabel *directionLa;

@property (strong, nonatomic) IBOutlet UILabel *scoreLa;
@property (strong, nonatomic) IBOutlet UIButton *introduceButton;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;

@property(nonatomic, strong) JJTestModel *myModel;
@property(nonatomic, strong) NSMutableArray *commentArray;

- (IBAction)writeComment:(id)sender;

- (id)initWithModel:(JJTestModel *)paramModel;
- (void)loadModel;
+ (instancetype)testDetailVCwithTestID:(NSInteger)testID;
@property(nonatomic, strong) UITableView *commentTableView;
@end
