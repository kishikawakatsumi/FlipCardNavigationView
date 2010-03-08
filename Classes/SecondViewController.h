//
//  SecondViewController.h
//  FlipCardNavigationView
//
//  Created by Kishikawa Katsumi on 10/03/08.
//  Copyright 2010 Kishikawa Katsumi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlipCardView.h"

@interface SecondViewController : UIViewController {
    FlipCardView *thumbnailView;
    UINavigationBar *navigationBar;
    UIViewController *previousViewController;
}

@property (nonatomic, assign) UINavigationBar *navigationBar;
@property (nonatomic, assign) UIViewController *previousViewController;

@end
