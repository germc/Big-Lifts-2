#import "BLJStoreManagerTests.h"
#import "JLift.h"
#import "JLiftStore.h"
#import "BLJStoreManager.h"
#import "JFTOLift.h"
#import "JFTOLiftStore.h"
#import "JSJLift.h"
#import "JSJLiftStore.h"

@implementation BLJStoreManagerTests

- (void)testFindsStoreForASubclassByUuid {
    JLift *lift = [[JLiftStore instance] create];
    JFTOLift *ftoLift = [[JFTOLiftStore instance] create];
    JSJLift *sjLift = [[JSJLiftStore instance] create];

    STAssertEquals([[BLJStoreManager instance] storeForModel:JLift.class withUuid: lift.uuid], [JLiftStore instance], @"");
    STAssertEquals([[BLJStoreManager instance] storeForModel:JLift.class withUuid: ftoLift.uuid], [JFTOLiftStore instance], @"");
    STAssertEquals([[BLJStoreManager instance] storeForModel:JLift.class withUuid: sjLift.uuid], [JSJLiftStore instance], @"");
}

@end