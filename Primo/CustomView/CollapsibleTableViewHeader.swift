//
//  CollapsibleTableViewHeader.swift
//  ios-swift-collapsible-table-section
//
//  Created by Yong Su on 5/30/16.
//  Copyright © 2016 Yong Su. All rights reserved.
//

import UIKit

protocol CollapsibleTableViewHeaderDelegate {
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int)
}

class CollapsibleTableViewHeader: UITableViewHeaderFooterView {
    
    var delegate: CollapsibleTableViewHeaderDelegate?
    var section: Int = 0
    
    let headerView = UIView()
    let indexLabel = UILabel()
    let cardImageView = UIImageView()
    let titleLabel = UILabel()
    let arrowLabel = UILabel()
    
    let warningView = UIView()
    let warningBg = UIView()
    let warningLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        indexLabel.translatesAutoresizingMaskIntoConstraints = false
        cardImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowLabel.translatesAutoresizingMaskIntoConstraints = false
        
        warningView.translatesAutoresizingMaskIntoConstraints = false
        warningBg.translatesAutoresizingMaskIntoConstraints = false
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(headerView)
        headerView.addSubview(indexLabel)
        headerView.addSubview(cardImageView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(arrowLabel)
        
        contentView.addSubview(warningView)
        warningView.addSubview(warningBg)
        warningBg.addSubview(warningLabel)
        
        //
        // Call tapHeader when tapping on this header
        //
        addGestureRecognizer(UITapGestureRecognizer(
            target: self, action: #selector(CollapsibleTableViewHeader.tapHeader(_:))))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        indexLabel.textAlignment = .center
        
        cardImageView.contentMode = .scaleAspectFit
        
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.font = titleLabel.font.withSize(12)
//        titleLabel.adjustsFontSizeToFitWidth = true
        
        warningBg.backgroundColor = PrimoColor.Green.UIColor
        warningBg.layer.borderColor = PrimoColor.Green.UIColor.cgColor
        warningBg.layer.borderWidth = 2
        warningBg.layer.cornerRadius = 10
        
        warningLabel.textColor = UIColor.white
        warningLabel.textAlignment = .center
        warningLabel.font = warningLabel.font.withSize(10)
        
        //
        // Autolayout the lables
        //
        let views = [
            "indexLabel" : indexLabel,
            "cardImageView" : cardImageView,
            "titleLabel" : titleLabel,
            "arrowLabel" : arrowLabel,
            "headerView" : headerView,
            "warningView" : warningView,
            "warningBg" : warningBg,
            "warningLabel" : warningLabel
            ]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[headerView]|",
            options: [], metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[warningView]|",
            options: [], metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[headerView(40)]-[warningView(40)]|",
            options: [], metrics: nil, views: views))
        
        headerView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-20-[indexLabel(12)]-[cardImageView(40)]-[titleLabel]-[arrowLabel(12)]-20-|",
            options: [], metrics: nil, views: views))
        headerView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[indexLabel]-|",
            options: [], metrics: nil, views: views))
        headerView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[cardImageView]-|",
            options: [], metrics: nil, views: views))
        headerView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[titleLabel]-|",
            options: [], metrics: nil, views: views))
        headerView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[arrowLabel]-|",
            options: [], metrics: nil, views: views))
        
        // Warning BG
        NSLayoutConstraint(item: warningBg, attribute: .height, relatedBy: .equal,
                           toItem: warningView, attribute: .height,
                           multiplier: 1.0, constant: -10.0).isActive = true
        NSLayoutConstraint(item: warningBg, attribute: .centerX, relatedBy: .equal,
                           toItem: warningView, attribute: .centerX,
                           multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: warningBg, attribute: .centerY, relatedBy: .equal,
                           toItem: warningView, attribute: .centerY,
                           multiplier: 1.0, constant: 0.0).isActive = true
        
        // Warning Label
        NSLayoutConstraint(item: warningLabel, attribute: .centerX, relatedBy: .equal,
                           toItem: warningBg, attribute: .centerX,
                           multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: warningLabel, attribute: .centerY, relatedBy: .equal,
                           toItem: warningBg, attribute: .centerY,
                           multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: warningLabel, attribute: .height, relatedBy: .equal,
                           toItem: warningBg, attribute: .height,
                           multiplier: 1.0, constant: -8.0).isActive = true
        NSLayoutConstraint(item: warningLabel, attribute: .width, relatedBy: .equal,
                           toItem: warningBg, attribute: .width,
                           multiplier: 1.0, constant: -16.0).isActive = true
    }
    
    //
    // Trigger toggle section when tapping on the header
    //
    func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? CollapsibleTableViewHeader else {
            return
        }
        
        delegate?.toggleSection(self, section: cell.section)
    }
    
    func setCollapsed(_ collapsed: Bool) {
        //
        // Animate the arrow rotation (see Extensions.swf)
        //
        arrowLabel.rotate(collapsed ? 0.0 : CGFloat(M_PI_2))
    }
    
}
