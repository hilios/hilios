---
---

{% include_relative vendor/angular.js %}

var app = angular.module('hilios', []);

app.constant('TumblrApiKey', 'fuiKNFp9vQFvjLNvx4sUwti4Yb5yGutBN4Xh10LXZhhRKjWlV4');

app.factory('TumblrApi', function($http, TumblrApiKey) {
  var endpoint = 'http://api.tumblr.com/v2/blog/hilios.tumblr.com',
    tumblrConfig = {
      params: {
        limit: 9,
        jsonp: 'JSON_CALLBACK',
        api_key: TumblrApiKey
      }
    };

  return {
    'links': function(config) {
      return $http.jsonp(endpoint + '/posts/link',
        angular.extend(tumblrConfig, config));
    }
  }
});

app.factory('Spinner', function($rootScope, $q) {
  function watch() {
    var promisses = Array.prototype.slice.call(arguments);

    $rootScope.$broadcast('spinner:show');

    $q.all(promisses).finally(function() {
      $rootScope.$broadcast('spinner:hide');
    });
  }

  return {
    'watch': watch
  };
});

app.controller('LinksController', function($scope, TumblrApi, Spinner) {
  var q;

  $scope.links = null;

  q = TumblrApi.links().success(function(data) {
    $scope.links = data.response.posts;
  });

    Spinner.watch(q);
});

app.directive('spinner', function() {
  return {
    templateUrl: 'spinner.html',
    scope: true,
    link: function(scope, el, attrs) {
      scope.isLoading = false;
      scope.$on('spinner:show', function() {
        console.log('show');
        scope.isLoading = true;
      });
      scope.$on('spinner:hide', function() {
        console.log('hide');
        scope.isLoading = false;
      });
    }
  };
});
