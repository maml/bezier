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

@synthesize timer, tagCounter, recorder;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupAVAudioRecorder];
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
        [[self view] addSubview:[[LineView alloc] initWithFrame:rect BeginningPoint:innerPoint EndingPoint:outerPoint Degrees:degrees Tag:(int)tagCounter]];
        tagCounter++;
    }
    tagCounter = 100;
    
}

- (IBAction)animate:(id)sender {
    [recorder recordForDuration:30];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(timerDidTick) userInfo:nil repeats:YES];
}

- (void)timerDidTick
{
    LineView *lineView = (LineView *)[self.view viewWithTag:tagCounter];
    
    // On each tick of the timer we want to draw a new instance of LineView. The new instance of LineView that we draw
    // will be based on the lineView we have a reference to from above. Since instances of LineView have its beginning
    // and ending points as properties we'll be able to draw essentially the same line. But instead of drawing the same
    // line we want the line we draw to be representative of the current decibel reading of this controller's instance of
    // AVAudioRecorder taken immediately before the drawing operation. To make the line representative of the decibel
    // reading we can calculate what percentage of the total possible decibel values is the current decibel reading. Then, whatever
    // percentage that is, we can make the line's length the same percentage of the total possible length of the line, where
    // the total possible length of the line is the distance between the two points (beginning and end points) that make up
    // the line we're basing the new line off of. Since we've hardcoded the inner and outer radii we know what this is:
    // 130 - 70, or, 60.
    // To get the new ending coordinate we need to calculate the ∆x and ∆y from the original beginning and ending points,
    // mulitply those values by the percentage of the decibel reading, and then plug everything back into the pythagorean
    // equation and solve for the new outer x,y coordinate. not sure how to do that with code so . . .
    // if when we originally create the base line we store the degree used to calculate its points we should be able to more
    // easily get the new coordinates.
  
    // second time this appears, refactor.
    int innerRadius = 70;
    int outerRadius = innerRadius + 60;
    CGPoint center = self.view.center;
    CGRect rect = CGRectMake((center.x - outerRadius), (center.y - outerRadius), 2 * outerRadius, 2 * outerRadius);
   
    int degrees = lineView.degrees;
    //int hardcodedRandomizedRadiusHaha = (innerRadius + arc4random() % 70);

    [recorder updateMeters];
    float dbLevel = [recorder averagePowerForChannel:0];
    float dbLevelMin = -65.0;
    float dbLevelMax = 5.0;
    float dbLevelRatio = (dbLevel - dbLevelMin) / abs(dbLevelMin - dbLevelMax);
    //NSLog(@"%f", dbLevel);
    int radiusDiff = outerRadius - innerRadius;
    float dbBasedOuterPoint = dbLevelRatio * radiusDiff;
    
    CGPoint outerPoint = CGPointMake((innerRadius + dbBasedOuterPoint) * cos((degrees * M_PI / 180)), (innerRadius + dbBasedOuterPoint) * sin((degrees * M_PI / 180)));
   
    LineView *newLine = [[LineView alloc] initWithFrame:rect BeginningPoint:lineView.beginningPoint EndingPoint:outerPoint Degrees:lineView.degrees Tag:tagCounter];
    [newLine setLineColor:[UIColor colorWithRed:252.0f/255.0f green:63.0f/255.0f blue:67.0f/255.0f alpha:1.0f]];
    [[self view] addSubview:newLine];
    
    tagCounter++;
}

- (void)setupAVAudioRecorder
{
    // settings for the recorder
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
   
    // sets the path for audio file (placeholder)
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"foo.m4a",
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];

    // initiate recorder
    NSError *error;
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:&error];
    recorder.delegate = self;
    [recorder prepareToRecord];
    recorder.meteringEnabled = YES;
}



@end








