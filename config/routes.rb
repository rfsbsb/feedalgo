Feedalgo::Application.routes.draw do

  root :to => "pages#home"

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  resources  :users
  resources  :feeds
  resources  :folders,    :except  => ['update']
  resources  :feed_users, :except  => ['update']

  get 'f/mark_as_read/:id'     => 'feed_entry_users#mark_as_read'
  get 'f/favorite/:id'         => 'feed_entry_users#favorite'
  put   'folders/:id'            => "folders#remove",                        constraints: lambda {|req| req.params.has_key?(:remove)}
  put   'folders/:id'            => "folders#update",                        constraints: lambda {|req| req.params.has_key?(:save)}
  put   'feed_users/:id'         => "feed_users#unsubscribe",                constraints: lambda {|req| req.params.has_key?(:unsubscribe)}
  put   'feed_users/:id'         => "feed_users#update",                     constraints: lambda {|req| req.params.has_key?(:save)}
  get 'f/import'               => 'feeds#import',                          :as => :import
  get 'f/all'                  => 'feeds#all',                             :as => :reader_all
  get 'f/paging/all'           => 'feeds#all_paging',                      :as => :reader_all_paging
  get 'f/all/unread'           => 'feeds#all_unread',                      :as => :reader_all_unread
  get 'f/all/favorites'        => 'feeds#all_favorite',                    :as => :reader_all_favorite
  get 'f/paging/favorites'     => 'feeds#all_favorite_paging',             :as => :reader_all_favorite_paging
  get 'f/folder/:id'           => 'folders#list',                          :as => :reader_folder
  get 'f/folder/toggle/:id'    => 'folders#toggle',                        :as => :toggle_folder
  get 'f/folder/unread/:id'    => 'folders#unread',                        :as => :folder_unread
  get 'f/folder/favorites/:id' => 'folders#favorite',                      :as => :folder_favorite
  get 'f/folder/paging/:id'    => 'folders#list_paging',                   :as => :folder_paging
  get 'f/mark_all'             => 'feed_entry_users#mark_all_read',        :as => :mark_all,        :via => [:post]
  get 'f/mark_all/:id'         => 'feed_entry_users#mark_all_feed_read',   :as => :mark_all_feed,   :via => [:post], :constraints => { :id => /[^\/]*/ }
  get 'f/folder/mark_all/:id'  => 'feed_entry_users#mark_all_folder_read', :as => :mark_all_folder, :via => [:post], :constraints => { :id => /[^\/]*/ }
  get 'f/unread/:id'           => 'feeds#unread',                          :as => :unread,          :constraints => { :id => /[^\/]*/ }
  get 'f/favorites/:id'        => 'feeds#favorite',                        :as => :favorite,        :constraints => { :id => /[^\/]*/ }
  get 'f/paging/:id'           => 'feeds#list_paging',                     :as => :feed_paging,     :constraints => { :id => /[^\/]*/ }
  get 'f/:id'                  => 'feeds#list',                            :as => :reader_feed,     :constraints => { :id => /[^\/]*/ }

end
