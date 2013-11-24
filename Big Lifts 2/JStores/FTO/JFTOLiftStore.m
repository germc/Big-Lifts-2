#import <MRCEnumerable/NSArray+Enumerable.h>
#import "JFTOLiftStore.h"
#import "JFTOLift.h"

@implementation JFTOLiftStore

- (Class)modelClass {
    return JFTOLift.class;
}

- (void)setupDefaults {
    [self createWithName:@"Bench" increment:5 order:0];
    [self createWithName:@"Squat" increment:10 order:1];
    [self createWithName:@"Press" increment:5 order:2];
    [self createWithName:@"Deadlift" increment:10 order:3];
    [self sync];
}

- (void)onLoad {
}

- (void)incrementLifts {
    [[self findAll] each:^(JFTOLift *lift) {
        [lift setWeight:[lift.weight decimalNumberByAdding:lift.increment]];
    }];
}

- (void)createWithName:(NSString *)name increment:(int)increment order:(int)order {
    JFTOLift *lift = [self create];
    lift.name = name;
    lift.increment = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithInt:increment] decimalValue]];
    lift.order = [NSNumber numberWithInt:order];
    lift.usesBar = YES;
}

- (void)adjustForKg {
//    SettingsStore *settingsStore = [SettingsStore instance];
//    Settings *settings = [settingsStore first];
//    if ([settings.units isEqualToString:@"kg"]) {
//        NSArray *liftNames = [[self findAll] collect:^id(Lift *lift) {
//            return lift.name;
//        }];
//        [liftNames each:^(NSString *liftName) {
//            FTOLift *lift = [[FTOLiftStore instance] find:@"name" value:liftName];
//            lift.increment = [settingsStore defaultLbsIncrementForLift:lift.name] ?
//                    [settingsStore defaultIncrementForLift:lift.name] : lift.increment;
//        }];
//    }
}

@end