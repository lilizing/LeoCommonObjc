#import "NSAttributedString+size.h"
#import <CoreText/CoreText.h>
#import "NSArray+Ext.h"
#import "NSAttributedString+Ext.h"
#import "NSMutableAttributedString+Ext.h"

@implementation NSAttributedString (size)

#pragma mark - private methods

+(NSInteger)_getStringNumberOfLines:(NSAttributedString*)attStr
                             inSize:(CGSize)size {
    CTFramesetterRef frameSetter = \
    CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,size.width,100000));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    
    CGPathRelease(path);
    CFRelease(frameSetter);
    CFRelease(frame);
    
    return lines.count;
}


#pragma mark -


+ (NSAttributedString *) formatePrice:(NSString*)priceStr
                            withColor:(UIColor*)color
                             headFont:(UIFont *)headFont
                             tailFont:(UIFont *)tailFont {
    
    NSArray *temAry = [priceStr componentsSeparatedByString:@"."];
    NSMutableAttributedString *temStr = [[NSMutableAttributedString alloc]init];
    if ([temAry objectAtIndexIfExist:0]!=nil) {
        [temStr appendAttributedString:[NSAttributedString string:[temAry objectAtIndexIfExist:0] color:color font:headFont]];
    }
    if ([temAry objectAtIndexIfExist:1]!=nil) {
        [temStr appendAttributedString:[NSAttributedString string:[NSString stringWithFormat:@".%@",[temAry objectAtIndexIfExist:1]] color:color font:tailFont]];
    }
    
    return [[NSAttributedString alloc]initWithAttributedString:temStr];
}

+(NSDictionary*)getAtrributeDicOfAttributedStr:(NSAttributedString*)str {
    if ([[str string] isEqualToString:@""]) {
        return nil;
    }
    NSRange range = NSMakeRange(0, str.length);
    NSDictionary *attributeDic = [str attributesAtIndex:0 effectiveRange:&range];
    return attributeDic;
}

+(CGSize)getSizeOfAttributedStr:(NSAttributedString*)str withConstraints:(CGSize)size {
    return [self getSizeOfAttributedStr:str withConstraints:size context:nil];
}

+(CGSize)getSizeOfAttributedStr:(NSAttributedString*)str
                withConstraints:(CGSize)size
                        context:(NSStringDrawingContext *) context{
    if (!str.length) {
        return CGSizeZero;
    }
    
    NSMutableAttributedString *caculateStr = [[NSMutableAttributedString alloc]initWithAttributedString:str];
    [caculateStr enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, caculateStr.length) options:0 usingBlock:^(NSTextAttachment *value, NSRange range, BOOL * _Nonnull stop) {
        if (value!=nil) {
            NSAttributedString *attachmentText = [caculateStr attributedSubstringFromRange:range];
            NSMutableAttributedString *attachmentText2 = [[NSMutableAttributedString alloc]initWithAttributedString:attachmentText];
            [attachmentText2 removeAttribute:(NSString *)kCTRunDelegateAttributeName range:NSMakeRange(0, 1)];
            [caculateStr replaceCharactersInRange:range withAttributedString:attachmentText2];
        }
    }];
    
    NSStringDrawingOptions options = \
    NSStringDrawingTruncatesLastVisibleLine |
    NSStringDrawingUsesLineFragmentOrigin |
    NSStringDrawingUsesFontLeading;
    
    return [caculateStr boundingRectWithSize:size
                                     options:options
                                     context:context].size;
}

+(CGSize)getOneWordSizeOfAttributedString:(NSAttributedString *)atrributesString {
    if ([[atrributesString string] isEqualToString:@""]) {
        return CGSizeZero;
    }
    NSDictionary *attributeDic = [self getAtrributeDicOfAttributedStr:atrributesString];
    
    NSAttributedString *string = \
    [[NSAttributedString alloc] initWithString:@"单" attributes:attributeDic];
    
    return [self getSizeOfAttributedStr:string
                        withConstraints:CGSizeMake(CGFLOAT_MAX, 50)];
}

