//
//  ViewController.m
//  DVProgressView_Example
//
//  Created by Denis Vashkovski on 24/10/2016.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "ViewController.h"

#import "DVProgressView.h"

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray<NSTimer *> *timers;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:NSStringFromClass([DVProgressView class])];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                             target:self
                                                                                             action:@selector(onRefreshBarButtonTouch)]];
    
    [self.collectionView setScrollEnabled:NO];
    
    self.timers = [NSMutableArray new];
}

#pragma mark UICollectionViewDataSource, UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#define DV_PROGRESS_TYPES_COUNT 6
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return DV_PROGRESS_TYPES_COUNT;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Achievement Cell ID" forIndexPath:indexPath];
    
    DVProgressView *container = (DVProgressView *)[cell viewWithTag:1];
    [container.layer setCornerRadius:8.];
    [container setBackgroundColor:[UIColor lightGrayColor]];
    [container setMinValue:.0];
    [container setMaxValue:4.];
    [container setCurrentValue:.0];
    [container setProgressType:(DVProgressType)indexPath.item];
    
    [self.timers addObject:[NSTimer scheduledTimerWithTimeInterval:.01
                                                           repeats:YES
                                                             block:
                            ^(NSTimer * _Nonnull timer) {
                                if ((container.currentValue + timer.timeInterval) <= container.maxValue) {
                                    container.currentValue += timer.timeInterval;
                                } else {
                                    [timer invalidate];
                                }
                            }]];
    
    UIImageView *imageView = (UIImageView *)[container viewWithTag:101];
    [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"medal%ld", (indexPath.row + 1)]]];
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

#pragma mark - Actions
- (void)onRefreshBarButtonTouch {
    for (NSTimer *timer in self.timers) {
        if (timer.isValid) {
            [timer invalidate];
        }
    }
    [self.timers removeAllObjects];
    
    [self.collectionView reloadData];
}

@end
