#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface UITextView(Ext)

@property (nonatomic, assign) NSInteger maxLength;
@property (nonatomic, strong, readonly) RACDisposable *reachMaxLengthWarningSignal;

- (NSString *) textIfChangeTextInRange:(NSRange)range
                       replacementText:(NSString *)text;

- (NSInteger) textLengthIfChangeTextInRange:(NSRange)range
                            replacementText:(NSString *)text;

@end
