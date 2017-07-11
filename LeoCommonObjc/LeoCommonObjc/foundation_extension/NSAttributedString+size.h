#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSAttributedString (size)

+ (NSAttributedString *) formatePrice:(NSString*)priceStr
                            withColor:(UIColor*)color
                             headFont:(UIFont *)headFont
                             tailFont:(UIFont *)tailFont;

+(NSDictionary*)getAtrributeDicOfAttributedStr:(NSAttributedString*)str;

/*
 * getSizeOfAttributedStr:withConstraints:
 * getSizeOfAttributedStr:withConstraints:context are deprecated, will be removed in future version.
 * use getExactSizeOfAttributedStr:withConstraints:limitedToNumberOfLines: instead.
 */
+(CGSize)getSizeOfAttributedStr:(NSAttributedString*)str withConstraints:(CGSize)size;
+(CGSize)getSizeOfAttributedStr:(NSAttributedString*)str
                withConstraints:(CGSize)size
                        context:(NSStringDrawingContext *) context;

+(NSArray *)getLinesArrayOfAtrString:(NSAttributedString*)attStr inSize:(CGSize)size;

+(CGSize)getExactSizeOfAttributedStr:(NSAttributedString*)attributedString
                     withConstraints:(CGSize)size
              limitedToNumberOfLines:(NSInteger)numberOfLines;

+ (NSAttributedString *) getAttributedString:(NSAttributedString *)attStr
                                      inSize:(CGSize)size
                      limitedToNumberOfLines:(NSInteger)numberOfLines;

@end
