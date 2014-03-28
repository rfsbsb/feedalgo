Feedalgo::Application.routes.draw do

  authenticated :user do
    root :to => 'pages#home'
  end

  root :to => "pages#home"

  devise_for :users
  resources :feeds
  resources :users

  match 'f/:id' => 'pages#feed', :as => :reader_feed, :constraints => { :id => /[^\/]*/ }
  match 'f/:id/mark_as_read' => 'pages#mark_as_read'
  match 'f/show_all_folder' => 'pages#show_all_folder'
  match 'f/:id/favorite' => 'pages#favorite'
  match 'f/unread/:id' => 'pages#show_unread', :as => :unread, :constraints => { :id => /[^\/]*/ }

end
