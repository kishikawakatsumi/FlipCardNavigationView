//
//  ThirdViewController.m
//  FlipCardNavigationView
//
//  Created by Kishikawa Katsumi on 10/03/09.
//  Copyright 2010 Kishikawa Katsumi. All rights reserved.
//

#import "ThirdViewController.h"

@implementation ThirdViewController

@synthesize navigationBar;
@synthesize previousViewController;

- (void)dealloc {
    [super dealloc];
}

- (void)loadView {
	UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 414.0f)];
    contentView.backgroundColor = [UIColor grayColor];
	self.view = contentView;
	[contentView release];
    
	UILabel *label = [[UILabel alloc] initWithFrame:contentView.frame];
    label.backgroundColor = [UIColor whiteColor];
    label.text = @"Third View";
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:36.0f];
    [contentView addSubview:label];
    [label release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Third View";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)navigationBar:(UINavigationBar *)navBar shouldPopItem:(UINavigationItem *)item {
    [thumbnailView popViewController];
    navigationBar.delegate = previousViewController;
    return YES;
}

#pragma mark - Tap Detect

#define DOUBLE_TAP_DELAY 0.35

CGPoint midpointBetweenPoints(CGPoint a, CGPoint b) {
    CGFloat x = (a.x + b.x) / 2.0;
    CGFloat y = (a.y + b.y) / 2.0;
    return CGPointMake(x, y);
}

- (void)handleSingleTap {
}

- (void)handleDoubleTap {
    [navigationBar popNavigationItemAnimated:YES];
}

- (void)handleTwoFingerTap {
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleSingleTap) object:nil];
    
    if ([[event touchesForView:self.view] count] > 1) {
        multipleTouches = YES;
    }
    if ([[event touchesForView:self.view] count] > 2) {
        twoFingerTapIsPossible = NO;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    BOOL allTouchesEnded = ([touches count] == [[event touchesForView:self.view] count]);
    
    if (!multipleTouches) {
        UITouch *touch = [touches anyObject];
        tapLocation = [touch locationInView:self.view];
        
        if ([touch tapCount] == 1) {
            [self performSelector:@selector(handleSingleTap) withObject:nil afterDelay:DOUBLE_TAP_DELAY];
        } else if([touch tapCount] == 2) {
            [self handleDoubleTap];
        }
    } else if (multipleTouches && twoFingerTapIsPossible) { 
        if ([touches count] == 2 && allTouchesEnded) {
            int i = 0; 
            int tapCounts[2]; CGPoint tapLocations[2];
            for (UITouch *touch in touches) {
                tapCounts[i]    = [touch tapCount];
                tapLocations[i] = [touch locationInView:self.view];
                i++;
            }
            if (tapCounts[0] == 1 && tapCounts[1] == 1) {
                tapLocation = midpointBetweenPoints(tapLocations[0], tapLocations[1]);
                [self handleTwoFingerTap];
            }
        } else if ([touches count] == 1 && !allTouchesEnded) {
            UITouch *touch = [touches anyObject];
            if ([touch tapCount] == 1) {
                tapLocation = [touch locationInView:self.view];
            } else {
                twoFingerTapIsPossible = NO;
            }
        } else if ([touches count] == 1 && allTouchesEnded) {
            UITouch *touch = [touches anyObject];
            if ([touch tapCount] == 1) {
                tapLocation = midpointBetweenPoints(tapLocation, [touch locationInView:self.view]);
                [self handleTwoFingerTap];
            }
        }
    }
    
    if (allTouchesEnded) {
        twoFingerTapIsPossible = YES;
        multipleTouches = NO;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    twoFingerTapIsPossible = YES;
    multipleTouches = NO;
}

@end
