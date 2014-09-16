//  SimpleFlickrAPI.h
//  Session
//
//  Created by Frederick C. Lee on 9/13/14.
//  Copyright (c) 2014 Frederick C. Lee. All rights reserved.
// -----------------------------------------------------------------------------------------------------------------------

#import <Foundation/Foundation.h>

@interface SimpleFlickrAPI : NSObject

- (NSString *)stringByRemovingFlickrJavaScript:(NSData *)data;

- (NSURL *)getURLForString:(NSString *)str;

// Returns a set of photos matching the search string.
- (NSArray *)photosWithSearchString:(NSString *)string;

// Returns the Flickr NSID for the given user name.
- (NSString *)userIdForUsername:(NSString *)username;

// Returns a Flickr photo set for the user. userId is the Flickr NSID
// of the user.
- (NSArray *)photoSetListWithUserId:(NSString *)userId;

// Returns the photos for a Flickr photo set.
- (NSArray *)photosWithPhotoSetId:(NSString *)photoSetId;

@end
