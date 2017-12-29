//
//  DealDetailTableViewCell.swift
//  Primo
//
//  Created by Macmini on 4/28/2560 BE.
//  Copyright © 2560 Chalee Pin-klay. All rights reserved.
//

import UIKit

class DealDetailTableViewCell: UITableViewCell
{
    @IBOutlet weak var TitleDeal: UILabel!
    @IBOutlet weak var DealName: UILabel!
    @IBOutlet var howToLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var termLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var SendSmsOrCommandButton: SendSMSButton!
}

extension DealDetailTableViewCell
{
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, proID id: Int) {
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = id
        collectionView.setContentOffset(collectionView.contentOffset, animated:false) // Stops collection view if it was scrolling.
        collectionView.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        set { collectionView.contentOffset.x = newValue }
        get { return collectionView.contentOffset.x }
    }
}
