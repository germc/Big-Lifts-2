#import "FTOWorkoutLogWorkSetsDataSourceTests.h"
#import "FTOWorkoutLogWorkSetsDataSource.h"
#import "JWorkoutLogStore.h"
#import "JSetLog.h"
#import "JSetLogStore.h"
#import "JWorkoutLog.h"

@implementation FTOWorkoutLogWorkSetsDataSourceTests

-(void) testReturnsWorkSets {
    JWorkoutLog *workoutLog = [[JWorkoutLogStore instance] create];
    JSetLog *warmup = [[JSetLogStore instance] create];
    warmup.warmup = YES;
    warmup.reps = @1;
    JSetLog *work1 = [[JSetLogStore instance] create];
    work1.warmup = NO;
    work1.reps = @2;
    work1.name = @"Squat";
    work1.weight = N(200);
    JSetLog *work2 = [[JSetLogStore instance] create];
    work2.warmup = NO;
    work2.reps = @3;
    work2.name = @"Squat";
    work2.weight = N(200);
    [workoutLog.sets addObjectsFromArray:@[warmup, work1, work2]];

    FTOWorkoutLogWorkSetsDataSource *dataSource = [[FTOWorkoutLogWorkSetsDataSource alloc] initWithWorkoutLog:workoutLog];
    STAssertEquals((int)[dataSource tableView:nil numberOfRowsInSection:0], 2, @"");
}

- (void) testDoesNotCombinesWorkSets {
    JWorkoutLog *workoutLog = [[JWorkoutLogStore instance] create];
    JSetLog *work1 = [[JSetLogStore instance] create];
    work1.reps = @3;
    work1.weight = N(100);
    work1.name = @"Squat";
    JSetLog *work2 = [[JSetLogStore instance] create];
    work2.reps = @3;
    work2.weight = N(100);
    work2.name = @"Squat";
    JSetLog *work3 = [[JSetLogStore instance] create];
    work3.reps = @1;
    work3.weight = N(100);

    [workoutLog.sets addObjectsFromArray:@[work1, work2, work3]];

    FTOWorkoutLogWorkSetsDataSource *dataSource = [[FTOWorkoutLogWorkSetsDataSource alloc] initWithWorkoutLog:workoutLog];
    STAssertEquals((int)[dataSource tableView:nil numberOfRowsInSection:0], 3, @"");
}

@end