//
//  ViewController.swift
//  Detect-a-Beacon
//
//  Created by Arvin Shen on 1/9/22.
//

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var beaconID: UILabel!
    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var distanceRadius: UIImageView!
    var locationManager: CLLocationManager?
    var beaconDetected = [UUID: Bool]()
    let beaconIdentityConstraints = [CLBeaconIdentityConstraint(uuid: UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!, major: 123, minor: 456), CLBeaconIdentityConstraint(uuid: UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!, major: 123, minor: 321), CLBeaconIdentityConstraint(uuid: UUID(uuidString: "74278BDA-B644-4520-8F0C-720EAF059935")!, major: 456, minor: 789)]
    var beaconsToRange = [CLBeaconRegion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(systemName: "circle")
        distanceRadius.image = image
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        for beaconIdentity in beaconIdentityConstraints {
            beaconDetected[beaconIdentity.uuid] = false
            let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: beaconIdentity, identifier: "\(beaconIdentity.major ?? 0)\(beaconIdentity.minor ?? 0)")
            locationManager?.startMonitoring(for: beaconRegion)
        }
    }

    func update(distance: CLProximity, uuidString: String = "BEACON") {
        UIView.animate(withDuration: 1) {
            self.beaconID.text = uuidString
            switch distance {
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "FAR"
                self.distanceRadius.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
                self.distanceRadius.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

            case .immediate:
                self.view.backgroundColor = .red
                self.distanceReading.text = "RIGHT HERE"
                self.distanceRadius.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)

            default:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
                self.distanceRadius.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print("\(beacons)")
        print("-----------------")
        if beacons.isEmpty {
            update(distance: .unknown)
            return
        }
        for beacon in beacons {
            if !beaconDetected[beacon.uuid]! {
                beaconDetected[beacon.uuid] = true
                let ac = UIAlertController(title: "Beacon detected", message: "\(beacon.uuid)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .cancel))
                present(ac, animated: true)
            }
        }
        let nearestBeacon = beacons.first!
        update(distance: nearestBeacon.proximity, uuidString: nearestBeacon.uuid.uuidString)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLBeaconRegion {
            // Start ranging only if the devices supports this service.
            if CLLocationManager.isRangingAvailable() {
                manager.startRangingBeacons(in: region as! CLBeaconRegion)

                // Store the beacon so that ranging can be stopped on demand.
                beaconsToRange.append(region as! CLBeaconRegion)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
//        beaconsToRange.remove(at: beaconsToRange.firstIndex(of: region as! CLBeaconRegion))
        manager.stopRangingBeacons(in: region as! CLBeaconRegion)
    }
}

