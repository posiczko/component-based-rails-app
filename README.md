# README

## 2.1 THE ENTIRE APP INSIDE A COMPONENT

* Start with regular app. This is our main app container

      CONTAINER_DIR=`pwd`/sportsball
      rails new sportsball \
        --skip-action-mailer \
        --skip-active-storage \
        --skip-action-cable \
        --skip-test \
        --skip-mini-test 

* Remove app and create components

      cd $CONTAINER_DIR
      rm -rf app
      mkdir components
      rails plugin new components/app_component \
        --skip-action-mailer \
        --skip-active-storage \
        --skip-action-cable \
        --dummy-path=spec/dummy \
        --skip-mini-test \
        --skip-test \
        --full --mountable
      cd components/app_component
      bundle
      
* Fix `./components/app_component/app_component.gemspec` removing TODOs
 
* Install via bundle in `$CONTAINER_DIR`
 
      cd $CONTAINER_DIR
      bundle

* Created landing page in container and point root to it in `./components/app_component/config/routes.rb`.
  Make main container app aware of the routes from engine by mounting it in 
  `$COMPINENT_DIR/config/routes.rb` by adding `mount AppComponent::Engine, at: "/"`


      cd components/app_component
      rails g controller welcome index 
       
* Create dependency graph:

      cd $COMPONENT_DIR
      gem install cobradeps
      # add  group: [:default, :direct] to $COMPONENT_DIR/Gemfile to allow cobradep
      # dependency
      cobradeps -g component_diagram .


## 2.2 ACTIVERECORD AND HANDLING MIGRATIONS WITHIN COMPONENTS

* The first feature we are going to focus on is for the app to be able to predict the outcome of future games 
  based on past performances. To this end, we will add teams and games as models to AppComponent. We will create 
  an admin interface for both teams and games, which will give us enough data to try our hand at predicting some games.

      export APP_COMPONENT_DIR=(pwd)/components/app_component
      cd $APP_COMPONENT_DIR
      rails g scaffold team name:string
      rails g scaffold game date:datetime \
                              location:string \
                              first_team_id:integer \
                              second_team_id:integer \
                              winning_team:integer \
                              first_team_score:integer \
                              second_team_score:integer
      rails db:migrate
      
* We need to make the container app aware of the migrations. The common solution to this is to install the engine’s 
  migrations into the main app with `rake app_component:install:migrations`. This will copy all the migrations found 
  in the engine’s db/migrate folder into that of the main app.

      cd $CONTAINER_DIR
      rake app_component:install:migrations
      rails db:migrate

* Or you can add `./components/app_component/lib/app_component/engine.rb` 
  to make main app aware of migrations in engine.


## 2.3 HANDLING DEPENDENCIES WITHIN COMPONENTS

* With Sportsball now having the ability to store teams and games, we can turn to the question of how to predict 
  the outcome of games based on past performance. To this end, we would like to add a page that will allow us to pick 
  two teams. Click a button labeled something like “Predict the winner!”, and see the application’s prediction of who 
  is more likely to win as a result.

* Add path in `$APP_COMPONENT_DIR/config/routes` to let bundler figure out the dependencies.

* Add `slim` templating to `app_component` in `./components/app_component/app_component.gemspec`
  Unlike Rails applications, which automatically require all the gems they are directly dependent upon, 
  Rails engines do not. Create `./components/app_component/lib/app_component.rb` which require `rails-slim`
  and move require app/component/engine within module AppComponent.

* Configure engine to use slim by default `./components/app_component/lib/app_component/engine.rb`

* Lock down all runtime dependencies in components to exact versions in `./components/app_component/app_component.gemspec`.

* Add Trueskill gem for comparing team to team. Add to sharef of outdated gem in `$APP_COMPONENT_DIR/Gemfile` and add
  the gem itself to `$APP_COMPINENT/app_component.gemspec`. Intall
  
      cd $APP_COMPONENT
      bundle

* The Gemfile of any gem is ignored by other gems or apps depending on it (again, due to fact that the common \
  expectation is for a gem to be published). We need to add sharef to `$CONTAINER_DIR/Gemfile`. Also need to require it
  in `$APP_COMPONENT_DIR/lib/app_component.rb`

* Add Predictions to the app in `$APP_COMPONENT_DIR/app/models/app_component_dir/predictor.rb`
  Prediction is a data object that holds on to the teams participating in the prediction, as well as the winning team.

## 3.1 TESTING A COMPONENT

* Add `rspec-rails` to `app_component.gemspec`.


