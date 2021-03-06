/*
* AnyPlace: A free and open Indoor Navigation Service with superb accuracy!
*
* Anyplace is a first-of-a-kind indoor information service offering GPS-less
* localization, navigation and search inside buildings using ordinary smartphones.
*
* Author(s): Artem Nikitin
*
* Supervisor: Demetrios Zeinalipour-Yazti
*
* URL: http://anyplace.cs.ucy.ac.cy
* Contact: anyplace@cs.ucy.ac.cy
*
* Copyright (c) 2015, Data Management Systems Lab (DMSL), University of Cyprus.
* All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy of
* this software and associated documentation files (the "Software"), to deal in the
* Software without restriction, including without limitation the rights to use, copy,
* modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
* and to permit persons to whom the Software is furnished to do so, subject to the
* following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
* OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
* DEALINGS IN THE SOFTWARE.
*
*/

import Foundation

class LatLng {
    static let EARTH_RADIUS_M = 6371.0*1000.0
    static let EARTH_EQUATORIAL_RADIUS_M = 6378.1370 * 1000.0
    static let EARTH_POLAR_RADIUS_M = 6356.7523 * 1000.0
    
    private(set) var lat: Double
    private(set) var lng: Double
    
    init(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
    }
    
    func toCartesian() -> Vector3D {
        let R = LatLng.radiusOfEarthAtLat(lat)
        let x = R*cos(lat)*cos(lng)
        let y = R*cos(lat)*sin(lng)
        let z = R*sin(lat)
        return Vector3D(x: x, y: y, z: z)
    }
    
    static func radiusOfEarthAtLat(lat: Double) -> Double {
        let a = EARTH_EQUATORIAL_RADIUS_M
        let b = EARTH_POLAR_RADIUS_M
        let nom = pow( pow(a, 2)*cos(lat), 2) + pow( pow(b, 2)*sin(lat), 2)
        let denom = pow( a*cos(lat), 2) + pow( b*sin(lat), 2)
        let R = sqrt( nom / denom )
        return R
    }

    //Haversine formula
    static func dist(p1: LatLng, p2: LatLng) -> Double {
        let sin2_lat = pow( (p2.lat - p1.lat)/2, 2 )
        let cos1 = cos(p1.lat)
        let cos2 = cos(p2.lat)
        let sin2_lng = pow( (p2.lng - p1.lng)/2, 2 )
        let p_avg = (p1 + p2) / 2
        let R = radiusOfEarthAtLat(p_avg.lat)
        return 2*R*asin(sqrt( sin2_lat + cos1*cos2*sin2_lng) )
    }
    
}


func +(left: LatLng, right: LatLng) -> LatLng { return LatLng(lat: left.lat + right.lat, lng: left.lng + right.lng) }
func *(p: LatLng, k: Double) -> LatLng { return LatLng(lat: p.lat * k, lng: p.lng * k) }
func *=(inout p: LatLng, k: Double) { p.lat *= k; p.lng *= k }
func /(p: LatLng, k: Double) -> LatLng { return p * (1.0/k) }
func /=(inout p: LatLng, k: Double) { p *= 1.0/k }