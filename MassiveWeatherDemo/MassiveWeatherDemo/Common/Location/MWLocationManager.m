//
//  MWLocationManager.m
//
//  MassiveWeatherDemo
//
//  Created by Ross on 2/3/15.
//  Copyright (c) 2015 Massive. All rights reserved.
//


#import "MWLocationManager.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#define iosVersion [[[UIDevice currentDevice] systemVersion] floatValue]

NSString *const MWLocationManagerErrorDomain = @"MWLocationManagerErrorDomain";

//  Private interface encapsulating functionality
@interface MWLocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MWLocationManagerCompletionHandler completionBlock;

@end


@implementation MWLocationManager {
    
    BOOL        _timeoutInProgress;
    NSUInteger  _errorsCount;
}

#pragma mark Lifecycle

+ (MWLocationManager *)sharedManager
{
    static MWLocationManager *SharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SharedInstance = [[MWLocationManager alloc] init];
    });
    
    return SharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        //  Private variables
        _errorsCount = 0;
        
        //  Default properties values
        _location = nil;
        _maxErrorsCount = 3;
        _errorTimeout = 3.0;
    }
    return self;
}

- (void)dealloc
{
    //  Dealloc should not be called on singleton instance,
    //  but for sure
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark - Accessors

- (void)setErrorTimeout:(NSTimeInterval)errorTimeout
{
    [self willChangeValueForKey:@"errorTimeout"];
    _errorTimeout = (errorTimeout >= 0.1 ? errorTimeout : 0.1);
    [self didChangeValueForKey:@"errorTimeout"];
}

#pragma mark Private

- (CLLocationManager *)locationManager
{
    //  Location manager is lazily intialized when its really needed
    if(!_locationManager)
    {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        if (iosVersion > 8.0) {
            BOOL hasAlwaysKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"] != nil;
            BOOL hasWhenInUseKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"] != nil;
            if (hasAlwaysKey) {
                [_locationManager requestAlwaysAuthorization];
            } else if (hasWhenInUseKey) {
                [_locationManager requestWhenInUseAuthorization];
            } else {
                // At least one of the keys NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription MUST be present in the Info.plist file to use location services on iOS 8+.
                NSAssert(hasAlwaysKey || hasWhenInUseKey, @"To use location services in iOS 8+, your Info.plist must provide a value for either NSLocationWhenInUseUsageDescription or NSLocationAlwaysUsageDescription.");
            }
        }
    }
    
    return _locationManager;
}

#pragma mark - Public interface

- (void)updateLocationWithCompletionHandler:(MWLocationManagerCompletionHandler)completion
{
    NSAssert(completion, @"You have to provide non-NULL completion handler to [MWLocationManager updateLocationWithCompletionHandler:]");
    
    self.completionBlock = completion;
    
    //  Start new errors counting
    _errorsCount = 0;
    
    [self.locationManager startUpdatingLocation];
}

#pragma mark - Location manager delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //  We accept only CLLocation with valid locationCoordinate
    CLLocation *newLocation = [locations lastObject];
    
    _location = (CLLocationCoordinate2DIsValid(newLocation.coordinate) ? newLocation : nil);
    
    //  Turn off the location manager to preserve energy
    [manager stopUpdatingLocation];
    
    _errorsCount = 0;
    
    
    //  Call location changed callback block
    if (_completionBlock) {
        [self getCityNameOfLocation:_location completion:_completionBlock];
        //  Stop previous error timeout
        [self stopErrorTimeout];
    }
}

- (void)getCityNameOfLocation:(CLLocation *)location completion:(MWLocationManagerCompletionHandler)completion{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        NSDictionary *dictionary = placemark.addressDictionary;
        NSString *city = dictionary[@"City"];
        if(!city) {
            city = placemark.addressDictionary[@"FormattedAddressLines"][0];
        }
        
        completion(location, city, nil, NO);
        _completionBlock = nil;
    }];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    _location = nil;
    
    //  Location services disabled, call the error block immediatelly
    //  ignore all errors counts and timeouts because they make no sense
    //  in this case
    if(error.domain == kCLErrorDomain && error.code == kCLErrorDenied)
    {
        _errorsCount = 0;
        [self locationUpdatingFailedWithError:error locationServicesDisabled:YES];
        return;
    }
    
    _errorsCount++;
    
    //  Start timeout of location failure
    [self startErrorTimeout];
    
    //  Number of errors in row without success exceeded reached threshold
    if(_errorsCount >= _maxErrorsCount)
    {
        [self locationUpdatingFailedWithError:error locationServicesDisabled:NO];
    }
}

#pragma mark - Private helper methods

- (void)locationUpdatingFailedWithError:(NSError *)error locationServicesDisabled:(BOOL)locationServicesDisabled
{
    [self.locationManager stopUpdatingLocation];

    //  Cancel previous error timeouts
    [self stopErrorTimeout];
    
    //  Reset errors count
    _errorsCount = 0;
}

- (void)locationUpdatingTimedOut
{
    //  Create custom error
    NSDictionary *userInfo = @{
       NSLocalizedDescriptionKey: NSLocalizedString(@"Failed to get current location.", @"MWLocationManager - Localized description of the error sent if the location request times out"),
       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Request on getting a current location timed out.", @"MWLocationManager - Localized failure reason of the error sent if the location request times out")
    };
    
    NSError *error = [NSError errorWithDomain:MWLocationManagerErrorDomain code:MWLocationManagerErrorCodeTimedOut userInfo:userInfo];
    
    [self locationUpdatingFailedWithError:error locationServicesDisabled:NO];
}

- (void)startErrorTimeout
{
    //  Start timeout if the timeout is not already in progress
    if (!_timeoutInProgress)
    {
        [self performSelector:@selector(locationUpdatingTimedOut) withObject:nil afterDelay:_errorTimeout];
        _timeoutInProgress = YES;
    }
}

- (void)stopErrorTimeout
{
    //  Cancel previous "performSelector" requests
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(locationUpdatingTimedOut) object:nil];
    _timeoutInProgress = NO;
}

@end
