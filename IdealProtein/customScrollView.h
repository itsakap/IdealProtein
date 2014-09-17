//
//  customScrollView.h
//  IdealProtein
//
//  Created by Adam Kaplan on 4/6/13.
//  Copyright (c) 2013 Adam Kaplan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface customScrollView : UIScrollView
@property (nonatomic) CGSize contentSize;
- (BOOL)touchesShouldCancelInContentView:(UIView *)view;
//- (BOOL)translatesAutoresizingMaskIntoConstraints;
@end
