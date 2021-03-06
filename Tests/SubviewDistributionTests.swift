//
//  SubviewDistributionTests.swift
//  Relativity
//
//  Created by Dan Federman on 12/30/16.
//  Copyright © 2016 Dan Federman.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import XCTest
@testable import Relativity


class SubviewDistributionTests: XCTestCase {

    public func test_distributeSubviewsVertically_relativeSpacers() {
        let window = UIWindow(frame: CGRect(x: 0.0, y: 0.0, width: 375, height: 667))
        let view = UIView(frame: window.frame)
        window.addSubview(view)
        
        let a = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
        let b = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0))
        let c = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 25.0, height: 25.0))
        
        view.addSubview(a)
        view.addSubview(b)
        view.addSubview(c)
        
        view.distributeSubviewsVertically { () -> [DistributionItem] in
            a <> ~1~ <> b <> ~2~ <> c
        }
        
        let relative1Space = a.frame.minY
        
        let pixelRounder = PixelRounder(for: view)
        // Assert that our spacing is correct above.
        XCTAssertEqualWithAccuracy(b.frame.minY - a.frame.maxY, relative1Space, accuracy: pixelRounder.pixelAccuracy)
        XCTAssertEqualWithAccuracy(c.frame.minY - b.frame.maxY, 2 * relative1Space, accuracy: pixelRounder.pixelAccuracy)
        XCTAssertEqualWithAccuracy((view.frame.maxY - c.frame.maxY), relative1Space, accuracy: pixelRounder.pixelAccuracy)
        
        // Assert that everything is rounded to the pixel.
        XCTAssertEqualWithAccuracy(a.frame.origin, a.frame.origin, accuracy: pixelRounder.pixelAccuracy)
        XCTAssertEqualWithAccuracy(b.frame.origin, b.frame.origin, accuracy: pixelRounder.pixelAccuracy)
        XCTAssertEqualWithAccuracy(c.frame.origin, c.frame.origin, accuracy: pixelRounder.pixelAccuracy)
    }
    
    public func test_distributeSubviewsVertically_relativeAndFixedSpacers() {
        let window = UIWindow(frame: CGRect(x: 0.0, y: 0.0, width: 375, height: 667))
        let view = UIView(frame: window.frame)
        window.addSubview(view)
        
        let a = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
        let b = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0))
        let c = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 25.0, height: 25.0))
        
        view.addSubview(a)
        view.addSubview(b)
        view.addSubview(c)
        
        view.distributeSubviewsVertically { () -> [DistributionItem] in
            a <> ~3~ <> b <> 8 <> c
        }
        
        // Space before a is implicity ~1~.
        let relative1Space = a.frame.minY
        
        let pixelRounder = PixelRounder(for: view)
        // Assert that our spacing is correct above.
        XCTAssertEqualWithAccuracy(b.frame.minY - a.frame.maxY, 3 * relative1Space, accuracy: pixelRounder.pixelAccuracy)
        XCTAssertEqual(c.frame.minY - b.frame.maxY, 8)
        XCTAssertEqualWithAccuracy(view.frame.maxY - c.frame.maxY, relative1Space, accuracy: pixelRounder.pixelAccuracy)
        
        // Assert that everything is rounded to the pixel.
        XCTAssertEqualWithAccuracy(a.frame.origin, a.frame.origin, accuracy: pixelRounder.pixelAccuracy)
        XCTAssertEqualWithAccuracy(b.frame.origin, b.frame.origin, accuracy: pixelRounder.pixelAccuracy)
        XCTAssertEqualWithAccuracy(c.frame.origin, c.frame.origin, accuracy: pixelRounder.pixelAccuracy)
    }
    
    public func test_distributeSubviewsVertically_leadingFixedSpace() {
        let window = UIWindow(frame: CGRect(x: 0.0, y: 0.0, width: 375, height: 667))
        let view = UIView(frame: window.frame)
        window.addSubview(view)
        
        let a = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
        let b = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0))
        let c = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 25.0, height: 25.0))
        
        view.addSubview(a)
        view.addSubview(b)
        view.addSubview(c)
        
        view.distributeSubviewsVertically { () -> [DistributionItem] in
            8 <> a <> ~3~ <> b <> 8 <> c
        }
        
        // Space after c is implicity ~1~.
        let relative1Space = (view.frame.maxY - c.frame.maxY)
        
        let pixelRounder = PixelRounder(for: view)
        // Assert that our spacing is correct above.
        XCTAssertEqual(a.frame.minY, 8)
        XCTAssertEqualWithAccuracy(b.frame.minY - a.frame.maxY, 3 * relative1Space, accuracy: pixelRounder.pixelAccuracy)
        XCTAssertEqual(c.frame.minY - b.frame.maxY, 8)
        
        // Assert that everything is rounded to the pixel.
        XCTAssertEqualWithAccuracy(a.frame.origin, a.frame.origin, accuracy: pixelRounder.pixelAccuracy)
        XCTAssertEqualWithAccuracy(b.frame.origin, b.frame.origin, accuracy: pixelRounder.pixelAccuracy)
        XCTAssertEqualWithAccuracy(c.frame.origin, c.frame.origin, accuracy: pixelRounder.pixelAccuracy)
    }
    
    public func test_distributeSubviewsVertically_trailingFixedSpace() {
        let window = UIWindow(frame: CGRect(x: 0.0, y: 0.0, width: 375, height: 667))
        let view = UIView(frame: window.frame)
        window.addSubview(view)
        
        let a = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
        let b = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0))
        let c = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 25.0, height: 25.0))
        
        view.addSubview(a)
        view.addSubview(b)
        view.addSubview(c)
        
        view.distributeSubviewsVertically { () -> [DistributionItem] in
            a <> ~2~ <> b <> 8 <> c <> 16
        }
        
        // Space before a is implicity ~1~.
        let relative1Space = a.frame.minY
        
        let pixelRounder = PixelRounder(for: view)
        // Assert that our spacing is correct above.
        XCTAssertEqualWithAccuracy((b.frame.minY - a.frame.maxY), 2 * relative1Space, accuracy: pixelRounder.pixelAccuracy)
        XCTAssertEqual(c.frame.minY - b.frame.maxY, 8)
        XCTAssertEqual(view.frame.maxY - c.frame.maxY, 16)
        
        // Assert that everything is rounded to the pixel.
        XCTAssertEqualWithAccuracy(a.frame.origin, a.frame.origin, accuracy: pixelRounder.pixelAccuracy)
        XCTAssertEqualWithAccuracy(b.frame.origin, b.frame.origin, accuracy: pixelRounder.pixelAccuracy)
        XCTAssertEqualWithAccuracy(c.frame.origin, c.frame.origin, accuracy: pixelRounder.pixelAccuracy)
    }
    
    public func test_distributeSubviewsVertically_labelDistributionRespectsFontBounds() {
        let window = UIWindow(frame: CGRect(x: 0.0, y: 0.0, width: 375, height: 667))
        let view = UIView(frame: window.frame)
        window.addSubview(view)
        
        let a = UILabel()
        a.text = "Some text"
        a.sizeToFit()
        let b = UILabel()
        b.text = "needs to be laid out"
        b.sizeToFit()
        let c = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 25.0, height: 25.0))
        
        view.addSubview(a)
        view.addSubview(b)
        view.addSubview(c)
        
        view.distributeSubviewsVertically { () -> [DistributionItem] in
            a <> 8 <> b <> ~2~ <> c
        }
        
        // Space after c is implicity ~1~.
        let relative1Space = (view.frame.maxY - c.frame.maxY)
        
        let pixelRounder = PixelRounder(for: view)
        // Assert that our spacing is correct above.
        XCTAssertEqualWithAccuracy((a.frame.minY + a.font.capInset(with: pixelRounder)), relative1Space, accuracy: pixelRounder.pixelAccuracy)
        XCTAssertEqualWithAccuracy((b.frame.minY - a.frame.maxY + a.font.baselineInset(with: pixelRounder) + b.font.capInset(with: pixelRounder)), 8, accuracy: pixelRounder.pixelAccuracy)
        XCTAssertEqualWithAccuracy((c.frame.minY - b.frame.maxY + b.font.baselineInset(with: pixelRounder)), 2 * relative1Space, accuracy: pixelRounder.pixelAccuracy)
        XCTAssertEqualWithAccuracy((view.frame.maxY - c.frame.maxY), relative1Space, accuracy: pixelRounder.pixelAccuracy)
        
        // Assert that everything is rounded to the pixel.
        XCTAssertEqualWithAccuracy(a.frame.origin, a.frame.origin, accuracy: pixelRounder.pixelAccuracy)
        XCTAssertEqualWithAccuracy(b.frame.origin, b.frame.origin, accuracy: pixelRounder.pixelAccuracy)
        XCTAssertEqualWithAccuracy(c.frame.origin, c.frame.origin, accuracy: pixelRounder.pixelAccuracy)
    }

}


// MARK: - Test Helpers


extension PixelRounder {
    
    var pixelAccuracy: CGFloat {
        // Pad a pixel by a 1 / 1000 to protect against floating point rounding errors.
        return (1.0 / screenScale) + 0.001
    }
    
}

public func XCTAssertEqualWithAccuracy(_ point1: CGPoint, _ point2: CGPoint, accuracy: CGFloat, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqualWithAccuracy(point1.x, point2.x, accuracy: accuracy)
    XCTAssertEqualWithAccuracy(point1.y, point2.y, accuracy: accuracy)
}
