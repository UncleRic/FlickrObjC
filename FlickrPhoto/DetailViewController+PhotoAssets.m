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


//- (void)addNewAssetWithImage:(UIImage *)image toAlbum:(PHAssetCollection *)album {
//    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//        // Request creating an asset from the image.
//        PHAssetChangeRequest *createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:self.image];
//        // Request editing the album.
//        PHAssetCollectionChangeRequest *albumChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:album];
//        // Get a placeholder for the new asset and add it to the album editing request.
//        PHObjectPlaceholder *assetPlaceholder = [createAssetRequest placeholderForCreatedAsset];
//        [albumChangeRequest addAssets:@[ assetPlaceholder ]];
//    } completionHandler:^(BOOL success, NSError *error) {
//        NSLog(@"Finished adding asset. %@", (success ? @"Success" : error));
//    }];
//}

// -----------------------------------------------------------------------------------------------------------------

- (void)savePhoto {
    UIImage *myImage = self.imageView.image;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest *changeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:myImage];
        changeRequest.creationDate = [NSDate date];
    } completionHandler:^(BOOL success, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                NSLog(@"*** Successfully Saved ***");
            }
            else {
                NSLog(@"error saving to photos: %@", error);
            }
        });
    }];
    
}



@end
