node default {
    include mprojects::apache::dpd_city_api
    include mprojects::apache::dpd_city_backend
    include mprojects::apache::dpd_city_ws
}

