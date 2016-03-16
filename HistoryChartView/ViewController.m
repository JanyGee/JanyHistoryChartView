//
//  ViewController.m
//  HistoryChartView
//
//  Created by Jany on 16/3/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController.h"
#import "JanyHistoryChartView.h"

@interface ViewController ()
@property (nonatomic, strong) JanyHistoryChartView *chartView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.chartView = [[JanyHistoryChartView alloc]initWithFrame:CGRectMake(10.f, 200.f, 200.f, 200.f)];
    [self.view addSubview:self.chartView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0.f, 500.f, 80.f, 30.f);
    btn.backgroundColor = [UIColor lightGrayColor];
    [btn addTarget:self action:@selector(btnClickl) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [self btnClick];
    
}

- (void)btnClick
{
    NSMutableArray *arr = [NSMutableArray array];
    int value = 0;
    for (int i = 0; i < 5; i ++) {
        value = arc4random() % 100;
        NSNumber *v = [NSNumber numberWithInt:value];
        [arr addObject:v];
    }
    
    self.chartView.dataValue = nil;
    self.chartView.dateValue = @[@"1-1",@"1-2",@"1-3",@"1-4",@"1-5"];
    [self.chartView refreshChartScrollView];
}

- (void)btnClickl
{
    NSMutableArray *arr = [NSMutableArray array];
    int value = 0;
    for (int i = 0; i < 5; i ++) {
        value = arc4random() % 100;
        NSNumber *v = [NSNumber numberWithInt:value];
        [arr addObject:v];
    }
    
    self.chartView.dataValue = arr;
    self.chartView.dateValue = @[@"1-1",@"1-2",@"1-3",@"1-4",@"1-5"];
    [self.chartView refreshChartScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
