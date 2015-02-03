//
//  MWMapViewController.m
//  MassiveWeatherDemo
//
//  Created by Ross on 2/3/15.
//  Copyright (c) 2015 Massive. All rights reserved.
//

#import "MWMapViewController.h"
#import "SWRevealViewController.h"
#import <MapKit/MapKit.h>
#import "MWLocationManager.h"
#import "MWLocation.h"
#import "MWForecastItemsManager.h"


@interface MWMapViewController ()
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@end

@implementation MWMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSidebar];
    [self setupAddingLocation];
}

#pragma mark adding new location
- (void) setupAddingLocation{
    UITapGestureRecognizer* tapRec = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(didTapMap:)];
    [self.mapView addGestureRecognizer:tapRec];
}

- (void)didTapMap:(UIGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self.mapView];
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    
    MKPointAnnotation *forecastPin = [[MKPointAnnotation alloc] init];
    forecastPin.coordinate = coordinate;
    forecastPin.title = @"Get Forecast";
    [self.mapView addAnnotation:forecastPin];
    
    [self addPreload];
    [self getCityName:[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude]];
    self.mapView.userInteractionEnabled = NO;
    
}

- (void)getCityName:(CLLocation *)location {
    [[MWLocationManager sharedManager] getCityNameOfLocation:location completion:^(CLLocation *location, NSString *cityName, NSError *error, BOOL locationServicesDisabled) {
        
        MWLocation *forecastLocation = [[MWLocation alloc] init];
        forecastLocation.city = cityName;
        forecastLocation.location = location;
        [[MWForecastItemsManager sharedManager] addForecastLocation:forecastLocation];
        [self performSelector:@selector(revealSidebar) withObject:self afterDelay:0.1];
        [self removePreload];
    }];
}

#pragma mark sidebar

- (void)revealSidebar {
    [self.revealViewController revealToggle:self];
}

- (void)setupSidebar {
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }

}

@end
