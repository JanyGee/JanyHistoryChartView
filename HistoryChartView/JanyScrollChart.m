//
//  JanyScrollChart.m
//  HistoryChartView
//
//  Created by Jany on 16/3/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "JanyScrollChart.h"


#define SHOW_DATA_COUNT 5
@implementation JanyScrollChart

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setContentSize:CGSizeMake(SHOW_DATA_COUNT * 100, self.frame.size.height)];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setBounces:NO];
        
        [self addSubview:self.graphView];
    }
    
    return self;
}

- (MPGraphView *)graphView
{
    if (!_graphView) {
        
        _graphView = [[MPGraphView alloc]initWithFrame:CGRectMake(0.f, 0.f, SHOW_DATA_COUNT * 100, self.frame.size.height)];
        _graphView.fillColors = @[[UIColor redColor],[UIColor colorWithRed:0 green:1 blue:0 alpha:0.5],[UIColor whiteColor]];
        _graphView.graphColor = [UIColor greenColor];
        _graphView.waitToUpdate = NO;
        _graphView.curved = YES;
    }
    
    return _graphView;
}


- (void)refreshChartView
{
    self.graphView.values = self.dataValue;
    self.graphView.dateValue = self.dateValue;
    
    int count = (int)self.dataValue.count + 1;
    [self setContentSize:CGSizeMake(count * 80, self.frame.size.height)];
    self.graphView.frame = CGRectMake(0.f, 0.f, count * 80, self.frame.size.height);
    
    [self.graphView refreshChart];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
    // Drawing code
//}

@end
