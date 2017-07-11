#import <ReactiveCocoa/ReactiveCocoa.h>

typedef void (^BarButtonItemActionBlock)(UIBarButtonItem *sender);

@interface UIBarButtonItem(RACCommandSupport_Ext)

// rac_actionBlock is much lightweight than rac_command
@property (nonatomic, copy) BarButtonItemActionBlock rac_actionBlock;

- (void) setEnabled:(RACSignal *)enabled actionBlock:(BarButtonItemActionBlock)actionBlock;

@end
