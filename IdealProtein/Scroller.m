//
//  Scroller.m
//  IdealProtein
//
//  Created by Adam Kaplan on 5/12/13.
//  Copyright (c) 2013 Adam Kaplan. All rights reserved.
//

#import "Scroller.h"

@implementation Scroller

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
-(BOOL)translatesAutoresizingMaskIntoConstraints{
    return NO;
}

@end
