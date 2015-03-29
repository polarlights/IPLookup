Rails.application.routes.draw do
  mount IPLookup::API => '/'
end
