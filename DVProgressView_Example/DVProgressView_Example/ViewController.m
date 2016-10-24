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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:NSStringFromClass([DVProgressView class])];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                             target:self
                                                                                             action:@selector(onRefreshBarButtonTouch)]];
    
    [self.collectionView setScrollEnabled:NO];
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
    
    dispatch_async(dispatch_queue_create([NSString stringWithFormat:
                                          @"test_%d_%d",
                                          (int)indexPath.section,
                                          (int)indexPath.item].UTF8String, NULL), ^{
        float currentValue = .0;
        float step = .01;
        
        while ((currentValue += step) <= container.maxValue) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [container setCurrentValue:currentValue];
            });
            
            [NSThread sleepForTimeInterval:step];
        }
    });
    
    UIImageView *imageView = (UIImageView *)[container viewWithTag:101];
    [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"medal%ld", indexPath.row]]];
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

#pragma mark - Actions
- (void)onRefreshBarButtonTouch {
    
}

@end
