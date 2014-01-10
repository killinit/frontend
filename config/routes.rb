Rails.application.routes.draw do
  root 'home#index'

  scope '/:locale' do
    get '/', to: 'home#index'
  end

  resource :styleguide, controller: 'styleguide', only: 'show' do
    member do
      get 'css'
      get 'html'
      get 'sass'
      get 'javascript'
      get 'ruby'
    end
  end
end
