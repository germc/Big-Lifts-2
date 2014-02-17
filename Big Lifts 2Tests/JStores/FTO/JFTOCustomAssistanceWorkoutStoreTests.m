#import "JFTOCustomAssistanceWorkoutStoreTests.h"
#import "JFTOCustomAssistanceWorkoutStore.h"
#import "JFTOLiftStore.h"
#import "JWorkoutStore.h"
#import "JFTOCustomAssistanceWorkout.h"
#import "JWorkout.h"
#import "JSetStore.h"
#import "JFTOAssistance.h"

@implementation JFTOCustomAssistanceWorkoutStoreTests

- (void)testSetsUpDefaultPlaceholders {
    STAssertEquals([[JFTOCustomAssistanceWorkoutStore instance] count], 4, @"");
}

- (void)testAdjustsToMainLifts {
    [[JFTOLiftStore instance] removeAtIndex:0];
    STAssertEquals([[JFTOCustomAssistanceWorkoutStore instance] count], 3, @"");
    [[JFTOLiftStore instance] create];
    STAssertEquals([[JFTOCustomAssistanceWorkoutStore instance] count], 4, @"");
}

- (void)testDoesNotLeakWorkouts {
    int workoutCount = [[JWorkoutStore instance] count];
    [[JFTOCustomAssistanceWorkoutStore instance] removeAtIndex:0];
    STAssertEquals(workoutCount - 1, [[JWorkoutStore instance] count], @"");
}

- (void)testCanEmptyAssistance {
    JFTOCustomAssistanceWorkout *ftoCustomAssistanceWorkout = [[JFTOCustomAssistanceWorkoutStore instance] first];
    [ftoCustomAssistanceWorkout.workout addSet:[[JSetStore instance] create]];

    [[JFTOCustomAssistanceWorkoutStore instance] copyTemplate:FTO_ASSISTANCE_NONE];
    STAssertEquals((int) [ftoCustomAssistanceWorkout.workout.sets count], 0, @"");
}

- (void)testCanCopyBbb {
    STFail(@"Write test");
}

@end