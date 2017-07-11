#import "RACCommand+Ext.h"
#import "NSObject+Ext.h"
#import <ReactiveCocoa/NSInvocation+RACTypeParsing.h>

@interface RACCommand(Ext_private)

@property (nonatomic, copy, readonly) RACSignal * (^signalBlock)(id input); // hack to get defined signalBlock property;

@end

#pragma mark -

@implementation RACCommand(Ext_private)

@dynamic signalBlock;

@end

#pragma mark -

@implementation RACCommand(Ext)

@dynamic captchaRetry;
- (BOOL)captchaRetry {
    return ((NSNumber *)GET_ASSOCIATED_OBJ()).boolValue;
}

- (void)setCaptchaRetry:(BOOL)retry {
    NSNumber *captchaRetry = @(retry);
    SET_ASSOCIATED_OBJ_RETAIN_NONATOMIC(captchaRetry);
}

@dynamic returnValue;
-(id)returnValue {
    return GET_ASSOCIATED_OBJ();
}

-(void)setReturnValue:(id)returnValue {
    SET_ASSOCIATED_OBJ_RETAIN_NONATOMIC(returnValue);
}

@dynamic muteErrorMessage;
- (BOOL)muteErrorMessage {
    return ((NSNumber *)GET_ASSOCIATED_OBJ()).boolValue;
}
- (void)setMuteErrorMessage:(BOOL)b {
    NSNumber *muteErrorMessage = @(b);
    SET_ASSOCIATED_OBJ_RETAIN_NONATOMIC(muteErrorMessage);

    if (self.muteErrorMessageDidChangeBlock) {
        self.muteErrorMessageDidChangeBlock(b);
    }
}

@dynamic muteErrorMessageDidChangeBlock;
- (MuteErrorMessageDidChangeBlock) muteErrorMessageDidChangeBlock {
    return (MuteErrorMessageDidChangeBlock)GET_ASSOCIATED_OBJ();
}
- (void)setMuteErrorMessageDidChangeBlock:(MuteErrorMessageDidChangeBlock)muteErrorMessageDidChangeBlock {
    SET_ASSOCIATED_OBJ_COPY_NONATOMIC(muteErrorMessageDidChangeBlock);
}

- (RACSignal *) createStandloneInternalSignalWithInput:(id)input {
    return self.signalBlock(input);
}

- (RACSignal *) responses {
    return [self.executionSignals switchToLatest];
}

+ (RACCommand *) commandWithCommand:(RACCommand *)command
                            enabled:(RACSignal *)enabled
                        willExecute:(NSError *(^)(id input)) willExecuteBlock
                        executeArgs:(NSArray *(^)(id input)) executeArgsBlock {
    if (!enabled) {
        enabled = command.enabled;
    }

    return [[RACCommand alloc] initWithEnabled:enabled
                                   signalBlock:^RACSignal *(id input) {
                                       NSError *error = nil;
                                       if (willExecuteBlock) {
                                           error = willExecuteBlock(input);
                                       }

                                       if (error) {
                                           return [RACSignal error:error];
                                       }

                                       if (executeArgsBlock) {
                                           input = executeArgsBlock(input);
                                       }

                                       return [command createStandloneInternalSignalWithInput:input];
                                   }];
}

+ (RACCommand *) commandWithTarget:(id)target
                          selector:(SEL)selector
                           enabled:(RACSignal *)enabled
                       willExecute:(NSError *(^)(id input)) willExecuteBlock
                       executeArgs:(NSArray *(^)(id input, id<RACSubscriber>subscriber)) executeArgsBlock
                        didExecute:(NSError *(^)(id input, id result)) didExecuteBlock
                     cancleExecute:(void (^)(id input, id result)) cancelExecuteBlock {
    return [[RACCommand alloc] initWithTarget:target
                                     selector:selector
                                      enabled:enabled
                                  willExecute:willExecuteBlock
                                  executeArgs:executeArgsBlock
                                   didExecute:didExecuteBlock
                                cancleExecute:cancelExecuteBlock];
}

- (instancetype) initWithTarget:(id)target
                       selector:(SEL)selector
                        enabled:(RACSignal *)enabled
                    willExecute:(NSError *(^)(id input)) willExecuteBlock
                    executeArgs:(NSArray *(^)(id input, id<RACSubscriber>subscriber)) executeArgsBlock
                     didExecute:(NSError *(^)(id input, id result)) didExecuteBlock
                  cancleExecute:(void (^)(id input, id result)) cancelExecuteBlock {
    @weakify(self, target)

    return [self initWithEnabled:enabled signalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self, target)

            NSError *error = nil;

            if (willExecuteBlock && (error = willExecuteBlock(input))) {
                [subscriber sendError:error];
                return nil;
            }

            NSMethodSignature *signature = [target methodSignatureForSelector:selector];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            invocation.selector = selector;
            invocation.target = target;

            __block NSInteger argIndex = 2;
            NSArray *arguments = nil;

            if (executeArgsBlock) {
                arguments = executeArgsBlock(input, subscriber);
                NSAssert(!arguments || [arguments isKindOfClass:NSArray.class], @"arguments must be array");
            }

            [arguments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                // replace NSNull with nil
                if (NSNull.null == obj) {
                    obj = nil;
                }

                [invocation rac_setArgument:obj atIndex:argIndex++];
            }];

            [invocation invoke];

            id returnValue = [invocation rac_returnValue];
            self.returnValue = returnValue;
            
            if (didExecuteBlock && (error = didExecuteBlock(input, returnValue))) {
                [subscriber sendError:error];
                return nil;
            }

            return [RACDisposable disposableWithBlock:^{
                !cancelExecuteBlock ? : cancelExecuteBlock(input, returnValue);
            }];
        }];
    }];
}

@end
