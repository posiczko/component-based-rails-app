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
