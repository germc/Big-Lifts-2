#import "JSONModel/JSONModel.h"

@interface JModel : JSONModel

@property(nonatomic, copy) NSString *uuid;

-(NSArray *) cascadeDeleteClasses;

@end