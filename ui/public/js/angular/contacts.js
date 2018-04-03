/**
 * Created by atrifan on 4/24/14.
 */
var phoneControllers = angular.module('phoneApp');

phoneControllers.controller('Caller', function ($scope, $http) {
    $http.get('resources/contacts.json').success(function(data) {
        $scope.contacts = data;
    });

    $scope.orderProp = 'firstName';
});

function Caller($scope, $http) {
    this._http = $http;
    this._scope = $scope;

    $http.get('/public/resources/contacts.json').success(
        function(data) {
            $scope.contacts = data;
        }
    ).fail(function (err) {
            console.log(err);
    })

    $scope.orderProp = 'id';

}