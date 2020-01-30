Rails.application.routes.draw do
  resources :news_writers
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/news', :controller=>'news', :action=>'get_news'
end
