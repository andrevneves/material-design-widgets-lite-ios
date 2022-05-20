//
//  ViewController.swift
//  MaterialDesignWidgetsDemo
//
//  Created by Ho, Tsung Wei on 5/17/19.
//  Copyright © 2019 Michael Ho. All rights reserved.
//

import UIKit
import MaterialDesignWidgets

class DemoViewController: UIViewController {
    
    private var stackView: UIStackView!
    private var topSegmentControl: UISegmentedControl!
    private let widgets: [WidgetType] = [
        .textField,
        .segmentedControlOutline,
        .segmentedControlLineText,
        .segmentedControlFill,
        .segmentedControlLineIcon
    ]
    
    private let buttons: [WidgetType] = [
        .button,
        .loadingButton,
        .verticalButton,
        .shadowButton,
        .loadingIndicator
    ]
    // loadView
    override func loadView() {
        super.loadView()
        // Init views
        topSegmentControl = UISegmentedControl(items: ["Widgets", "Buttons"])
        stackView = UIStackView(axis: .vertical, distribution: .fill, spacing: self.view.frame.height * 0.01)
        self.view.addSubViews([topSegmentControl, stackView])
        
        // AutoLayout
        let height = self.view.frame.height
        let width = self.view.frame.width
        self.topSegmentControl.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        self.topSegmentControl.setAnchors(top: self.view, tConst: 0.05*height,
                                          left: self.view, lConst: 0.05*width,
                                          right: self.view, rConst: -0.05*width)
        self.stackView.setAnchors(left: self.view, lConst: 0.05*width,
                                  right: self.view, rConst: -0.05*width)
        self.stackView.topAnchor.constraint(equalTo: self.topSegmentControl.bottomAnchor, constant: 0.03*height).isActive = true
    }
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = UIColor.systemBackground
            topSegmentControl.selectedSegmentTintColor = .systemGray3
        }
        topSegmentControl.tintColor = .black
        topSegmentControl.addTarget(self, action: #selector(topSegmentDidChange(_:)), for: .valueChanged)
        topSegmentControl.selectedSegmentIndex = 0
        topSegmentDidChange(topSegmentControl)
    }
    /**
     traitCollectionDidChange is called when user switch between dark and light mode. Whenever this is
     called, reset the UI.
     */
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        topSegmentDidChange(self.topSegmentControl)
    }
    /**
     Reload demo app UI.
     
     - Parameter widgetTypes: The widget type to display.
     */
    private func reloadStackView(_ widgetTypes: [WidgetType]) {
        // Remove old widgets
        self.stackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        // Add all widgets
        for type in widgetTypes {
            let label = UILabel()
            label.text = type.rawValue
            label.font = UIFont.boldSystemFont(ofSize: 14.0)
            // Set label color for dark mode
            label.textColor = .black
            if #available(iOS 13.0, *) {
                label.textColor = .label
            }
            stackView.addArrangedSubview(label)
            label.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.06).isActive = true
            
            if type == .loadingButton, let stack = type.widget as? UIStackView {
                for subView in stack.arrangedSubviews {
                    if let loadingBtn = subView as? MaterialButton {
                        loadingBtn.addTarget(self, action: #selector(tapLoadingButton(sender:)), for: .touchUpInside)
                    }
                }
                stackView.addArrangedSubview(stack)
            } else if let segCtrl = type.widget as? MaterialSegmentedControl {
                switch type {
                    case .segmentedControlFill,
                            .segmentedControlOutline:
                        setSampleSegments(segmentedControl: segCtrl)
                    case .segmentedControlLineText:
                        setSampleSegments(segmentedControl: segCtrl)
                    case .segmentedControlLineIcon:
                        let icons = [(icon: #imageLiteral(resourceName: "ic_home_fill").colored(.black)!, text: "Home"),
                                     (icon: #imageLiteral(resourceName: "ic_home_fill").colored(.black)!, text: "Home"),
                                     (icon: #imageLiteral(resourceName: "ic_home_fill").colored(.black)!, text: "Home"),
                                     (icon: #imageLiteral(resourceName: "ic_home_fill").colored(.black)!, text: "Home"),
                                     (icon: #imageLiteral(resourceName: "ic_home_fill").colored(.black)!, text: "Home"),
                                     (icon: #imageLiteral(resourceName: "ic_home_fill").colored(.black)!, text: "Home"),
                        ]
                        for i in 0...icons.count - 1 {
                            let button = MaterialVerticalButton(icon: UIImage(named: "ic_home_fill")!,
                                                                text: "Fidelidade",
                                                                font: UIFont(name: "Arial",
                                                                             size: CGFloat(9.0)),
                                                                foregroundColor: .white,
                                                                bgColor: .black,
                                                                cornerRadius: 0)
                            //                            segCtrl.appendSegment(icon: icons[i].icon, text: icons[i].text, textColor: .white, font: UIFont(name: "Arial", size: CGFloat(9.0)), rippleColor: .black)
                            segCtrl.appendIconSegment(icon: icons[i].icon, preserveIconColor: true, rippleColor: .clear)
                        }
                    default:
                        continue
                }
                stackView.addArrangedSubview(segCtrl)
            } else {
                stackView.addArrangedSubview(type.widget)
            }
            
            if let last = stackView.arrangedSubviews.last {
                last.heightAnchor.constraint(equalTo: self.view.heightAnchor,
                                             multiplier: type == .verticalButton || type == .segmentedControlLineIcon ? 0.1 : 0.06).isActive = true
            }
        }
        self.view.layoutIfNeeded()
    }
    /**
     Create sample segments for the segmented control.
     
     - Parameter segmentedControl: The segmented control to put these segments into.
     - Parameter cornerRadius:     The corner radius to be set to segments and selectors.
     */
    private func setSampleSegments(segmentedControl: MaterialSegmentedControl) {
        for i in 0..<3 {
            segmentedControl.appendTextSegment(text: "Segment \(i)", textColor: .gray, rippleColor: .lightGray)
        }
    }
    
    @objc func topSegmentDidChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                reloadStackView(widgets)
            case 1:
                reloadStackView(buttons)
            default:
                break
        }
    }
    
    @objc func tapLoadingButton(sender: MaterialButton) {
        sender.isLoading = !sender.isLoading
        sender.isLoading ? sender.showLoader(userInteraction: true) : sender.hideLoader()
    }
}

enum WidgetType: String {
    case button = "Material Design Button"
    case loadingButton = "Loading Button"
    case shadowButton = "Shadow Button"
    case verticalButton = "Vertical Aligned Button"
    case textField = "Material Design TextField"
    case loadingIndicator = "Loading Indicator"
    case segmentedControlOutline = "Segmented Control - Outline"
    case segmentedControlLineText = "Segmented Control - Line Text"
    case segmentedControlFill = "Segmented Control - Fill"
    case segmentedControlLineIcon = "Segmented Control - Line Icon"
    
    var widget: UIView {
        // The iOS 13.0 block tunes for light/dark mode switch
        if #available(iOS 13.0, *) {
            switch self {
                case .button:
                    let btnLeft = MaterialButton(text: "Button", cornerRadius: 15.0, buttonStyle: .fill)
                    let btnRight = MaterialButton(text: "Button", cornerRadius: 15.0, buttonStyle: .outline)
                    let stack = UIStackView(arrangedSubviews: [btnLeft, btnRight], axis: .horizontal, distribution: .fillEqually, spacing: 10.0)
                    return stack
                case .loadingButton:
                    let btnLeft = MaterialButton(text: self.rawValue, cornerRadius: 15.0, buttonStyle: .fill)
                    let btnRight = MaterialButton(text: self.rawValue, cornerRadius: 15.0, buttonStyle: .outline)
                    let stack = UIStackView(arrangedSubviews: [btnLeft, btnRight], axis: .horizontal, distribution: .fillEqually, spacing: 10.0)
                    return stack
                case .shadowButton:
                    // We don't recommend outline style shadow button since in such case the shadow will become the background color of the button.
                    // Feel free to tune one by yourself if you still need a outline shadow button.
                    return MaterialButton(text: self.rawValue, cornerRadius: 15.0, withShadow: true, buttonStyle: .fill)
                case .verticalButton:
                    let font = UIFont(name: "Arial", size: CGFloat(9.0))
                    let bgColor: UIColor = .black
                    let foregroundColor: UIColor = .white
                    let btn1 = MaterialVerticalButton(icon: #imageLiteral(resourceName: "ic_home_fill"), text: "Outline", font: font, foregroundColor: foregroundColor, bgColor: bgColor, preserveIconColor: true, cornerRadius: 0, buttonStyle: .outline, useEffects: false)
                    let btn2 = MaterialVerticalButton(icon: #imageLiteral(resourceName: "ic_home_color"), text: "Outline", font: font, foregroundColor: foregroundColor, bgColor: bgColor, cornerRadius: 0, buttonStyle: .fill)
                    let btn3 = MaterialVerticalButton(icon: #imageLiteral(resourceName: "ic_home_outline"), text: "Outline", font: font, foregroundColor: foregroundColor, bgColor: bgColor, preserveIconColor: true, cornerRadius: 0, buttonStyle: .outline)
                    let btn4 = MaterialVerticalButton(icon: #imageLiteral(resourceName: "ic_home_fill"), text: "Outline", font: font, foregroundColor: foregroundColor, bgColor: bgColor, preserveIconColor: true, cornerRadius: 0, buttonStyle: .fill)
                    let btn5 = MaterialVerticalButton(icon: #imageLiteral(resourceName: "ic_home_fill"), text: "Outline", font: font, foregroundColor: foregroundColor, bgColor: bgColor, preserveIconColor: true, cornerRadius: 0, buttonStyle: .fill)
                    let btn6 = MaterialVerticalButton(icon: #imageLiteral(resourceName: "ic_home_fill"), text: "Outline", font: font, foregroundColor: foregroundColor, bgColor: bgColor, preserveIconColor: true, cornerRadius: 0, buttonStyle: .fill)
                    let stack = UIStackView(arrangedSubviews: [btn1, btn2, btn3, btn4, btn5, btn6], axis: .horizontal, distribution: .fillEqually, spacing: 8.0)
                    stack.backgroundColor = .black
                    return stack
                case .textField:
                    return MaterialTextField(placeholder: "Material Design TextField", bottomBorderEnabled: true)
                case .loadingIndicator:
                    let indicatorBlack = MaterialLoadingIndicator(radius: 15.0, color: .label)
                    let indicatorGray = MaterialLoadingIndicator(radius: 15.0, color: .systemGray3)
                    return UIStackView(arrangedSubviews: [indicatorBlack, indicatorGray], axis: .horizontal, distribution: .fillEqually, spacing: 10.0)
                case .segmentedControlFill:
                    var segCtrl: MaterialSegmentedControl!
                    segCtrl = MaterialSegmentedControl(selectorStyle: .fill, cornerRadius: 15.0)
                    return segCtrl
                case .segmentedControlOutline:
                    return MaterialSegmentedControl(selectorStyle: .outline, cornerRadius: 15.0)
                case .segmentedControlLineText:
                    return MaterialSegmentedControl(selectorStyle: .line, cornerRadius: 0.0)
                case .segmentedControlLineIcon:
                    return MaterialSegmentedControl(selectorStyle: .line, cornerRadius: 0.0)
            }
        } else {
            // This is for versions below iOS 13 that assumes a white background color
            switch self {
                case .button:
                    let btnLeft = MaterialButton(text: "Button", textColor: .white, bgColor: .black, cornerRadius: 15.0)
                    let btnRight = MaterialButton(text: "Button", textColor: .black, bgColor: .white, borderColor: .black, cornerRadius: 15.0)
                    let stack = UIStackView(arrangedSubviews: [btnLeft, btnRight], axis: .horizontal, distribution: .fillEqually, spacing: 10.0)
                    return stack
                case .loadingButton:
                    let btnLeft = MaterialButton(text: self.rawValue, textColor: .white, bgColor: .black, cornerRadius: 15.0)
                    let btnRight = MaterialButton(text: self.rawValue, textColor: .black, bgColor: .white, borderColor: .black, cornerRadius: 15.0)
                    let stack = UIStackView(arrangedSubviews: [btnLeft, btnRight], axis: .horizontal, distribution: .fillEqually, spacing: 10.0)
                    return stack
                case .shadowButton:
                    let btnLeft = MaterialButton(text: self.rawValue,  textColor: .white, bgColor: .black, cornerRadius: 15.0, withShadow: true)
                    let btnRight = MaterialButton(text: self.rawValue, textColor: .black, bgColor: .white, borderColor: .black, cornerRadius: 15.0, withShadow: true)
                    let stack = UIStackView(arrangedSubviews: [btnLeft, btnRight], axis: .horizontal, distribution: .fillEqually, spacing: 10.0)
                    return stack
                case .verticalButton:
                    let btn1 = MaterialVerticalButton(icon: #imageLiteral(resourceName: "ic_home_fill"), text: "Fill", foregroundColor: .white, bgColor: .black, preserveIconColor: false, cornerRadius: 18.0)
                    let btn2 = MaterialVerticalButton(icon: #imageLiteral(resourceName: "ic_home_color"), text: "Color", foregroundColor: .black, bgColor: .white, cornerRadius: 18.0)
                    let btn3 = MaterialVerticalButton(icon: #imageLiteral(resourceName: "ic_home_outline"), text: "Outline", foregroundColor: .black, bgColor: .clear, borderColor: .black, preserveIconColor: false, cornerRadius: 18.0)
                    let stack = UIStackView(arrangedSubviews: [btn1, btn2, btn3], axis: .horizontal, distribution: .fillEqually, spacing: 10.0)
                    return stack
                case .textField:
                    return MaterialTextField(placeholder: "Material Design TextField", textColor: .black, bgColor: .white, borderColor: .lightGray)
                case .loadingIndicator:
                    let indicatorBlack = MaterialLoadingIndicator(radius: 15.0, color: .black)
                    let indicatorGray = MaterialLoadingIndicator(radius: 15.0, color: .gray)
                    return UIStackView(arrangedSubviews: [indicatorBlack, indicatorGray], axis: .horizontal, distribution: .fillEqually, spacing: 10.0)
                case .segmentedControlFill:
                    return MaterialSegmentedControl(selectorStyle: .fill, cornerRadius: 15.0,
                                                    fgColor: .black, selectedFgColor: .white, selectorColor: .black, bgColor: .lightGray)
                case .segmentedControlOutline:
                    return MaterialSegmentedControl(selectorStyle: .outline, cornerRadius: 15.0,
                                                    fgColor: .black, selectedFgColor: .black, selectorColor: .black, bgColor: .white)
                case .segmentedControlLineText:
                    return MaterialSegmentedControl(selectorStyle: .line, cornerRadius: 0.0,
                                                    fgColor: .black, selectedFgColor: .black, selectorColor: .black, bgColor: .white)
                case .segmentedControlLineIcon:
                    return MaterialSegmentedControl(selectorStyle: .line, cornerRadius: 0.0,
                                                    fgColor: .black, selectedFgColor: .black, selectorColor: .gray, bgColor: .white)
            }
        }
    }
}

