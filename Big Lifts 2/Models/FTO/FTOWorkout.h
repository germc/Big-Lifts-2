@class Workout;

@interface FTOWorkout : NSManagedObject

@property(nonatomic) Workout *workout;
@property(nonatomic) NSNumber *week;
@property(nonatomic, strong) NSNumber *order;
@end