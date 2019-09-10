Metricky::Engine.routes.draw do
  resources :metrics, only: [:show], param: :name
end