#import "NSDate+format.h"

#define NANO_SECOND(nano) (int)((nano)/50000000.f * 3)

@implementation NSDate(format)

- (NSString *) countDownTextToDate_YYMMddHHmmsss:(NSDate *)date {
    NSString *result = nil;
    
    long long miliSeconds = (long long)([date timeIntervalSinceDate:self] * 10);
    int year = (int)(miliSeconds / 315360000);
    int month = (miliSeconds % 315360000) / 25920000;
    int day = (miliSeconds % 25920000) / 864000;
    int hour = (miliSeconds % 864000) / 36000;
    int minute = (miliSeconds % 36000) / 600;
    int second = (miliSeconds % 600) / 10;
    int miliSecond = miliSeconds % 10;
    
    if (year > 0) {
        result = [NSString stringWithFormat:@"%02d年%02d月%02d天%02d时%02d分%02d秒%d",
                  year,
                  month,
                  day,
                  hour,
                  minute,
                  second,
                  miliSecond];
    }
    else if (month > 0) {
        result = [NSString stringWithFormat:@"%02d月%02d天%02d时%02d分%02d秒%d",
                  month,
                  day,
                  hour,
                  minute,
                  second,
                  miliSecond];
    }
    else if (day > 0) {
        result = [NSString stringWithFormat:@"%02d天%02d时%02d分%02d秒%d",
                  day,
                  hour,
                  minute,
                  second,
                  miliSecond];
    }
    else if (hour > 0) {
        result = [NSString stringWithFormat:@"%02d时%02d分%02d秒%d",
                  hour,
                  minute,
                  second,
                  miliSecond];
    }
    else {
        result = [NSString stringWithFormat:@"%02d分%02d秒%d",
                  (int)MAX(minute, 0),
                  (int)MAX(second, 0),
                  MAX(miliSecond, 0)];
    }
    
    return result;
}

- (NSString *) countDownTextToDate_YYMMddHHmmss:(NSDate *)date {
    NSString *result = nil;
    
    long long miliSeconds = [date timeIntervalSinceDate:self];
    int year = (int)(miliSeconds / 31536000);
    int month = (miliSeconds % 31536000) / 2592000;
    int day = (miliSeconds % 2592000) / 86400;
    int hour = (miliSeconds % 86400) / 3600;
    int minute = (miliSeconds % 3600) / 60;
    int second = miliSeconds % 60;
    
    if (year > 0) {
        result = [NSString stringWithFormat:@"%02d年%02d月%02d天%02d时%02d分%02d秒",
                  year,
                  month,
                  day,
                  hour,
                  minute,
                  second];
    }
    else if (month > 0) {
        result = [NSString stringWithFormat:@"%02d月%02d天%02d时%02d分%02d秒",
                  month,
                  day,
                  hour,
                  minute,
                  second];
    }
    else if (day > 0) {
        result = [NSString stringWithFormat:@"%02d天%02d时%02d分%02d秒",
                  day,
                  hour,
                  minute,
                  second];
    }
    else if (hour > 0) {
        result = [NSString stringWithFormat:@"%02d时%02d分%02d秒",
                  hour,
                  minute,
                  second];
    }
    else {
        result = [NSString stringWithFormat:@"%02d分%02d秒",
                  (int)MAX(minute, 0),
                  (int)MAX(second, 0)];
    }
    
    return result;
}

- (NSString *) countDownTextToDate_mmss:(NSDate *)date {
    NSString *result = nil;
    
    long long seconds = (long long)[date timeIntervalSinceDate:self];
    int minute = (int)seconds/60;
    int second = seconds%60;
    
    result = [NSString stringWithFormat:@"%02d : %02d",minute,second];
    
    return result;
}

- (NSString *) countDownTextToDate_hhmmss:(NSDate *)date {
    NSString *result = nil;
    
    long long seconds = (long long)[date timeIntervalSinceDate:self];
    int hour = (int)seconds/60/60;
    int minute = (int)((seconds-hour*3600)/60);
    int second = seconds%60;
    
    result = [NSString stringWithFormat:@"%02d:%02d:%02d",hour,minute,second];
    
    return result;
}

