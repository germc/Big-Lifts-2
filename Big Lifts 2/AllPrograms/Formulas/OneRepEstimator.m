#import "OneRepEstimator.h"
#import "JSettings.h"
#import "EpleyEstimator.h"
#import "JSettingsStore.h"
#import "BrzyckiEstimator.h"
#import "DecimalNumberHelper.h"

@implementation OneRepEstimator

- (NSDecimalNumber *)estimate:(NSDecimalNumber *)weight withReps:(int)reps {
    if (reps == 1) {
        return [DecimalNumberHelper nanOrNil:weight] ? N(0) : weight;
    }
    else if (reps == 0 || weight == nil || [weight isEqual:[NSDecimalNumber notANumber]]) {
        return N(0);
    }

    NSDictionary *estimators = @{
            ROUNDING_FORMULA_EPLEY : [EpleyEstimator new],
            ROUNDING_FORMULA_BRZYCKI : [BrzyckiEstimator new]
    };
    NSObject <MaxEstimator> *estimator = estimators[[[[JSettingsStore instance] first] roundingFormula]];
    return [self oneDecimalPlace:[estimator estimate:weight withReps:reps]];
}

- (NSDecimalNumber *)oneDecimalPlace:(NSDecimalNumber *)number {
    NSDecimalNumberHandler *handler =
            [[NSDecimalNumberHandler alloc] initWithRoundingMode:NSRoundPlain scale:1 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    return [number decimalNumberByRoundingAccordingToBehavior:handler];
}

@end