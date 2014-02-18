#import "Migrator.h"
#import "JVersionStore.h"
#import "JVersion.h"
#import "Migrate1to2.h"
#import "Migrate2to3.h"
#import "Migrate3to4.h"
#import "Migrate4to5.h"
#import "Migrate5to6.h"
#import "Migrate6to7.h"
#import "Migrate7to8.h"
#import "Migrate8to9.h"

@implementation Migrator

- (void)migrateStores {
    @try {
        [[JVersionStore instance] load];
        JVersion *version = [[JVersionStore instance] first];

        NSDictionary *migrations = @{
                @3 : [Migrate2to3 new],
                @4 : [Migrate3to4 new],
                @5 : [Migrate4to5 new],
                @6 : [Migrate5to6 new],
                @7 : [Migrate6to7 new],
                @8 : [Migrate7to8 new],
                @9 : [Migrate8to9 new]
        };
        //first migration must run every time, since I was missing the version property on existing installs
        if ([version.version intValue] <= 2) {
            [[Migrate1to2 new] run];
            version.version = @2;
        }
        else {
            for (NSNumber *versionNumber in [[migrations allKeys] sortedArrayUsingSelector:@selector(compare:)]) {
                if ([version.version intValue] < [versionNumber intValue]) {
                    NSObject <Migration> *migration = migrations[versionNumber];
                    [migration run];
                    version.version = versionNumber;
                }
            }
        }
    }
    @catch (NSException *e) {
        //TODO: log with crashlytics
    }
}

@end