- (NSString *) dateString_specialMdHHmm
{
    if([self equalByAddDay:-2]) {
        return [NSString stringWithFormat:@"前天 %@",[self timeString_HHmm]];
    }else if([self equalByAddDay:-1]) {
        return [NSString stringWithFormat:@"昨天 %@",[self timeString_HHmm]];
    }else if([self equalByAddDay:0]) {
        return [NSString stringWithFormat:@"今天 %@",[self timeString_HHmm]];
    }else if([self equalByAddDay:1]) {
        return [NSString stringWithFormat:@"明天 %@",[self timeString_HHmm]];
    }else if([self equalByAddDay:2]) {
        return [NSString stringWithFormat:@"后天 %@",[self timeString_HHmm]];
    }else{
        return [self dateTimeString_MdHHmm];
    }
}

- (NSDateComponents *)componentsByAddDay:(NSInteger)day {
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay:day];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:componentsToSubtract toDate:self options:0];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:newDate];
    return components;
}

- (BOOL)equalByAddDay:(NSInteger)day {
    NSDateComponents *origin = [self componentsByAddDay:0];
    NSDateComponents *comp = [[NSDate date] componentsByAddDay:day];
    return origin.year == comp.year && origin.month == comp.month && origin.day == comp.day;
}

- (NSString *) dateTimeString:(NSString *)string {
    
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = string;
    }
    return [formatter stringFromDate:self];
}

- (NSString *) dateTimeString_MMddHHmm {
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MM-dd HH:mm";
    }
    return [formatter stringFromDate:self];
}

- (NSString *) dateTimeString_yyyyMMddHHmmss {
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return [formatter stringFromDate:self];
}

- (NSString *) dateTimeString_yyyyMMddHHmm {
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    return [formatter stringFromDate:self];
}

- (NSString *) dateTimeString_yyyyMMdd {
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
    }
    return [formatter stringFromDate:self];
}

- (NSString *) dateTimeString_yyyyMMdd_Seperator_Slash {
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy/MM/dd";
    }
    return [formatter stringFromDate:self];
}

- (NSString *) dateTimeString_MdHHmm {
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"M月d日 HH:mm";
    }
    return [formatter stringFromDate:self];
}

- (NSString *) dateString_Md {
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"M月d日";
    }
    return [formatter stringFromDate:self];
}

- (NSString *) dateString_MMdd {
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MM月dd日";
    }
    return [formatter stringFromDate:self];
}

- (NSString *) timeString_HHmm {
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"HH:mm";
    }
    return [formatter stringFromDate:self];
}

+ (NSString *) currentYearMonthDayKeyString {
    return [[NSDate date] dateTimeString_yyyyMMdd_Seperator_Slash];
}

- (NSString *) timesAgoString {
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    
    NSTimeInterval secondsDiff = (currentTime - [self timeIntervalSince1970]) ;
    NSString *timeString;
    if (secondsDiff / 3600 < 1) {
        if (secondsDiff / 60 < 1) {
            timeString = @"刚刚";
            //            timeString = [NSString stringWithFormat:@"%.f秒前", secondsDiff];
        } else {
            timeString = [NSString stringWithFormat:@"%.f分钟前", secondsDiff / 60];
        }
    } else if (secondsDiff / 3600 > 1 && secondsDiff / 86400 < 1) {
        timeString = [NSString stringWithFormat:@"%.f小时前", secondsDiff / 3600];
    }
    //    else if (secondsDiff / 86400 > 1 && secondsDiff / 604800 < 1) {
    //        timeString = [NSString stringWithFormat:@"%.f天前", secondsDiff / 86400];
    //    }
    else {
        timeString = [self dateTimeString_yyyyMMddHHmm];
    }
    return timeString;
}

- (NSString *) timesAgoStringNoYear {
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval secondsDiff = (currentTime - [self timeIntervalSince1970]) ;
    if (secondsDiff / 86400 < 1) {
        return [self timesAgoString];
    } else {
        return [self dateTimeString_MMddHHmm];
    }
}

- (NSString *) timesAgoStringNoHHmm {
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval secondsDiff = (currentTime - [self timeIntervalSince1970]) ;
    if (secondsDiff / 86400 < 1) {
        return [self timesAgoString];
    } else {
        return [self dateTimeString_yyyyMMdd];
    }
}

@end
