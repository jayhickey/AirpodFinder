//
//  ViewController.swift
//  AirpodFinder
//
//  Created by johnrhickey on 12/27/16.
//  Copyright © 2016 Jay Hickey. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate {
    
    @IBOutlet var progressView: ProgressView!
    
    var progressValues = [CGFloat]()
    
    let centralManager = CBCentralManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralManager.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        centralManager.stopScan()
    }
    
    // MARK: - CBCentralManagerDelegate
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        scan()
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        guard let peripheralName = peripheral.name, peripheralName.uppercased().range(of: "AIRPODS") != nil else {
            return
        }
        
        let max = 80.0
        let min = 40.0
        
        let absoluteRSSI = abs(RSSI.doubleValue)
        let normalizedRSSI = (absoluteRSSI - min) / (max - min)
        let progress = CGFloat(1 - round(normalizedRSSI * 10.0) / 10.0)
        
        debugPrint(progress)
        progressValues.append(progress)
    
        progressView.set(label: "RSSI: \(RSSI.stringValue)")
        
        if let max = progressValues.max(), progressValues.count > 3 {            
            progressValues.removeAll()
            progressView.set(progress: max, animated: true)
        }
        
    }
    
    // MARK: - Private
    
    private func scan() {
        centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        
        debugPrint("Scanning started")
    }
    
}

