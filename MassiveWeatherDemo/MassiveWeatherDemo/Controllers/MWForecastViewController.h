//
//  MWMainViewController.h
//  MassiveWeatherDemo
//
//  Created by Ross on 2/3/15.
//  Copyright (c) 2015 Massive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWBaseViewController.h"
@class MWLocation;

@interface MWForecastViewController : MWBaseViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic, strong) MWLocation *location;
@end
