//
//  SBJson4RecordParser.h
//  SBJSON_test
//
//  Created by pawelc on 04/04/2018.
//  Copyright © 2018 MP. All rights reserved.
//

#import "SBJson5Parser.h"

typedef void (^SBJson5ErrorBlock)(NSError* _Nonnull error);
/**
 Block called when the parser has parsed a record.

 @param item Record object
 @param parentKey Key in parent dictionary object, can be `nil` for array as a parent
 @return Return YES to continue parsing, NO to stop
 
 */
typedef BOOL (^SBJson5RecordValueBlock)(id _Nonnull item, NSString* _Nullable parentKey);



@interface SBJson5RecordParser : SBJson5Parser

+ (nonnull instancetype)parserWithValueBlock:(nonnull SBJson5RecordValueBlock)valueBlock
	   allowMultiRoot:(BOOL)allowMultiRoot
	  unwrapRootArray:(BOOL)unwrapRootArray
		 errorHandler:(nullable SBJson5ErrorBlock)eh;

+ (nonnull instancetype)multiRootParserWithValueBlock:(nonnull SBJson5RecordValueBlock)valueBlock
				  errorHandler:(nullable SBJson5ErrorBlock)eh;

+ (nonnull instancetype)unwrapRootArrayParserWithValueBlock:(nonnull SBJson5RecordValueBlock)valueBlock
						errorHandler:(nullable SBJson5ErrorBlock)eh;

- (nonnull instancetype)initWithValueBlock:(nonnull SBJson5RecordValueBlock)valueBlock
		  multiRoot:(BOOL)multiRoot
	unwrapRootArray:(BOOL)unwrapRootArray
		   maxDepth:(NSUInteger)maxDepth
	   errorHandler:(nullable SBJson5ErrorBlock)eh;


@end
