#import "BLStore.h"

@interface FTOWorkoutStore : BLStore
- (void)switchTemplate;

- (void)restoreTemplate;

- (NSDictionary *)getDoneLiftsByWeek;

- (void)createWithWorkout:(id)week week:(int)week1 order:(int)order;

- (void)reorderWorkoutsToLifts;
@end