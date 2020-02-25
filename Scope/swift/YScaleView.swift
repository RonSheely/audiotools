//
//  YScaleView.swift
//  Oscilloscope
//
//  Created by Bill Farmer on 09/04/2018.
//  Copyright © 2018 Bill Farmer. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.

import Cocoa

// YScaleView
class YScaleView: NSView
{
    var height = 0

    // intrinsicContentSize
    override var intrinsicContentSize: NSSize
    {
        get
        {
            return NSSize(width: CGFloat(kScaleWidth),
                          height: super.intrinsicContentSize.height)
        }
    }

    // mouseDown
    override func mouseDown(with event: NSEvent)
    {
        if (event.type == .leftMouseDown)
        {
            let location = event.locationInWindow
            let point = convert(location, from: nil)
            yscale.index = Int32(point.y) - Int32(height / 2)
            needsDisplay = true;
        }
    }

    // draw
    override func draw(_ rect: NSRect)
    {
        super.draw(rect)

        // Drawing code here.
        height = Int(NSHeight(rect))

        // Move the origin
        var transform = AffineTransform(translationByX: 0, byY: NSMidY(rect))
        (transform as NSAffineTransform).concat()
        let context = NSGraphicsContext.current!
        context.shouldAntialias = false

        // Draw scale
        for y in stride(from: 0, to: NSHeight(rect) / 2, by: 6)
        {
            NSBezierPath.strokeLine(from: NSMakePoint(NSMidX(rect), y),
                                    to: NSMakePoint(NSMaxX(rect), y))
            NSBezierPath.strokeLine(from: NSMakePoint(NSMidX(rect), -y),
                                    to: NSMakePoint(NSMaxX(rect), -y))
        }

        // Thumb
        let thumb = NSBezierPath()
        thumb.move(to: NSMakePoint(-1, 1))
        thumb.line(to: NSMakePoint(1, 1))
        thumb.line(to: NSMakePoint(2, 0))
        thumb.line(to: NSMakePoint(1, -1))
        thumb.line(to: NSMakePoint(-1, -1))
        thumb.close()

        // Transform
        let scale =
          AffineTransform(scale: NSWidth(rect) / (NSWidth(thumb.bounds) * 2))
        transform =
          AffineTransform(translationByX: NSWidth(rect) / 3,
                          byY: CGFloat(yscale.index))
        thumb.transform(using: scale)
        thumb.transform(using: transform)
        if (yscale.index != 0)
        {
            thumb.fill()
        }
    }    
}
