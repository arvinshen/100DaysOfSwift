//
//  ViewController.swift
//  CapitalCities
//
//  Created by Arvin Shen on 1/2/22.
//

import MapKit
import UIKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    var cities = [City]()
    var capitals = [Capital]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Maps"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(changeMapType))

        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            if let fileURL = Bundle.main.url(forResource: "world-cities", withExtension: ".json") {
                if let data = try? Data(contentsOf: fileURL) {
                    self?.parse(json: data)
                    for city in self!.cities {
                        self?.capitals.append(Capital(title: city.city, coordinate: CLLocationCoordinate2D(latitude: city.lat, longitude: city.long), info: "Population: \(city.population)", city_url: city.city_url))
                    }
                }
            }
            self?.mapView.addAnnotations(self!.capitals)
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonData = try? decoder.decode(Cities.self, from: json) {
            cities = jsonData.cities
        }
    }
    
    @objc func changeMapType() {
        let ac = UIAlertController(title: "Change Map Type", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Default", style: .default) {
            [weak self] _ in
            self?.mapView.mapType = .standard
        })
        ac.addAction(UIAlertAction(title: "Satellite", style: .default) {
            [weak self] _ in
            self?.mapView.mapType = .satellite
        })
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default) {
            [weak self] _ in
            self?.mapView.mapType = .hybrid
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.pinTintColor = .magenta
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        let placeName = capital.title
        let placeInfo = capital.info
        
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Open in \"Wikipedia\"?", style: .default) {
            [weak self] _ in
            if let vc = self?.storyboard?.instantiateViewController(identifier: "Wiki") as? WebViewController {
                vc.selectedCapital = capital.city_url
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
}

// TODO: Add web view UI (back, forward, refresh, load progress bar, etc.)
