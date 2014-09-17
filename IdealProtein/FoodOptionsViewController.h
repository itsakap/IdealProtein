//
//  FoodOptionsViewController.h
//  IdealProtein
//
//  Created by Adam Kaplan on 4/23/13.
//  Copyright (c) 2013 Adam Kaplan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericViewController.h"
#import "customScrollView.h"
@class FoodChooserViewController;
@interface FoodOptionsViewController : UIViewController

-(IBAction)createASegueAndMakeItHappen:(id)sender;
-(void)storeChooserIdentifier:(NSString *)choice;
-(void)storePassedIdentifier:(NSString *)passed;
-(void)passDate:(NSDate *)dateObj;
-(void)displayImage;
@end
