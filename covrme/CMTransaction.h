//
//  CMTransaction.h
//  covrme
//
//  Created by Anthony Wong on 12-03-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPerson.h"
@interface CMTransaction : NSObject

//Amount
//Lender
//Spender
//Completed
//Date
//Description
@property (nonatomic, strong) NSNumber* amount;
@property (nonatomic, strong) CMPerson* lender;
@property (nonatomic, strong) CMPerson* spender;
@property (nonatomic, strong) NSDate* date;
@property (nonatomic, strong) NSString* description;
@property (nonatomic, strong) NSNumber* identifier;



@end
