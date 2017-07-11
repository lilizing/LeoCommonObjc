#import "UITextView+Ext.h"
#import "NSObject+Ext.h"
#import "RACDisposableSubscriptingAssignmentTrampoline.h"
#import "UIDevice+Ext.h"

@implementation UITextView(Ext)

@dynamic reachMaxLengthWarningSignal;
- (RACSignal *) reachMaxLengthWarningSignal {
    RACSignal *result = GET_ASSOCIATED_OBJ();

    if (!result) {
        RACSubject *reachMaxLengthWarningSignal = [RACSubject subject];
        SET_ASSOCIATED_OBJ_RETAIN_NONATOMIC(reachMaxLengthWarningSignal);

        result = reachMaxLengthWarningSignal;
    }

    return result;
}

@dynamic maxLength;
- (NSInteger) maxLength {
    NSNumber *num = GET_ASSOCIATED_OBJ();
    return num ? num.integerValue : NSIntegerMax;
}
- (void) setMaxLength:(NSInteger)length {
    NSNumber *maxLength = nil;
    RACDisposable *disposbale = nil;

    if (NSIntegerMax != length) {
        @weakify(self)

        disposbale = \
        [self.rac_textSignal subscribeNext:^(id _) {
            @strongify(self)

            // skip if there are marked text during multil stage language input,
            // or will cause crash in iOS 7: http://mantis.bolo.me/view.php?id=5947
            if (!self.markedTextRange && self.text.length > length) {
                self.text = [self.text substringToIndex:length];

                // force rac_textSignal to send new text value
                [self.delegate textViewDidChange:self];

                RACSubject *subject = (RACSubject *) self.reachMaxLengthWarningSignal;
                [subject sendNext:nil];
            }
        }];

        maxLength = @(length);
    }

    RACDisposable(self, maxLengthDisposable) = disposbale;
    SET_ASSOCIATED_OBJ_RETAIN_NONATOMIC(maxLength);
}

- (NSString *) textIfChangeTextInRange:(NSRange)range
                       replacementText:(NSString *)text{
    return [self.text stringByReplacingCharactersInRange:range withString:text];
}

- (NSInteger) textLengthIfChangeTextInRange:(NSRange)range
                            replacementText:(NSString *)text{
    return [text length] - range.length + [self.text length];
}

@end
