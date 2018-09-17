//
//  ViewController.swift
//  WeatherApp5Days
//
//  Created by Hana  Demas on 9/13/18.
//  Copyright © 2018 ___HANADEMAS___. All rights reserved.
//

import UIKit

//Enumrate the modes of the datasource
enum DataSourceMode {
    case online, offline
}

class WeatherForcastViewController: UIViewController {
    //MARK: Properties
    @IBOutlet var forcastTableView: UITableView!
    
    fileprivate var forcastViewModel = WeatherForcastViewModel()
    fileprivate var dataSourceMode: DataSourceMode = .online
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.forcastTableView.dataSource = self
        self.forcastTableView.delegate = self
        
        forcastViewModel.getAllForcastsFromAPI(for: "Munich,de", completion: {
            DispatchQueue.main.async {
                self.forcastViewModel.organizeForcasts()
                self.forcastTableView.reloadData()
            }
        })
    }
    
    //MARK: IBActions (when the button is pressed the datasource switchs between online and offline)
    @IBAction func switchDataSource(_ sender: Any) {
        if dataSourceMode == .online {
            dataSourceMode = .offline
            
            forcastViewModel.getAllOfflineForcasts {
                DispatchQueue.main.async {
                    self.forcastViewModel.organizeForcasts()
                    self.forcastTableView.reloadData()
                }
            }
        } else {
            dataSourceMode = .online
            
            forcastViewModel.getAllForcastsFromAPI(for: "Munich,de", completion: {
                DispatchQueue.main.async {
                    self.forcastViewModel.organizeForcasts()
                    self.forcastTableView.reloadData()
                }
            })
        }
    }
}

//MARK: viewcontroller extension for implementing datasource and delegates of uitableview
extension WeatherForcastViewController: UITableViewDataSource, UITableViewDelegate {
    
    func registerCellsForTableView(tableView: UITableView) {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "dateCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.forcastViewModel.getNumberOfDays()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! DailyForcastTableViewCell
        cell.dayOfTheWeekLabel.text = self.forcastViewModel.getDayAtIndex(index: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {guard let tableViewCell = cell as? DailyForcastTableViewCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
    }
}

//MARK: viewcontroller extension for implementing datasource and delegates of UICollectionView
extension WeatherForcastViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let day = self.forcastViewModel.getDayAtIndex(index: collectionView.tag)
        return self.forcastViewModel.getNumberOfForcasts(day: day)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "forcastCell", for: indexPath) as! SingleForcastCollectionViewCell
        let day = self.forcastViewModel.getDayAtIndex(index: collectionView.tag)
        
        if  let forcast = self.forcastViewModel.getForcastAtIndex(day: day, index: indexPath.row) {
            cell.temperatureLabel.text = "\(String(describing: forcast.temperature))" +  "\u{00B0}"
            cell.weatherIconImageView.loadImageWithURLString((forcast.iconImageUrl()) ?? "", placeHolder: UIImage(named: "placeholder"))
            cell.timeLabel.text = forcast.hourString
        }
        return cell
    }
}
