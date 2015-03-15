require 'spec_helper'

describe WelcomeMessagesController do
  describe 'routing' do

    it 'routes to #index' do
      get('/projects/1/welcome_messages').should_not route_to('welcome_messages#index', project_id: '1')
    end

    it 'routes to #new' do
      get('/projects/1/welcome_messages/new').should_not route_to('welcome_messages#new', project_id: '1')
      get('/welcome_messages/new').should_not route_to('welcome_messages#new')
    end

    it 'routes to #show' do
      get('/welcome_messages/1').should route_to('welcome_messages#show', id:  '1')
    end

    it 'routes to #edit' do
      get('/projects/1/welcome_messages/1/edit').should_not route_to('welcome_messages#edit', id: '1', project_id: '1')
      get('/welcome_messages/1/edit').should_not route_to('welcome_messages#edit', id: '1')
    end

    it 'routes to #create' do
      post('/projects/1/welcome_messages').should_not route_to('welcome_messages#create', project_id: '1')
      post('/welcome_messages').should_not route_to('welcome_messages#create')
    end

    it 'routes to #update' do
      put('/projects/1/welcome_messages/1').should_not route_to('welcome_messages#update', id: '1', project_id: '1')
      put('/welcome_messages/1').should_not route_to('welcome_messages#update', id: '1')
    end

    it 'routes to #destroy' do
      delete('/welcome_messages/1').should route_to('welcome_messages#destroy', id: '1')
    end

  end
end
