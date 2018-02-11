//  SimpleFlickrAPI.m
//  Session
//
//  Created by Frederick C. Lee on 9/13/14.
//  Copyright (c) 2014 Frederick C. Lee. All rights reserved.
// ------------------------------------------------------------------------------------

#import "SimpleFlickrAPI.h"
#import <Foundation/NSJSONSerialization.h>                              // 1

NSString const *flickrAPIKey = @"ebbefd0c0a07c996f7867f014778adf7";
NSString const *flickrAPISecret = @"bf823c361bc6f09e";
NSString const *sharkAPIKey = @"949e98778755d1982f537d56236bbb42";

// Changes this value to your own application key. More info
// at http://www.flickr.com/services/api/misc.api_keys.html.
// #define flickrAPIKey @"YOUR_FLICKR_APP_KEY"                             // 2

// ------------------------------------------------------------------------------------
// Each RESTful API uses the same base URL.
// The base URL is stored as a macro, making it easy to change should Flickr ever change the URL.
// Also note the query string parameter format.
// It is set to JSON, which tells the Flickr API to return data formatted with JSON.

#define flickrBaseURL \
@"https://api.flickr.com/services/rest/?format=json&"                    // 3


// @"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=949e98778755d1982f537d56236bbb42&text=shark&format=json&nojsoncallback=1&page=1"

// ------------------------------------------------------------------------------------
// The Flickr API uses different parameter names.
// Instead of the Flickr API parameter names being hard-coded throughout, they are defined here as macros.
// The Flickr API parameters are defined as query string parameters on the HTTP GET request.

#define flickrParamMethod @"method"                                     // 4
#define flickrParamAppKey @"api_key"
#define flickrParamUsername @"username"
#define flickrParamUserid @"user_id"
#define flickrParamPhotoSetId @"photoset_id"
#define flickrParamExtras @"extras"
#define flickrParamText @"text"
// ------------------------------------------------------------------------------------
//The Flickr API includes a parameter named method.
// This parameter defines which API method is called.
// The API methods supported by this simple wrapper are defined here as macros.

#define flickrMethodFindByUsername @"flickr.people.findByUsername"      // 5
#define flickrMethodGetPhotoSetList @"flickr.photosets.getList"
#define flickrMethodGetPhotosWithPhotoSetId @"flickr.photosets.getPhotos"
#define flickrMethodSearchPhotos @"flickr.photos.search"

// =======================================================================================================================

@implementation SimpleFlickrAPI


- (NSURL *)getURLForString:(NSString *)str {
    
    NSDictionary *parameters = @{
                                 flickrParamMethod : flickrMethodSearchPhotos,
                                 flickrParamAppKey : sharkAPIKey,
                                 flickrParamText : str,
                                 flickrParamExtras : @"url_t, url_s, url_m, url_sq",
                                 };
    
    NSURL *URL = [self buildFlickrURLWithParameters:parameters];
    
    return URL;
}

// (6) The first Flickr API wrapped by the class is flickr.photos.search.
//     It is wrapped in the method -photosWithSearchString:.
//     This method takes a search string, asks Flickr to find any matching photos, and then returns an array of photos to the caller.

#pragma mark - *** Get Photos ***

- (NSArray *)photosWithSearchString:(NSString *)string {                 // 6
    
    
    NSDictionary *parameters = @{
                                 flickrParamMethod : flickrMethodSearchPhotos,
                                 flickrParamAppKey : sharkAPIKey,
                                 flickrParamText : string,
                                 flickrParamExtras : @"url_t, url_s, url_m, url_sq",
                                 };                                                                   // 7
    
    
    NSDictionary *json = [self flickrJSONSWithParameters:parameters];    // 8
    
    
    NSDictionary *photoset = [json objectForKey:@"photos"];              // 9
    NSArray *photos = [photoset objectForKey:@"photo"];                  // 10
    return photos;                                                       // 11
}

// -----------------------------------------------------------------------------------------------------------------------

- (NSString *)userIdForUsername:(NSString *)username                    // 12
{
    NSDictionary *parameters = @{
                                 flickrParamMethod : flickrMethodFindByUsername,
                                 flickrParamAppKey : sharkAPIKey,
                                 flickrParamUsername : username,
                                 };
    NSDictionary *json = [self flickrJSONSWithParameters:parameters];
    NSDictionary *userDict = [json objectForKey:@"user"];
    NSString *nsid= [userDict objectForKey:@"nsid"];
    
    return nsid;
}

// -----------------------------------------------------------------------------------------------------------------------

- (NSArray *)photoSetListWithUserId:(NSString *)userId                  // 13
{
    NSDictionary *parameters = @{
                                 flickrParamMethod : flickrMethodGetPhotoSetList,
                                 flickrParamAppKey : sharkAPIKey,
                                 flickrParamUserid : userId,
                                 };
    NSDictionary *json = [self flickrJSONSWithParameters:parameters];
    NSDictionary *photosets = [json objectForKey:@"photosets"];
    NSArray *photoSet = [photosets objectForKey:@"photoset"];
    return photoSet;
}

// -----------------------------------------------------------------------------------------------------------------------

