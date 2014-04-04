Feedalgo::Application.routes.draw do

  authenticated :user do
    root :to => 'pages#home'
  end

  root :to => "pages#home"

  devise_for :users
  resources :feeds
  resources :users

  match 'f/:id'                 => 'pages#feed',          :as => :reader_feed, :constraints => { :id => /[^\/]*/ }
  match 'f/paging/:id'          => 'pages#feed_paging',   :as => :feed_paging, :constraints => { :id => /[^\/]*/ }
  match 'f/mark_as_read/:id'    => 'pages#mark_as_read'
  match 'f/favorite/:id'        => 'pages#favorite'
  match 'f/mark_all/:id'        => 'pages#mark_all_read', :as => :mark_all, :via => [:post], :constraints => { :id => /[^\/]*/ }

  match 'f/unread/:id'          => 'pages#show_unread',   :as => :unread, :constraints => { :id => /[^\/]*/ }

  match 'f/folder/:id'          => 'pages#folder',        :as => :reader_folder
  match 'f/folder/unread/:id'   => 'pages#folder_unread', :as => :folder_unread
  match 'f/folder/mark_all/:id' => 'pages#mark_all_folder_read', :as => :mark_all_folder, :via => [:post], :constraints => { :id => /[^\/]*/ }

end