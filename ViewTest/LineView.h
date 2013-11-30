//
//  OvalView.h
//  ViewTest
//
//  Created by Matthew Loseke on 11/11/13.
//  Copyright (c) 2013 foo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineView : UIView

- (id)initWithFrame:(CGRect)frame BeginningPoint:(CGPoint)_beginningPoint EndingPoint:(CGPoint)_endingPoint Degrees:(int)degrees Tag:(int)tag;

@property (strong, nonatomic) CALayer *animationLayer;
@property (nonatomic, retain) CAShapeLayer *pathLayer;

@property CGPoint beginningPoint;
@property CGPoint endingPoint;
@property int degrees;
@property UIColor *lineColor;

@end
