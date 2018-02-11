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
    [self RequestLibraryAccess];
    
}

- (void)RequestLibraryAccess {
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        
        switch (status) {
            case PHAuthorizationStatusAuthorized:
                NSLog(@"PHAuthorizationStatusAuthorized");
                break;
                
            case PHAuthorizationStatusDenied:
                NSLog(@"PHAuthorizationStatusDenied");
                break;
            case PHAuthorizationStatusNotDetermined:
                NSLog(@"PHAuthorizationStatusNotDetermined");
                break;
            case PHAuthorizationStatusRestricted:
                NSLog(@"PHAuthorizationStatusRestricted");
                break;
        }
        
    }];
   
}

@end
