//
//  NSString+Helpers.m
//  covrme
//
//  Created by Anthony Wong on 2/7/2014.
//
//

#import "NSString+Helpers.h"

@implementation NSString (Helpers)

- (BOOL)startsWith:(NSString*)text
{
    NSRange range = [self rangeOfString:text];
    
    if (range.location == 0)
        return YES;
    
    return NO;
}

@end
