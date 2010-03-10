//
//  FlipCardView.m
//  FlipCardNavigationView
//
//  Created by Kishikawa Katsumi on 10/03/08.
//  Copyright 2010 Kishikawa Katsumi. All rights reserved.
//

#import "FlipCardView.h"
#import "FlipCardThumbnailButton.h"
#import <QuartzCore/QuartzCore.h>

#define ANIMATION_DURATION 0.5

@implementation FlipCardView

@synthesize delegate;
@synthesize dataSource;
@synthesize nextViewController;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        thumbnailView = [[UIScrollView alloc] initWithFrame:frame];
        thumbnailView.delegate = self;
        [self addSubview:thumbnailView];
        [thumbnailView release];
    }
    return self;
}

- (void)dealloc {
    [nextViewController release];
    [super dealloc];
}

- (void)setDataSource:(id)d {
    dataSource = d;
    flags.dataSourceNumberOfRows = [dataSource respondsToSelector:@selector(flipCardViewNumberOfRows:)];
    flags.dataSourceNumberOfColumns = [dataSource respondsToSelector:@selector(flipCardViewNumberOfColumns:)];
    flags.dataSourceThumbnailView = [dataSource respondsToSelector:@selector(flipCardView:thumbnailViewForRow:forColumn:)];
    flags.dataSourceFullView = [dataSource respondsToSelector:@selector(flipCardView:fullViewForRow:forColumn:)];
}

- (void)setDelegate:(id)d {
    delegate = d;
    flags.delegateHeightForRow = [delegate respondsToSelector:@selector(flipCardView:heightForRow:)];
    flags.delegateWidthForColumn = [delegate respondsToSelector:@selector(flipCardView:widthForColumn:)];
    flags.delegateDidSelectThumbnail = [delegate respondsToSelector:@selector(flipCardView:didSelectThumbnailForRow:forColumn:)];
}

- (UIEdgeInsets)contentInset {
    return thumbnailView.contentInset;
}

- (UIEdgeInsets)scrollIndicatorInsets {
    return thumbnailView.scrollIndicatorInsets;
}

- (void)setContentInset:(UIEdgeInsets)insets {
    thumbnailView.contentInset = insets;
}

- (void)setScrollIndicatorInsets:(UIEdgeInsets)insets {
    thumbnailView.scrollIndicatorInsets = insets;
}

- (void)setBackgroundColor:(UIColor *)color {
    thumbnailView.backgroundColor = color;
}

- (void)layoutSubviews {
    if (!initialized) {
        initialized = YES;
        if (flags.dataSourceNumberOfRows) {
            numberOfRows = [dataSource flipCardViewNumberOfRows:self];
        }
        if (flags.dataSourceNumberOfColumns) {
            numberOfColumns = [dataSource flipCardViewNumberOfColumns:self];
        }
        numberOfViews = numberOfRows * numberOfColumns;
        CGFloat width = 0.0f;
        CGFloat height = 0.0f;
        UIView *view = nil;
        for (NSUInteger row = 0; row < numberOfRows; row++) {
            for (NSUInteger column = 0; column < numberOfColumns; column++) {
                if (flags.dataSourceThumbnailView) {
                    view = [dataSource flipCardView:self thumbnailViewForRow:row forColumn:column];
                }
                view.userInteractionEnabled = YES;
                
                CGRect rect = view.frame;
                if (column > 0) {
                    if (flags.delegateWidthForColumn) {
                        rect.origin.x = column * [delegate flipCardView:self widthForColumn:column - 1] + 1 * column;
                    } else {
                        rect.origin.x = column * view.frame.size.width + 1 * column;
                    }
                } else {
                    rect.origin.x = 0.0f;
                }
                if (row > 0) {
                    if (flags.delegateHeightForRow) {
                        rect.origin.y = row * [delegate flipCardView:self heightForRow:row - 1] + 1 * row;
                    } else {
                        rect.origin.y = row * rect.size.height + 1 * row;
                    }
                } else {
                    rect.origin.y = 0.0f;
                }
                
                view.frame = rect;
                
                FlipCardThumbnailButton *button = [[FlipCardThumbnailButton alloc] init];
                button.frame = CGRectMake(0.0f, 0.0f, view.frame.size.width, view.frame.size.height);
                button.exclusiveTouch = YES;
                [button addTarget:self action:@selector(thumbnailButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
                
                [thumbnailView addSubview:view];
                
                [view addSubview:button];
                [button release];
                
                if (row == 0) {
                    width += view.frame.size.width;
                }
            }
            height += view.frame.size.height;
        }
        thumbnailView.contentSize = CGSizeMake(width, height);
    }
}

- (void)thumbnailButtonPushed:(id)sender {
    FlipCardThumbnailButton *button = (FlipCardThumbnailButton *)sender;
    lastSelected = button;
    if (flags.delegateDidSelectThumbnail) {
        [delegate flipCardView:self didSelectThumbnailForRow:button.row forColumn:button.column];
    }
}

- (void)pushViewController:(UIViewController *)controller {
    self.nextViewController = controller;
    
    UIView *selectedView = lastSelected.superview;
    
    UIImageView *thumbnailImageView = [[UIImageView alloc] initWithFrame:[thumbnailView convertRect:selectedView.frame toView:self]];
    
    UIGraphicsBeginImageContext(thumbnailImageView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [selectedView.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    thumbnailImageView.image = image;
    thumbnailImageView.userInteractionEnabled = YES;
    [self addSubview:thumbnailImageView];
    [thumbnailImageView release];
    
    thumbFrame = thumbnailImageView.frame;
    
    [self performSelector:@selector(flipThumbViewToNextView:) withObject:thumbnailImageView afterDelay:0.0];
}

- (void)popViewController {
    UIView *nextView = nextViewController.view;
    UIView *thumbnailImageView = nextView.superview;
    
    [UIView beginAnimations:nil context:thumbnailImageView];
    [UIView setAnimationDuration:ANIMATION_DURATION];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:thumbnailImageView cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(flipAnimationFinished:finished:context:)];
    thumbnailImageView.frame = thumbFrame;
    [nextView removeFromSuperview];
    [UIView commitAnimations];
}

- (void)flipThumbViewToNextView:(UIView *)thumbnailImageView {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:ANIMATION_DURATION];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:thumbnailImageView cache:YES];
    thumbnailImageView.frame = self.frame;
    [thumbnailImageView addSubview:nextViewController.view];
    [UIView commitAnimations];
}

- (void)flipAnimationFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
    UIView *thumbnailImageView = (UIView *)context;
    [thumbnailImageView removeFromSuperview];
}

@end
