#import "SSLiftViewController.h"
#import "SSLiftSummaryDataSource.h"
#import "SSWorkoutStore.h"
#import "SSWorkout.h"

@implementation SSLiftViewController

@synthesize ssLiftSummaryDataSource, workoutSummaryTable, ssWorkout;

- (void)viewDidLoad {
    [super viewDidLoad];

    ssWorkout = [[SSWorkoutStore instance] first];
    ssLiftSummaryDataSource = [[SSLiftSummaryDataSource alloc] initWithSsWorkout:ssWorkout];
    [workoutSummaryTable setDataSource:ssLiftSummaryDataSource];
}


- (IBAction)workoutValueChanged:(id)sender {
    UISegmentedControl *workoutSelector = sender;
    [self switchWorkoutToIndex:[workoutSelector selectedSegmentIndex]];
}

- (void)switchWorkoutToIndex:(int)index {
    [ssLiftSummaryDataSource setSsWorkout:[[SSWorkoutStore instance] atIndex:index]];
    [workoutSummaryTable reloadData];
}

@end