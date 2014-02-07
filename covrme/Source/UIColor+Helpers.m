//
//  UIColor+Helpers.m
//  covrme
//
//  Created by Anthony Wong on 2/7/2014.
//
//

#import "UIColor+Helpers.h"
#import "NSString+Helpers.h"

@implementation UIColor (Helpers)

+ (UIColor *)colorWithHexValue:(unsigned int)hexValue
{
    int a = (hexValue >> 24) & 0xff;
    int r = (hexValue >> 16) & 0xff;
    int g = (hexValue >> 8) & 0xff;
    int b = (hexValue) & 0xff;
    
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/255.0];
}

/**
 * @param hexString Format must be specified in ARGB.
 */
+ (UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned int result = 0;
    int offset = 0;
    
    
    if ([hexString startsWith:@"#"]) {
        hexString = [hexString substringFromIndex:1];
    }
    while (hexString.length < 8) {
        hexString = [@"f" stringByAppendingString:hexString];
    }
    
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    
    [scanner setScanLocation:offset];
    [scanner scanHexInt:&result];
    
    return [UIColor colorWithHexValue:result];
}

@end
