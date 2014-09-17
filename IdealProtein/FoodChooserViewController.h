//
//  FoodChooserViewController.h
//  IdealProtein
//
//  Created by Adam Kaplan on 4/10/13.
//  Copyright (c) 2013 Adam Kaplan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodOptionsViewController.h"
@class GenericViewController;
@interface FoodChooserViewController : UIViewController
@property (weak,nonatomic) id delegate;
-(void)storeGenericIdentifier:(NSString *)trigger andDate:(NSDate *)dateObj;
-(IBAction)exitToThis:(UIStoryboardSegue *)sender;
@end
