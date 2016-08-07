//
//  MainViewController.m
//  01-FZHDrawerView
//
//  Created by 冯志浩 on 16/8/5.
//  Copyright © 2016年 FZH. All rights reserved.
//

#import "MainViewController.h"
#import "SubViewController.h"
#import "MainView.h"
#import "LeftView.h"
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface MainViewController ()<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) LeftView *leftView;
@property (nonatomic, strong) SubViewController *subVC;
@property (nonatomic, assign) BOOL isSelect;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationItem];
    [self initSubView];
    [self setupTableView];
}

- (void)initNavigationItem{
    self.title = @"Main";
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"left" style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonItemTargetAction)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)leftBarButtonItemTargetAction{
    if (self.isSelect == NO) {
        [UIView animateWithDuration:0.5 animations:^{
            self.navigationController.navigationBar.transform = CGAffineTransformMakeTranslation(200, 0);
            self.mainView.transform = CGAffineTransformMakeTranslation(200, 0);
            self.tabBarController.tabBar.transform = CGAffineTransformMakeTranslation(200, 0);
            self.subVC.view.transform = CGAffineTransformMakeTranslation(200, 0);
        }];
        self.isSelect = YES;
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.navigationController.navigationBar.transform = CGAffineTransformIdentity;
            self.leftView.transform = CGAffineTransformIdentity;
            self.mainView.transform = CGAffineTransformIdentity;
            self.tabBarController.tabBar.transform = CGAffineTransformIdentity;
            self.subVC.view.transform = CGAffineTransformIdentity;
        }];
        self.isSelect = NO;
    }
}

- (void)initSubView{
//    1.leftView
    self.leftView = [[LeftView alloc]init];
    self.leftView.frame = CGRectMake(0, 0, 200, SCREEN_HEIGHT);
    [self.view addSubview:self.leftView];
//    2.mainView
    self.mainView = [[MainView alloc]init];
    self.mainView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.mainView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainView];
    
}

- (void)setupTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 200, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor blueColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.leftView addSubview:self.tableView];
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = @"subView";
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.navigationController.navigationBar.transform = CGAffineTransformIdentity;
        self.leftView.transform = CGAffineTransformIdentity;
        self.mainView.transform = CGAffineTransformIdentity;
        self.tabBarController.tabBar.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.subVC = [[SubViewController alloc]init];
        [self.navigationController pushViewController:self.subVC animated:NO];

    }];
    self.isSelect = NO;
  
}

@end
