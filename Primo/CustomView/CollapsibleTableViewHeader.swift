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
    var hightSize: Int = 0
    var Condition: String? = ""
    var RestaurantStatus: Int? = 0
    
    let headerView = UIView()
    let indexLabel = UILabel()
    let cardImageView = UIImageView()
    let titleLabel = UILabel()
    let arrowLabel = UILabel()
    
    let warningView = UIView()
    let warningBg = UIView()
    let warningLabel = UILabel()
    

    let lableCondition = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        warningView.removeFromSuperview()
        lableCondition.removeFromSuperview()
        
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
        headerView.addSubview(lableCondition)
        
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
        
//        warningBg.backgroundColor = PrimoColor.Green.UIColor
//        warningBg.layer.borderColor = PrimoColor.Green.UIColor.cgColor
        warningBg.layer.borderWidth = 2
        warningBg.layer.cornerRadius = 10
        
        warningLabel.textColor = UIColor.white
        warningLabel.textAlignment = .center
        warningLabel.font = warningLabel.font.withSize(10)
        
        
        if((Condition?.length)! > 0 && RestaurantStatus! == 2){
            
            lableCondition.translatesAutoresizingMaskIntoConstraints = false
            warningView.addSubview(lableCondition)

            
            lableCondition.textColor =  PrimoColor.Red.UIColor
            lableCondition.textAlignment = .center
            lableCondition.font = lableCondition.font.withSize(12)
            
            let views = [
                "indexLabel" : indexLabel,
                "cardImageView" : cardImageView,
                "titleLabel" : titleLabel,
                "arrowLabel" : arrowLabel,
                "headerView" : headerView,
                "warningView" : warningView,
                "warningBg" : warningBg,
                "warningLabel" : warningLabel,
                "lableCondition" : lableCondition
            ]
            
            
            contentView.addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[headerView]|",
                options: [], metrics: nil, views: views))
            contentView.addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[warningView]|",
                options: [], metrics: nil, views: views))
            contentView.addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[headerView(50)]-[warningView(60)]|",
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
            
            
            //        if(hightSize != 50 && hightSize != 90){
            // Warning BG
            NSLayoutConstraint(item: warningBg, attribute: .height, relatedBy: .equal,
                               toItem: warningView, attribute: .height,
                               multiplier: 1.0, constant: -25).isActive = true
            NSLayoutConstraint(item: warningBg, attribute: .centerX, relatedBy: .equal,
                               toItem: warningView, attribute: .centerX,
                               multiplier: 1.0, constant: 0.0).isActive = true
            NSLayoutConstraint(item: warningBg, attribute: .centerY, relatedBy: .equal,
                               toItem: warningView, attribute: .centerY,
                               multiplier: 1.0, constant: -10).isActive = true
            
            // Warning Label
            NSLayoutConstraint(item: warningLabel, attribute: .centerX, relatedBy: .equal,
                               toItem: warningBg, attribute: .centerX,
                               multiplier: 1.0, constant: 0.0).isActive = true
            NSLayoutConstraint(item: warningLabel, attribute: .centerY, relatedBy: .equal,
                               toItem: warningBg, attribute: .centerY,
                               multiplier: 1.0, constant: 0.0).isActive = true
            NSLayoutConstraint(item: warningLabel, attribute: .height, relatedBy: .equal,
                               toItem: warningBg, attribute: .height,
                               multiplier: 1.0, constant: -8).isActive = true
            NSLayoutConstraint(item: warningLabel, attribute: .width, relatedBy: .equal,
                               toItem: warningBg, attribute: .width,
                               multiplier: 1.0, constant: -17).isActive = true
            
            
            
            NSLayoutConstraint(item: lableCondition, attribute: .centerX, relatedBy: .equal,
                               toItem: warningView, attribute: .centerX,
                               multiplier: 1.0, constant: 0.0).isActive = true
            
            NSLayoutConstraint(item: lableCondition, attribute: .height, relatedBy: .equal,
                               toItem: warningView, attribute: .height,
                               multiplier: 1.0, constant: 0.0).isActive = true
            NSLayoutConstraint(item: lableCondition, attribute: .width, relatedBy: .equal,
                               toItem: warningView, attribute: .width,
                               multiplier: 1.0, constant: 0.0).isActive = true
            
            NSLayoutConstraint(item: lableCondition, attribute: .centerY, relatedBy: .equal,
                               toItem: warningView, attribute: .centerY,
                               multiplier: 1.0, constant: 18).isActive = true

            
        }else{
            let views = [
                "indexLabel" : indexLabel,
                "cardImageView" : cardImageView,
                "titleLabel" : titleLabel,
                "arrowLabel" : arrowLabel,
                "headerView" : headerView,
                "warningView" : warningView,
                "warningBg" : warningBg,
                "warningLabel" : warningLabel,
                "lableCondition" : lableCondition
            ]
            
            contentView.addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[headerView]|",
                options: [], metrics: nil, views: views))
            contentView.addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[warningView]|",
                options: [], metrics: nil, views: views))
            contentView.addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[headerView(50)]-[warningView(40)]|",
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
            

            NSLayoutConstraint(item: warningBg, attribute: .height, relatedBy: .equal,
                                           toItem: warningView, attribute: .height,
                                           multiplier: 1.0, constant: -10).isActive = true
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
                    multiplier: 1.0, constant: -8).isActive = true
            NSLayoutConstraint(item: warningLabel, attribute: .width, relatedBy: .equal,
                                           toItem: warningBg, attribute: .width,
                    multiplier: 1.0, constant: -16).isActive = true
            

        }
   

        
    }
    
    func setData(type: Int , condition: String){
        
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
