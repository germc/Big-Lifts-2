@class Set;

@interface FTOCustomSetViewController : UITableViewController <UITextFieldDelegate> {}
@property (weak, nonatomic) IBOutlet UITextField *repsLabel;
@property (weak, nonatomic) IBOutlet UITextField *percentageLabel;
@property (weak, nonatomic) IBOutlet UISwitch *amrapSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *warmupSwitch;

@property(nonatomic, strong) Set *set;
@end