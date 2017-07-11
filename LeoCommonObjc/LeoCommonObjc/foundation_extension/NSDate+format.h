#import <Foundation/Foundation.h>

@interface NSDate(format)

- (NSString *) countDownTextToDate_YYMMddHHmmsss:(NSDate *)date;

- (NSString *) countDownTextToDate_YYMMddHHmmss:(NSDate *)date;

- (NSString *) countDownTextToDate_mmss:(NSDate *)date;

- (NSString *) countDownTextToDate_hhmmss:(NSDate *)date;

- (NSString *) dateString_specialMdHHmm;
- (NSString *) dateTimeString_MMddHHmm;
- (NSString *) dateTimeString_yyyyMMddHHmm;
- (NSString *) dateTimeString_yyyyMMdd;
- (NSString *) dateTimeString_yyyyMMdd_Seperator_Slash;
- (NSString *) dateTimeString_yyyyMMddHHmmss;
- (NSString *) dateTimeString_MdHHmm;
- (NSString *) dateString_Md;
- (NSString *) dateString_MMdd;
- (NSString *) timeString_HHmm;
- (NSString *) timesAgoString;
- (NSString *) timesAgoStringNoYear;
- (NSString *) timesAgoStringNoHHmm;

- (NSString *) dateTimeString:(NSString *)string;
- (BOOL)equalByAddDay:(NSInteger)day;

+ (NSString *) currentYearMonthDayKeyString;

@end
