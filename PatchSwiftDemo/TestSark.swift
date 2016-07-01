//
//  Main.swift
//  PatchSwiftDemo
//
//  Created by sunnyxx on 16/7/1.
//  Copyright © 2016年 sunnyxx. All rights reserved.
//

import Foundation

@objc class TestSark : NSObject {
    class func test() {
        let sark = Sark()
        // before patch
        let orig = sark.foo(123);
        print("orig: \(orig)"); // print 123
        
        patchSwift() // in main.m
        
        // after patch
        let patched = sark.foo(123);
        print("patched: \(patched)"); // print 123 * 123
    }
}