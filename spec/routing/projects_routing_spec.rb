require 'spec_helper'

describe ProjectsController do
  describe 'routing' do

    it 'does not route to #index' do
      get('/projects').should_not be_routable
    end

    it 'routes to #new' do
      get('/charities/1/projects/new').should route_to('projects#new', charity_id: '1')
      get('/projects/new').should_not route_to('projects#new')
    end

    it 'routes to #show' do
      get('/projects/1').should route_to('projects#show', :id => '1')
    end

    it 'routes to #edit' do
      get('/charities/1/projects/2/edit').should route_to('projects#edit', charity_id: '1', id: '2')
      get('/projects/1/edit').should_not route_to('projects#edit', :id => '1')
    end

    it 'routes to #create' do
      post('/charities/1/projects').should route_to('projects#create', charity_id: '1')
      post('/projects').should_not route_to('projects#create')
    end

    it 'routes to #update' do
      put('/charities/1/projects/2').should route_to('projects#update', charity_id: '1', id: '2')
      put('/projects/1').should_not route_to('projects#update', :id => '1')
    end

    it 'routes to #destroy' do
      delete('/projects/1').should route_to('projects#destroy', :id => '1')
    end

    it 'routes through a slug as well' do
      get('/projects/friendly_id').should route_to('projects#show', :id => 'friendly_id')
    end
  end
end
