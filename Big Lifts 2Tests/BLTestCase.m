#import "BLTestCase.h"
#import "BLStoreManager.h"
#import "IAPAdapter.h"
#import "SKProductStore.h"
#import "BLJStoreManager.h"

@implementation BLTestCase

- (void)setUp {
    self.done = NO;
    if (![BLStoreManager context]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoaded) name:@"dataLoaded" object:nil];
        [self waitForCompletion:5];
    }

    [[SKProductStore instance] removePurchases];
    [[IAPAdapter instance] resetPurchases];
    [[BLStoreManager instance] resetAllStores];
    [[BLJStoreManager instance] resetAllStores];
}

- (void)dataLoaded {
    self.done = YES;
}

- (BOOL)waitForCompletion:(NSTimeInterval)timeoutSecs {
    NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:timeoutSecs];
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:timeoutDate];
        if ([timeoutDate timeIntervalSinceNow] < 0.0)
            break;
    } while (!self.done);
    return self.done;
}

@end