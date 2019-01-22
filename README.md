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

