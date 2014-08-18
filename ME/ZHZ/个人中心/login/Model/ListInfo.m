//
//  ListInfo.m
//  ME
//
//  Created by qf on 14/8/10.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "ListInfo.h"
#import "OLNetManager.h"
#import "JSONKit.h"
@interface ListInfo (){
}

@end

@implementation ListInfo

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _data = dic;
    }
    return self;
}

- (void)refreshLinkContent{
	_linkContent = [[OLNetManager netRequestWithUrl:self.link andPostBody:nil] objectFromJSONData];
}

- (NSMutableArray *)linkContent{
	if (!_linkContent) {
		[self refreshLinkContent];
	}
	return _linkContent;
}

- (NSMutableArray *)courses{
	if (!_courses) {
		_courses = [_data objectForKey:@"courses"];
	}
	return _courses;
}

- (NSMutableArray *)values{
	if (!_values) {
		_values = [_data objectForKey:@"value"];
	}
	return _values;
}

- (NSUInteger)count{
	if (_data) {
		_count = [[_data objectForKey:@"count"] integerValue];
	}
	return _count;
}

- (NSString *)link{
	if (!_link) {
		_link = [_data objectForKey:@"link"];
	}
	return _link;
}

@end
