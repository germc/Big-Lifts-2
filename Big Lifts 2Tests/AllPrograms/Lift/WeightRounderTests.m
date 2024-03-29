#import "WeightRounderTests.h"
#import "WeightRounder.h"
#import "JSettingsStore.h"
#import "JSettings.h"

@implementation WeightRounderTests

- (void)testRoundsTo5ByDefault {
    STAssertEqualObjects([[WeightRounder new] round:N(165)], @165, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(166)], @165, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(168)], @170, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(167.5)], @170, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(167.3)], @165, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(85.4)], @85, @"");
}

- (void)testRoundsTo5WithDirection {
    [[[JSettingsStore instance] first] setRoundingType:(NSString *) ROUNDING_TYPE_UP];
    STAssertEqualObjects([[WeightRounder new] round:N(160.1)], @165, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(165)], @165, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(165.1)], @170, @"");

    [[[JSettingsStore instance] first] setRoundingType:(NSString *) ROUNDING_TYPE_DOWN];
    STAssertEqualObjects([[WeightRounder new] round:N(164.9)], @160, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(165)], @165, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(169.9)], @165, @"");
}

- (void)testRoundsTo2p5 {
    [[[JSettingsStore instance] first] setRoundTo:N(2.5)];
    STAssertEqualObjects([[WeightRounder new] round:N(81.24)], @80, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(82.5)], @82.5, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(83.75)], @85, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(85)], @85, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(86.25)], @87.5, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(87.5)], @87.5, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(87.6)], @87.5, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(88.75)], @90, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(90)], @90, @"");
}

- (void)testRoundsTo2p5WithDirection {
    [[[JSettingsStore instance] first] setRoundTo:N(2.5)];
    [[[JSettingsStore instance] first] setRoundingType:(NSString *) ROUNDING_TYPE_UP];
    STAssertEqualObjects([[WeightRounder new] round:N(80.1)], @82.5, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(82.5)], @82.5, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(85.0)], @85, @"");

    [[[JSettingsStore instance] first] setRoundingType:(NSString *) ROUNDING_TYPE_DOWN];
    STAssertEqualObjects([[WeightRounder new] round:N(82.4)], @80, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(89.9)], @87.5, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(85.0)], @85, @"");
}

- (void)testDoesNotCrashOnBoundaryInputs {
    STAssertEqualObjects([[WeightRounder new] round:N(0)], @0, @"");
    STAssertEqualObjects([[WeightRounder new] round:nil], @0, @"");
    STAssertEqualObjects([[WeightRounder new] round:[NSDecimalNumber notANumber]], @0, @"");
}

- (void)testRoundsTo1 {
    [[[JSettingsStore instance] first] setRoundTo:N(1)];
    STAssertEqualObjects([[WeightRounder new] round:N(166)], @166, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(166.3)], @166, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(166.5)], @167, @"");
}

- (void)testRoundTo1WithDirection {
    [[[JSettingsStore instance] first] setRoundTo:N(1)];
    [[[JSettingsStore instance] first] setRoundingType:(NSString *) ROUNDING_TYPE_UP];
    STAssertEqualObjects([[WeightRounder new] round:N(166)], @166, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(166.1)], @167, @"");

    [[[JSettingsStore instance] first] setRoundingType:(NSString *) ROUNDING_TYPE_DOWN];
    STAssertEqualObjects([[WeightRounder new] round:N(166)], @166, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(166.9)], @166, @"");
}

- (void)testRoundToNearest5 {
    [[[JSettingsStore instance] first] setRoundTo:[NSDecimalNumber decimalNumberWithString:NEAREST_5_ROUNDING]];
    STAssertEqualObjects([[WeightRounder new] round:N(166)], @165, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(160)], @165, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(159)], @155, @"");
}

- (void)testRoundToNearest5WithDirection {
    [[[JSettingsStore instance] first] setRoundTo:[NSDecimalNumber decimalNumberWithString:NEAREST_5_ROUNDING]];
    [[[JSettingsStore instance] first] setRoundingType:(NSString *) ROUNDING_TYPE_UP];
    STAssertEqualObjects([[WeightRounder new] round:N(165)], @165, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(165.1)], @175, @"");

    [[[JSettingsStore instance] first] setRoundingType:(NSString *) ROUNDING_TYPE_DOWN];
    STAssertEqualObjects([[WeightRounder new] round:N(165)], @165, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(164.9)], @155, @"");
}

- (void)testRoundsTo2 {
    [[[JSettingsStore instance] first] setRoundTo:N(2)];
    STAssertEqualObjects([[WeightRounder new] round:N(166)], @166, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(160)], @160, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(159)], @160, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(158.9)], @158, @"");
}

- (void)testRoundsTo2WithDirection {
    [[[JSettingsStore instance] first] setRoundTo:N(2)];
    [[[JSettingsStore instance] first] setRoundingType:(NSString *) ROUNDING_TYPE_UP];
    STAssertEqualObjects([[WeightRounder new] round:N(166)], @166, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(166.1)], @168, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(165.9)], @166, @"");

    [[[JSettingsStore instance] first] setRoundingType:(NSString *) ROUNDING_TYPE_DOWN];
    STAssertEqualObjects([[WeightRounder new] round:N(166)], @166, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(166.1)], @166, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(165.9)], @164, @"");
}

- (void)testRoundsTo0p5 {
    [[[JSettingsStore instance] first] setRoundTo:N(0.5)];
    STAssertEqualObjects([[WeightRounder new] round:N(166)], @166, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(166.5)], @166.5, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(166.2)], @166, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(166.25)], @166.5, @"");

    [[[JSettingsStore instance] first] setRoundingType:(NSString *) ROUNDING_TYPE_UP];
    STAssertEqualObjects([[WeightRounder new] round:N(166)], @166, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(166.5)], @166.5, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(166.2)], @166.5, @"");

    [[[JSettingsStore instance] first] setRoundingType:(NSString *) ROUNDING_TYPE_DOWN];
    STAssertEqualObjects([[WeightRounder new] round:N(166)], @166, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(166.5)], @166.5, @"");
    STAssertEqualObjects([[WeightRounder new] round:N(166.4)], @166, @"");
}

@end