//
//  FoodJournalData.m
//  IdealProtein
//
//  Created by Adam Kaplan on 4/15/13.
//  Copyright (c) 2013 Adam Kaplan. All rights reserved.
//

#import "FoodJournalData.h"

@implementation FoodJournalData
@synthesize rootElement,dates,plistData,filePathObj,data;
//returns all mondays in the "calendar" from  last to first day as an array of NSDate objects
-(NSMutableArray *)mondays{
    NSMutableArray *toReturn = [[NSMutableArray alloc] init];
    NSDate *lastDate = [self lastDate];
    for(int i = 0; i<31; i++){
        NSDate *candidate = [NSDate dateWithTimeInterval:-86400 *i sinceDate:lastDate];
        NSString *candidateString = [self dateStringForDate:candidate];
        NSRange three = NSMakeRange(0, 3);
        NSString *weekday = (NSString *)[[candidateString componentsSeparatedByString:@" "] subarrayWithRange:three][0];
        
        
        
        
        if([weekday isEqualToString:@"Mon"]){
            [toReturn addObject:candidate];
        }
    }
    return  toReturn;
}
-(void)createAppPlist{
    NSMutableDictionary *innerDict;
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    NSDate *dateObject;
    NSError *err;
    dates = [NSMutableDictionary dictionaryWithCapacity:30];
    rootElement = [NSMutableDictionary dictionaryWithCapacity:1];
   // plistPath = [[NSBundle mainBundle] pathForResource:@"FoodJournalData" ofType:@"plist"];
    err=[NSError errorWithDomain:@"shouldn't happen" code:0 userInfo:nil];
    NSString *dateString;
    [dateFormat setDateFormat:@"E MMM d"];
    dateObject = [NSDate dateWithTimeInterval:86400*-15 sinceDate:[NSDate date]];
    dateString = [dateFormat stringFromDate:dateObject];
    innerDict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[self checkMarks],[self inputs], dateObject,nil] forKeys:[NSArray arrayWithObjects:@"checkMarks",@"inputs",@"date",nil]];
    for(int i = 0;i<29;i++){
        
        
        [dates setObject:innerDict forKey:dateString];
        dateObject = [NSDate dateWithTimeInterval:86400 sinceDate:dateObject];
        dateString = [dateFormat stringFromDate:dateObject];
        innerDict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects: [self checkMarks], [self inputs], dateObject,nil] forKeys:[NSArray arrayWithObjects:@"checkMarks",@"inputs",@"date",nil]];
      //  [innerDict removeObjectForKey:@"date"];
        
    }
    
    [rootElement setObject:dates forKey:@"hi"];

    // get paths from root direcory
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"FoodJournalData.plist"];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:plistPath]){
        [[NSFileManager defaultManager] createFileAtPath:plistPath contents:nil attributes:nil];
     
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:plistPath];
    [fileHandle seekToEndOfFile];
    data = [NSPropertyListSerialization dataWithPropertyList:(id)rootElement format:NSPropertyListXMLFormat_v1_0 options:nil error:&err];
    [fileHandle writeData:data];
        [fileHandle closeFile];
    
    }
    else [self updatePlist];
    
    
    
    //[rootElement writeToFile:plistPath atomically:YES];
   /*
    
    
    if(data){
        [data writeToFile:plistPath atomically:YES];
        NSLog(@"H?");
    } else{
        NSLog(@"SHOULDN'T HAPPEN");
     }*/
}
-(NSMutableDictionary *)innerDict:(NSDate *)dateObject{
     return [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects: [self checkMarks], [self inputs], dateObject,nil] forKeys:[NSArray arrayWithObjects:@"checkMarks",@"inputs",@"date",nil]];
}
-(NSMutableArray *) checkMarks{
    //indices 0-9 represent h2O checkmarks; indices 10-25 represent supplement checkmarks!
    return [NSArray arrayWithObjects: [NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO], nil]; //26
}

-(NSMutableDictionary *) inputs{
    //9 strings, five input texts (4 food, 1 exercise), four image names
    //2 numbers
   // return [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects: [NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null], [NSNull null],[NSNull null],nil] forKeys:[NSArray arrayWithObjects:@"breakfastInput", @"breakfastImage", @"lunchInput", @"lunchImage", @"dinnerInput", @"dinnerImage", @"snackInput", @"snackImage", @"exerciseInput",@"exerciseDuration",@"selfRating",nil]];
    NSMutableDictionary *toReturn = [@{@"selfRating":[NSNumber numberWithInt:0]} mutableCopy];
    
    //[toReturn setValue:[NSNumber numberWithInt:1] forKey:@"selfRating"];
    return toReturn;
}

