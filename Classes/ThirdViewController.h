//
//  ThirdViewController.h
//  FlipCardNavigationView
//
//  Created by Kishikawa Katsumi on 10/03/09.
//  Copyright 2010 Kishikawa Katsumi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlipCardView.h"

@interface ThirdViewController : UIViewController {
    FlipCardView *thumbnailView;
    UINavigationBar *navigationBar;
    UIViewController *previousViewController;

    BOOL singleTapReady;
    CGPoint tapLocation;
    BOOL multipleTouches;
    BOOL twoFingerTapIsPossible;
}

@property (nonatomic, assign) UINavigationBar *navigationBar;
@property (nonatomic, assign) UIViewController *previousViewController;

@end
