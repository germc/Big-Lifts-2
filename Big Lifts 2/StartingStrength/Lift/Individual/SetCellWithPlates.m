#import "SetCellWithPlates.h"
#import "Set.h"
#import "BarCalculator.h"
#import "PlateStore.h"
#import "BarStore.h"
#import "Bar.h"

@implementation SetCellWithPlates

- (void)setSet:(Set *)set {
    [super setSet:set];

    Bar *bar = [[BarStore instance] first];
    BarCalculator *calculator = [[BarCalculator alloc] initWithPlates:[[PlateStore instance] findAll]
                                                            barWeight:bar.weight];

    NSArray *plates = [calculator platesToMakeWeight:[set roundedEffectiveWeight]];
    NSString *platesText = @"";
    if ([plates count] != 0) {
        platesText = [NSString stringWithFormat:@"[%@]", [plates componentsJoinedByString:@", "]];
    }

    [self.platesLabel setText:platesText];
}

@end