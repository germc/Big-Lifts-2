#import "ProgramSelectorViewController.h"
#import "SettingsStore.h"
#import "Settings.h"
#import "CurrentProgramStore.h"
#import "CurrentProgram.h"

@implementation ProgramSelectorViewController {
}

- (IBAction)unitsChanged:(id)sender {
    UISegmentedControl *unitsControl = sender;
    NSArray *unitsMapping = @[@"lbs", @"kg"];
    [[[SettingsStore instance] first] setUnits:unitsMapping[(NSUInteger) [unitsControl selectedSegmentIndex]]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)reloadData {
    Settings *settings = [[SettingsStore instance] first];
    NSDictionary *unitsSegments = @{@"lbs" : @0, @"kg" : @1};
    [unitsSegmentedControl setSelectedSegmentIndex:[[unitsSegments objectForKey:settings.units] integerValue]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self rememberSelectedProgram:[segue identifier]];
}

- (void)rememberSelectedProgram:(NSString *)segueName {
    CurrentProgramStore *store = [CurrentProgramStore instance];
    CurrentProgram *program = [store first];
    if (!program) {
        program = [store create];
    }

    NSDictionary *segueToProgramNames = @{
            @"selectStartingStrengthProgramSegue" : @"StartingStrength"
    };

    program.name = segueToProgramNames[segueName];
}


@end