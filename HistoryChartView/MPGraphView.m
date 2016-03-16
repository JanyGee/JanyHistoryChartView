//
//  MPGraphView.m
//
//
//  Created by Alex Manzella on 18/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "MPGraphView.h"
#import "UIBezierPath+curved.h"


@implementation MPGraphView


+ (Class)layerClass{
    return [CAShapeLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        self.dateValue = [NSArray array];
        currentTag = -1;

    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (self.values.count && !self.waitToUpdate) {
        
        ((CAShapeLayer *)self.layer).fillColor=[UIColor clearColor].CGColor;
        ((CAShapeLayer *)self.layer).strokeColor = self.graphColor.CGColor;
        ((CAShapeLayer *)self.layer).path = [self graphPathFromPoints].CGPath;
    }

}

- (void)refreshChart
{
    [self setNeedsDisplay];
}

- (UIBezierPath *)graphPathFromPoints{
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.alignment = NSTextAlignmentRight;
    
    BOOL fill = self.fillColors.count;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for (UIButton* button in buttons) {
        [button removeFromSuperview];
    }
    
    buttons = [[NSMutableArray alloc] init];
    
    
    for (NSInteger i = 0; i < points.count; i++) {
        
        
        CGPoint point=[self pointAtIndex:i];
        
        if(i == 0){
            [path moveToPoint:point];
        }
        
//        MPButton *button=[MPButton buttonWithType:UIButtonTypeCustom tappableAreaOffset:UIOffsetMake(25, 25)];
//        [button setBackgroundColor:self.graphColor];
//        button.layer.cornerRadius = 3;
//        button.frame = CGRectMake(0.f, 0.f, 6.f, 6.f);
//        button.center = point;
//        [button addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
//        button.tag = i;
//        [self addSubview:button];
//        
//        [buttons addObject:button];
        
        if ( points.count - i > 1) {
            
            NSString *yValue = [NSString stringWithFormat:@"%@",self.dateValue[i]];
            UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(point.x + 40.f, self.height - 15.f, 50.f, 20.f)];
            dateLabel.center = CGPointMake(point.x + 50.f, self.height - 15.f);
            dateLabel.textColor = [UIColor lightGrayColor];
            dateLabel.font = [UIFont systemFontOfSize:10];
            dateLabel.textAlignment = NSTextAlignmentCenter;
            dateLabel.text = yValue;
            [self addSubview:dateLabel];
        }
        
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetRGBStrokeColor(context, 0.1, 0.2, 0.3, 1);
        CGFloat dashArray1[] = {3, 2};
        CGContextSetLineDash(context, 0, dashArray1, 2);
        CGContextMoveToPoint(context, point.x, point.y);
        CGContextAddLineToPoint(context, point.x, self.height);
        CGContextStrokePath(context);
        
        [path addLineToPoint:point];
        
    }
    
    if (self.curved) {
        
        path = [path smoothedPathWithGranularity:20];
        
    }
    
    if (points.count >= 2) {
        CGPoint last = [self pointAtIndex:points.count-1];
        CGPoint first = [self pointAtIndex:0];
        
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(first.x - 1.f, self.height - 5.f, 1.f, self.height)];
        v.backgroundColor = [UIColor whiteColor];
        [self addSubview:v];
        
        UIView *v1 = [[UIView alloc]initWithFrame:CGRectMake(first.x, self.height, last.x - first.x, 1.f)];
        v1.backgroundColor = [UIColor whiteColor];
        [self addSubview:v1];
        
        UIView *v2 = [[UIView alloc]initWithFrame:CGRectMake(last.x - 0.5, self.height - 5.f, 1.f, self.height)];
        v2.backgroundColor = [UIColor whiteColor];
        [self addSubview:v2];
        
    }
    
    if(fill){

        CGPoint last = [self pointAtIndex:points.count-1];
        CGPoint first = [self pointAtIndex:0];
        [path addLineToPoint:CGPointMake(last.x,self.height)];
        [path addLineToPoint:CGPointMake(first.x,self.height)];
        [path addLineToPoint:first];
        
    }
    
    if (fill) {
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = path.CGPath;
        
        gradient.mask = maskLayer;
    }
    
    path.lineWidth = self.lineWidth ? self.lineWidth : 1;
    
    return path;
}

- (CGPoint)pointAtIndex:(NSInteger)index{

    
    CGFloat space = 90;
//    
//    if (points.count <= 5) {
//        space = (self.frame.size.width) / (points.count+1);
//    }
    
    return CGPointMake(5 + (space) * index, self.height - ((self.height - PADDING * 2) * [[points objectAtIndex:index] floatValue] + PADDING));
}

- (void)animate{
    
    if(self.detailView.superview){
        
        [self.detailView removeFromSuperview];
    }
    

    gradient.hidden = 0;
    
    ((CAShapeLayer *)self.layer).fillColor = [UIColor clearColor].CGColor;
    ((CAShapeLayer *)self.layer).strokeColor = self.graphColor.CGColor;
    ((CAShapeLayer *)self.layer).path = [self graphPathFromPoints].CGPath;
    
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    animation.fromValue = @0;
//    animation.toValue = @1;
//    animation.duration = self.animationDuration;
//    animation.delegate=self;
//    [self.layer addAnimation:animation forKey:@"MPStroke"];
    
//    for (UIButton* button in buttons) {
//        [button removeFromSuperview];
//    }
    
//    buttons = [[NSMutableArray alloc] init];
//    
//    CGFloat delay = ((CGFloat)self.animationDuration) / (CGFloat)points.count;
//    
//    for (NSInteger i = 0; i < points.count; i++) {
//        
//        CGPoint point=[self pointAtIndex:i];
    
//        MPButton *button=[MPButton buttonWithType:UIButtonTypeCustom];
//        [button setBackgroundColor:self.graphColor];
//        button.layer.cornerRadius = 3;
//        button.frame = CGRectMake(0, 0, 6, 6);
//        button.center = point;
//        [button addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
//        button.tag = i;
//        button.transform=CGAffineTransformMakeScale(0,0);
//        [self addSubview:button];
//        
//        [self performSelector:@selector(displayPoint:) withObject:button afterDelay:delay*i];
//        
//        [buttons addObject:button];
        
        
//    }
    
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{

    self.waitToUpdate = NO;
    gradient.hidden = 0;

}

- (void)displayPoint:(UIButton *)button{
    
        [UIView animateWithDuration:.2 animations:^{
            button.transform=CGAffineTransformMakeScale(1, 1);
        }];
}


#pragma mark Setters

-(void)setFillColors:(NSArray *)fillColors{
    
    [gradient removeFromSuperlayer];
    
    gradient = nil;
    
    if(fillColors.count){
        
        NSMutableArray *colors=[[NSMutableArray alloc] initWithCapacity:fillColors.count];
        
        for (UIColor* color in fillColors) {
            
            if ([color isKindOfClass:[UIColor class]]) {
                [colors addObject:(id)[color CGColor]];
            }else{
                [colors addObject:(id)color];
            }
            
        }
        _fillColors = colors;
        
        gradient = [CAGradientLayer layer];
        gradient.frame = self.bounds;
        gradient.colors = _fillColors;
        [self.layer addSublayer:gradient];
        
    }else{
        
        _fillColors = fillColors;
    }
    
    [self setNeedsDisplay];
    
}

-(void)setCurved:(BOOL)curved{
    _curved=curved;
    [self setNeedsDisplay];
}

@end
