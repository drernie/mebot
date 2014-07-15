if (Meteor.isClient) {
	var favoriteFood = "Welcome";
	var favoriteFoodDep = new Deps.Dependency;

	var getFavoriteFood = function () {
	  favoriteFoodDep.depend();
	  return favoriteFood;
	};

	var setFavoriteFood = function (newValue) {
	  favoriteFood = newValue;
	  favoriteFoodDep.changed();
	};

  Template.hello.greeting = function () {
    return getFavoriteFood() + " to Rohan and Ernie's 1-nothing.";
  };

  Template.hello.events({
    'click input': function () {
      // template data, if any, is available in 'this'
      if (typeof console !== 'undefined') {
        console.log("You pressed the button for " + getFavoriteFood());
				setFavoriteFood("Goodbye");    	
      }
    }
  });
}

if (Meteor.isServer) {
  Meteor.startup(function () {
    // code to run on server at startup
  });
}
