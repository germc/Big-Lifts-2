#import "BLStoreManager.h"
#import "SettingsStore.h"
#import "WorkoutStore.h"
#import "SetStore.h"
#import "SSLiftStore.h"
#import "SSWorkoutStore.h"
#import "CurrentProgramStore.h"
#import "WorkoutLogStore.h"
#import "PlateStore.h"
#import "BarStore.h"
#import "SetLogStore.h"
#import "SSVariantStore.h"
#import "SSStateStore.h"
#import "FTOLiftStore.h"
#import "FTOWorkoutStore.h"
#import "FTOSetStore.h"
#import "FTOSettingsStore.h"
#import "FTOVariantStore.h"
#import "FTOAssistanceStore.h"
#import "FTOTriumvirateLiftStore.h"
#import "FTOTriumvirateStore.h"
#import "FTOSSTLiftStore.h"
#import "FTOBoringButBigStore.h"
#import "SJLiftStore.h"
#import "SJWorkoutStore.h"
#import "FTOCustomWorkoutStore.h"

@implementation BLStoreManager
@synthesize allStores;

+ (NSManagedObjectContext *)context {
    return [[BLStoreManager instance] context];
}

+ (NSManagedObjectModel *)model {
    return [[BLStoreManager instance] model];
}

- (void)initializeAllStores:(NSManagedObjectContext *)context withModel:(NSManagedObjectModel *)model {
    self.context = context;
    self.model = model;
    [self loadStores];
}

- (void)loadStores {
    @try {
        allStores = @[
                [CurrentProgramStore instance],
                [SettingsStore instance],
                [FTOSettingsStore instance],
                [BarStore instance],
                [WorkoutStore instance],
                [WorkoutLogStore instance],
                [SetStore instance],
                [FTOSetStore instance],
                [SSStateStore instance],
                [SSLiftStore instance],
                [SSVariantStore instance],
                [SSWorkoutStore instance],
                [FTOVariantStore instance],
                [FTOBoringButBigStore instance],
                [FTOAssistanceStore instance],
                [FTOLiftStore instance],
                [FTOSSTLiftStore instance],
                [FTOCustomWorkoutStore instance],
                [FTOWorkoutStore instance],
                [FTOTriumvirateLiftStore instance],
                [FTOTriumvirateStore instance],
                [PlateStore instance],
                [SetLogStore instance],
                [WorkoutLogStore instance],
                [SJLiftStore instance],
                [SJWorkoutStore instance]
        ];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"storesLoaded" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataModelChange:)
                                                     name:NSManagedObjectContextObjectsDidChangeNotification
                                                   object:self.context];
    }
    @catch (NSException *e) {
        NSLog(@"Failed to fetch. Trying again");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self loadStores];
        });
    }
}

- (void)resetAllStores {
    for (BLStore *store in allStores) {
        [store empty];
    }

    for (BLStore *store in allStores) {
        [store setupDefaults];
    }
}

- (void)handleDataModelChange:(id)note {
    NSSet *updatedObjects = [[note userInfo] objectForKey:NSUpdatedObjectsKey];
    NSSet *deletedObjects = [[note userInfo] objectForKey:NSDeletedObjectsKey];
    NSSet *insertedObjects = [[note userInfo] objectForKey:NSInsertedObjectsKey];

    NSSet *allObjects = [[updatedObjects setByAddingObjectsFromSet:deletedObjects] setByAddingObjectsFromSet:insertedObjects];
    for (BLStore *store in [self getChangedStoresFromObjects:allObjects]) {
        [store fireChanged];
    }
}

- (NSSet *)getChangedStoresFromObjects:(NSSet *)allObjects {
    NSMutableSet *changedModelNames = [self getChangedModelNames:allObjects];

    NSMutableDictionary *storeModelMapping = [@{} mutableCopy];
    for (BLStore *store in allStores) {
        [storeModelMapping setObject:store forKey:[store modelName]];
    }

    NSMutableSet *changedStores = [NSMutableSet new];
    for (NSString *modelName in changedModelNames) {
        id store = storeModelMapping[modelName];
        if (store == nil ) {
            NSLog(@"Store not defined: %@", modelName);
        }
        else {
            [changedStores addObject:store];
        }
    }

    return changedStores;
}

- (NSMutableSet *)getChangedModelNames:(NSSet *)allObjects {
    NSMutableSet *changedModelNames = [NSMutableSet new];
    for (NSManagedObject *object in allObjects) {
        [changedModelNames addObject:[[object entity] name]];
    }
    return changedModelNames;
}

+ (BLStoreManager *)instance {
    static BLStoreManager *manager = nil;

    if (!manager) {
        manager = [BLStoreManager new];
    }

    return manager;
}

- (void)dataWasSynced {
    for (BLStore *store in self.allStores) {
        [store dataWasSynced];
    }
}

@end