Feedalgo::Application.routes.draw do

  root :to => "pages#home"

  devise_for :users
  resources  :users
  resources  :feeds
  resources  :folders,    :except  => ['update']
  resources  :feed_users, :except  => ['update']

  match 'f/mark_as_read/:id'     => 'feed_entry_users#mark_as_read'
  match 'f/favorite/:id'         => 'feed_entry_users#favorite'
  put   'folders/:id'            => "folders#remove",                        constraints: lambda {|req| req.params.has_key?(:remove)}
  put   'folders/:id'            => "folders#update",                        constraints: lambda {|req| req.params.has_key?(:save)}
  put   'feed_users/:id'         => "feed_users#unsubscribe",                constraints: lambda {|req| req.params.has_key?(:unsubscribe)}
  put   'feed_users/:id'         => "feed_users#update",                     constraints: lambda {|req| req.params.has_key?(:save)}
  match 'f/all'                  => 'feeds#all',                             :as => :reader_all
  match 'f/paging/all'           => 'feeds#all_paging',                      :as => :reader_all_paging
  match 'f/all/unread'           => 'feeds#all_unread',                      :as => :reader_all_unread
  match 'f/all/favorites'        => 'feeds#all_favorite',                    :as => :reader_all_favorite
  match 'f/folder/:id'           => 'folders#list',                          :as => :reader_folder
  match 'f/folder/toggle/:id'    => 'folders#toggle',                        :as => :toggle_folder
  match 'f/folder/unread/:id'    => 'folders#unread',                        :as => :folder_unread
  match 'f/folder/favorites/:id' => 'folders#favorite',                      :as => :folder_favorite
  match 'f/mark_all'             => 'feed_entry_users#mark_all_read',        :as => :mark_all,        :via => [:post]
  match 'f/mark_all/:id'         => 'feed_entry_users#mark_all_feed_read',   :as => :mark_all_feed,   :via => [:post], :constraints => { :id => /[^\/]*/ }
  match 'f/folder/mark_all/:id'  => 'feed_entry_users#mark_all_folder_read', :as => :mark_all_folder, :via => [:post], :constraints => { :id => /[^\/]*/ }
  match 'f/unread/:id'           => 'feeds#unread',                          :as => :unread,          :constraints => { :id => /[^\/]*/ }
  match 'f/favorites/:id'        => 'feeds#favorite',                        :as => :favorite,        :constraints => { :id => /[^\/]*/ }
  match 'f/paging/:id'           => 'feeds#list_paging',                     :as => :feed_paging,     :constraints => { :id => /[^\/]*/ }
  match 'f/:id'                  => 'feeds#list',                            :as => :reader_feed,     :constraints => { :id => /[^\/]*/ }

end