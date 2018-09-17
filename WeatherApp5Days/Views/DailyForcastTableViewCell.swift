//
//  DailyForcastTableViewCell.swift
//  WeatherApp5Days
//
//  Created by Hana  Demas on 9/14/18.
//  Copyright © 2018 ___HANADEMAS___. All rights reserved.
//

import UIKit

class DailyForcastTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet var dayOfTheWeekLabel: UILabel!
    @IBOutlet var forcastCollectionView: UICollectionView!
}

//Tableviewcell extension to setup datasource and delgate of collectionview inside it
extension DailyForcastTableViewCell {
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        forcastCollectionView.delegate = dataSourceDelegate
        forcastCollectionView.dataSource = dataSourceDelegate
        forcastCollectionView.tag = row
        
        forcastCollectionView.setContentOffset(forcastCollectionView.contentOffset, animated:false)
        
        forcastCollectionView.reloadData()
    }
}
