#import <CTCustomTableViewCell/CTCustomTableViewCell.h>

@protocol ShareDelegate;

@interface RestShareToolbar : CTCustomTableViewCell <UIActionSheetDelegate> {
}
@property(weak, nonatomic) IBOutlet UIButton *timerButton;

@property(weak, nonatomic) IBOutlet UIButton *shareButton;
@property(nonatomic, weak) UIViewController <ShareDelegate> *shareDelegate;

- (void)updateTime;
@end