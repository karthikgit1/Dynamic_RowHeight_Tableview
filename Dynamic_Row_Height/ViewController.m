//
//  ViewController.m
//  Dynamic_Row_Height
//
//  Created by Vy Systems - iOS1 on 5/22/15.
//  Copyright (c) 2015 Vy Systems - iOS1. All rights reserved.
//

//***********************
//*********REFERENCE : http://www.fantageek.com/1468/ios-dynamic-table-view-cells-with-varying-row-height-and-autolayout/ *************//
//***********************

#import "ViewController.h"
#import "QuoteTableViewCell.h"

#define SYSTEM_VERSION                              ([[UIDevice currentDevice] systemVersion])
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([SYSTEM_VERSION compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IS_IOS8_OR_ABOVE                            (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))

@interface ViewController ()
{
    
}
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) QuoteTableViewCell *prototypeCell;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self setupTableView];
    
    [self loadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup
- (void)setupTableView
{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

#pragma mark - Data
- (void)loadData
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"quotes" ofType:@"plist"];
    self.items = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    [self.tableView reloadData];
    
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        NSIndexPath *rowIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    //        [self.tableView scrollToRowAtIndexPath:rowIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    //    });
}

#pragma mark - PrototypeCell
- (QuoteTableViewCell *)prototypeCell
{
    if (!_prototypeCell) {
        _prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QuoteTableViewCell class])];
    }
    
    return _prototypeCell;
}

#pragma mark - Configure
- (void)configureCell:(QuoteTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *quote = self.items[indexPath.row];
    
    //cell.numberLabel.text = [NSString stringWithFormat:@"Quote %ld", (long)indexPath.row];
    cell.quoteLabel.text = quote;
}

#pragma mark - UITableViewDataSouce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"number of rows is %ld",self.items.count +1);
    if (section == 0)
    {
        return self.items.count  ;
    }
    
    return 1 ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QuoteTableViewCell class])];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IOS8_OR_ABOVE)
    {
        return UITableViewAutomaticDimension;
    }
    
    //self.prototypeCell.bounds = CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(self.prototypeCell.bounds));
    
    [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];
    
    [self.prototypeCell updateConstraintsIfNeeded];
    [self.prototypeCell layoutIfNeeded];
    
    return [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
}


@end
