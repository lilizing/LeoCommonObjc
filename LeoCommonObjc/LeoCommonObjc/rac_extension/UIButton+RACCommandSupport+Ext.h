#import <ReactiveCocoa/ReactiveCocoa.h>

typedef void (^ButtonActionBlock)(UIButton *sender);

@interface UIButton(RACCommandSupport_Ext)

// rac_actionBlock is much more lightweight than rac_command, prefer not to use rac_command
@property (nonatomic, copy) ButtonActionBlock rac_actionBlock;

- (void) setEnabled:(RACSignal *)enabled actionBlock:(ButtonActionBlock)actionBlock;

@end
