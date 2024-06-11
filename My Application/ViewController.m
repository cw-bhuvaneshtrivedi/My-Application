//
//  ViewController.m
//  My Application
//
//  Created by Ranjit Mahadik on 30/05/24.
//

#import "ViewController.h"
#import "UsedCarData.h"

@interface ViewController()
@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.stocks = [NSMutableArray array];
    
    self.currentPage = 1;
    self.isLoadingMoreData = NO;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.delegate = self;
    
    [self.view addSubview:self.scrollView];
    [self makePostRequest:self.currentPage];
}

-(void)makePostRequest:(NSInteger)page {
    NSURL *url = [NSURL URLWithString:@"https://stg.carwale.com/api/stocks/filters"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod =@"POST";
    
    NSDictionary *bodyData = @{
        @"pn":@(page),
    };
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:bodyData options:0 error:&error];

    if (!jsonData) {
        NSLog(@"Error creating JSON data: %@", error.localizedDescription);
        return;
    }

    request.HTTPBody = jsonData;

    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error making POST request: %@", error.localizedDescription);
            return;
        }

        if (data) {
            NSError *jsonError;
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];

            if (jsonError) {
                NSLog(@"Error parsing JSON response: %@", jsonError.localizedDescription);
                return;
            }

            NSArray *stocksArray = responseDict[@"stocks"];

            if (stocksArray) {
                NSLog(@"Stocks: %@", stocksArray);
                
                [self.stocks addObjectsFromArray:stocksArray];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self populateScrollView];
                    self.isLoadingMoreData = NO;
                });
            } else {
                NSLog(@"'stocks' key not found in the response.");
            }
        }
    }];

    [dataTask resume];
}

-(void)populateScrollView {
    CGFloat customViewWidth = self.view.frame.size.width - 20;
    CGFloat customViewHeight = 200;
    CGFloat spacing = 10;
    
    for (int i = 0; i < self.stocks.count; i++) {
        CGFloat yOffset = (customViewHeight + spacing) * i + spacing;
        UsedCarData *usedCarData = [[UsedCarData alloc] initWithFrame:CGRectMake(10, yOffset, customViewWidth, customViewHeight)];
        
        NSDictionary *stock = self.stocks[i];
        usedCarData.makeName.text = stock[@"carName"] ? stock[@"carName"] : [NSString stringWithFormat:@"Custom View %d", i + 1];
//        usedCarData.modelName.text = stock
        
        NSString *imageURLString = stock[@"imageUrl"];
        if (imageURLString) {
            NSURL *imageURL = [NSURL URLWithString:imageURLString];
            [usedCarData setImageWithURL:imageURL];
        }
        
        [self.scrollView addSubview:usedCarData];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, (customViewHeight + spacing) * self.stocks.count + spacing);
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollViewHeight = scrollView.frame.size.height;
    CGFloat contentHeight = scrollView.contentSize.height;
    CGFloat yOffset = scrollView.contentOffset.y;
    
    if (yOffset + scrollViewHeight > contentHeight - 100) {
        // Near the bottom, load more data if not already loading
        if (!self.isLoadingMoreData) {
            self.isLoadingMoreData = YES;
            self.currentPage += 1;
            [self makePostRequest:self.currentPage];
        }
    }
}


@end
