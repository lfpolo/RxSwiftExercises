//
//  WeatherView.swift
//  Weather
//
//  Created by Luís Felipe Polo on 03/02/21.
//

import Foundation
import UIKit

class WeatherView : UIView {
    
    lazy var placeTextField : UITextField = {
        let view = UITextField(frame: .zero)
        view.returnKeyType = .search
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .purple
        return view
    }()
    
    lazy var temperatureLabel : UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .brown
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(placeTextField)
        addSubview(temperatureLabel)
        
        placeTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        placeTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        placeTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 150).isActive = true
        
        temperatureLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        //temperatureLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        temperatureLabel.topAnchor.constraint(equalTo: placeTextField.topAnchor, constant: 150).isActive = true
                
        self.backgroundColor = .orange
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
