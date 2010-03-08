//
//  FirstViewController.m
//  FlipCardNavigationView
//
//  Created by Kishikawa Katsumi on 10/03/08.
//  Copyright Kishikawa Katsumi 2010. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"

@implementation FirstViewController

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
} 

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark FlipCardViewDataSource Methods

- (NSUInteger)flipCardViewNumberOfRows:(FlipCardView *)flipCardView {
    return 8;
}

- (NSUInteger)flipCardViewNumberOfColumns:(FlipCardView *)flipCardView {
    return 5;
}

- (UIView *)flipCardView:(FlipCardView *)flipCardView thumbnailViewForRow:(NSUInteger)row forColumn:(NSUInteger)column {
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 106.0f, 106.0f)];
    label.backgroundColor = [UIColor whiteColor];
    label.text = [NSString stringWithFormat:@"%d", row * [self flipCardViewNumberOfColumns:flipCardView] + column];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:24.0f];
	return [label autorelease];
}

#pragma mark FlipCardViewDelegate Methods

- (CGFloat)flipCardView:(FlipCardView *)flipCardView heightForRow:(NSUInteger)row {
    return 106.0f;
}

- (CGFloat)flipCardView:(FlipCardView *)flipCardView widthForColumn:(NSUInteger)column {
    return 106.0f;
}

- (void)flipCardView:(FlipCardView *)flipCardView didSelectThumbnailForRow:(NSUInteger)row forColumn:(NSUInteger)column {
    SecondViewController *controller = [[SecondViewController alloc] init];
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    navigationBar.delegate = self;
    
    controller.navigationBar = navigationBar;
    controller.previousViewController = self;
    
    [flipCardView pushViewController:controller];
    [controller release];
    
    [navigationBar pushNavigationItem:controller.navigationItem animated:YES];
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    [thumbnailView popViewController];
    return YES;
}

@end
