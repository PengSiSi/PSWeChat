//
//  XMLParse.m
//  QianfengSchool
//
//  Created by AlicePan on 16/9/18.
//  Copyright © 2016年 Combanc. All rights reserved.
//

#import "XMLParse.h"
#import "GDataXMLNode.h"

@implementation XMLParse

+ (NSString *)getSimpleResult:(NSData *)data {
    GDataXMLElement* element = [self getResultElement:data];
    NSString* result =  element.stringValue;
    return result;
}

+ (GDataXMLElement*) getResultElement:(NSData *)data {
    if(!data) {
        return nil;
    }
    NSError *_error;

    GDataXMLDocument* _GDataParse = [[[GDataXMLDocument alloc]initWithData:data  options:0 error:&_error] autorelease];
    if(_error) {
        NSLog(@"AFNETWORKINGREQUEST DATA PARSE ERROR : %@",_error.debugDescription);
    }
    GDataXMLElement *element1=[_GDataParse.rootElement.children objectAtIndex:0];
    GDataXMLElement *element2=[element1.children lastObject];
    GDataXMLElement *element3=[element2.children lastObject];
    GDataXMLElement *element4=[element3.children lastObject];
    return element4;
}

@end
