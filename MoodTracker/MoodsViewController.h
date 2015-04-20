#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class FetchedResultsControllerDataSource;
@class MoodEntry;


@interface MoodsViewController : UITableViewController

@property (nonatomic, strong) MoodEntry* moodEntry;

-(instancetype)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

@end