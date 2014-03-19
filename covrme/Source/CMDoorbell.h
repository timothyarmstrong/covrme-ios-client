//
//  CMDoorbell.h
//  covrme
//
//  Created by Anthony Wong on 2013-07-27.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CMDoorbell : NSManagedObject

@property (nonatomic, retain) NSString * doorbellID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * addedDate;

@end
