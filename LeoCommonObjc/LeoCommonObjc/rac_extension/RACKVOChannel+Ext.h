#import <ReactiveCocoa/ReactiveCocoa.h>

#define RACChannelBindWithTextField(viewModel, property, textField)\
({\
RACCompoundDisposable *disposable = [RACCompoundDisposable compoundDisposable];\
RACChannelTerminal *viewModelTextTerminal = RACChannelTo(viewModel, property);\
RACChannelTerminal *inputFieldTerminal = [textField rac_newTextChannel];\
[disposable addDisposable:[viewModelTextTerminal subscribe:inputFieldTerminal]];\
[disposable addDisposable:[inputFieldTerminal subscribe:viewModelTextTerminal]];\
\
[self.rac_deallocDisposable addDisposable:disposable];\
\
@weakify(self)\
\
[RACDisposable disposableWithBlock:^{\
@strongify(self)\
\
[self.rac_deallocDisposable removeDisposable:disposable];\
[disposable dispose];\
}];\
})