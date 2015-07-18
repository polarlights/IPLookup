Rails.application.routes.draw do
  mount API::Root, at: "/api"
end
