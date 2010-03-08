//
//  FlipCardThumbnailButton.h
//  FlipCardNavigationView
//
//  Created by Kishikawa Katsumi on 10/03/08.
//  Copyright 2010 Kishikawa Katsumi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlipCardThumbnailButton : UIButton {
	NSUInteger row;
	NSUInteger column;
}

@property (nonatomic) NSUInteger row;
@property (nonatomic) NSUInteger column;

@end
