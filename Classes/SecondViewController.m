//
//  SecondViewController.m
//  FlipCardNavigationView
//
//  Created by Kishikawa Katsumi on 10/03/08.
//  Copyright 2010 Kishikawa Katsumi. All rights reserved.
//

#import "SecondViewController.h"
#import "ThirdViewController.h"

@implementation SecondViewController

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
    
	thumbnailView = [[FlipCardView alloc] initWithFrame:contentView.frame];
	thumbnailView.delegate = self;
	thumbnailView.dataSource = self;
	[contentView addSubview:thumbnailView];
	[thumbnailView release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Second View";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark FlipCardViewDataSource Methods

- (NSUInteger)flipCardViewNumberOfRows:(FlipCardView *)flipCardView {
    return 1;
}

- (NSUInteger)flipCardViewNumberOfColumns:(FlipCardView *)flipCardView {
    return 8;
}

- (UIView *)flipCardView:(FlipCardView *)flipCardView thumbnailViewForRow:(NSUInteger)row forColumn:(NSUInteger)column {
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 79.0f, 414.0f)];
    label.backgroundColor = [UIColor whiteColor];
    label.text = [NSString stringWithFormat:@"%d", row * [self flipCardViewNumberOfColumns:flipCardView] + column];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:24.0f];
	return [label autorelease];
}

#pragma mark FlipCardViewDelegate Methods

- (CGFloat)flipCardView:(FlipCardView *)flipCardView heightForRow:(NSUInteger)row {
    return 414.0f;
}

- (CGFloat)flipCardView:(FlipCardView *)flipCardView widthForColumn:(NSUInteger)column {
    return 79.0f;
}

- (void)flipCardView:(FlipCardView *)flipCardView didSelectThumbnailForRow:(NSUInteger)row forColumn:(NSUInteger)column {
    ThirdViewController *controller = [[ThirdViewController alloc] init];
    [thumbnailView pushViewController:controller];
    navigationBar.delegate = self;
    controller.navigationBar = navigationBar;
    [controller release];
    
    [navigationBar pushNavigationItem:controller.navigationItem animated:YES];
}

- (BOOL)navigationBar:(UINavigationBar *)navBar shouldPopItem:(UINavigationItem *)item {
    [thumbnailView popViewController];
    navigationBar.delegate = previousViewController;
    return YES;
}

@end
