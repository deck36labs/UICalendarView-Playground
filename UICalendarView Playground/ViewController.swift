//
//  ViewController.swift
//  UICalendarView Playground
//
//  Created by Deck 36 Labs on 12/5/22.
//

import UIKit

class ViewController: UIViewController, UICalendarSelectionSingleDateDelegate {
    
    
    @IBOutlet weak var mainCalendar: UICalendarView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureCalendarView()
    }
    
    func configureCalendarView(){
        // UICalendarView Setup
        mainCalendar.calendar = Calendar(identifier: .gregorian)
        mainCalendar.fontDesign = .rounded
        
        // Delegate for Decoration Views
        mainCalendar.delegate = self
        
        // Date selection Delegate and allowed behavior
        mainCalendar.selectionBehavior = UICalendarSelectionSingleDate(delegate: self)
    }

    // UICalendarView Selection Delegate
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        print(dateComponents?.date!)
    }
}

extension ViewController: UICalendarViewDelegate {
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        // Create and return calendar decorations here.
        
        guard let day = dateComponents.day else {
            return nil
        }
        
        // Check for odd/even days so we can demostrate 2 different decoration views
        if (!day.isMultiple(of: 2)){
            // Decoration view with a custom UIView
            return UICalendarView.Decoration.customView {
                // Seems 15x15px are the bounds of the decoration view. Documentation notes that
                // decoration will clip to the parent's bounds.
                let squareSize = 15
                let decorationView = self.bezierPathDecoration(withSquareSize: squareSize)
                
                return decorationView
            }
        }else{
            // Decoration view with SF Symboles
            let decImgSF = UIImage(systemName: "checkmark.circle.fill")

            return UICalendarView.Decoration.image(decImgSF, color: .systemTeal, size: .large)
        }
    }
    
    func bezierPathDecoration(withSquareSize frameSize: Int) -> UIView{
        let decorationView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        
        // Create a half circle path to display on the calendar
        let circleBezierPath = UIBezierPath(arcCenter: CGPoint(x: decorationView.frame.width/2, y: decorationView.frame.height/2), radius: CGFloat(frameSize/2), startAngle: -90.radians, endAngle: -270.radians, clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circleBezierPath.cgPath
        // Customize BezierPath properties
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.systemPink.cgColor
        shapeLayer.lineWidth = 3
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        
        // Add CAShapeLayer, which contains the UIBezierPath, to the view's layers
        decorationView.layer.addSublayer(shapeLayer)
        
        return decorationView
    }
    
}

// Extension to Double for BezierPath Decoration
// Note: Not critical to UICalendarView Implementation
extension Double {
    var radians: Double {
        return Measurement(value: self, unit: UnitAngle.degrees).converted(to: UnitAngle.radians).value
    }
    var degrees: Double {
        return Measurement(value: self, unit: UnitAngle.radians).converted(to: UnitAngle.degrees).value
    }
}
