#import "BarStore.h"
#import "Bar.h"
#import "SettingsStore.h"
#import "Settings.h"

@implementation BarStore

- (void)setupDefaults {
    Bar *bar = [[BarStore instance] create];
    bar.weight = [NSNumber numberWithDouble:45];
}

- (void)onLoad {
    [[SettingsStore instance] registerChangeListener:^{
        [self adjustWeightForSettings];
    }];
}

- (void)adjustWeightForSettings {
    Bar *bar = [[BarStore instance] first];
    Settings *settings = [[SettingsStore instance] first];
    if ([settings.units isEqualToString:@"kg"]) {
        bar.weight = [NSNumber numberWithDouble:20.4];
    }
}


@end