//
//  FoodJournalData.h
//  IdealProtein
//
//  Created by Adam Kaplan on 4/15/13.
//  Copyright (c) 2013 Adam Kaplan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodJournalData : NSObject
{
    CFStringRef trees[3];
    CFArrayRef treeArray;
    CFDataRef xmlValues;
    BOOL fileStatus;
    CFURLRef fileURL;
    SInt32 errNbr;
    CFPropertyListRef plist;
    CFStringRef errStr;
}
@property(nonatomic,retain)NSMutableDictionary *rootElement;
@property(nonatomic,retain)NSMutableDictionary *dates;
@property(nonatomic,strong)NSString *plistPath;
@property(nonatomic,strong)NSData *data;
@property(nonatomic,strong) id plistData;
@property(nonatomic,strong) id filePathObj;


-(void) updatePlist;
-(void) createAppPlist;
-(NSMutableDictionary *) readAppPlist;

-(void) createCFPlist;
-(void) readCFPlist;
-(NSString *)dateStringForDate:(NSDate *)thisDate;
-(NSMutableArray *)PDFDatesForWeekOf:(NSDate *)date;
-(NSMutableArray *)mondays;
@end
