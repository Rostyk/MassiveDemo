//
//  MWLocationManager.h
//  MassiveWeatherDemo
//
//  Created by Ross on 2/3/15.
//  Copyright (c) 2015 Massive. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;

/**
 *  Error domain used for error created directly by MWLocationManager
 */
extern NSString *const MWLocationManagerErrorDomain;

/**
 *  MWLocationManagerErrorDomain custom error codes
 */
typedef NS_ENUM(NSInteger, MWLocationManagerErrorCode) {
    MWLocationManagerErrorCodeUnknown = 0,
    MWLocationManagerErrorCodeTimedOut
};

/**
 *  Typedef for completion handler block
 *
 *  @param location                 Received location or nil if there was an error
 *  @param error                    Error which occured while getting location or nil if everything went fine. Either the originating CLLocationManager error is passed or custom error with MWLocationManagerErrorDomain domain and MWLocationManagerErrorCode status code
 *  @param locationServicesDisabled YES if there was any error and it was because the Location Services are disabled for this. This is very often case to be checked so it is directly passed to the completion handler for .convenience
 */
typedef void (^MWLocationManagerCompletionHandler)(CLLocation *location, NSString *cityName, NSError *error, BOOL locationServicesDisabled);


@interface MWLocationManager : NSObject

/**
 *  Location received from Location services
 */
@property (nonatomic, readonly) CLLocation *location;

/**
 *  Threshold number of location services errors until the error block is called.
 *  When the error is "Location services disabled", this threshold is ignored
 *  Default: 3 (Error block is called on 3rd received error)
 */
@property (nonatomic, assign) NSUInteger maxErrorsCount;

/**
 *  How many seconds should the manager try to obtain location before failing on timeout.
 *  Minimum value is 0.1s. Values lower than 0.1s will be automatically set to 0.1s.
 *  Default: 3s
 */
@property (nonatomic, assign) NSTimeInterval errorTimeout;

/**
 *  @return Shared singleton instance
 */
+ (MWLocationManager *)sharedManager;

/**
 *  Asks the manager get current location with the given completion handler block.
 *  Location is updated only once and the location listening is turned off again
 *  to preserve battery.
 *  If you dont provide completion block, STAsset macro will cause app crash because
 *  there is no logical use to update location without using it.
 *
 *  @param completionBlock Comletion block called on when the location is received.
 *  @see MWLocationManagerCompletionHandler
 */
- (void)updateLocationWithCompletionHandler:(MWLocationManagerCompletionHandler)completion;
- (void)getCityNameOfLocation:(CLLocation *)location completion:(MWLocationManagerCompletionHandler)completion;

@end
