Rails.application.routes.draw do
  get "static_pages/home"
  get "static_pages/help"
  get "static_pages/about"
<<<<<<< HEAD
  root "static_pages#home"
=======
	root "static_pages#home"
>>>>>>> 1a6368d709f7170b840343cd46e7e7dcfdb55b13
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
