//
//  ViewController.swift
//  MyWeather
//
//  Created by Hadi Ariawan on 5/19/17.
//  Copyright © 2017 Niltava Media. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var locationManager : CLLocationManager!
    
    var latitude : String?
    var longitude : String?
    
    var rsCity : String!
    var rsCountry : String!
    
    //var numOfWeathers : Int!
    //var weathersList : [String:Any] = [:]
    var weatherItem : [WeatherItem] = []
    
    @IBOutlet weak var labelCityName: UILabel!
    @IBOutlet weak var weatherTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.startUpdatingLocation()
        
    }
    
    func currentWeatherRequest(lat : String, long: String) {
        let endpoint = URL(string: "http://api.openweathermap.org/data/2.5/forecast/daily?lat=" + lat + "&lon=" + long + "&appid=807d77b4720fb60df97f6f8782915ebd&cnt=15&units=metric")
        
        do {
            let reqData = try Data(contentsOf: endpoint!)
            
            if let jsonData : NSDictionary = try
            JSONSerialization.jsonObject(with: reqData, options: .mutableContainers) as? NSDictionary{
                
                if let weathers = jsonData["list"] as? [[String:AnyObject]] {
                    for item in weathers {
                     
                        
                        var _wTempDay : Double
                        var _wTempMin : Double
                        var _wTempMax : Double
                        var _wTempNight : Double
                        var _wTempEvening : Double
                        var _wTempMorning : Double
                        var _wMain : String = ""
                        var _wDescription : String = ""
                        let _wPressure : Double = item["pressure"] as! Double
                        let _wHumidity : Int = item["humidity"] as! Int
                        let _wSpeed : Int = item["speed"] as! Int
                        let _wDeg : Int = item["deg"] as! Int
                        let _wClouds : Int = item["clouds"] as! Int
                        
                        let t = item["temp"] as? [String:Double]
                            _wTempDay = (t?["day"])!
                            _wTempMin = (t?["min"])!
                            _wTempMax = (t?["max"])!
                            _wTempNight = (t?["night"])!
                            _wTempEvening = (t?["eve"])!
                            _wTempMorning = (t?["morn"])!
                        
                        if let w = item["weather"] as? [[String:Any]] {
                            for _w in w {
                                _wMain = _w["main"] as! String
                                _wDescription = _w["description"] as! String
                            }
                        }
                        
                        
                        let itemToDisplay = WeatherItem(wDate: item["dt"] as! Int, wTempDay: _wTempDay, wTempMin: _wTempMin, wTempMax: _wTempMax, wTempNight: _wTempNight, wTempEvening: _wTempEvening, wTempMorning: _wTempMorning, wMain: _wMain, wDescription: _wDescription, wPressure: _wPressure, wHumidity: _wHumidity, wSpeed: _wSpeed, wDeg: _wDeg, wClouds: _wClouds)
                        self.weatherItem.append(itemToDisplay)
                    }
                }
                
                if let rsCity = jsonData["city"] as? [String:Any] {
                    self.rsCity = rsCity["name"] as! String
                }
                if let rsCountry = jsonData["city"] as? [String:Any]{
                    self.rsCountry = rsCountry["country"]! as! String
                }
                
                labelCityName.text = "\(self.rsCity!),\(self.rsCountry!)"
                weatherTableView.reloadData()
                
            }
            
        } catch {
            print("Error on try espression!")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let alert = UIAlertController(title: "Location Error", message: "Error. We can not access your location.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let currentLocation = locations.last {
            self.latitude = currentLocation.coordinate.latitude.description
            self.longitude = currentLocation.coordinate.longitude.description
        }
        locationManager.stopUpdatingLocation()
        
        currentWeatherRequest(lat: self.latitude!, long: self.longitude!)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
            let date = NSDate(timeIntervalSince1970: TimeInterval(weatherItem[indexPath.row].wDate))
            let dayTimePeriodFormatter = DateFormatter()
            dayTimePeriodFormatter.dateFormat = "dd MMM YYYY hh:mm a"
            let dateString = dayTimePeriodFormatter.string(from: date as Date)
        
            cell.textLabel?.text = "\(weatherItem[indexPath.row].wMain.description) : \(weatherItem[indexPath.row].wDescription.description)"
            cell.detailTextLabel?.text = "\(dateString). Temperature : \(weatherItem[indexPath.row].wTempMin) - \(weatherItem[indexPath.row].wTempMax)"
            
            if weatherItem[indexPath.row].wDescription == "sky is clear" {
                cell.imageView?.image = UIImage(named: "weather-sunny")
            }else if weatherItem[indexPath.row].wDescription == "light rain" {
                cell.imageView?.image = UIImage(named: "weather-rainy")
            }else if weatherItem[indexPath.row].wDescription == "moderate rain" {
                cell.imageView?.image = UIImage(named: "weather-rainy")
            }else if weatherItem[indexPath.row].wDescription == "few clouds" {
                cell.imageView?.image = UIImage(named: "weather-cloudy")
            }else {
                cell.imageView?.image = UIImage(named: "weather-question")
            }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherItem.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "weatherDetail" {
            
            let selectedIndexPath = weatherTableView.indexPathForSelectedRow!
            let itemToSent = weatherItem[selectedIndexPath.row]
            let destinationVC = segue.destination as! DetailViewController
            
            destinationVC.weatherItem = itemToSent
            destinationVC.cityName = self.rsCity
            destinationVC.countryCode = self.rsCountry
            
        }
    }


}

