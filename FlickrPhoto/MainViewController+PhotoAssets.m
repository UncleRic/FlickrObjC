//
//  MainViewController+PhotoAssets.m
//  FlickrPhoto
//
//  Created by Frederick C. Lee on 2/11/18.
//  Copyright © 2018 Frederick C. Lee. All rights reserved.
//

#import "MainViewController+PhotoAssets.h"
#import <Photos/PHPhotoLibrary.h>

@implementation MainViewController (PhotoAssets)

- (void)photoLibrary {
    Boolean status = [self DetermineStatus];
    NSLog(@"Photo Library Status: %s", status? "true" : "false");
    
}

- (Boolean)DetermineStatus {
    
    Boolean status = [PHPhotoLibrary authorizationStatus];
    
    
    return status;
}

@end
