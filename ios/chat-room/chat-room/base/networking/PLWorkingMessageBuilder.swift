//
//  TAWorkingMessageBuilder.swift
//  Tarina
//
//  Created by Desarrollo on 02/11/16.
//  Copyright © 2016 Plenumsoft. All rights reserved.
//

import UIKit

class PLWorkingMessageBuilder: NSObject {

    
    func showModalSpinnerIndicator(view:UIView) ->UIActivityIndicatorView{

        UIApplication.shared.beginIgnoringInteractionEvents()
        
        var indicator = UIActivityIndicatorView()
        
        indicator = UIActivityIndicatorView(frame: view.frame)
        indicator.center = view.center
        indicator.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        
        view.addSubview(indicator)
        
        return indicator
    }
    
    func showModalSpinnerIndicatorWithMessage(view:UIView, message:String) -> UIActivityIndicatorView{
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        var indicator = UIActivityIndicatorView()
        
        indicator = UIActivityIndicatorView(frame: view.frame)
        indicator.center = view.center
        indicator.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        let label = UILabel()
        label.frame = CGRect(x: 0.0, y: 0.0, width: 250, height: 250)
        label.text = message
        label.textColor = UIColor.white
        label.textAlignment = .center
        let frame = indicator.center;
        label.center = CGPoint(x: frame.x, y: frame.y + 50.0)
        indicator.addSubview(label)
        view.addSubview(indicator)
        
        return indicator
    
    }
    
    func hideModalSpinnerIndicator(indicator: UIActivityIndicatorView){
        indicator.stopAnimating()
        indicator.isHidden = true
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}
