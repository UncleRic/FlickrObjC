//
//  DetailViewController+PhotoAssets.m
//  FlickrPhoto
//
//  Created by Frederick C. Lee on 2/11/18.
//  Copyright © 2018 Frederick C. Lee. All rights reserved.
//

#import "DetailViewController+PhotoAssets.h"
#

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


- (void)addNewAssetWithImage:(UIImage *)image toAlbum:(PHAssetCollection *)album {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // Request creating an asset from the image.
        PHAssetChangeRequest *createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:self.image];
        // Request editing the album.
        PHAssetCollectionChangeRequest *albumChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:album];
        // Get a placeholder for the new asset and add it to the album editing request.
        PHObjectPlaceholder *assetPlaceholder = [createAssetRequest placeholderForCreatedAsset];
        [albumChangeRequest addAssets:@[ assetPlaceholder ]];
    } completionHandler:^(BOOL success, NSError *error) {
        NSLog(@"Finished adding asset. %@", (success ? @"Success" : error));
    }];
}

- (void)savePhoto {
//    
//    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
//                                                                          subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
//    PHCollection *collection = fetchResult[indexPath.row];
//    if ([collection isKindOfClass:[PHAssetCollection class]]) {
//        PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
//        
//        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:(PHAssetCollection *)assetCollection options:nil];
//        assetGridViewController.assetsFetchResults = assetsFetchResult;
//        assetGridViewController.assetCollection = assetCollection;
//    }
    
    
    
    
    
    
    
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest *assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:self.image];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        // Do Something.
    }];
    
}



@end
