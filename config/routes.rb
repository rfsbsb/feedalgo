Feedalgo::Application.routes.draw do

  authenticated :user do
    root :to => 'pages#home'
  end

  root :to => "pages#home"

  devise_for :users
  resources :users
  resources :feeds


  match 'f/all'                 => 'feeds#all',           :as => :reader_all
  match 'f/paging/all'          => 'feeds#all_paging',    :as => :reader_all_paging
  match 'f/all/unread'          => 'feeds#all_unread',    :as => :reader_all_unread
  match 'f/mark_all'            => 'feed_entry_users#mark_all_read', :as => :mark_all, :via => [:post]

  match 'f/paging/:id'          => 'feeds#list_paging',   :as => :feed_paging, :constraints => { :id => /[^\/]*/ }
  match 'f/mark_as_read/:id'    => 'feed_entry_users#mark_as_read'
  match 'f/favorite/:id'        => 'feed_entry_users#favorite'
  match 'f/mark_all/:id'        => 'feed_entry_users#mark_all_feed_read', :as => :mark_all_feed, :via => [:post], :constraints => { :id => /[^\/]*/ }

  match 'f/unread/:id'          => 'feeds#unread',        :as => :unread, :constraints => { :id => /[^\/]*/ }

  match 'f/folder/:id'          => 'folders#list',        :as => :reader_folder
  match 'f/folder/toggle/:id'   => 'folders#toggle',      :as => :toggle_folder
  match 'f/folder/unread/:id'   => 'folders#unread',      :as => :folder_unread
  match 'f/folder/mark_all/:id' => 'feed_entry_users#mark_all_folder_read', :as => :mark_all_folder, :via => [:post], :constraints => { :id => /[^\/]*/ }

  match '/f/folder/rename/:id'  => 'folders#rename',      :as => :rename_folder, :via => [:put, :post], :constraints => { :id => /[^\/]*/ }
  match '/f/feed/rename/:id'    => 'feed_users#rename',   :as => :rename_feed, :via => [:put, :post], :constraints => { :id => /[^\/]*/ }

  match 'f/:id'                 => 'feeds#list',          :as => :reader_feed, :constraints => { :id => /[^\/]*/ }

end