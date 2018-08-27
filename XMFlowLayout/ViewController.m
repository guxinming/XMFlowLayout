//
//  ViewController.m
//  XMFlowLayout
//
//  Created by EDZ on 2018/8/27.
//  Copyright © 2018年 EDZ. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewController.h"
#import "XMFlowLayout.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (copy, nonatomic)   NSArray *sourceArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sourceArray = @[@"Default", @"Vertical", @"Horizontal"];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - 44) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"mineCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.textLabel.text = self.sourceArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewController *vc = [[CollectionViewController alloc] init];
    if (indexPath.row == 0) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(100, 100);
        layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 50);
        layout.footerReferenceSize = CGSizeMake(self.view.frame.size.width, 50);
        
        vc.layout = layout;
    } else if (indexPath.row == 1) {
        XMFlowLayout *layout = [[XMFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(100, 100);
        layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 50);
        layout.footerReferenceSize = CGSizeMake(self.view.frame.size.width, 50);
        layout.cellInset = UIEdgeInsetsMake(10, (self.view.frame.size.width - 320) / 2, 10, (self.view.frame.size.width - 320) / 2);
        layout.cellSpace = 10;
        
        vc.layout = layout;
    } else if (indexPath.row == 2) {
        XMFlowLayout *layout = [[XMFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(100, 100);
        layout.headerReferenceSize = CGSizeMake(100, 400);
        layout.footerReferenceSize = CGSizeMake(100, 400);
        layout.cellInset = UIEdgeInsetsMake(40, 10, 40, 10);
        layout.cellSpace = 10;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        vc.layout = layout;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

@end
