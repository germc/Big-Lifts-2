@class Set;
@protocol SetChangeDelegate;

@interface FTOSetRepsForm : UITableViewController <UITextFieldDelegate> {
}
@property(weak, nonatomic) IBOutlet UITextField *repsField;
@property (weak, nonatomic) IBOutlet UITextField *weightField;

@property (weak, nonatomic) IBOutlet UILabel *oneRepField;
@property(nonatomic, strong) NSObject <SetChangeDelegate> *delegate;

@property(nonatomic, strong) Set *set;
@property(nonatomic) int previouslyEnteredReps;

@property(nonatomic, strong) NSDecimalNumber *previouslyEnteredWeight;

- (void)setupFields;
@end