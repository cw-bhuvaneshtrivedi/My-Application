//
//  UsedCarData.h
//  My Application
//
//  Created by Ranjit Mahadik on 05/06/24.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface UsedCarData : UIView


@property (nonatomic,strong) IBOutlet UIImageView *carImage;
@property (nonatomic,strong) IBOutlet UITextView *makeName;
@property (nonatomic,strong) IBOutlet UITextView *modelName;
@property (nonatomic,strong) UIScrollView *scrollView;

-(void) setImageWithURL : (NSURL *)url;

@end

NS_ASSUME_NONNULL_END
