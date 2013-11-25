//
//  ViewController.h
//  ViewTest
//
//  Created by Matthew Loseke on 11/10/13.
//  Copyright (c) 2013 foo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <math.h>
#import "LineView.h"

@interface ViewController : UIViewController <AVAudioRecorderDelegate>

@property (strong, nonatomic) AVAudioRecorder *recorder;
@property (strong, nonatomic) NSTimer *timer;
@property int tagCounter;

- (IBAction)animate:(id)sender;

- (void)setupAVAudioRecorder;

@end
