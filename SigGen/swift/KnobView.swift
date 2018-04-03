//
//  KnobView.swift
//  SigGen
//
//  Created by Bill Farmer on 29/03/2018.
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

class KnobView: NSControl
{
    let kFrequencyMax: CGFloat = 3.4
    let kFrequencyMin: CGFloat = 0.0

    var value: CGFloat = 0.0
    {
        didSet
        {
            needsDisplay = true
        }
    }

    // mouseDragged
    override func mouseDragged(with event: NSEvent)
    {
        switch event.type
        {
        case .leftMouseDragged:

            // Convert point
            let location = convert(event.locationInWindow, from: nil)

            // Get centre
            let centre = NSMakePoint(NSMidX(bounds), NSMidY(bounds))

            // Calculate previous location
            let prevX = location.x - event.deltaX
            let prevY = location.y - event.deltaY

            // Previous offset from centre of knob
            var x = prevX - centre.x
            var y = prevY - centre.y

            // Angle
            let theta = atan2(x, y)

            // Current offset from centre
            x = location.x - centre.x
            y = location.y - centre.y

            // Change in angle
            var change = atan2(x, y) - theta

            if (change > .pi)
            {
	        change -= 2.0 * .pi
            }

            if (change < -.pi)
            {
	        change += 2.0 * .pi
            }

            value += change / .pi

            if (value > kFrequencyMax)
            {
                value = kFrequencyMax
            }

            if (value < kFrequencyMin)
            {
                value = kFrequencyMin
            }

            sendAction(action, to: target)

            NSLog("Change %f", change / .pi)
            NSLog("Value %f", value)

        default:
            break
        }
    }

    // draw
    override func draw(_ dirtyRect: NSRect)
    {
        super.draw(dirtyRect)

        // Drawing code here.
        let gradient = NSGradient(colors: [NSColor.white, NSColor.gray])!

        // Draw bezel
        let shade = NSBezierPath(ovalIn: dirtyRect)
        gradient.draw(in: shade, angle: 315)

        // Draw knob
        NSColor.lightGray.set()
        let inset = NSInsetRect(dirtyRect, 4, 4)
        let path = NSBezierPath(ovalIn: inset)
        path.fill()

        // Translate to centre
        let centre = AffineTransform(translationByX: NSMidX(dirtyRect),
                                     byY: NSMidY(dirtyRect))
        (centre as NSAffineTransform).concat()

        // Path for indent
        let indentSize = NSMaxX(dirtyRect) / 32
        let indent = NSMakeRect(-indentSize / 2, -indentSize / 2,
                                indentSize, indentSize)
        let indentPath = NSBezierPath(ovalIn: indent)

        // Translate for indent
        let indentRadius = NSMidY(inset) * 0.8
        let x = sin(value * .pi) * indentRadius
        let y = cos(value * .pi) * indentRadius
        let transform = AffineTransform(translationByX: x, byY: y)
        // (transform as NSAffineTransform).concat()
        indentPath.transform(using: transform)

        // Draw indent
        gradient.draw(in: indentPath, angle: 135)
    }
    
}
