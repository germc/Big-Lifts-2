#import <MRCEnumerable/NSArray+Enumerable.h>
#import "FTOBoringButBigAssistance.h"
#import "FTOWorkoutStore.h"
#import "FTOWorkout.h"
#import "Workout.h"
#import "Set.h"
#import "Lift.h"
#import "FTOSetStore.h"
#import "FTOSet.h"
#import "FTOBoringButBig.h"
#import "FTOBoringButBigStore.h"
#import "SetData.h"

@implementation FTOBoringButBigAssistance

- (void)setup {
    [[FTOWorkoutStore instance] switchTemplate];
    [self removeAmrapFromWorkouts];
    [self addBoringSets];
}

- (void)cycleChange {
}

- (void)removeAmrapFromWorkouts {
    [[[FTOWorkoutStore instance] findAll] each:^(FTOWorkout *ftoWorkout) {
        [[[ftoWorkout.workout sets] array] each:^(Set *set) {
            set.amrap = NO;
        }];
    }];
}

- (void)addBoringSets {
    [[[FTOWorkoutStore instance] findAll] each:^(FTOWorkout *ftoWorkout) {
        int sets = ftoWorkout.deload ? 3 : 5;
        Set *set = ftoWorkout.workout.sets[0];
        [ftoWorkout.workout.sets addObjectsFromArray:[self createBoringSets:sets forLift:set.lift]];
    }];
}

- (NSArray *)createBoringSets:(int)numberOfSets forLift:(Lift *)lift {
    NSMutableArray *sets = [@[] mutableCopy];
    NSDecimalNumber *percentage = [[[FTOBoringButBigStore instance] first] percentage];
    for (int set = 0; set < numberOfSets; set++) {
        FTOSet *ftoSet = [[FTOSetStore instance] create];
        ftoSet.lift = lift;
        ftoSet.percentage = percentage;
        ftoSet.reps = @10;
        [sets addObject:ftoSet];
    }
    return sets;
}

@end