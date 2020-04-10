//
//  Api.swift
//  Liquorder
//
//  Created by 李建霖 on 2020/2/21.
//  Copyright © 2020 creationspace. All rights reserved.
//

import Foundation

struct Api {
//    struct Authorization {
//        static let AUTH_HEADER = "Authorization"
//        static let BEARER_PREFIX = "Bearer "
//    }
//
//    struct Status {
//        static let UNAUTHORIZED = "Unauthorized"
//    }

    struct Url {
        static let AUTH_BASE_URL = "http://ec2-3-112-213-86.ap-northeast-1.compute.amazonaws.com:8083"
        static let LOGIN_URL = AUTH_BASE_URL + "/api/v1/identity/login"
        static let REFRESH_TOKEN_URL = AUTH_BASE_URL + "/api/v1/identity/refresh"

        static let BASE_URL = "http://ec2-3-112-213-86.ap-northeast-1.compute.amazonaws.com:8086"
        static let GET_CELLARERS = BASE_URL + "/api/v1/retailer/coopcellarers"
        static let GET_CELLARER_ACTIVE_MENU = BASE_URL + "/api/v1/retailer/coopcellarer/%d/activemenu"
        static let GET_MENU_CATEGORIES = BASE_URL + "/api/v1/retailer/activemenu/%d/categories"
        static let GET_MENU_CATEGORY_ITEMS = BASE_URL + "/api/v1/retailer/activemenu/%d/items?categoryId=%d"
        static let CREATE_ORDER = BASE_URL + "/api/v1/retailer/order/create?isSubmit=%@"
        static let UPDATE_ORDER = BASE_URL + "/api/v1/retailer/order/%d/update?isSubmit=%@"
        static let GET_ORDERS = BASE_URL + "/api/v1/retailer/orders?startDate=%@&endDate=%@"
        static let GET_ORDER_ITEMS = BASE_URL + "/api/v1/retailer/order/%d/items"
        static let GET_LIQUOR_CATEGORIES = BASE_URL + "/api/v1/retailer/liquor/categories"
        static let GET_LIQUOR_CATEGORY_ITEMS = BASE_URL + "/api/v1/retailer/liquors?categoryId=%d"
        static let GET_FAVORITES = BASE_URL + "/api/v1/retailer/favorites"
        static let ADD_FAVORITE = BASE_URL + "/api/v1/retailer/favorite/add"
        static let REMOVE_FAVORITE = BASE_URL + "/api/v1/retailer/favorite/remove"
    }
}