//copy of dates
-(NSMutableDictionary *)readAppPlist{
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dataFile = [docDir stringByAppendingPathComponent:@"FoodJournalData.plist"];
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithContentsOfFile:dataFile];
   // NSLog(@"READAPPPLIST %@",d);
   // if([[NSFileManager defaultManager] fileExistsAtPath:dataFile]){}
    return [d objectForKey:@"hi"];
}
-(void) updatePlist{
    NSDate *today = [NSDate date];
    int numberOfDaysToChange = 0;
    //NSString *todayAsString = [self dateStringForDate:today];
    NSMutableDictionary *thePlist = [self readAppPlist];
    
    //initialize date objects representing range of dates that we need in the datebook.
    NSDate *earliestDate = [NSDate dateWithTimeInterval:-86400 *15 sinceDate:today];
    NSDate *latestDate = [NSDate dateWithTimeInterval:86400 *15 sinceDate:today];
    
    //date object that represents the furthest date in time currently in the Plist.  Used to filter dates.
    NSDate *deleter = [self lastDate];
    while(![[self dateStringForDate:latestDate] isEqualToString:[self dateStringForDate:deleter]]){
        numberOfDaysToChange++;
        latestDate = [NSDate dateWithTimeInterval:-86400 sinceDate:latestDate];
        if(numberOfDaysToChange>30) break;
    }
   
    
    for(int i = 0; i<numberOfDaysToChange; i++){
        latestDate = [NSDate dateWithTimeInterval:86400 sinceDate:latestDate];
        [thePlist setObject:[self innerDict:latestDate] forKey:[self dateStringForDate:latestDate]];
        earliestDate = [NSDate dateWithTimeInterval:-86400 sinceDate:earliestDate];
    /*
     
     two possible cases: date range in PList overlaps partly with new range, or all dates in PList
     are earlier than all dates in new range.  When PList overlaps fully, numberOfDaysToChange = 0
     and for-loop isn't called.
     
    */
        if([thePlist objectForKey:[self dateStringForDate:earliestDate]]){
           [thePlist removeObjectForKey:[self dateStringForDate:earliestDate]];
            earliestDate = [NSDate dateWithTimeInterval:-86400 sinceDate:earliestDate];
            
            
        }
        else{
            //should only activate in case 2 (see above)... check day by day
            [thePlist removeObjectForKey:[self dateStringForDate:deleter]];
            deleter = [NSDate dateWithTimeInterval:-86400 sinceDate:deleter];
        }
       
    }
    
    //if new data was created, save it.
    if(numberOfDaysToChange>0){
    [rootElement setObject:thePlist forKey:@"hi"];
    // get paths from root direcory
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"FoodJournalData.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath]){
        [[NSFileManager defaultManager] createFileAtPath:plistPath contents:(id)rootElement attributes:nil];
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:plistPath];
        [fileHandle seekToEndOfFile];
        data = [NSPropertyListSerialization dataWithPropertyList:(id)rootElement format:NSPropertyListXMLFormat_v1_0 options:nil error:nil];
        [fileHandle writeData:data];
        [fileHandle closeFile];
    }
    }
}
//returns the furthest date in time available in the dictionary, either before or after present date.
-(NSDate *) lastDate{
    NSMutableDictionary *thePlist = [self readAppPlist];
    NSDate *latest = [NSDate date];
    if ([thePlist objectForKey:[self dateStringForDate:latest]]){
        do{
            //one ahead of what i need
            latest = [NSDate dateWithTimeInterval:86400 sinceDate:latest];
        }while ([thePlist objectForKey:[self dateStringForDate:[NSDate dateWithTimeInterval:86400 sinceDate:latest]]]);
    }
    else {
        while (![thePlist objectForKey:[self dateStringForDate:latest]]){
            
            latest = [NSDate dateWithTimeInterval:-86400 sinceDate:latest];
        }
    }
         return latest;
}

//returns an array of dictionaries for a week, given its first date.
-(NSMutableArray *)PDFDatesForWeekOf:(NSDate *)date{
    NSMutableDictionary *thePList = [self readAppPlist];
    NSMutableArray *toReturn = [[NSMutableArray alloc]init];
    for(int i = 0; i<7;i++){
        NSDate *dateToAdd = [NSDate dateWithTimeInterval:86400*i sinceDate:date];
        
        NSMutableDictionary *entryItself = [thePList objectForKey:[self dateStringForDate:dateToAdd]];//objectForKey:@"inputs"];
            [toReturn addObject:entryItself];
        if([[self dateStringForDate:dateToAdd]isEqualToString:[self dateStringForDate:[self lastDate]]]) return toReturn;
    }
    return toReturn;
}
//given a date, returns its string representation (used in data retrieval and date display)
-(NSString *)dateStringForDate:(NSDate *)thisDate {
    NSString *todaysDateString;
    NSDateFormatter *dateFormat;
    dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"E MMM d"];
    todaysDateString = [dateFormat stringFromDate:thisDate];
    return todaysDateString;
    
}
-(void)createCFPlist{
    
}
-(void)readCFPlist{
    
}

@end
