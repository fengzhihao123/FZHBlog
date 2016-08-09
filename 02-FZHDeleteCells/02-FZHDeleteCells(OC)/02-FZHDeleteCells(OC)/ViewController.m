//
//  ViewController.m
//  02-FZHDeleteCells(OC)
//
//  Created by 冯志浩 on 16/8/9.
//  Copyright © 2016年 FZH. All rights reserved.
//

#import "ViewController.h"
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *deleteArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationItem];
    [self setupTableView];
    [self initData];
    
}

- (void)initData{
    self.dataSource = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8", nil];
    self.deleteArray = [NSMutableArray arrayWithObjects:@"", nil];
}

- (void)setupTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)setupNavigationItem{

    UIBarButtonItem *editBtn = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(buttonDidTouch:)];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(buttonDidTouch:)];
    UIBarButtonItem *deleteBtn = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(buttonDidTouch:)];
    UIBarButtonItem *selectAllBtn = [[UIBarButtonItem alloc]initWithTitle:@"全选" style:UIBarButtonItemStyleDone target:self action:@selector(buttonDidTouch:)];
    
    editBtn.tag = 1001;
    doneBtn.tag = 1002;
    deleteBtn.tag = 1003;
    self.navigationItem.leftBarButtonItems = @[editBtn,doneBtn,deleteBtn,selectAllBtn];
}

- (void)buttonDidTouch:(UIButton *)btn{
    if (btn.tag == 1001) {//edit
        self.tableView.editing = YES;
        self.tableView.allowsMultipleSelectionDuringEditing = YES;
    }else if (btn.tag == 1002){//done
        self.tableView.editing = NO;
    }else if (btn.tag == 1003){//delete
        [self.dataSource removeObjectsInArray:self.deleteArray];
        [self.tableView reloadData];
    }else{
        if (self.tableView.editing == NO) {
            return;
        }else{
            for (int i = 0; i < self.dataSource.count; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            }
            [self.deleteArray addObjectsFromArray:self.dataSource];
        }
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate
//选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.deleteArray addObject:self.dataSource[indexPath.row]];
}
//取消选中
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.deleteArray removeObject:self.dataSource[indexPath.row]];
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{

    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}
@end
