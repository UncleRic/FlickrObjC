//
//  MainViewController+PhotoAssets.h
//  FlickrPhoto
//
//  Created by Frederick C. Lee on 2/11/18.
//  Copyright © 2018 Frederick C. Lee. All rights reserved.
//

#import "MainViewController.h"
#import <Photos/PHPhotoLibrary.h>
#import <Photos/PHAssetResource.h>
#import <Photos/PHAssetChangeRequest.h>

@interface MainViewController (PhotoAssets)
//@property (nonatomic, strong) PHAsset *photoAsset;
+ (void)RequestLibraryAccess;
- (void)savePhotoFile:(NSURL *)fileURL;

@end
