//
//  LineView.m
//  ViewTest
//
//  Created by Matthew Loseke on 11/11/13.
//  Copyright (c) 2013 foo. All rights reserved.
//

#import "LineView.h"

@implementation LineView

@synthesize beginningPoint, endingPoint, lineColor;

- (id)initWithFrame:(CGRect)frame BeginningPoint:(CGPoint)_beginningPoint EndingPoint:(CGPoint)_endingPoint Tag:(int)tag
{
    self = [super initWithFrame:frame];
    if (self) {
        beginningPoint = _beginningPoint;
        endingPoint = _endingPoint;
        [self setTag:tag];
        [self setLineColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    
    [lineColor setStroke];

    [aPath moveToPoint:beginningPoint];
    [aPath addLineToPoint:endingPoint];
    [aPath closePath];
   
    CGContextRef aRef = UIGraphicsGetCurrentContext();
    
    // Adjust the view's origin. We want 0,0 to be the at the center of this view's frame,
    // instead of the upper-left, which it is by default.
    CGContextTranslateCTM(aRef, CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
    
    aPath.lineWidth = 1;
    [aPath stroke];
}

@end
