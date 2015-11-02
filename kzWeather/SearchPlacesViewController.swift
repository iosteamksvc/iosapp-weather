//
//  SearchPlacesViewController.swift
//  kzWeather
//
//  Created by HQVINH-PC on 11/2/15.
//  Copyright © 2015 iosteamksvc. All rights reserved.
//

import UIKit
import GooglePlacesAutocomplete

class SearchPlacesViewController: UIViewController {
    let gpaViewController = GooglePlacesAutocomplete(
        apiKey: "AIzaSyB0yA8tNB2KAuMmLoJ2RXSf8gBPBV83YCI",
        placeType: .Address
    )
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        gpaViewController.placeDelegate = self
        
        gpaViewController.navigationItem.title = "Places"
        
        presentViewController(gpaViewController, animated: true, completion: nil)
    }
}

extension SearchPlacesViewController: GooglePlacesAutocompleteDelegate {
    func placeSelected(place: Place) {
        // print("place.description" + place.description)
        
        place.getDetails { details in
            print(details)
            
            
            
            let startView = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
            
            startView.isSearchingLocation = true
            
            startView.currentPlace = FavoritePlace(name: details.name, latitude: details.latitude , longtitude: details.longitude)!
            self.gpaViewController.showViewController(startView, sender: self)

        }
        
    }
    
    func placeViewClosed() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
