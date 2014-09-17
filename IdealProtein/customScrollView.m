//
//  customScrollView.m
//  IdealProtein
//
//  Created by Adam Kaplan on 4/6/13.
//  Copyright (c) 2013 Adam Kaplan. All rights reserved.
//

#import "customScrollView.h"

@implementation customScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (BOOL)touchesShouldCancelInContentView:(UIView *)view{
    return YES;
}
//-(BOOL)translatesAutoresizingMaskIntoConstraints{
 //   if(self.tag ==30) return YES;
   // else return NO;}


@end
