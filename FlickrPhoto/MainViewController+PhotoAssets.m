//
//  MainViewController+PhotoAssets.m
//  FlickrPhoto
//
//  Created by Frederick C. Lee on 2/11/18.
//  Copyright © 2018 Frederick C. Lee. All rights reserved.
//

#import "MainViewController+PhotoAssets.h"


@implementation MainViewController (PhotoAssets)

- (void)SaveImage:(UIImage *)image {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // Do Something.
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        // Do Something.
    }];
   
}

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

//func saveImage(image: UIImage, completion: (Bool, NSError?) -> Void) {
//
//    if assetCollection == nil {
//        return   // If there was an error upstream, skip the save.
//    }
//
//    PHPhotoLibrary.sharedPhotoLibrary().performChanges({
//        let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(image)
//        let assetPlaceholder = assetChangeRequest.placeholderForCreatedAsset
//        let albumChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: self.assetCollection)
//        albumChangeRequest?.addAssets([assetPlaceholder!])
//    }, completionHandler: completion )
//}
//
//}


@end
