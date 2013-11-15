//
//  ViewController.m
//  ViewTest
//
//  Created by Matthew Loseke on 11/10/13.
//  Copyright (c) 2013 foo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize timer, tagCounter;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tagCounter = 100;
    
    // The desired affect is a series of straight lines drawn about an implied circle.
    
    // Most of the parameters that determine the overall look of the drawing
    // are hard-coded but we should take time to make these as dynamic as possible for handling
    // multiple window / screen sizes, device orientation changes, etc.
    
    // The declaration of radii suggests we will be rendering circles but this is not the case. We
    // need to calculate corresponding points on an 'inner' and 'outer' circle only to be able to
    // draw a line that connects them. In doing so we achieve the desired affect.
    int innerRadius = 70;
    int outerRadius = innerRadius + 60;
  
    // Finding the center of the currents view's bounds helps us to properly position the CGRect we declare
    // below. The CGRect we declare below will be used as the frame onto which all instances of LineView will
    // be drawn. This instance of CGRect is simply a square that encapsulates all the outerPoints we will calculate.
    // The outerPoints we will calculate will be based on the outerRadius declared above.
    CGPoint center = self.view.center;
    CGRect rect = CGRectMake((center.x - outerRadius), (center.y - outerRadius), 2 * outerRadius, 2 * outerRadius);
    
    // We calculate the inner and outer points for every 3˚ interval.
    for (int degrees = 0; degrees < 360; degrees+=3) {
        
        // The following are basic equations for determining points on a circle. Note the degrees to radians conversion.
        // 3 methods could be pulled out here: i) degreesToRadians, ii) xCoordinate, and iii) yCoordinate
        CGPoint innerPoint = CGPointMake(innerRadius * cos((degrees * M_PI / 180)), innerRadius * sin((degrees * M_PI / 180)));
        CGPoint outerPoint = CGPointMake(outerRadius * cos((degrees * M_PI / 180)), outerRadius * sin((degrees * M_PI / 180)));
        
        // CGRect has a ULO coordinate system which means that, while the rect passed below to LineView as its frame
        // is itself centered within this controller instance's view, the points we've calculated, which are for a
        // 0,0 cartesian system, will be drawn from its upper left corner. We don't want them to be drawn from the upper left
        // corner, we want them to be centered within its area. Updating each line's origin to the center of rect can
        // be made by transforming the current graphics context in LineView's drawRect: method, and this is what we've chosen to do.
        // see: View Programming Guide for iOS -> View Geometry and Coordinate Systems -> Coordinate System Transformations
        // "Rather than fix the position of an object at some location in your view, it is simpler to create each object relative
        // to a fixed point, typically (0, 0), and use a transform to position the object immediately prior to drawing."
        [[self view] addSubview:[[LineView alloc] initWithFrame:rect BeginningPoint:innerPoint EndingPoint:outerPoint Tag:(int)tagCounter]];
        tagCounter++;
    }
    tagCounter = 100;
    
}

- (IBAction)animate:(id)sender {
    timer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(timerDidTick) userInfo:nil repeats:YES];
}

- (void)timerDidTick
{
    LineView *lineView = (LineView *)[self.view viewWithTag:tagCounter];
    
    // LineView's are drawn with UIBezierPath - they get their color from having had the stroke set and then calling stroke.
    // lineColor is a synthesized property with a type of UIColor that's upon which we call setStroke. Calling setNeedsDisplay
    //invalidates the view causing it to be updated in the next drawing cylce.
    [lineView setLineColor:[UIColor colorWithRed:252.0f/255.0f green:63.0f/255.0f blue:67.0f/255.0f alpha:1.0f]];
    [lineView setNeedsDisplay];
    tagCounter++;
}

@end