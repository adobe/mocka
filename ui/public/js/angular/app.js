var phoneApp = angular.module('phoneApp', [
    'ngRoute',
    'phoneControllers'
]);

phoneApp.config(['$routeProvider',
    function($routeProvider) {
        $routeProvider
            .when('/call', {
                templateUrl: 'call.html',
                controller: 'Caller'
            })
            .when('/contacts', {
                templateUrl: 'contact-list.html',
                controller: 'Caller'
            })
            .when('/contacts/:contactId', {
                templateUrl: 'contact-detail.html',
                controller: 'ContactDetail'
            })
            .otherwise({
                redirectTo: '/call'
            });
    }
]);