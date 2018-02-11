//
//  PhotoCollectionView.m
//  FlickrPhoto
//
//  Created by Frederick C. Lee on 2/10/18.
//  Copyright © 2018 Frederick C. Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoCollectionView.h"

@implementation PhotoCollectionView

- (void)recenterIfNecessary {
    CGPoint currentOffset = self.contentOffset;
    CGFloat contentHeight = self.contentSize.height;
    CGFloat centerOffsetY = (contentHeight - self.bounds.size.width) / 2.0;
    CGFloat distanceFromCenter = fabs(currentOffset.y - centerOffsetY);
    
    if (distanceFromCenter > (contentHeight / 4.0)) {
        NSLog(@"** recenterIfNecessary **");
        self.contentOffset = CGPointMake(currentOffset.x, centerOffsetY);
        // Move content by the same amount so it appears to stay still.
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self recenterIfNecessary];
}

@end