+(CGSize)getMaxTwoLineSizeOfAttributedString:(NSAttributedString *)attributedString
                             withConstraints:(CGSize)size {
    if ([[attributedString string] isEqualToString:@""]) {
        return CGSizeZero;
    }
    
    NSRange range = NSMakeRange(0, attributedString.length);
    NSDictionary *attributeDic = [attributedString attributesAtIndex:0 effectiveRange:&range];
    CGSize oneWordSize = [self getOneWordSizeOfAttributedString:attributedString];
    
    CGFloat twolineHeight = \
    [self getSizeOfAttributedStr:[[NSAttributedString alloc] initWithString:@"双g" attributes:attributeDic]
                 withConstraints:CGSizeMake(oneWordSize.width, CGFLOAT_MAX)].height;
    
    return [self getSizeOfAttributedStr:attributedString
                        withConstraints:CGSizeMake(size.width, twolineHeight)];
}

+(NSArray *)getLinesArrayOfAtrString:(NSAttributedString*)attStr inSize:(CGSize)size
{
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,size.width,100000));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    for (id line in lines)
    {
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSAttributedString *lineString = [attStr attributedSubstringFromRange:range];
        [linesArray addObject:lineString];
    }
    
    CFRelease(frameSetter);
    CFRelease(frame);
    CFRelease(path);
    
    return (NSArray *)linesArray;
}

+(CGSize)getExactSizeOfAttributedStr:(NSAttributedString*)attributedString
                     withConstraints:(CGSize)size
              limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGSize result = CGSizeZero;
    
    if (!attributedString || attributedString.length == 0) {
        return result;
    }
    
    BOOL isLineBreakend = NO;
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc]init];
    [attributedString enumerateAttribute:NSParagraphStyleAttributeName inRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(NSParagraphStyle *value, NSRange range, BOOL * _Nonnull stop) {
        if (value!=nil) {
            [paraStyle setParagraphStyle:value];
            *stop = YES;
        }
    }];
    
    if (paraStyle.lineBreakMode == NSLineBreakByTruncatingTail) {
        paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    }
    
    NSMutableAttributedString *caculateText = [[NSMutableAttributedString alloc]initWithAttributedString:attributedString];
    [caculateText setParagraphStyle:paraStyle];
    
    if(numberOfLines == 0 ){
        return [self getSizeOfAttributedStr:caculateText withConstraints:size];
    }
    
    NSMutableAttributedString *newStr = [[NSMutableAttributedString alloc]init];
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)caculateText);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,size.width,CGFLOAT_MAX));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    
    NSInteger max = MIN(numberOfLines==0?lines.count:numberOfLines, lines.count);
    
    for (int i = 0; i<max; i++) {
        
        id line = [lines objectAtIndex:i];
        
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSAttributedString *lineString = [caculateText attributedSubstringFromRange:range];
        if (i == max-1 ) {
            NSString *text = [lineString string];
            if ([text rangeOfString:@"\n"].location!= NSNotFound) {
                lineString = [caculateText attributedSubstringFromRange:NSMakeRange(lineRange.location, lineRange.length-1)];
                isLineBreakend = YES;
            }
        }
        [newStr appendAttributedString:lineString];
    }
    
    CFRelease(frameSetter);
    CFRelease(frame);
    CFRelease(path);
    
    result = [self getSizeOfAttributedStr:newStr withConstraints:size];
    
    if ((numberOfLines>0 && numberOfLines<lines.count)) {
        result.height += paraStyle.lineSpacing;
    }else if(isLineBreakend == YES) {
        result.height += paraStyle.lineSpacing;
    }
    return result;
}


+ (NSAttributedString *) getAttributedString:(NSAttributedString *)attStr
                                      inSize:(CGSize)size
                      limitedToNumberOfLines:(NSInteger)numberOfLines {
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,size.width, CGFLOAT_MAX));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, attStr.length), path, NULL);
    
    NSRange resultRange = NSMakeRange(0, 0);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    for (NSInteger i = 0; i < numberOfLines && i < lines.count; ++i) {
        CTLineRef lineRef = (__bridge CTLineRef )lines[i];
        resultRange.length +=  CTLineGetStringRange(lineRef).length;
    }
    
    CFRelease(frameSetter);
    CFRelease(frame);
    CFRelease(path);
    
    return [attStr attributedSubstringFromRange:resultRange];
}

@end
