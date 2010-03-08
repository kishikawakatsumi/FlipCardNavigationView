//
//  FlipCardView.h
//  FlipCardNavigationView
//
//  Created by Kishikawa Katsumi on 10/03/08.
//  Copyright 2010 Kishikawa Katsumi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlipCardThumbnailButton;

@interface FlipCardView : UIView<UIScrollViewDelegate> {
    UIScrollView *thumbnailView;
    BOOL initialized;
    
    id delegate;
    id dataSource;
    NSUInteger numberOfViews;
    NSUInteger numberOfRows;
    NSUInteger numberOfColumns;
    struct {
        unsigned int dataSourceNumberOfRows:1;
        unsigned int dataSourceNumberOfColumns:1;
        unsigned int dataSourceThumbnailView:1;
        unsigned int dataSourceFullView:1;
        unsigned int delegateHeightForRow:1;
        unsigned int delegateWidthForColumn:1;
        unsigned int delegateDidSelectThumbnail:1;
    } flags;
    
    UIViewController *nextViewController;
    FlipCardThumbnailButton *lastSelected;
    CGRect thumbFrame;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) id dataSource;
@property (nonatomic) UIEdgeInsets contentInset;
@property (nonatomic) UIEdgeInsets scrollIndicatorInsets;

@property (nonatomic, retain) UIViewController *nextViewController;

- (void)pushViewController:(UIViewController *)controller;
- (void)popViewController;

@end

@protocol FlipCardViewDataSource
- (NSUInteger)flipCardViewNumberOfRows:(FlipCardView *)flipCardView;
- (NSUInteger)flipCardViewNumberOfColumns:(FlipCardView *)flipCardView;
- (UIView *)flipCardView:(FlipCardView *)flipCardView thumbnailViewForRow:(NSUInteger)row forColumn:(NSUInteger)column;
- (UIView *)flipCardView:(FlipCardView *)flipCardView fullViewForRow:(NSUInteger)row forColumn:(NSUInteger)column;
@end

@protocol FlipCardViewDelegate
- (CGFloat)flipCardView:(FlipCardView *)flipCardView heightForRow:(NSUInteger)row;
- (CGFloat)flipCardView:(FlipCardView *)flipCardView widthForColumn:(NSUInteger)column;
@optional
- (void)flipCardView:(FlipCardView *)flipCardView didSelectThumbnailForRow:(NSUInteger)row forColumn:(NSUInteger)column;
@end
