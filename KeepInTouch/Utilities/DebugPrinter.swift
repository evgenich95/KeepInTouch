//
//  DebugPrinter.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 10.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation

func printMe(filePath: String = #file, functionName: String = #function, with arguments: Any...) {
    //<FileName>.swift
    let swiftFileName = filePath.components(separatedBy: "/").last ?? ""
    //<FileName>
    let className = swiftFileName.components(separatedBy: ".").first ?? ""
    print("-->\(className).\(functionName)")
    arguments.forEach {
        print("\t\t\($0)")
    }
}
