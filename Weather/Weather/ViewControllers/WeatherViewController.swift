//
//  ViewController.swift
//  Weather
//
//  Created by Luís Felipe Polo on 25/01/21.
//

import UIKit
import RxSwift
import RxCocoa

class WeatherViewController: UIViewController {

    @IBOutlet var placeTextField: UITextField!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        placeTextField.rx.controlEvent(.editingDidEndOnExit)
            .asObservable()
            .map{ self.placeTextField.text }
            .subscribe(onNext: { city in
                guard let city = city, !city.isEmpty else {
                    return
                }
                self.fetchWeather(city: city)
            }).disposed(by: disposeBag)
    }

    private func fetchWeather(city : String) {
        
        guard let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed), let url = URL.urlForWeatherAPI(city: cityEncoded) else {
            return
        }
        
        let search = URLRequest.load(url: url)
            .retry(3)
            .observe(on: MainScheduler.instance)
            .catch{ error in
                print(error.localizedDescription)
                return Observable.just(WeatherResult.empty)
            }.asDriver(onErrorJustReturn: WeatherResult.empty)
        
        search.map { weatherResult in String(weatherResult.main.temp) + " ℃" }
        .drive(temperatureLabel.rx.text)
        .disposed(by: disposeBag)
        
        search.map { weatherResult in String(weatherResult.main.humidity) + " 💦" }
        .drive(humidityLabel.rx.text)
        .disposed(by: disposeBag)
    }
}

