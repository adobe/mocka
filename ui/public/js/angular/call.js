/**
 * Created by atrifan on 4/24/14.
 */
var phoneControllers = angular.module('phoneControllers', []);

phoneControllers.controller('Caller', ['$scope', '$http', Caller]);

function Caller($scope) {
    this._scope = $scope;

    this._call = $('.call-button');
    this._call.on('click', this.call.bind(this));

    return this;
}

Caller.prototype.call = function (event) {
    console.log('ok');
    window.location.href = '#/contacts';
}


