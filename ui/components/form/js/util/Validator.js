/**
 * Created by alexandru.trifan on 22.09.2015.
 */
define(['promise'], function(Promise) {


    function Validator() {

    }

    Validator.registerChecker = function(name, fn) {
        checkers[name] = fn;
    };

    Validator.get = function() {
        return checkers;
    };

    function emailChecker(value) {
        var deferred = Promise.defer();
        var emailValidationURL = 'https://ajith-Verify-email-address-v1.p.mashape.com/varifyEmail',
            checkData = 'email=' + value;
        $.ajax({
            url: emailValidationURL,
            type: 'GET',
            dataType: 'json',
            data: checkData,
            beforeSend: function(xhr) {
                xhr.setRequestHeader("X-Mashape-Authorization", "HRREufGqPXmshBkgax5Y6YC8culyp1Xjo8ijsniZZiflM7nuDs"); // Enter here your Mashape key
            },
            success: function(data) {
                deferred.resolve(data.exist);
            },
            error: function(err) {
                deferred.reject();
            }
        });

        return deferred.promise;
    };

    function notNullChecker(value) {
        var check = (typeof value != 'undefined');
        return check;
    };

    function truthChecker(value) {
        var check = (value == true);
        console.log(check);
        return check;
    };

    var checkers = {
        email: emailChecker,
        notNull: notNullChecker,
        truth: truthChecker
    };

    return Validator;
});
