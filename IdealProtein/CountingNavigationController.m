//
//  CountingNavigationController.m
//  IdealProtein
//
//  Created by Adam Kaplan on 4/1/13.
//  Copyright (c) 2013 Adam Kaplan. All rights reserved.
//

#import "CountingNavigationController.h"

@interface CountingNavigationController ()

@end

@implementation CountingNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.theNavBar.tintColor = [UIColor colorWithRed:.5 green:.7 blue:.3 alpha:.6];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
