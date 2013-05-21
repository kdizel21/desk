angular.module('deskApp', [])
  .config(function($routeProvider, $locationProvider) {
    $routeProvider.when('', {
      templateUrl: 'quizzes.html',
      controller: 'quizController'
    });
    $routeProvider.when('/quiz/:quizId/:question', {
      templateUrl: 'questions.html',
      controller: 'questionController'
    });
    $routeProvider.when('/login',{
      templateUrl:'index.html',
      controller: 'user'
    });
    $routeProvider.when('/new',{
      templateUrl:'new.html',
      controller: 'user'
    });
    $routeProvider.when('/completed',{
      templateUrl:'completed.html',
      controller: 'completedController'
    });
    $routeProvider.otherwise({
      templateUrl: 'quizzes.html',
      controller: 'quizController'
    });
  })
  .controller('user', ['$scope', '$http', '$location', '$routeParams',
  function($scope, $http, $location, $routeParams) {
    $scope.login = function(user) {
      $http({
        url: '/users/login',
        method: 'post',
        data: {user: user}}).
        success(function(data) {
          $location.path("quizzes/" + data.user.id);
          Desk.user = data.user;
          $scope.email = data.user.email
        }).
        error(function(xhr) {
          $scope.error = xhr.error;
        });
    }

    $scope.create = function(user) {
      $http({
        url: '/users',
        method: 'post',
        data: {user: user}}).
        success(function(data) {
          $location.path("quizzes/" + data.user.id);
        }).
        error(function(xhr) {
          $scope.error = xhr.error;
        });
    }
    $scope.loggedIn = function() {
      return Desk.user.email;
    }
  }])
  .controller('quizController', ['$scope', '$routeParams', '$http', '$location',
  function($scope, $routeParams, $http, $location) {
    if(Desk.user.email === undefined) {
      $location.path('/login');
    } else {
      $http({
        url: '/quizzes',
        method: 'get'}).
        success(function(data) {
          $scope.quizzes = data.quizzes
        }).
        error(function(xhr) {
          $scope.error = xhr.error;
        });
    }
  }])
  .controller('questionController', ["$scope", "$routeParams", "$http", "$location",
  function($scope, $routeParams, $http, $location){
    $scope.handleQuestions = function(quizId, questionId,location) {
      if(Desk.quiz.quizzes[quizId].answers[questionId]) {
        $scope.quiz = Desk.quiz.quizzes[quizId];
        $scope.answers = Desk.quiz.quizzes[quizId].answers[questionId];
        $scope.title = $scope.quiz.questions[questionId - 1].question;
      } else {
        $location.path("completed");
      }
    }
//    $scope.submitAnswer = function(answer) {
//      var quizLength = Desk.quizzes[$routeParams.id].questions.length;
//      if(answer) {
//        $http({
//          url: '/user_answers',
//          data: {group: $routeParams.id, question: $routeParams.questionId, answer: answer.id},
//          method: 'put'}).
//          success(function(data) {
//            $location
//          }).
//          error(function(xhr) {
//            $scope.error = xhr.error;
//          });
//      }
//    }

    $scope.localStorage = function(answer) {
      var userAnswer = {},
          local = {},
          answer = answer,
          addData = function(hash) {
            hash[answer.question_group] = {};
            hash[answer.question_group].answer = answer.id;
            hash[answer.question_group].group = answer.group;
            hash[answer.question_group].question = answer.question_group;
            return hash;
          }
      if(localStorage.getItem('questions')) {
        local = JSON.parse( localStorage.getItem('questions'));
        localStorage.setItem("questions", JSON.stringify(addData(local)));
      } else {
        localStorage.setItem("questions", JSON.stringify(addData(userAnswer)));
      }
    }
    $scope.pagination = function(quizId, questionId) {
      var qId = parseInt(questionId);
      $scope.nextLink = "#/quiz/" + quizId + "/" + (qId +1);
      if(qId === 1) {
        $scope.backLink = "#/";
      } else {
        $scope.backLink = "#/quiz/" + quizId + "/" + (qId -1);
      }
    }

    if(!Desk.quiz) {
      $http({
        url: '/questions/',
        params: {group: $routeParams.quizId},
        method: 'get'}).
        success(function(data) {
          Desk.quiz = data;
          $scope.handleQuestions($routeParams.quizId, $routeParams.question);
          $scope.pagination($routeParams.quizId, $routeParams.question);
        }).
        error(function(xhr) {
          $scope.error = xhr.error;
        });
    } else {
      $scope.handleQuestions($routeParams.quizId, $routeParams.question);
      $scope.pagination($routeParams.quizId, $routeParams.question);
    }
  }])
  .controller('completedController', ["$scope", "$routeParams", "$http", "$location",
  function($scope, $routeParams, $http, $location) {
    if(!Desk.results) {
      var answerHash = JSON.parse( localStorage.getItem('questions'));
      $http({
          url: '/user_answers',
          data: {questions : answerHash},
          method: 'put'}).
          success(function(data) {
            Desk.results = data;
            console.log(data)
          }).
          error(function(xhr) {
            $scope.error = xhr.error;
          });
    }
  }]);
