//
//  LineView.m
//  ViewTest
//
//  Created by Matthew Loseke on 11/11/13.
//  Copyright (c) 2013 foo. All rights reserved.
//

#import "LineView.h"

@implementation LineView

@synthesize beginningPoint, endingPoint, degrees, lineColor, animationLayer, pathLayer;

- (id)initWithFrame:(CGRect)frame BeginningPoint:(CGPoint)_beginningPoint EndingPoint:(CGPoint)_endingPoint Degrees:(int)_degrees Tag:(int)tag
{
    self = [super initWithFrame:frame];
    if (self) {
        beginningPoint = _beginningPoint;
        endingPoint = _endingPoint;
        degrees = _degrees;
        [self setTag:tag];
        
        [self setLineColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]];
        
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self setUpPathLayer];
    [self startAnimation];
}

/*
    Not sure why but passing the translated current graphics context in from drawRect and then attempting
    to render into that context failed. (The context was translated so that 0,0 was in the center
    of the frame instead of the default, which is upper left.) So here we translate the layer to get the
    same orientation. If were weren't using CAShapeLayer to draw the UIBezierPath and were just drawing it
    directly, we could do everything in drawRect and have the context translated there, but we need CAShapeLayer
    so we can use CABasicAnimation.
*/
- (void)setUpPathLayer
{
    pathLayer = [CAShapeLayer layer];
    [pathLayer setAffineTransform:CGAffineTransformMakeTranslation(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))];
    pathLayer.strokeColor = lineColor.CGColor;
    pathLayer.lineWidth = 1.0f;

    UIBezierPath *linePath = [self setUpBezierPath];
    pathLayer.path = linePath.CGPath;
    
    [self.layer addSublayer:pathLayer];
}

- (UIBezierPath *)setUpBezierPath
{
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:beginningPoint];
    [linePath addLineToPoint:endingPoint];
    return linePath;
}

- (void)startAnimation
{
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 0.3f;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
}

@end
