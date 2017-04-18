//
//  PaletteView.m
//  NotePad
//
//  Created by 陈晓磊 on 17/3/18.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import "PaletteView.h"

@implementation PaletteView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
       
        self.lineMArr = [NSMutableArray arrayWithCapacity:1];
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect {

    //得到上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置画笔的颜色
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    //设置画笔的粗细
    CGContextSetLineWidth(context, 2.0);
    
    for (int i = 0; i < self.lineMArr.count; i ++) {
        NSMutableArray *pointMArr = [self.lineMArr objectAtIndex:i];
        
        for (int j = 0; j < pointMArr.count - 1; j ++) {
            //拿出小数组中的两个点
            NSValue *firstPointValue = [pointMArr objectAtIndex:j];
            NSValue *secondPointValue = [pointMArr objectAtIndex:j + 1];
            
            CGPoint firstPoint = [firstPointValue CGPointValue];
            CGPoint secondPoint = [secondPointValue CGPointValue];
            
            //把笔触移动一个点
            CGContextMoveToPoint(context, firstPoint.x, firstPoint.y);
            //笔触和另外一个点形成路径
            CGContextAddLineToPoint(context, secondPoint.x, secondPoint.y);
        }
    }
    
    //真正绘制
    CGContextStrokePath(context);
}

// 从触摸屏幕开始 创建一个点数组
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //点数组，用于存放每一条线的点
    NSMutableArray *pointMArr = [NSMutableArray arrayWithCapacity:1];
    
    [self.lineMArr addObject:pointMArr];
}

// 从移动开始
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //拿到触摸点的位置
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    //拿到触摸点所属的线
    NSMutableArray *pointMArr = [self.lineMArr lastObject];
    NSValue *pointValue = [NSValue valueWithCGPoint:point];
    
    //保存每一个触摸点的值
    [pointMArr addObject:pointValue];
    
    //重绘页面
    [self setNeedsDisplay];
}

@end
