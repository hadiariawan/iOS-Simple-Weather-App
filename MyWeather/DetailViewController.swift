//
//  DetailViewController.swift
//  MyWeather
//
//  Created by Hadi Ariawan on 5/19/17.
//  Copyright © 2017 Niltava Media. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var labelCityName: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var labelWeatherMain: UILabel!
    @IBOutlet weak var labelWeatherDescription: UILabel!
    @IBOutlet weak var labelWeatherTemperature: UILabel!
    
    var weatherItem : WeatherItem?
    var cityName : String?
    var countryCode : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        showWeatherDetail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBarButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func showWeatherDetail() {
        
        labelCityName.text = "\(String(describing: self.cityName!)), \(String(describing: self.countryCode!))"
        labelWeatherMain.text = weatherItem?.wMain
        labelWeatherDescription.text = weatherItem?.wDescription
        labelWeatherTemperature.text = "\(String(describing: weatherItem?.wTempMin.description)) - \(String(describing: weatherItem?.wTempMax.description))"
        
        if weatherItem?.wDescription == "sky is clear" {
            weatherImageView.image = UIImage(named: "weather-sunny")
        }else if weatherItem?.wDescription == "light rain" {
            weatherImageView.image = UIImage(named: "weather-rainy")
        }else if weatherItem?.wDescription == "moderate rain" {
            weatherImageView.image = UIImage(named: "weather-rainy")
        }else if weatherItem?.wDescription == "few clouds" {
            weatherImageView.image = UIImage(named: "weather-cloudy")
        }else {
            weatherImageView.image = UIImage(named: "weather-question")
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
