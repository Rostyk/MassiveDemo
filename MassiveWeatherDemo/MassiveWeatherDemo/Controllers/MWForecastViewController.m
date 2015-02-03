//
//  MWMainViewController.m
//  MassiveWeatherDemo
//
//  Created by Ross on 2/3/15.
//  Copyright (c) 2015 Massive. All rights reserved.
//

#import "MWForecastViewController.h"
#import "SWRevealViewController.h"
#import "MWLocationManager.h"
#import "ServiceAPI.h"
#import "MWLocation.h"
#import "MWForecastItemsManager.h"
#import "MWForecast.h"
#import "NSDateHelper.h"

@interface MWForecastViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *cloudImageView;
@property (nonatomic, weak) IBOutlet UILabel *temperatureLabel;
@property (nonatomic, weak) IBOutlet UILabel *cloudLabel;
@property (nonatomic, weak) IBOutlet UILabel *windSpeedLabel;
@property (nonatomic, weak) IBOutlet UILabel *cityLabel;
@property (nonatomic, weak) IBOutlet UILabel *datelabel;
@end

@implementation MWForecastViewController

#pragma mark lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSidebar];
    [self setupForecast];
}


#pragma mark forecast

- (void) setupForecast {
    self.datelabel.text = [NSDateHelper currentDateString];
    [self addPreload];
    
    
    if(!self.location) {
        [self getCurrentLocationForecast];
    }
    else {
        self.cityLabel.text = self.location.city;
        MWLocation *extraLocation = self.location;
        [self getForecastForLocation:extraLocation.location];
    }
   
}

- (void)getCurrentLocationForecast {
    __weak typeof(self) weakSelf = self;
    [[MWLocationManager sharedManager] updateLocationWithCompletionHandler:^(CLLocation *location, NSString *cityName, NSError *error, BOOL locationServicesDisabled) {
        
        if(location) {
            self.cityLabel.text = cityName;
            [weakSelf getForecastForLocation:location];
            [weakSelf handleCityName:cityName];
        }
        else {
            [weakSelf alert:error.localizedDescription];
            [self removePreload];
        }
    }];
}

- (void)getForecastForLocation:(CLLocation *)location {
    __weak typeof(self) weakSelf = self;
    [[ServiceAPI sharedInstance] getWeatherForecast:^(NSArray *forecastItems, ...) {
        [[MWForecastItemsManager sharedManager] setForecastItems:forecastItems];
        [weakSelf showForecast];
        
    } failure:^(id responseObject, NSError *error) {
        [weakSelf alert:error.localizedDescription];
        [self removePreload];
    } progress:^(NSInteger progressCount, NSInteger totalCount) {
        
    }
     forLocation:location];
}

#pragma mark alert

- (void)alert:(NSString *)text {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:text
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark sidebar

- (void)setupSidebar {
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

#pragma mark forecast UI

- (void)showForecast {
    [self removePreload];
    MWForecast *todayForecast = [[MWForecastItemsManager sharedManager] forecastForDaySinceToday:0];
    
    /*round up the decimal part of wind speed, cloudy, temperature */
    self.temperatureLabel.text = [NSString stringWithFormat:@"%lu°", (unsigned long)[todayForecast.temperature floatValue]];
    self.windSpeedLabel.text = [NSString stringWithFormat:@"%lumph", (unsigned long)todayForecast.windSpeed];
    self.cloudLabel.text = [NSString stringWithFormat:@"%lu%%", (unsigned long)todayForecast.clouds];
}

- (void)handleCityName:(NSString *)cityName {
    self.title = cityName;
}

@end
