//
//  SBJson4RecordParser.m
//  SBJSON_test
//
//  Created by pawelc on 04/04/2018.
//  Copyright © 2018 MP. All rights reserved.
//

#import "SBJson5RecordParser.h"
#import <objc/runtime.h>
#import <objc/message.h>


@interface SBJson5RecordParser () {
	SBJson5RecordValueBlock _recordValueBlock;
}

@end

@implementation SBJson5RecordParser

+ (id)multiRootParserWithValueBlock:(SBJson5RecordValueBlock)valueBlock errorHandler:(SBJson5ErrorBlock)eh {
	return [self parserWithValueBlock:valueBlock
				  allowMultiRoot:YES
				 unwrapRootArray:NO
					errorHandler:eh];
}

+ (id)unwrapRootArrayParserWithValueBlock:(SBJson5RecordValueBlock)valueBlock errorHandler:(SBJson5ErrorBlock)eh {
	return [self parserWithValueBlock:valueBlock
				  allowMultiRoot:NO
				 unwrapRootArray:YES
					errorHandler:eh];
}

+ (id)parserWithValueBlock:(SBJson5RecordValueBlock)valueBlock
	   allowMultiRoot:(BOOL)allowMultiRoot
	  unwrapRootArray:(BOOL)unwrapRootArray
		 errorHandler:(SBJson5ErrorBlock)eh {
	
	return [[self alloc] initWithValueBlock:valueBlock
							 multiRoot:allowMultiRoot
					   unwrapRootArray:unwrapRootArray
							  maxDepth:32
						  errorHandler:eh];
}

- (id)initWithValueBlock:(SBJson5RecordValueBlock)valueBlock
		  multiRoot:(BOOL)multiRoot
	unwrapRootArray:(BOOL)unwrapRootArray
		   maxDepth:(NSUInteger)maxDepth
	   errorHandler:(SBJson5ErrorBlock)eh {
	
	self = [super initWithBlock:nil allowMultiRoot:multiRoot unwrapRootArray:unwrapRootArray maxDepth:maxDepth errorHandler:eh];
	if(self) {
		_recordValueBlock = valueBlock;
	}
	
	return self;
}

#pragma mark Overrides

- (void)parserFound:(id)obj isValue:(BOOL)isValue {
	NSParameterAssert(obj);
	
	switch (self->currentType) {
		case SBJson5ChunkObject:
		{
			NSMutableArray *keyStack = self->keyStack;
			NSParameterAssert(keyStack.count);
			[self->dict setObject:obj forKey:[keyStack lastObject]];
			[keyStack removeLastObject];
		}
			break;

		case SBJson5ChunkArray:
			if( self->keyStack.count == 1 ) {
				// fallthrough
			} else {
				[self->array addObject:obj];
				break;
			}
			
			
		case SBJson5ChunkNone: {
			NSString *parentKey = [self->keyStack lastObject];
			if( NO == _recordValueBlock(obj, parentKey) ) {			
				[self->_parser stop];
			}
		}
			break;
			
		default:
			break;
	}
}


@end
