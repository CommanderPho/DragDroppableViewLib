//
//  DragView.swift
//  
//
//  Created by Pho Hale on 1/19/21.
//
//	Implementation by https://stackoverflow.com/users/215282/geri-borbás.


import Foundation
import Cocoa


// MARK: -
// MARK: - class DragView: NSView
/// Description: Allows dragging and dropping a file
open class DragView: NSView
{

	@IBOutlet public weak var delegate: DragViewDelegate?

	@IBInspectable public var fileExtensions = ["pdf"]

	public required init?(coder: NSCoder)
	{
		super.init(coder: coder)
		color(to: .clear)
		registerForDraggedTypes([.fileURL])
	}

	public override func draggingEntered(_ draggingInfo: NSDraggingInfo) -> NSDragOperation
	{
		var containsMatchingFiles = false
		draggingInfo.draggingPasteboard.readObjects(forClasses: [NSURL.self], options: nil)?.forEach
		{
			eachObject in
			if let eachURL = eachObject as? URL
			{
				containsMatchingFiles = containsMatchingFiles || fileExtensions.contains(eachURL.pathExtension.lowercased())
				if containsMatchingFiles { print(eachURL.path) }
			}
		}

		switch (containsMatchingFiles)
		{
			case true:
				color(to: .secondaryLabelColor)
				return .copy
			case false:
				color(to: .disabledControlTextColor)
				return .init()
		}
	}

	public override func performDragOperation(_ draggingInfo: NSDraggingInfo) -> Bool
	{
		// Collect URLs.
		var matchingFileURLs: [URL] = []
		draggingInfo.draggingPasteboard.readObjects(forClasses: [NSURL.self], options: nil)?.forEach
		{
			eachObject in
			if
				let eachURL = eachObject as? URL,
				fileExtensions.contains(eachURL.pathExtension.lowercased())
			{ matchingFileURLs.append(eachURL) }
		}

		// Only if any,
		guard matchingFileURLs.count > 0
		else { return false }

		// Pass to delegate.
		delegate?.dragViewDidReceive(fileURLs: matchingFileURLs)
		return true
	}

	public override func draggingExited(_ sender: NSDraggingInfo?)
	{ color(to: .clear) }

	public override func draggingEnded(_ sender: NSDraggingInfo)
	{ color(to: .clear) }

}


public extension DragView
{

	public func color(to color: NSColor)
	{
		self.wantsLayer = true
		self.layer?.backgroundColor = color.cgColor
	}
}
