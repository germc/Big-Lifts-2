#import "OneRepEstimatorTests.h"
#import "OneRepEstimator.h"

@implementation OneRepEstimatorTests

- (void) testEstimatesOneRepMax {
    STAssertEqualObjects([[OneRepEstimator new] estimate:N(200) withReps:6], N(239.6), @"");
}

@end