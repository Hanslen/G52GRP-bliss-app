// Ionic Starter App

// angular.module is a global place for creating, registering and retrieving Angular modules
// 'starter' is the name of this angular module example (also set in a <body> attribute in index.html)
// the 2nd parameter is an array of 'requires'
angular.module('bliss', ['ionic'])

.controller('blissCtrl', function($scope, $ionicSideMenuDelegate){
  $scope.events = [
    {title:'Bliss Buggy Push', imgUrl:'img/pasted-image.png', content:'Do something amazing and join or organise a Bliss Buggy Push. You can organise a push, take part in one, or take on a personal buggy challenge!',colorClass:'listleft1'},
    {title:'Families with a disabled child', imgUrl:'img/pasted-image.png', content:'Babies who are born premature or sick sometimes start life with a disability. In this section you will find information about help and benefits that are available',colorClass:'listleft2'},
    {title:'Developmental milestones', imgUrl:'img/pasted-image.png', content:'Reaching developmental milestones may take longer in premature babies and it is likely that they will reach major milestones later than babies born full term.',colorClass:'listleft3'},
    {title:'Bliss Buggy Push', imgUrl:'img/pasted-image.png', content:'Do something amazing and join or organise a Bliss Buggy Push. You can organise a push, take part in one, or take on a personal buggy challenge!',colorClass:'listleft1'},
    {title:'Growing up', imgUrl:'img/pasted-image.png', content:'Even though all children develop at their own pace, some parents may become concerned at their child’s development. In this section, we focus on some of the issues that may affect children who were born prematurely, as they continue to grow and start their school life.',colorClass:'listleft2'}
  ];
  $scope.categories = [
    {title:'Diseases'},
    {title:'Foods'},
    {title:'Books'},
    {title:'Settings'},
    {title:'Tutorial'},
    {title:'What we do'},
    {title:'Contact us'}
  ];
  $scope.toggleCategories = function(){
    $ionicSideMenuDelegate.toggleLeft();
  }
});
