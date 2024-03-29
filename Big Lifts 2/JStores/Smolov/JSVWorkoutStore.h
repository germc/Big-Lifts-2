#import "BLJStore.h"

@class JSVWorkout;

@interface JSVWorkoutStore : BLJStore
- (JSVWorkout *)createWithDay:(int)day week:(int)week cycle:(int)cycle;

- (NSDecimalNumber *)incrementInLbsOrKg:(NSDecimalNumber *)number;

- (void)adjustForKg;
@end