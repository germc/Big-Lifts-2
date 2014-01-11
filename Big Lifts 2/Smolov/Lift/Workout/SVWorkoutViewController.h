@class JSVWorkout;
@class PaddingTextField;

@interface SVWorkoutViewController : UITableViewController <UITextFieldDelegate> {}

@property(nonatomic, strong) JSVWorkout *svWorkout;
@property(nonatomic, strong) PaddingTextField *oneRepField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

- (IBAction)doneButtonTapped:(id)sender;
@end