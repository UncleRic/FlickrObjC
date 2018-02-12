//
//  DetailViewController+PhotoAssets.m
//  FlickrPhoto
//
//  Created by Frederick C. Lee on 2/11/18.
//  Copyright © 2018 Frederick C. Lee. All rights reserved.
//

#import "DetailViewController+PhotoAssets.h"


@implementation DetailViewController (PhotoAssets)
#pragma mark - Class Methods

+ (void)RequestLibraryAccess {
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

#pragma mark - Instance Methods
// -----------------------------------------------------------------------------------------------------------------

- (void)savePhoto {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest *assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:self.image];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        // Do Something.
    }];
    
}



@end
