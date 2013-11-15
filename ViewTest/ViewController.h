//
//  ViewController.h
//  ViewTest
//
//  Created by Matthew Loseke on 11/10/13.
//  Copyright (c) 2013 foo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <math.h>
#import "LineView.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) NSTimer *timer;
@property int tagCounter;

- (IBAction)animate:(id)sender;

@end
