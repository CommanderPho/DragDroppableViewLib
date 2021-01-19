//
//  File.swift
//  
//
//  Created by Pho Hale on 1/19/21.
//

import Foundation


@objc public protocol DragViewDelegate
{
	func dragViewDidReceive(fileURLs: [URL])
}
