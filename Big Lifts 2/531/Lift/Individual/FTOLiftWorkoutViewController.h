#import "AmrapDelegate.h"

@class FTOWorkout;
@class Set;

@interface FTOLiftWorkoutViewController : UITableViewController <UITextFieldDelegate, AmrapDelegate> {
}
@property(weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property(nonatomic, strong) FTOWorkout *ftoWorkout;

@property(nonatomic) NSNumber * tappedSetRow;

- (IBAction)doneButtonTapped:(id)sender;

- (void) setWorkout: (FTOWorkout *) ftoWorkout1;

@end