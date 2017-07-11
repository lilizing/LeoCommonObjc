#import <ReactiveCocoa/ReactiveCocoa.h>

typedef void(^MuteErrorMessageDidChangeBlock)(BOOL muteErrorMessage);

@interface RACCommand(Ext)

@property (assign) BOOL captchaRetry;
@property (assign) BOOL muteErrorMessage;
@property (nonatomic, strong) id returnValue;
@property (copy) MuteErrorMessageDidChangeBlock muteErrorMessageDidChangeBlock;

- (RACSignal *) createStandloneInternalSignalWithInput:(id)input;

- (RACSignal *) responses;

+ (RACCommand *) commandWithCommand:(RACCommand *)command
                            enabled:(RACSignal *)enabled
                        willExecute:(NSError *(^)(id input)) willExecuteBlock
                        executeArgs:(NSArray *(^)(id input)) executeArgsBlock;

/*
 * @target: will not be retained, similar with NSInvocation
 */
+ (RACCommand *) commandWithTarget:(id)target
                          selector:(SEL)selector
                           enabled:(RACSignal *)enabled
                       willExecute:(NSError *(^)(id input)) willExecuteBlock
                       executeArgs:(NSArray *(^)(id input, id<RACSubscriber>subscriber)) executeArgsBlock
                        didExecute:(NSError *(^)(id input, id result)) didExecuteBlock
                     cancleExecute:(void (^)(id input, id result)) cancelExecuteBlock;

- (instancetype) initWithTarget:(id)target
                       selector:(SEL)selector
                        enabled:(RACSignal *)enabled
                    willExecute:(NSError *(^)(id input)) willExecuteBlock
                    executeArgs:(NSArray *(^)(id input, id<RACSubscriber>subscriber)) executeArgsBlock
                     didExecute:(NSError *(^)(id input, id result)) didExecuteBlock
                  cancleExecute:(void (^)(id input, id result)) cancelExecuteBlock;

@end
