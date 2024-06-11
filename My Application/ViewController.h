//
//  ViewController.h
//  My Application
//
//  Created by Ranjit Mahadik on 30/05/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ViewController : UIViewController

@property (nonatomic,strong) NSMutableArray *stocks;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) BOOL isLoadingMoreData;

@end

NS_ASSUME_NONNULL_END
