//
//  MapsViewController.swift
//  worldAirports
//
//  Created by Mario Acero on 9/13/18.
//  Copyright © 2018 MarioAcero. All rights reserved.
//

import UIKit
import GoogleMaps

class MapsViewController: UIViewController {
    
    lazy var viewModel: MapsViewModel = {
        return MapsViewModel()
    }()
    var  mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let camera = GMSCameraPosition.camera(withLatitude:  viewModel.originDetination.depart.latitude.value!, longitude: viewModel.originDetination.depart.longitude.value!, zoom: 7.0)
        mapView = .map(withFrame: CGRect.zero, camera: camera)
        
        let markerDepart = GMSMarker()
        markerDepart.position = CLLocationCoordinate2D(latitude: viewModel.originDetination.depart.latitude.value!, longitude: viewModel.originDetination.depart.longitude.value!)
        markerDepart.map = mapView
        
        let markerArrived = GMSMarker()
        markerArrived.position = CLLocationCoordinate2D(latitude: viewModel.originDetination.arrival.latitude.value!, longitude: viewModel.originDetination.arrival.longitude.value!)
        markerArrived.map = mapView
        
        view = mapView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let path = GMSMutablePath()
        path.add(CLLocationCoordinate2D(latitude: viewModel.originDetination.depart.latitude.value!, longitude: viewModel.originDetination.depart.longitude.value!))
        path.add(CLLocationCoordinate2D(latitude: viewModel.originDetination.arrival.latitude.value!, longitude: viewModel.originDetination.arrival.longitude.value!))
        
        let polyLine = GMSPolyline(path: path)
        polyLine.strokeColor = .red
        polyLine.strokeWidth = 3
        polyLine.map = mapView
        
        var bounds = GMSCoordinateBounds()
        for index in 0..<path.count() {
            bounds = bounds.includingCoordinate(path.coordinate(at: index))
        }
        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
    }
}
