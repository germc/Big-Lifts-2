#import "DataLoadingViewController.h"
#import "CurrentProgramStore.h"
#import "CurrentProgram.h"

@implementation DataLoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSelector:@selector(pollForReady) withObject:nil afterDelay:0.5];
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.dataLoaded) {
        [self segueToApp];
    }
}

- (void)pollForReady {
    if (self.dataLoaded) {
        [self segueToApp];
    }
    else {
        [self performSelector:@selector(pollForReady) withObject:nil afterDelay:0.5];
    }
}

- (void)segueToApp {
    CurrentProgram *program = [[CurrentProgramStore instance] first];
    if (program.name) {
        [self performSegueWithIdentifier:@"dataLoadedSegueToProgram" sender:self];
    }
    else {
        [self performSegueWithIdentifier:@"dataLoadedSegue" sender:self];
    }

}

@end