//
//  UIColor+Helpers.h
//  covrme
//
//  Created by Anthony Wong on 2/7/2014.
//
//

#import <UIKit/UIKit.h>

@interface UIColor (Helpers)

+ (UIColor *)colorWithHexValue:(unsigned int)hexValue;
+ (UIColor *)colorFromHexString:(NSString *)hexString;

@end
