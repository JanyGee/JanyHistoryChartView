//
//  JanyScrollChart.h
//  HistoryChartView
//
//  Created by Jany on 16/3/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPGraphView.h"

@interface JanyScrollChart : UIScrollView
@property (nonatomic, strong) MPGraphView *graphView;
@property (nonatomic, strong) NSArray *dataValue;
@property (nonatomic, strong) NSArray *dateValue;

- (void)refreshChartView;
@end
