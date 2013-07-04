//
//  CMCustomResponse.h
//  covrme
//
//  Created by Anthony Wong on 2013-07-04.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CMCustomResponse : NSManagedObject

@property (nonatomic, strong) NSString *responseText;
@property (nonatomic, strong) NSDate *createdDate;

@end