- (NSArray *)photosWithPhotoSetId:(NSString *)photoSetId                // 14
{
    NSDictionary *parameters = @{
                                 flickrParamMethod : flickrMethodGetPhotosWithPhotoSetId,
                                 flickrParamAppKey : sharkAPIKey,
                                 flickrParamPhotoSetId : photoSetId,
                                 flickrParamExtras : @"url_t, url_s, url_m, url_sq",
                                 };
    NSDictionary *json = [self flickrJSONSWithParameters:parameters];
    NSDictionary *photoset = [json objectForKey:@"photoset"];
    NSArray *photos = [photoset objectForKey:@"photo"];
    return photos;
}

// -----------------------------------------------------------------------------------------------------------------------

#pragma mark - Helper methods


// (15) The method -fetchResponseWithURL: is responsible for making the actual Web service call to the Flickr Web server.
//      The URL passed in consists of the Flickr API URL with parameters.

- (NSData *)fetchResponseWithURL:(NSURL *)URL {                          // 15

    NSURLRequest *request = [NSURLRequest requestWithURL:URL];           // 16
    
// (17) A nil NSURLResponse object is created.
//      This response object is used to retrieve additional information, such as headers, from the HTTP response.
    NSURLResponse *response = nil;                                       // 17
    NSError *error = nil;                                                // 18
    
    // (19) The NSURLConnection is used to call the Flickr Web server synchronously for the given request.
    // The response and error pointers are set to valid object references if any are created during the request process.
    // The synchronous call returns the data as an NSData object.
    // This is a stream of the response data coming from the Flickr Web server, which is formatted as JSON.
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];      // 19
    
//  (20) If nil is returned for the response data, an error occurred during the request.
//  The error is logged to the console.
//  A more robust Flickr framework would return the error to the caller so that the caller can log it or report the error to the user.
    
    if (data == nil) {                                                   // 20
        NSLog(@"%s: Error: %@", __PRETTY_FUNCTION__,
              [error localizedDescription]);
    }
    return data;                                                         // 21
}

// -----------------------------------------------------------------------------------------------------------------------
// (22) The method -buildFlickrURLWithParameters: takes the dictionary of parameters and creates the URL to the API call.
// This is done by appending each key-value pair in the dictionary as a query string parameter to the base Flickr API URL.

- (NSURL *)buildFlickrURLWithParameters:(NSDictionary *)parameters      // 22
{
    NSMutableString *URLString = [[NSMutableString alloc]
                                  initWithString:flickrBaseURL];
    for (id key in parameters) {
        NSString *value = [parameters objectForKey:key];
        [URLString appendFormat:@"%@=%@&", key,
         [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    NSURL *URL = [NSURL URLWithString:URLString];
    return URL;
}

// -----------------------------------------------------------------------------------------------------------------------
// (23) The method -stringWithData: converts the contents of an NSData object to a string.
// As you will see momentarily, the response data from Flickr requires a bit of tweaking before NSJSONSerialization can parse it.

- (NSString *)stringWithData:(NSData *)data                             // 23
{
    NSString *result = [[NSString alloc] initWithBytes:[data bytes]
                                                length:[data length]
  
                                              encoding:NSUTF8StringEncoding];
    return result;
}

// -----------------------------------------------------------------------------------------------------------------------
// (24) The method -stringByRemovingFlickrJavaScript: returns a cleaned-up version of the Flickr API response data.
// The Flickr API wraps the response data in a JavaScript function, but the SimpleFlickrAPI wants only the JSON data.
// Consequently, the response data is converted from an NSData object to an NSString object.
// The JavaScript function is then stripped from the string, resulting in the string containing only the JSON-formatted data.

- (NSString *)stringByRemovingFlickrJavaScript:(NSData *)data           // 24
{
    // Flickr returns a JavaScript function containing the JSON data.
    // We need to strip out the JavaScript part before we can parse
    // the JSON data. Ex: jsonFlickrApi(JSON-DATA-HERE).
    
    NSMutableString *string = [[self stringWithData:data] mutableCopy];
    NSRange range = NSMakeRange(0, [@"jsonFlickrApi(" length]);
    [string deleteCharactersInRange:range];
    range = NSMakeRange([string length] - 1, 1);
    [string deleteCharactersInRange:range];
    
    return string;
}

// -----------------------------------------------------------------------------------------------------------------------
// (25) The method -flickrJSONWithParameters: is called by the wrapper methods defined at the top of the class.
// This method pulls all the pieces together to make the API call.
// It uses the parameters to create the API URL; it then uses this URL to fetch the response data from Flickr.
// It removes the JavaScript function provided by Flickr.
// It then uses the NSJSONSerialization class to convert the JSON data into Foundation objects, which are returned to the caller.
// The method also logs the JSON data to the console so that you can see what the data looks like coming from Flickr.


- (id)flickrJSONSWithParameters:(NSDictionary *)parameters              // 25
{
    NSURL *URL = [self buildFlickrURLWithParameters:parameters];
    NSData *data = [self fetchResponseWithURL:URL];  // <---------- The actual Web service call @ (15).
    NSString *string = [self stringByRemovingFlickrJavaScript:data];
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%s: json: %@", __PRETTY_FUNCTION__, string);
    
    NSError *error = nil;
    id json = [NSJSONSerialization
               JSONObjectWithData:jsonData
               options:NSJSONReadingAllowFragments
               error:&error];
    if (json == nil) {
        NSLog(@"%s: Error: %@", __PRETTY_FUNCTION__,
              [error localizedDescription]);
    }
    
    return json;
}

@end
