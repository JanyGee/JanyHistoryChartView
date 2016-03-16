//
//  JanyHistoryChartView.m
//  HistoryChartView
//
//  Created by Jany on 16/3/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "JanyHistoryChartView.h"
#import "JanyScrollChart.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SHOW_DATA_COUNT 50
#define VERTICAL_COUNT 5
#define VERTICAL_DISTANCE 10.f
@interface JanyHistoryChartView ()
@property (nonatomic, strong) JanyScrollChart *chartView;
@property (nonatomic, strong) NSDictionary *textStyleDict;
@property (nonatomic, strong) UIView *viewBack;
@property (nonatomic, assign) int maxValue;
@end

@implementation JanyHistoryChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, [[UIScreen mainScreen] bounds].size.width - 20.f, 200);

        [self addSubview:self.chartView];
        
    }
    
    return self;
}

- (UIScrollView *)chartView
{
    if (!_chartView) {
        _chartView = [[JanyScrollChart alloc]initWithFrame:CGRectMake(20.f, 0.f, self.frame.size.width - 20.f, self.frame.size.height)];
    }
    return _chartView;
}

- (NSDictionary *)textStyleDict
{
    if (!_textStyleDict) {
        UIFont *font = [UIFont systemFontOfSize:10.f];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        style.alignment = NSTextAlignmentRight;
        _textStyleDict = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style, NSForegroundColorAttributeName:[UIColor grayColor]};
    }
    return _textStyleDict;
}

-(UIView *)viewBack
{
    if (!_viewBack) {
        _viewBack = [[UIView alloc]initWithFrame:CGRectMake(20.f, 0.f, self.frame.size.width - 20.f, self.frame.size.height)];
        [_viewBack setBackgroundColor:[UIColor whiteColor]];
        UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(10.f, 10.f, 50.f, 30.f)];
        l.center = CGPointMake(self.chartView.frame.size.width / 2, self.chartView.frame.size.height / 2);
        l.textColor = [UIColor lightGrayColor];
        l.font = [UIFont systemFontOfSize:10];
        l.text = @"暂无数据";
        [_viewBack addSubview:l];
    }
    
    return _viewBack;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self drawVerticalDataTitle];
}

- (void)refreshChartScrollView
{
    if (self.dataValue.count != 0) {
        
        [self.viewBack removeFromSuperview];
        self.viewBack = nil;
        
        self.chartView.dataValue = self.dataValue;
        self.chartView.dateValue = self.dateValue;
        [self.chartView refreshChartView];
        [self setNeedsDisplay];
        
    }else{
        
        [self addSubview:self.viewBack];
    }

}

- (int)getMaxValueFromArr:(NSArray *)arr
{
    NSNumber *max = [arr valueForKeyPath:@"@max.self"];
    int maxV = max.intValue;
    if (maxV <= 0) {
        maxV = 2000;
    }
    return maxV;
}

- (void)drawVerticalDataTitle
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.alignment = NSTextAlignmentRight;
    
    for (int i = 0; i <= VERTICAL_COUNT; i ++) {
        
        NSString *yValue = [NSString stringWithFormat:@"%d",[self getMaxValueFromArr:self.dataValue] / VERTICAL_COUNT * i];
        
        CGSize size = [yValue boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:8.f], NSParagraphStyleAttributeName:style,
                                                     NSForegroundColorAttributeName:[UIColor grayColor]}
                                           context:nil].size;
        
        CGFloat weightUnit = self.frame.size.height / size.height;
        [yValue drawAtPoint:CGPointMake(0.f, self.frame.size.height - weightUnit * i - 15.f * i - VERTICAL_DISTANCE)
             withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:8.f],
                              NSParagraphStyleAttributeName:style,
                              NSForegroundColorAttributeName:[UIColor grayColor]}];
    }
    
}

@end
