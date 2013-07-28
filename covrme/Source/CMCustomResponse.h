//
//  CMCustomResponse.h
//  covrme
//
//  Created by Anthony Wong on 2013-07-27.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CMCustomResponse : NSManagedObject

@property (nonatomic, retain) NSDate *createdDate;
@property (nonatomic, retain) NSString *responseText;

@end
