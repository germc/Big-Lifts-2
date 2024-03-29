#import "FTOLiftViewController.h"
#import "FTOLiftWorkoutViewController.h"
#import "JFTOLiftStore.h"
#import "JFTOWorkoutStore.h"
#import "JWorkout.h"
#import "JSet.h"
#import "JLift.h"
#import "JFTOVariant.h"
#import "JFTOVariantStore.h"
#import "JFTOWorkout.h"
#import "JFTOWorkoutSetsGenerator.h"
#import "JFTOPlan.h"
#import "JFTOSettings.h"
#import "JFTOSettingsStore.h"
#import "FTOSectionTitleHelper.h"

@interface FTOLiftViewController ()

@property(nonatomic) JFTOWorkout *nextWorkout;
@end

@implementation FTOLiftViewController

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int week = section + 1;
    NSArray *liftsPerWeek = [[JFTOWorkoutStore instance] findAllWhere:@"week" value:(id) [NSNumber numberWithInt:week]];
    return [liftsPerWeek count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[[JFTOWorkoutStore instance] unique:@"week"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FTOLiftViewCell"];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FTOLiftViewCell"];
    }

    int week = [indexPath section] + 1;
    NSUInteger index = (NSUInteger) [indexPath row];
    JFTOWorkout *ftoWorkout = [self getWorkout:week row:index];

    if ([ftoWorkout.workout.sets count] > 0) {
        JSet *set = ftoWorkout.workout.sets[0];
        [cell.textLabel setText:set.lift.name];
    }
    else {
        [cell.textLabel setText:@"Empty workout"];
    }


    if (ftoWorkout.done) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }

    return cell;
}

- (JFTOWorkout *)getWorkout:(int)week row:(NSUInteger)index {
    JFTOWorkout *ftoWorkout = [[JFTOWorkoutStore instance] findAllWhere:@"week" value:(id) [NSNumber numberWithInt:week]][index];
    return ftoWorkout;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[FTOSectionTitleHelper new] titleForSection: section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.nextWorkout = [self getWorkout:([indexPath section] + 1) row:(NSUInteger) [indexPath row]];
    [self performSegueWithIdentifier:@"ftoViewWorkout" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ftoViewWorkout"]) {
        FTOLiftWorkoutViewController *controller = [segue destinationViewController];
        [controller setWorkout:self.nextWorkout];
    }
}

@end