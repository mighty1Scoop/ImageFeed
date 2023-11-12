//
//  Constants.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 27.07.2023.
//

import Foundation

struct Constants {
//    static let AccessKey = "jcx8QRPzoEuH3hBa1gvsLQMMvtoAP2t05MAGldh2Bw4"
//    static let AccessKey = "2-qU9Ie3wyNwZfQPwXMFef1eshJu3LU7ahnhOCesqso"
    static let AccessKey = "_e5yZfIub46_bDk9EjLOFgA5q6clA3jpGYU2lJbh0gA"
//    static let SecretKey = "nKFpl3vnBE6ZLmUU94P646oFRs76bYN8wKZwCymsG3s"
//    static let SecretKey = "3IRlengpaPK6_QY84o_kF2aAe3OrrKqQj3hfnRxIclc"
    static let SecretKey = "NX6GVxfgbMnx3ffCpnrwH_GcXTcu9fHT3afpUQI9eFM"
    static let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let AccessScope = "public+read_user+write_likes"
    static let DefaultBaseApiURL = URL(string: "https://api.unsplash.com")
    static let DefaultURL = URL(string: "https://unsplash.com")
    static let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}
