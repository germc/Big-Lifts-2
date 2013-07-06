#import "SetStore.h"
#import "Set.h"
#import "SSLift.h"
#import "Lift.h"

@implementation SetStore
- (Set *)createWithLift:(Lift *)lift percentage:(NSDecimalNumber *)percentage {
    Set *set = [[SetStore instance] create];
    set.lift = lift;
    set.percentage = percentage;
    return set;
}

@end