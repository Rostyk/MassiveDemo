//
//  MWBaseViewController.m
//  MassiveWeatherDemo
//
//  Created by Ross on 2/3/15.
//  Copyright (c) 2015 Massive. All rights reserved.
//

#import "MWBaseViewController.h"
#import "MBProgressHUD.h"

@interface MWBaseViewController ()
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation MWBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)addPreload {
    
    //just to be on the safe side
    [self removePreload];
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    self.hud.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.view addSubview:self.hud];
    [self.view bringSubviewToFront:self.hud];
    
    self.hud.labelText = @"Forecast";
    [self.hud show: YES];
}

- (void)removePreload {
    [self.hud hide:YES];
}

@end
