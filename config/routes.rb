Rails.application.routes.draw do
  get 'pages/home'
  devise_for :users, :controllers => {:registrations => :registrations}
  root to:'pages#home'
  get 'comments/index'
  get 'comments/new'
  get 'comments/edit'
  get 'comments/destroy'
  get 'comments/create'
  get 'comments/update'
  get 'news_report/index'
  get 'news_report/show'
  get 'news_report/new'
  get 'news_report/edit'
  get 'profile/index'
  get 'profile/show'
  get 'profile/new'
  get 'profile/edit'
  resources :users do
    resources :profiles do
      resources :news_reports do
        resources :comments
      end
    end
  end
  # resources :news_writers
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/news', :controller=>'news', :action=>'get_news'
  get '/newsreports', :controller=>'news_reports', :action=>'all_reports'
  get '/newswriters', :controller=>'profiles', :action=>'all_profiles'
  get '/search', :controller=>'news', :action=>'search_news'
end
